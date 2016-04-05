Release Notes for CernVM-FS 2.2
===============================

Version 2.2 comes with a number of new features and bugfixes.  We would like to
especially thank

  * Brian Bockelman (U. Nebraska)
  * Dave Dykstra (FNAL)
  * Derek Weitzel (U. Nebraska)

for their contributions to this release!

Substential improvements in this release are:

  * Move to semantic versioning.  Bugfix releases to this release will be named
    2.2.Z with an increasing value for Z.  In parallel, we will work on feature
    release cvmfs version 2.3.

  * Support for Overlay-FS on the release manager machine as an alternative to
    aufs.  Please note that Overlay-FS on RHEL 7 is unfortunately not yet
    functional enough to operate with a cvmfs release manager machine.  The
    Overlay-FS versions in Fedora 23 and Ubuntu 15.10 do work.

  * Support for extended attributes, such as file capabilities and SElinux
    attributes.

  * Support for the SHA-3 derived SHAKE-128 algorithm as an alternative to the
    aging SHA-1 and RIPEMD-160 content hash algorithms.

  * New platforms: OS X El Capitan (client only), AArch64 (experimental),
    Power 8 little-endian (experimental)

  * Experimental support for automatic creation of nested catalogs.

  * New experimental features that facilitate data distribution in certain
    scenarios (see below).

As with previous releases, upgrading should be seamless just by installing the
new package from the repository.  Please take special care when upgrading a
cvmfs client in NFS mode.  As of this release, we also provide an
apt repository.

This release has been tested at the CERN Tier 1 for the last couple of weeks.

Please find below details on the larger new features and changes, followed by
the usual list of bugfixes and smaller improvements.

Semantic Versioning
-------------------

So far cvmfs versions had the form 2.1.Z where Z increased for both bugfix
releases and feature releases.  As of this release, version numbers 2.Y.Z will
have the following meaning

Major version 2: will only be changed when backwards compatibility fully breaks.
That is if the internal storage format changes in such a way that new servers
cannot maintain repositories for old clients anymore.  We have currently no
plans to change the major version.

Minor version Y: increases as new features are added.  We ensure that existing
repositories can be maintained by the latest 2.Y server and be accessible by all
clients and stratum 1 servers >= 2.1.  Repositories that start to make use of
new features introduced with a certain minor release Y might require a client
version >= 2.Y.  For instance, if a repository is migrated to the new SHAKE-128
content hash algorithm, it requires clients >= 2.2 that understand the
algorithm.

Bugfix version Z: no new features, only bug fixes.

Overlay-FS
----------

The CernVM-FS release manager machines use a union file system in order to track
write operations to ``/cvmfs/$repository``.  So far, the only supported union
file system was aufs.  As of this release, CernVM-FS alternatively supports
overlayfs.  In contrast to aufs, overlayfs is part of the upstream Linux kernel.

By design overlayfs does not support hard links.  Hard linked files installed in
an overlayfs backed CernVM-FS repository will be broken into multiple inodes on
publication of the repository.

The overlayfs file system is fully functional for CernVM-FS as of upstream
kernel 4.2 (e.g. Fedora 23, Ubuntu 15.10).  Unfortunately, the Overlay-FS
version of RHEL 7.2 is not yet fully functional.  A
`bug report with Red Hat <https://bugzilla.redhat.com/show_bug.cgi?id=1303139>`_
has been opened.

On creation of new repositories, the desired union file system can be
specified with the ``mkfs -f`` parameter.  If unspecified, CernVM-FS will try
aufs first and fallback to overlayfs.

Related JIRA ticket: `CVM-835 <https://sft.its.cern.ch/jira/browse/CVM-835>`_


Extended Attributes
-------------------

The CernVM-FS server can process and store extended attributes such as the ones
used to store SElinux labels and file capabilities.  In order to activate
support for extended attributes, set

::

    CVMFS_INCLUDE_XATTRS=true

in ``/etc/cvmfs/repositories.d/$repository/server.conf``.  Extended attributes
are only shown by clients >= 2.2, previous clients ignore the extended
attributes (but can still read the repository).

CernVM-FS currently can pick up extended attributes from regular files only.
CernVM-FS's support for extended attributes is further limited to 256 attributes
per file, with names <= 256 characters and values <= 256 bytes.

For regular software, storing extended attributes is usually unnecessary.
It becomes important for storing operating system files and application
container contents.

Related JIRA ticket: `CVM-734 <https://sft.its.cern.ch/jira/browse/CVM-734>`_


SHAKE-128 Content Hash
----------------------

As the currently supported content hashes SHA-1 and RIPEMD-160 are aging,
support for the SHAKE-128 variant from the SHA-3 standardized suite of hash
algorithms was added.  CernVM-FS uses SHAKE-128 with 160 output bits, i.e. the
resulting hashes have the same length as SHA-1 or RIPEMD-160.

An existing repository can be gradually migrated between content hashes.
The parameter

::

    CVMFS_HASH_ALGORITHM

in ``/etc/cvmfs/repositories.d/$repository/server.conf`` specifies the content
hash used during publish operations.  New and modified files will be processed
by the new content hash, existing files remain at the old hashes.

Please note that the use of SHAKE-128 requires all clients and stratum 1
servers to use version >= 2.2.  To older clients and stratum 1 servers such
repositories become unreadable.


Experimental: Automatic Creation of Nested Catalogs
---------------------------------------------------

In addition to the manually created nested catalogs by .cvmfscatalog files,
CernVM-FS can try to automatically cut large directory trees into nested
catalogs.  In order to activate automatic cutting, set

::

    CVMFS_AUTOCATALOGS=true

CernVM-FS will then maintain catalog sizes at reasonable minimum (1,000) and
maximum (100,000) number of entries.

Please note that due to a lack of knowledge about the repository contents, the
cutting of catalogs might occur at undesired points in the directory hierarchy.
For certain repositories, however, the automatic decisions might turn out to be
good enough.

Please further note that this is an experimental feature and not yet meant for
production use.


Experimental: Support For Data Federations
------------------------------------------

Four new features facilitate the use of CernVM-FS as a namespace for data hosted
in HTTP data federations.  These features are

  * Support for using HTTPS servers including authentication with the user's
    proxy certificate (file pointed to by ``X509_USER_PROXY``).

  * Support for "grafting" of files.  That means that files in a cvmfs
    repository can be described (including their content hash) without being
    actually processed.  It remains the responsibility of the user to provide
    the files at the expected URLs.

  * Support for uncompressed files in addition to the default of zlib compressed
    files.

  * Support for "external files" that have their URLs derived from their path
    rather than their content hash.

Please not that except grafting, using any of these features requires a
client >= 2.2.

Please further note that these are experimental features and not yet meant for
production use.  In particular, the support for certificate authentication will
be finalized in a further bugfix release. For further information, please refer
to the corresponding JIRA tickets or contact us directly.

Related JIRA tickets:
`CVM-904 <https://sft.its.cern.ch/jira/browse/CVM-904>`_
`CVM-905 <https://sft.its.cern.ch/jira/browse/CVM-905>`_
`CVM-906 <https://sft.its.cern.ch/jira/browse/CVM-906>`_
`CVM-907 <https://sft.its.cern.ch/jira/browse/CVM-907>`_
`CVM-908 <https://sft.its.cern.ch/jira/browse/CVM-908>`_


Smaller Improvements and Bug Fixes
----------------------------------
(Excluding fixes from the 2.2 server-only pre-release)

Bug Fixes
~~~~~~~~~

  * Client: let ``cvmfs_config chksetup`` find the fuse library in
    ``/usr/lib/$platform``
    (`CVM-802 <https://sft.its.cern.ch/jira/browse/CVM-802>`_)

  * Client: prevent ``ctrl+c`` during ``cvmfs_config reload``
    (`CVM-869 <https://sft.its.cern.ch/jira/browse/CVM-869>`_)

  * Client: fix memory and file descriptor leak in the download manager
    during reload

  * Client: immediately pick up modified file system snapshots after
    idle period
    (`CVM-636 <https://sft.its.cern.ch/jira/browse/CVM-636>`_)

  * Client: fix several rare races that can result in a hanging reload

  * Client: fix handling of empty ``CVMFS_CONFIG_REPOSITORY``

  * Client: perform host fail-over on HTTP 400 error code
    (`CVM-819 <https://sft.its.cern.ch/jira/browse/CVM-819>`_)

  * Client: fix cache directory selection in ``cvmfs_config wipecache``
    (`CVM-709 <https://sft.its.cern.ch/jira/browse/CVM-709>`_)

  * Client: fix mounting with a read-only cache directory

  * Client: fix rare deadlock on unmount

  * Client: unmount repositories when rpm is erased
    (`CVM-757 <https://sft.its.cern.ch/jira/browse/CVM-757>`_)

  * Client: remove sudo dependency from Linux packages

  * Server: fix rare bug in the garbage collection that can lead to removal of
    live files
    (`CVM-942 <https://sft.its.cern.ch/jira/browse/CVM-942>`_)

  * Server: add IPv6 support for GeoAPI
    (`CVM-807 <https://sft.its.cern.ch/jira/browse/CVM-807>`_)

  * Server: harden GeoAPI against cache poisoning
    (`CVM-722 <https://sft.its.cern.ch/jira/browse/CVM-722>`_)

  * Server: fix leak of temporary files in .cvmfsdirtab handling
    (`CVM-818 <https://sft.its.cern.ch/jira/browse/CVM-818>`_)

  * Server: fix auto tag creation for fast successive publish runs
    (`CVM-795 <https://sft.its.cern.ch/jira/browse/CVM-795>`_)

  * Server: fix cache-control max-age time coming from .cvmfs* files on EL7
    (`CVM-974 <https://sft.its.cern.ch/jira/browse/CVM-974>`_)

  * Server: fix mount point auto repair when only the read-only branch is broken
    (`CVM-918 <https://sft.its.cern.ch/jira/browse/CVM-918>`_)

  * Server: fix crash when publishing specific files which a size of a multiple
    of the chunk size
    (`CVM-957 <https://sft.its.cern.ch/jira/browse/CVM-957>`_)

  * Server: fix systemd detection in ``cvmfs_server`` on systems with multiple
    running systemd processes like Fedora 22

  * Server: fix crash for invalid spooler definition
    (`CVM-891 <https://sft.its.cern.ch/jira/browse/CVM-891>`_)

  * Server: fix stale lock file on server machine crash
    (`CVM-810 <https://sft.its.cern.ch/jira/browse/CVM-810>`_)

  * Server: fix URL option parsing for S3 backend in cvmfs_server

  * Server: do not roll back to incompatible catalog schemas
    (`CVM-252 <https://sft.its.cern.ch/jira/browse/CVM-252>`_)


Improvements
~~~~~~~~~~~~

  * Client: add ``cvmfs_config fsck`` command to run fsck on all configured
    repositories
    (`CVM-371 <https://sft.its.cern.ch/jira/browse/CVM-371>`_)

  * Client: add support for explicitly listed repositories in
    ``cvmfs_config probe``
    (`CVM-793 <https://sft.its.cern.ch/jira/browse/CVM-793>`_)

  * Client: add ``cvmfs_config killall`` command to escape from hanging mount
    points without a node reboot
    (`CVM-899 <https://sft.its.cern.ch/jira/browse/CVM-899>`_)

  * Client: add ``cvmfs_talk cleanup rate`` command to help detect inappropriate
    cache size configurations
    (`CVM-270 <https://sft.its.cern.ch/jira/browse/CVM-270>`_)

  * Client: detect missing ``http://`` proxy prefix in chksetup
    (`CVM-979 <https://sft.its.cern.ch/jira/browse/CVM-979>`_)

  * Client: add ``user.pubkeys`` extended attribute

  * Client: fail immediately if ``CVMFS_SERVER_URL`` is unset
    (`CVM-892 <https://sft.its.cern.ch/jira/browse/CVM-892>`_)

  * Client: add ``CVMFS_IPFAMILY_PREFER=[4|6]`` to select preferred IP
    protocol for proxies

  * Client: add support for IPv6 extensions in proxy auto config files
    (`CVM-903 <https://sft.its.cern.ch/jira/browse/CVM-903>`_)

  * Client: add ``CVMFS_MAX_IPADDR_PER_PROXY`` parameter to avoid very long
    fail-over chains

  * Client: allow for configuration of DNS timeout and retry
    (`CVM-875 <https://sft.its.cern.ch/jira/browse/CVM-875>`_)

  * Client: read blacklist from config repository if available
    (`CVM-901 <https://sft.its.cern.ch/jira/browse/CVM-901>`_)

  * Client: add ``CVMFS_SYSTEMD_NOKILL`` parameter to make cvmfs act as a
    systemd recognized low-level storage provider

  * Server: add ``cvmfs_rsync`` utility to support rsync of foreign directories
    in the presence of nested catalog markers
    (`CVM-814 <https://sft.its.cern.ch/jira/browse/CVM-814>`_)

  * Server: add static status files on stratum 0/1 server as well as for
    repositories
    (`CVM-860 <https://sft.its.cern.ch/jira/browse/CVM-860>`_,
    `CVM-804 <https://sft.its.cern.ch/jira/browse/CVM-804>`_)

  * Server: do not resolve magic symlinks in ``/cvmfs/*``
    (`CVM-879 <https://sft.its.cern.ch/jira/browse/CVM-879>`_)

  * Server: make ``CVMFS_AUTO_REPAIR_MOUNTPOINT`` the default
    (`CVM-889 <https://sft.its.cern.ch/jira/browse/CVM-889>`_)

  * Server: Do not mount ``/cvmfs`` on boot on the release manager machine;
    on the first transaction, ``CVMFS_AUTO_REPAIR_MOUNTPOINT`` mounts
    automatically

  * Server: add ``-p`` switch to ``cvmfs_server`` commands to skip Apache config
    modifications
    (`CVM-900 <https://sft.its.cern.ch/jira/browse/CVM-900>`_)

  * Server: log key events to syslog
    (`CVM-812 <https://sft.its.cern.ch/jira/browse/CVM-812>`_,
    `CVM-861 <https://sft.its.cern.ch/jira/browse/CVM-861>`_)

  * Server: add ``cvmfs_server snapshot -a`` as a convenience command to
    replicate all configured repositories on a stratum 1
    (`CVM-813 <https://sft.its.cern.ch/jira/browse/CVM-813>`_)

  * Server: add ``cvmfs_server check -s`` to verify repository subtrees

  * Server: enable ``cvmfs_server import`` to generate new repository keys
    (`CVM-865 <https://sft.its.cern.ch/jira/browse/CVM-865>`_)

  * Server: add ``CVMFS_REPOSITORY_TTL`` server parameter to specify the
    repository TTL in seconds

  * Server: don't re-commit existing files to local storage backend in server
    (`CVM-894 <https://sft.its.cern.ch/jira/browse/CVM-894>`_)

  * Server: allow geodb update for non-root users
    (`CVM-895 <https://sft.its.cern.ch/jira/browse/CVM-895>`_)

  * Server: add ``catalog-chown`` command to ``cvmfs_server``
    (`CVM-836 <https://sft.its.cern.ch/jira/browse/CVM-836>`_)

  * Server: avoid use of ``sudo``
    (`CVM-245 <https://sft.its.cern.ch/jira/browse/CVM-245>`_)

  * Server: print error message at the end of a failing ``cvmfs_server check``
    (`CVM-958 <https://sft.its.cern.ch/jira/browse/CVM-958>`_)

  * Server: add support for a garbage collection deletion log
    (`CVM-710 <https://sft.its.cern.ch/jira/browse/CVM-710>`_)

  * Library: add support for chunked files in libcvmfs
    (`CVM-687 <https://sft.its.cern.ch/jira/browse/CVM-687>`_)