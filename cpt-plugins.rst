.. _cpt_plugins:

Client Plug-Ins
===============

The CernVM-FS client's functionality can be extended through plug-ins.
CernVM-FS plug-ins are binaries (processes) that communicate with the main
client process through IPC.  Currently the only plug-in interface is for
authorization helpers.

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
searches for a binary ``${CVMFS_AUTHZ_SEARCH_PATH}/cvmfs_helper_<helper>``.  By
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

On success, the permit can optionally conatain a Base64 encoded version of an
X.509 proxy certificate (``x509_proxy`` string field).  This certificate is used
by the CernVM-FS client when downloading nested catalogs files as client-side
HTTPS authentication certificate.

.. _sct_plugin_cache:

Cache Plugins
-------------
