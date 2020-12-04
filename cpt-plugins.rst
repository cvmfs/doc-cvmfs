.. _cpt_plugins:

Client Plug-Ins
===============

The CernVM-FS client's functionality can be extended through plug-ins.
CernVM-FS plug-ins are binaries (processes) that communicate with the main
client process through IPC.  Currently there are two plug-in interfaces:
cache manager plugins and authorization helpers.

.. _sct_plugin_cache:

Cache Plugins
-------------

A cache plugin provides the functionality of the client's local cache directory:
it maintains a set of content-addressed objects. Clients can read from these
objects.  Depending on its capabilities, a cache plugin might also support
addition of new objects, listing objects and eviction of objects from the cache.

**Note:** The CernVM-FS client trusts the contents of the cache. Cache plugins
that store data in untrusted locations need to perform their own content
verification before data is provided to the clients.

Cache plugins and clients exchange messages through a socket.  The messages are
serialized by the Google protobuf library. A description of the wire protocol
can be found in the ``cvmfs/cache.proto`` source file, although the cache
plugins should not directly implement the protocol. Instead, plugins are
supposed to use the ``libcvmfs_cache`` library (part of the CernVM-FS
development package), which takes care of the low-level protocol handling.

Good entry points into the development of a cache plugin are the demo plugin
``cvmfs/cache_plugin/cvmfs_cache_null.cc`` and the production in-memory cache
plugin ``cvmfs/cache_plugin/cvmfs_cache_ram.cc``. The CernVM-FS unit test suite
has a unit test driver, ``cvmfs_test_cache``, with a number of tests that are
helpful for the development and debugging of a cache plugin.

Broadly speaking, a cache plugin process performs the following steps

::

    #include <libcvmfs_cache.h>

    cvmcache_init_global();
    // Option parsing, which can use cvmcache_options_... functions to parse
    // CernVM-FS client configuration files

    // Optionally: spawning the watchdog to create stack traces when the cache
    // plugin crashes
    cvmcache_spawn_watchdog(NULL);

    // Create a plugin context by passing function pointers to callbacks
    struct cvmcache_context *ctx = cvmcache_init(&callbacks);

    // Connect to the socket defined by the locator string
    cvmcache_listen(ctx, locator);

    // Spawn an I/O thread in which the callback functions are called
    cvmcache_process_requests(ctx, 0);

    // Depending on whether the plugin is started independently or by the
    // CernVM-FS client, cvmcache_process_requests() termination behaves
    // differently

    if (!cvmcache_is_supervised()) {
      // Decide when the plugin should be terminated, e.g. wait for a signal
      cvmcache_terminate(ctx);
    }

    // Cleanup
    cvmcache_wait_for(ctx);
    cvmcache_terminate_watchdog();
    cvmcache_cleanup_global();

The core of the cache plugin is the implementation of the callback functions
provided to ``cvmcache_init()``.  Not all callback functions need to be
implemented.  Some can be set to ``NULL``, which needs to correspond to the
indicated plugin capabilities specified in the ``capabilities`` bit vector.


Basic Capabilities
~~~~~~~~~~~~~~~~~~

Objects maintained by the cache plugin are identified by their content hash.
Every cache plugin must be able to check whether a certain object is available
or not and, if it is available, provide data from the object.  This
functionality is provided by the ``cvmcache_chrefcnt()``,
``cvmcache_obj_info()``, and ``cvmcache_pread()`` callbacks.  With only this
functionality, the cache plugin can be used as a read-only lower layer in a
tiered cache but not as a stand-alone cache manager.

For a proper stand-alone cache manager, the plugin must keep reference counting
for its objects.  The concept of reference counting is borrowed from link counts
in UNIX file systems.  Every object in a cache plugin has a reference counter
that indicates how many times the object is being in use by CernVM-FS clients.
For objects in use, clients expect that reading succeeds, i.e. objects in use
must not be deleted.


Adding Objects
~~~~~~~~~~~~~~

On a cache miss, clients need to populate the cache with the missing object.
To do so, cache plugins provide a transactional write interface. The upload
of an object results in the following call chain:

  1. A call to ``cvmcache_start_txn()`` with a given transaction id

  2. Zero, one, or multiple calls to ``cvmcache_write_txn()`` that append data

  3. A call to ``cvmcache_commit_txn()`` ro ``cvmcache_abort_txn()``

Only after commit the object must be accessible for reading. Multiple concurrent
transactions on the same object are possible. After commit, the reference
counter of the object needs to be equal to the number of transactions that
committed the object (usually 1).


Listing and Cache Space Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Listing of the objects in the cache and the ability to evict objects from the
cache are optional capabilities. Only objects whose reference counter is zero
may be evicted. Clients can keep file catalogs open for a long time, thereby
preventing them from being evicted.  To mitigate that fact, cache plugins can
at any time send a notification to clients using ``cvmcache_ask_detach()``,
asking them to close as many nested catalogs as they can.



.. _sct_authz:

Authorization Helpers
---------------------

Client authorization helpers (*authz helper*) can be used to grant or deny read
access to a mounted repository.  To do so, authorization helpers can verify the
local UNIX user (uid/gid) and the process id (pid) that is issuing a file system
request.

An authz helper is spawned by CernVM-FS if the root file catalog contains
*membership requirement* (see below).  The binary to be spawned is derived from
the membership requirement but it can be overwritten with the
``CVMFS_AUTHZ_HELPER`` parameter.  The authz helper listens for commands on
``stdin`` and it replies on ``stdout``.

Grant/deny decisions are typically cached for a while by the client.  Note that
replies are cached for the entire session (session id) that contains the calling
process id.


Membership Requirement
~~~~~~~~~~~~~~~~~~~~~~

The root file catalog of a repository determines if and which authz helper
should be used by a client.  The membership requirement (also called
*VOMS authorization*) can be set, unset, and changed when creating a
repository and on every publish operation.  It has the form

::

      <helper>%<membership string>

The ``<helper>`` component helps the client find an authz helper.  The client
searches for a binary ``${CVMFS_AUTHZ_SEARCH_PATH}/cvmfs_<helper>_helper``.  By
default, the search path is ``/usr/libexec/cvmfs/authz``.  CernVM-FS comes with
two helpers: ``cvmfs_helper_allow`` and ``cvmfs_helper_deny``.  Both helpers
make static decisions and disregard the membership string.  Other helpers can
use the membership string to specify user groups that are allowed to access a
repository.


Authz Helper Protocol
~~~~~~~~~~~~~~~~~~~~~

The authz helper gets spawned by the CernVM-FS client with ``stdin`` and
``stdout`` connected. There is a command/reply style of messages.  Messages have
a 4 byte version (=1), a 4 byte length, and then a JSON text that needs to
contain the top-level struct ``cvmfs_authz_v1 { ... }``. Communication starts
with a handshake where the client passes logging parameters to the authz helper.
The client then sends zero or more authorization requests, each of which is
answered by a positive or negative permit.  A positive permit can include an
access token that should be used to download data. The permits are cached by the
client with a TTL that the helper can chose. On unmount, the client sends a quit
command to the helper.

When spawned, the authz helper's environment is prepopulated with all
``CVMFS_AUTHZ_...`` environment variables that are in the CernVM-FS client's
environment.  Furthermore the parameter ``CVMFS_AUTHZ_HELPER=yes`` is set.

The JSON snippet of every message contains ``msgid`` and ``revision`` integer
fields.  The revision is currently 0 and unused.  Message ids indicate certain
other fields that can or should be present.  Additional JSON text is ignored.
The message id can be one of the following

======== =======================================================
**Code** **Meaning**
-------- -------------------------------------------------------
0        Cvmfs: "Hello, helper, are you there?" (handshake)
1        Helper: "Yes, cvmfs, I'm here" (handshake reply)
2        Cvmfs: "Please verify, helper" (verification request)
3        Helper: "I verified, cvmfs, here's the result" (permit)
4        Cvmfs: "Please shutdown, helper" (termination)
======== =======================================================

Handshake and Termination
^^^^^^^^^^^^^^^^^^^^^^^^^

In the JSON snippet of the hand shake, the CernVM-FS client transmits the fully
qualified repository name (``fqrn`` string field) and the syslog facility and
syslog level the helper is supposed to use (``syslog_facility``,
``syslog_level`` integer fields).  The handshake reply as well as the
termination have no additional payload.

Verification Requests
^^^^^^^^^^^^^^^^^^^^^

A verification request contains the uid, gid, and pid of the calling process
(``uid``, ``gid``, ``pid`` integer fields).  It furthermore contains the
Base64 encoded membership string from the membership requirement
(``membership`` string field).

The permit has to contain a status indicating success or failure (``status``
integer field) and a time to live for this reply in seconds (``ttl`` integer
field).  The status can be one of the following

======== ========================================================
**Code** **Meaning**
-------- --------------------------------------------------------
0        Success (allow access)
1        Authentication token of the user not found (deny access)
2        Invalid authentication token (deny access)
3        User is not member of the required groups (deny access)
======== ========================================================

On success, the permit can optionally conatain a Base64 encoded version of
either an X.509 proxy certificate (``x509_proxy`` string field) or a bearer
token (``bearer_token`` string field). These credentials are used by the
CernVM-FS client when downloading nested catalogs files as client-side HTTPS
authentication information.

