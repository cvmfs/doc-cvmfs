Release Notes for CernVM-FS 2.5.2
=================================

CernVM-FS 2.5.2 is a patch release.  It contains bugfixes and improvements for
clients, stratum 0 and stratum 1 servers.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update
only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS
mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For Release Manager Machines, all transactions must be closed before upgrading.
Together with CernVM-FS 2.5.2 we also release the CernVM-FS Gateway Services
version 0.3.1.

Note for upgrades from versions prior to 2.5.1: please also see the specific
instructions in the release notes for version 2.5.1 and earlier.


Bug Fixes and Improvements
--------------------------

  * Client: fix cache cleanup logic for chunks >25M
    `CVM-1625 <https://sft.its.cern.ch/jira/browse/CVM-1625>`_

  * Client: fix busy waiting in cache manager communication under heavy load
    `CVM-1618 <https://sft.its.cern.ch/jira/browse/CVM-1618>`_

  * Client: fix stale authz session cache when repository membership changes
    `CVM-1653 <https://sft.its.cern.ch/jira/browse/CVM-1653>`_

  * Client, macOS: add support for ``CVMFS_FUSE_NOTIFY_INVALIDATION``, disable
    by default on macOS to fix stability issues
    `CVM-1638 <https://sft.its.cern.ch/jira/browse/CVM-1638>`_

  * Client: add support for ``CVMFS_MAX_[EXTERNAL_]SERVERS`` to restrict the
    effective number of stratum 1 servers
    `CVM-1631 <https://sft.its.cern.ch/jira/browse/CVM-1631>`_

  * Client: add support for ``CVMFS_DNS_{MIN,MAX}_TTL`` for proxy name
    resolution `CVM-1659 <https://sft.its.cern.ch/jira/browse/CVM-1659>`_

  * Client: add support for ``CVMFS_SUID`` config parameter
    `CVM-1591 <https://sft.its.cern.ch/jira/browse/CVM-1591>`_

  * Client: log to syslog when session authorization disappears
    `CVM-1658 <https://sft.its.cern.ch/jira/browse/CVM-1658>`_

  * Client: change ``cvmfs_talk`` implementation from perl to C++ to improve
    speed

  * Server: more fine-grained syncfs control through
    ``CVMFS_SYNCFS_LEVEL=[none,default,cautious]``, change default back to 2.5.0
    behavior `CVM-1646 <https://sft.its.cern.ch/jira/browse/CVM-1646>`_

  * Server: update Apache config to ignore If-Modified-Since on stratum 1s
    `CVM-1655 <https://sft.its.cern.ch/jira/browse/CVM-1655>`_

  * Server: add retry support for ``cvmfs_server transaction``
    `CVM-1611 <https://sft.its.cern.ch/jira/browse/CVM-1611>`_

  * Server: restrict lazy downloads of geodb to once a day
    `CVM-1647 <https://sft.its.cern.ch/jira/browse/CVM-1647>`_

  * Server: print the start of mark and sweep phases during garbage collection

  * Server, replication/preloader: improve error reporting of network failures
    `CVM-1624 <https://sft.its.cern.ch/jira/browse/CVM-1624>`_

  * Server: print warnings during publish to stdout instead of stderr
    `CVM-1630 <https://sft.its.cern.ch/jira/browse/CVM-1630>`_

  * Server, S3: fix cache control headers for objects pushed to S3
    `CVM-1606 <https://sft.its.cern.ch/jira/browse/CVM-1606>`_

  * Server, S3: fix content type header for objects pushed to S3

  * Server, S3: add support for URL subpaths and DNS-style bucket URLs
    `CVM-1641 <https://sft.its.cern.ch/jira/browse/CVM-1641>`_

  * Server, S3: add support for ``CVMFS_S3_DNS_BUCKETS=false`` to disable
    DNS-style bucket URLs when S3 backend doesn't support them (e.g. Minio)
    `CVM-1641 <https://sft.its.cern.ch/jira/browse/CVM-1641>`_

  * Server, gateway: delete session tokens for transactions after use
    `CVM-1643 <https://sft.its.cern.ch/jira/browse/CVM-1643>`_

  * Server, gateway: fix permissions on temporary directory used by the receiver

  * Server, gateway: automatically apply lease path to abort and publish
    commands `CVM-1601 <https://sft.its.cern.ch/jira/browse/CVM-1601>`_

  * Server, gateway: bump gateway protocol version to 2
    `CVM-1626 <https://sft.its.cern.ch/jira/browse/CVM-1626>`_

  * Fix potential memory corruption in catalog traversal

  * Fix building on macOS 10.14


Manual Migration from 2.5.1 Stratum 1 Servers
---------------------------------------------

If you do not want to use ``cvmfs_server migrate`` to automatically upgrade,
stratum 1 servers that maintain repositories replicas using the Apache backend
can be migrated from version 2.5.1 with the following steps:

  1. Ensure that there are no active replication or garbage collection processes
     before updating the server software and during the repository layout
     migration.

  2. Install the ``cvmfs-server`` 2.5.2 package.

  3. Edit the Apache configuration for the repositories and add to the
     ``<Directory>`` section of the repositories

::

    RequestHeader unset If-Modified-Since

  4. Update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and set
     ``CVMFS_CREATOR_VERSION=140``



Release Notes for CernVM-FS 2.5.1
=================================

CernVM-FS 2.5.1 is a patch release.  It contains bugfixes and improvements for
clients, stratum 0 and stratum 1 servers.  This release also adds support for
Ubuntu 18.04 ("bionic").

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update
only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS
mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For Release Manager Machines, all transactions must be closed before upgrading.
Together with CernVM-FS 2.5.1 we also release the CernVM-FS Gateway Services
version 0.3.

Note for upgrades from versions prior to 2.5.0: please also see the specific
instructions in the release notes for version 2.5.0 and earlier.

Bug Fixes and Improvements
--------------------------

  * Client, macOS: Improved check for OSXFUSE in ``cvmfs_config chksetup``
    (`CVM-1550 <https://sft.its.cern.ch/jira/browse/CVM-1550>`_)

  * Client: avoid mount helper crash if required config repository is missing
    (`CVM-1512 <https://sft.its.cern.ch/jira/browse/CVM-1512>`_)

  * Client: Apply catalog updates from updated alien cache
    (`CVM-1515 <https://sft.its.cern.ch/jira/browse/CVM-1515>`_)

  * Client: Fix occasional false error of ``cvmfs_config probe`` on Fedora 28

  * Client: add support for CA bundle files through new parameter ``X509_CERT_BUNDLE``
    (`CVM-1421 <https://sft.its.cern.ch/jira/browse/CVM-1421>`_)

  * Libcvmfs: fix workspace default location

  * Server: fix broken repository manifest after catalog migration operations
    (`CVM-1534 <https://sft.its.cern.ch/jira/browse/CVM-1534>`_)

  * Server: fix locking bug in cvmfs_server snapshot
    (`CVM-1598 <https://sft.its.cern.ch/jira/browse/CVM-1598>`_)

  * Server: fix Yubikey signature handling (`CVM-1604 <https://sft.its.cern.ch/jira/browse/CVM-1604>`_)

  * Server: flush file system buffers after snapshot, gc, resign, and publish
    (`CVM-1552 <https://sft.its.cern.ch/jira/browse/CVM-1552>`_)

  * Server: fix ``cvmfs_suid_helper`` on Ubuntu 18.04 for symlinked spool directory

  * Server: replace deprecated geolite free database by geolite2
    (`CVM-1496 <https://sft.its.cern.ch/jira/browse/CVM-1496>`_)

  * Server, S3: parallelize object removal during garbage collection
    (`CVM-1593 <https://sft.its.cern.ch/jira/browse/CVM-1593>`_)

  * Server, S3: Make S3 network parameters adjustable, new parameters
    ``CVMFS_S3_MAX_RETRIES`` and ``CVMFS_S3_TIMEOUT``

  * Gateway: handle spooler failures gracefully in the gateway receiver
    (`CVM-1545 <https://sft.its.cern.ch/jira/browse/CVM-1545>`_)

  * Gateway: fix publishing with ``CVMFS_AUTO_TAGS=false``
    (`CVM-1559 <https://sft.its.cern.ch/jira/browse/CVM-1559>`_)

  * Gateway: fix potential deadlock when uploading files to the repository storage
    (`CVM-1555 <https://sft.its.cern.ch/jira/browse/CVM-1555>`_)

  * Gateway: fix hard link handling (`CVM-1542 <https://sft.its.cern.ch/jira/browse/CVM-1542>`_)

  * Gateway: terminate gracefully when reflog is missing
    (`CVM-1560 <https://sft.its.cern.ch/jira/browse/CVM-1560>`_)

  * Gateway: performance improvements for publishing

  * Fix potential memory corruption on gcc7+ in tiered cache manager and cvmfs_swissknife

  * Fix compilation with libattr >= 2.4.48

  * Fix compiler optimization flags for gcc8+ and macOS clang9+


Release Notes for CernVM-FS 2.5.0
=================================

CernVM-FS 2.5 is a feature release that comes with performance improvements,
new functionality, and bugfixes. We would like to thank Dave Dykstra (FNAL),
Brian Bockelman (U. Nebraska) and Ben Tovar (U. Notre Dame) for their
contributions to this release!

This release comes with the new Repository Gateway Services that allow for
multiple release managers operating concurrently on different subtrees of
a repository.

This release also comes with rewritten code for the processing of new files.
This was necessary to address several lurking deadlocks. This change should be
transparent to users.

Other notable changes include

  * Support for AWSv4 authorization protocol in the S3 backend

  * Removal of the "multi-bucket" support in the S3 backend (this feature
    was aimed at a specific, now outdated hardware product)

  * Allow for automatic but infrequent garbage collection

  * Support for publishing special files (named pipes, sockets, device files)

  * Client can adjust itself to a change of the DNS servers

  * New platforms: Fedora 26 and 27 on x86_64, macOS 10.11+

As with previous releases, upgrading should be seamless just by installing the
new package from the repository. As usual, we recommend to update only a few
worker nodes first and gradually ramp up once the new version proves to work
correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading.
For Stratum 1 servers, there should be no running snapshots during the upgrade.
After the software upgrade, both stratum 0 and 1 servers require doing ``cvmfs_server migrate`` for each repository.


**Note**: if the configuration of the Stratum 0/1 server is handled by a
configuration management system (Puppet, Chef, ...), please see Section
:ref:`sct_manual_migration`.


Gateway Services
----------------

The new CernVM-FS Gateway Services allow for distributed server deployments.
This can be used for multi-tenant repositories, where every tenant takes
ownership of a specific repository subtree.  It can also be used to parallelize
publishing of content if the different change sets are limited to a specific
subtree.

The gateway services come as separate packages. They control the access to the
storage and they need to be installed on a central machine. Multiple release
manager machines can then be installed that use the gateway service to operate
on the same repository.

Detailed documentation is available in Chapter :ref:`cpt_repository_gateway`.


Automatic, Infrequent Garbage Collection
-----------------------------------------

The new parameter ``CVMFS_AUTO_GC_LAPSE`` can be used on stratum 0 and stratum 1
to specify how often the garbage collection should run
(`CVM-1400 <https://sft.its.cern.ch/jira/browse/CVM-1400>`_).

It works like the existing ``CVMFS_..._TIMESPAN`` parameters with a string that
is parsed by the ``date`` utility.  The default setting is ``1 day ago``,
meaning that garbage collection runs on publish if the last garbage collection
(manual or automatic) was more that one day ago.


Bug Fixes
---------

  * Client: fix crash in ``cvmfs_talk remount`` with fixed repository snapshot

  * Client: fix retry of repository manifest download in "offline mode"

  * Client: fix statvfs for cache size >4G on macOS
    (`CVM-1474 <https://sft.its.cern.ch/jira/browse/CVM-1474>`_)

  * Client: use lazy unmount as a last resort in ``cvmfs_config killall``
    (`CVM-1465 <https://sft.its.cern.ch/jira/browse/CVM-1465>`_)

  * Client: Fix storage location of the catalog checksum destination in certain
    rare cache configurations
    (`CVM-962 <https://sft.its.cern.ch/jira/browse/CVM-962>`_)

  * Client: fix error message when trying to mount an already mounted repo
    (`CVM-1477 <https://sft.its.cern.ch/jira/browse/CVM-1477>`_)

  * Server: fix garbage collection of idle repositories
    (`CVM-1460 <https://sft.its.cern.ch/jira/browse/CVM-1460>`_)

  * Server: use ``systemd start <mount unit>`` in suid helper if applicable
    (`CVM-1398 <https://sft.its.cern.ch/jira/browse/CVM-1398>`_)

  * Server: fix transaction abort with many temporary files
    (`CVM-1390 <https://sft.its.cern.ch/jira/browse/CVM-1390>`_)

  * Server: place bootstrapping symlinks on replica storage
    (`CVM-1366 <https://sft.its.cern.ch/jira/browse/CVM-1366>`_)

  * Server: sanitize repository names in cvmfs_server
    (`CVM-1389 <https://sft.its.cern.ch/jira/browse/CVM-1389>`_)

  * Server: check for autofs in ``cvmfs_server rmfs`` only for stratum 0s
    (`CVM-1490 <https://sft.its.cern.ch/jira/browse/CVM-1490>`_)

  * Server: fix warnings with bash >= 4.4
    (`CVM-1401 <https://sft.its.cern.ch/jira/browse/CVM-1401>`_)


Other Improvements
------------------

  * Client: don't enforce ``user_allow_other`` fuse option
    (`CVM-1379 <https://sft.its.cern.ch/jira/browse/CVM-1379>`_)

  * Client: use /etc/auto.master.d/cvmfs.autofs if applicable
    (`CVM-675 <https://sft.its.cern.ch/jira/browse/CVM-675>`_)

  * Client: improve CPU utilization when downloading with limited bandwidth
    (`CVM-1480 <https://sft.its.cern.ch/jira/browse/CVM-1480>`_)

  * Client: send "offline mode" enter/recover events to syslog
    (`CVM-1497 <https://sft.its.cern.ch/jira/browse/CVM-1497>`_)

  * Client: implement ``CVMFS_DNS_ROAMING`` on Linux
    (`CVM-496 <https://sft.its.cern.ch/jira/browse/CVM-496>`_)

  * Client: increase default cache limit to 20G on macOS

  * Client: use ``CVMFS_MAX_IPADDR_PER_PROXY=2`` by default on macOS

  * Client: automatically restart failed authz helper after cool-off period

  * Client: create libcvmfs.a and libcvmfs_cache.a on macOS
    (`CVM-1489 <https://sft.its.cern.ch/jira/browse/CVM-1489>`_)

  * Server: use AWSv4 S3 authorization if ``CVMFS_S3_REGION`` is set
    (`CVM-988 <https://sft.its.cern.ch/jira/browse/CVM-988>`_)

  * Server: add ``CAP_DAC_READ_SEARCH`` to swissknife to publish locked-down
    files

  * Server: add support for diff snapshots based on root hash
    (`CVM-1452 <https://sft.its.cern.ch/jira/browse/CVM-1452>`_)

  * Server: add ``cvmfs_server tag -b`` to print the hierarchy of branches
    (`CVM-1392 <https://sft.its.cern.ch/jira/browse/CVM-1392>`_)

  * Server: make ``CVMFS_GENERATE_LEGACY_BULK_CHUNKS=false`` the default
    (`CVM-1429 <https://sft.its.cern.ch/jira/browse/CVM-1429>`_)

  * Server: add CloudFlare support to GeoAPI
    (`CVM-1468 <https://sft.its.cern.ch/jira/browse/CVM-1468>`_)

  * Server: set httpd selinux label for GeoIP database
    (`CVM-1454 <https://sft.its.cern.ch/jira/browse/CVM-1454>`_)

  * Server: new server parameter ``CVMFS_IGNORE_SPECIAL_FILES``


.. _sct_manual_migration:

Manual Migration from 2.4.4 Release Manager Machines
----------------------------------------------------

If you do not want to use ``cvmfs_server migrate`` to automatically upgrade,
release manager machines that maintain Stratum 0 repositories as well as web
servers serving stratum 0/1 repositories can be migrated from version 2.4.4 with
the following steps:

  1. Ensure that there are no open transactions and no active replication or
     garbage collection processes before updating the server software and during
     the repository layout migration.

  2. Install the ``cvmfs-server`` 2.5 package.

  3. *Only on release manager machines*:
     Adjust the /etc/fstab entries for union file system mount (/cvmfs/...) of
     the repositories: add the ``nodev`` mount option after the ``noauto`` mount
     option.

  4. *Only on systemd managed release manager machines*:
     Ensure that the mount units for all the repositories exist by running


::

    /usr/lib/systemd/system-generators/systemd-fstab-generator \
      /run/systemd/generator '' '' 2>/dev/null
    systemctl daemon-reload

On both stratum 0 and stratum 1 servers

  5. Update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and set
     ``CVMFS_CREATOR_VERSION=139``

On release manager machines, in agreement with the repository owner it's
recommended to make a test publish

::

    cvmfs_server transaction <REPOSITORY>
    cvmfs_server publish <REPOSITORY>

before resuming normal operation.
