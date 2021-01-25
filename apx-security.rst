.. _apx_security:

Security Considerations
=======================

CernVM-FS provides end-to-end data integrity and authenticity using a signed
Merkle Tree.  CernVM-FS clients verify the signature and the content hashes of
all downloaded data.  Once a particular revision of a file system is stored in
a client's local cache, the client will not apply an older revision anymore.

The public key used to ultimately verify a repository's signature needs to be
distributed to clients through a channel different from CernVM-FS content
distribution.  In practice, these public keys are distributed as part of the
source code or through ``cvmfs-config-...`` packages.  One or multiple public
keys can be configured for a repository (the *fully qualified repository name*),
all repositories within a specific domain (like ``*.cern.ch``) or all
repositories (``*``).  If multiple keys are configured, it is sufficient if any
of them validates a signature.

Besides the client, data is also verified by the replication code (Stratum 1 or
preloaded cache) and by the release manager machine in case the repository is
stored in S3 and not on a local file system.

CernVM-FS does **not** provide data confidentiality out of the box.  By default
data is transferred through HTTP and thus only public data should be stored on
CernVM-FS.  However, CernVM-FS can be operated with HTTPS data transport.  In
combination with client-authentication using an authz helper (see Section
:ref:`sct_authz`), CernVM-FS can be configured for end-to-end data
confidentiality.

Once downloaded and stored in a cache, the CernVM-FS client fully trusts the
cache.  Data in the cache can be checked for silent corruption but no integrity
re-check takes place.

Signature Details
-----------------

Creating and validating a repository signature is a two-step process.  The
*repository manifest* (the file ``.cvmfspublished``) is signed by a private RSA
key whose public part is stored in the form of an X.509 certificate in the
repository.  The fingerprint of all certificates that are allowed to sign a
repository is stored on a *repository whitelist* (the file ``.cvmfswhitelist``).
The whitelist is signed with a different RSA key, the *repository master key*.
Only the public part of this master key needs to be distributed to clients.

The X.509 certificate currently only serves as an envelope for the public part
of a repository key.  No further certificate validation takes place.

The repository manifest contains, among other information, the content hash of
the root file catalog, the content hash of the signing certificate, the fully
qualified repository name, and a timestamp. In order to sign the manifest, the
content of the manifest is hashed and encrypted with a private repository key.
The timestamp and repository name are used prevent replay attacks.

The whitelist contains the fully qualified repository name, a creation
timestamp, an expiry timestamp, and the certificate fingerprints.  Since the
whitelist expires, it needs to be regularly resigned.

The private part of the repository key needs to be accessible on the release
manager machine.  The private part of the repository master key used to sign the
whitelist *can* be maintained on a file on the release manager machine.
We recommend, however, to use a smart card to store this private key.
See section :ref:`sct_master_keys` for more details.


Content Hashes
--------------

CernVM-FS supports multiple content hash algorithms: SHA-1 (default),
RIPEMD-160, and SHAKE-128 with 160 output bits.  The content hash algorithm
can be changed with every repository publish operation.  Files and file catalogs
hashed with different content hash algorithms can co-exist.  On changing the
algorithm, new and changed files are hashed with the new algorithm, existing
data remains unchanged.  That allows seamless migration from one algorithm to
another.


Local UNIX Permissions
----------------------

Most parts of CernVM-FS do not require root privileges.  On the server side,
only creating and deleting a repository (or replica) requires root privileges.
Repository transactions and snapshots can be performed with an unprivileged user
account.  In order to remount a new file system revision after publishing a
transaction, the release manager machines uses a custom suid binary.

On client side, the CernVM-FS fuse module is normally started as root.  It drops
root privileges and changes the persona to the ``cvmfs`` user early in the file
system initialization.  The client RPM package installs SElinux rules for RHEL6
and RHEL7.  The cache directory should be labeled as ``cvmfs_cache_t``.


.. _sct_running_client_as_normal_user:

Running the client as a normal user
-----------------------------------

The client can also be started as a normal user. In this case, the user needs
to have access to /dev/fuse.  On Linux kernels < 4.18, mounting /dev/fuse is
either performed by fuse's ``fusermount`` utility or through a pre-mounted file
descriptor. On newer Linux kernels, the client can mount as an unprivileged
user in a user namespace with a detached mount namespace.

The easiest way to run the client as a normal user is with the
`cvmfsexec <https://github.com/cvmfs/cvmfsexec>`_ package.  It supports
four ways to run cvmfs as an unprivileged user, depending on the
capabilities available on the host.  See the README there for details.


SETUID bit and file capabilities
--------------------------------

By default, CernVM-FS repositories are mounted with the ``nosuid`` option.
Therefore, file capabilities and the setuid bit of files in the repository
are ignored. The root user can decide to mount a CernVM-FS repository with the
``cvmfs_suid`` option, in which case the original behavior of the suid flag
and file capabilities is restored.


CernVM-FS Software Distribution
-------------------------------

CernVM-FS software is distributed through HTTPS in packages.  There are yum and
apt repositories for Linux and ``pkg`` packages for OS X.  Software is available
from HTTPS servers.  The Linux packages and repositories are signed with a GPG
key.
