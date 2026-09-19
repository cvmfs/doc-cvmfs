# Security Considerations
CernVM-FS verifies end-to-end data integrity and authenticity using a
signed Merkle Tree. CernVM-FS clients verify the cryptographic signature and the
content hashes of all downloaded data. (This is a stronger form of integrity verification
than using TLS, because it ensures the integrity of the content rather than the connection.)
Once a particular revision of a file system is stored in a client's local cache, the client will not
apply an older revision anymore.

The public key used to ultimately verify a repository's signature needs
to be distributed to clients through a channel different from CernVM-FS
content distribution. In practice, these public keys are distributed as
part of the source code or through `cvmfs-config-...` packages. One or
multiple public keys can be configured for a repository (the *fully
qualified repository name*), all repositories within a specific domain
(like `*.cern.ch`) or all repositories (`*`). If multiple keys are
configured, it is sufficient if any of them validates a signature.

Besides the client, data is also verified by the replication code
(Stratum 1 or preloaded cache) and by the release manager machine in
case the repository is stored in S3 and not on a local file system.

CernVM-FS does **not** provide data confidentiality out of the box.
In the standard deployment scenario, repositories contain public content,
and data is transferred via HTTP in order to enable caching in forward
proxy servers, which is required for scalability and performance.
CernVM-FS can be operated with HTTPS data transport, but this breaks
site-local cacheability, as a forward caching proxy would be considered
a MITM attacker in the context of a HTTPS connection to a stratum server.
Therefore, HTTPS should only be used in the following situations:

-   If it is necessary to preserve the confidentiality of client data access (i.e. concealing which clients are accessing which files - even though the files may be public).
-   If an alternative caching solution is employed (e.g. a commercial CDN with TLS termination), eliminating the need for conventional caching forward proxy servers.
-   To host repositories of confidential data, in conjunction with an authorization mechanism as described below.

Note that nearly all commercial object storages support unencrypted HTTP access, as it is a common requirement for CDN edge nodes and reverse proxying.

CernVM-FS can also be used to deliver confidential data.
For example, if HTTPS is used in combination with client-authentication using an
authz helper (see the [authorization helpers](cpt-plugins.md#authorization-helpers) section),
CernVM-FS can be configured for end-to-end data confidentiality.
Alternatively, HTTP transport and firewall rules can be used to allow access only
from authorized trusted IP addresses.

Once downloaded and stored in a cache, the CernVM-FS client fully trusts
the cache. Data in the cache can be checked for silent corruption but no
integrity re-check takes place.

## Signature Details

Creating and validating a repository signature is a two-step process.
The *repository manifest* (the file `.cvmfspublished`) is signed by a
private RSA key whose public part is stored in the form of an X.509
certificate in the repository. The fingerprint of all certificates that
are allowed to sign a repository is stored on a *repository whitelist*
(the file `.cvmfswhitelist`). The whitelist is signed with a different
RSA key, the *repository master key*. Only the public part of this
master key needs to be distributed to clients.

The X.509 certificate currently only serves as an envelope for the
public part of a repository key. No further certificate validation takes
place.

The repository manifest contains, among other information, the content
hash of the root file catalog, the content hash of the signing
certificate, the fully qualified repository name, and a timestamp. In
order to sign the manifest, the content of the manifest is hashed and
encrypted with a private repository key. The timestamp and repository
name are used prevent replay attacks.

The whitelist contains the fully qualified repository name, a creation
timestamp, an expiry timestamp, and the certificate fingerprints. Since
the whitelist expires, it needs to be regularly resigned.

The private part of the repository key needs to be accessible on the
release manager machine. The private part of the repository master key
used to sign the whitelist *can* be maintained on a file on the release
manager machine. We recommend, however, to use a smart card to store
this private key. See the [Master keys](cpt-repo.md#master-keys) section for more details.

## Content Hashes

CernVM-FS supports multiple content hash algorithms: SHA-1 (default),
RIPEMD-160, and SHAKE-128 with 160 output bits. The content hash
algorithm can be changed with every repository publish operation. Files
and file catalogs hashed with different content hash algorithms can
co-exist. On changing the algorithm, new and changed files are hashed
with the new algorithm, existing data remains unchanged. That allows
seamless migration from one algorithm to another.

## Local UNIX Permissions

Most parts of CernVM-FS do not require root privileges. On the server
side, only creating and deleting a repository (or replica) requires root
privileges. Repository transactions and snapshots can be performed with
an unprivileged user account. In order to remount a new file system
revision after publishing a transaction, the release manager machine
uses a custom suid binary.

On client side, the CernVM-FS fuse module is normally started as root.
It drops root privileges and changes the persona to the `cvmfs` user
early in the file system initialization. The client RPM package installs
SElinux rules for RHEL6 and RHEL7. The cache directory should be labeled
as `cvmfs_cache_t`.

## Running the client as a normal user
The client can also be started as a normal user. In this case, the user
needs to have access to /dev/fuse. On Linux kernels < 4.18, mounting
/dev/fuse is either performed by fuse's `fusermount` utility or through
a pre-mounted file descriptor. On newer Linux kernels, the client can
mount as an unprivileged user in a user namespace with a detached mount
namespace.

The easiest way to run the client as a normal user is with the
[cvmfsexec](https://github.com/cvmfs/cvmfsexec) package. It supports
four ways to run cvmfs as an unprivileged user, depending on the
capabilities available on the host. See the README there for details.

## SETUID bit and file capabilities

By default, CernVM-FS repositories are mounted with the `nosuid` option.
Therefore, file capabilities and the setuid bit of files in the
repository are ignored. The root user can decide to mount a CernVM-FS
repository with the `cvmfs_suid` option, in which case the original
behavior of the suid flag and file capabilities is restored.

## CernVM-FS Software Distribution

CernVM-FS software is distributed through HTTPS in packages. There are
yum and apt repositories for Linux and `pkg` packages for OS X. Software
is available from HTTPS servers. The Linux packages and repositories are
signed with a GPG key.
