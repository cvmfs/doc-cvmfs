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

For Stratum 0 servers, all transactions must be closed before upgrading.  After
the software upgrade, the directory layout on the release manager needs to be
adjusted by a call to ``cvmfs_server migrate`` for each repository.

For Stratum 1 server, there should be no running snapshots during the upgrade.

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

Detailed documentation is available in Section :ref:`sct_manual_migration`.


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
