Release Notes for CernVM-FS 2.3.4
=================================

CernVMV-FS 2.3.4 is a patch release containing bugfixes and adjustments
necessary for smooth operation.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to
update only a few worker nodes first and gradually ramp up once the new version
proves to work correctly. Please take special care when upgrading a cvmfs
client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.

For Release Manager Machines, all transactions must be closed before upgrading.

**Note for upgrades from versions prior to 2.3.3**: please also see the
specific instructions in the release notes for version 2.3.3 and earlier.

Bug Fixes
---------

  * Client: work around CentOS 7 bug that can kill cvmfs fuse mount points on ``systemctl restart autofs`` (`CVM-1200 <https://sft.its.cern.ch/jira/browse/CVM-1200>`_)
  * Client: fix getting the ``rawlink`` extended attribute
  * Client: remove corrupted empty files from cache during recovery of the cache database after worker node crash (`CVM-1113 <https://sft.its.cern.ch/jira/browse/CVM-1113>`_)
  * Server: fix automatic tag cleanup for repositories with large tag lists (`CVM-1198 <https://sft.its.cern.ch/jira/browse/CVM-1198>`_)
  * Server: fix stratum 0 /etc/fstab migration from versions < 2.1.20 (`CVM-1182 <https://sft.its.cern.ch/jira/browse/CVM-1182>`_)
  * Server: allow for keys directory in addition to specific public key list for stratum 1 repositories (`CVM-985 <https://sft.its.cern.ch/jira/browse/CVM-985>`_)
  * Server: improve snapshot logging for repositories with large tag lists (`CVM-1021 <https://sft.its.cern.ch/jira/browse/CVM-1021>`_)


Release Notes for CernVM-FS 2.3.3
=================================

CernVMV-FS 2.3.3 is a hotpatch release containing bugfixes and adjustments
necessary for smooth operation.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to
update only a few worker nodes first and gradually ramp up once the new version
proves to work correctly. Please take special care when upgrading a cvmfs
client in NFS mode.

**Note for mac OS 10.12 Sierra**: Please use `FUSE for macOS 3.5.2 or newer
<https://github.com/osxfuse/osxfuse/releases>`_, which fixes stuck Fuse
mountpoints on Sierra.

For Stratum 1 servers, there should be no running snapshots during the upgrade.

For Release Manager Machines, all transactions must be closed before upgrading.

For both Release Manager Machines and Stratum 1 servers, after the software
upgrade, the directory layout on the release manager needs to be slightly
adjusted by a call to ``cvmfs_server migrate`` for each repository.  If the
configuration of the server is handled by a configuration management system
(Puppet, Chef, ...), please see Section :ref:`sct_manual_migration_2.3.2`.

**Note for upgrades from versions prior to 2.3.2**: please also see the
specific instructions in the release notes for version 2.3.2.

Bug Fixes
---------

  * Client: perform host failover when receiving corrupted data from stratum 1 (`CVM-478 <https://sft.its.cern.ch/jira/browse/CVM-478>`_)
  * Client: add support for ``CVMFS_CONFIG_REPO_REQUIRED`` option (`CVM-1111 <https://sft.its.cern.ch/jira/browse/CVM-1111>`_)
  * Client: add support for ``cvmfs_talk external host switch`` (`CVM-1126 <https://sft.its.cern.ch/jira/browse/CVM-1126>`_)
  * Client: fix ``cvmfs_config`` on EL7 if working directory is /usr/bin (`CVM-1118 <https://sft.its.cern.ch/jira/browse/CVM-1118>`_)
  * Client: fix crash when ``cvmfs_talk cleanup rate`` is called without an argument
  * Client: fix misleading cache cleanup log message (`CVM-1128 <https://sft.its.cern.ch/jira/browse/CVM-1128>`_)
  * Client: fix output of ``cvmfs_config umount`` on failures
  * Server: accept OverlayFS / ext4 on RHEL >= 7.3 (`CVM-835 <https://sft.its.cern.ch/jira/browse/CVM-835>`_)
  * Server: fix potential deadlock when uploading catalogs (`CVM-1165 <https://sft.its.cern.ch/jira/browse/CVM-1165>`_)
  * Server: fix asynchronous cleanup with open file descriptors on some aufs versions
  * Server: prevent garbage collection from running at the same time as snapshot (`CVM-1108 <https://sft.its.cern.ch/jira/browse/CVM-1108>`_)
  * Server: don't ignore stale locks when publishing (`CVM-1146 <https://sft.its.cern.ch/jira/browse/CVM-1146>`_)
  * Server: increase robustness when fetching reflog and checksum (`CVM-1114 <https://sft.its.cern.ch/jira/browse/CVM-1114>`_, `CVM-1124 <https://sft.its.cern.ch/jira/browse/CVM-1124>`_)
  * Server: fix history file leak on automatic removal of generic tags
  * Server: fix migration of server info JSON files (`CVM-1159 <https://sft.its.cern.ch/jira/browse/CVM-1159>`_)
  * Server: fix ``cvmfs_server resign`` if ``CVMFS_HASH_ALGORITHM`` is unset (`CVM-1013 <https://sft.its.cern.ch/jira/browse/CVM-1013>`_)
  * Server: fix selecting repositories by wildcard (`CVM-1151 <https://sft.its.cern.ch/jira/browse/CVM-1151>`_)
  * Server: compact reflog after garbage collection (`CVM-1162 <https://sft.its.cern.ch/jira/browse/CVM-1162>`_)
  * Server: add .cvmfs_status file for stratum 1 monitoring (`CVM-1107 <https://sft.its.cern.ch/jira/browse/CVM-1107>`_)
  * Preloader: fix application of dirtab for nested catalogs
  * Fixes for macOS 10.12 Sierra (`CVM-1084 <https://sft.its.cern.ch/jira/browse/CVM-1084>`_)
  * Fix building on EL 7.3 (`CVM-1153 <https://sft.its.cern.ch/jira/browse/CVM-1153>`_)


Release Manager Machines on EL 7
--------------------------------

As of RHEL 7.3, the overlayfs implementation shipped with the Red Hat kernel
passes the CernVM-FS integration tests provided that /var/spool/cvmfs is served
by an ext4 file system. In this case, the ``cvmfs_server mkfs`` command does
not prevent anymore creation of new repositories. Reportedly, the overlayfs
implementation also works if /var/spool/cvmfs is on an xfs partition that was
created with the ``ftype=1`` option. This has not yet been verified by
integration tests. Users can export ``CVMFS_DONT_CHECK_OVERLAYFS_VERSION=yes``
in order to force the creation of a repository.



.. _sct_manual_migration_2.3.2:

Manual Migration from 2.3.2 Release Manager Machines and Stratum 1s
-------------------------------------------------------------------

Repositories on release manager machines and Stratum 1 servers can be migrated from version 2.3.2 with the following steps.  Earlier version require additional migration to 2.3.2 first.

  1. Ensure that there are no open transactions and no running snapshots before updating the server software.

  2. Install the ``cvmfs-server`` 2.3.3 package.

  3. Ensure that the ``/srv/cvmfs/info/v1/meta.json`` and ``/srv/cvmfs/info/v1/repositories.json`` files exist and are being served by the Stratum 0/1 (see Section :ref:`sct_metainfo`).

The following step has to be done for all repositories on the server:

  3. Update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and set ``CVMFS_CREATOR_VERSION=2.3.3-1``


In agreement with the repository owner, it's recommended for stratum 0 servers to make a test publish

::

    cvmfs_server transaction <REPOSITORY>
    cvmfs_server publish <REPOSITORY>

before resuming normal operation.



Release Notes for CernVM-FS 2.3.2
=================================

CernVM-FS 2.3 comes with performance improvements and several new features and
bugfixes. We would like to thank Dave Dykstra (FNAL), Brian Bockelman
(U. Nebraska) and David Abdurachmanov (CERN/CMS) for their contributions to this
release!

Substantial improvements in this release are:

  * A plugin interface for client-side authorization helpers (see Section
    :ref:`sct_authz` for details).

  * Reworked data structures for garbage-collectable repositories. Stratum 0 and
    Stratum 1 servers now keep independent "reference logs" for the objects in
    their respective storage. That improves the robustness of replicated,
    garbage-collected repositories in a number of corner cases. The transition
    to the new data structures takes place automatically on the first GC run
    after the software upgrade.

  * Official support for manually triggered garbage collection with
    ``cvmfs_server gc``.

  * Possibility to automatically cleanup older repository tags.  The new
    server-side parameter ``CVMFS_AUTO_TAG_TIMESPAN`` can be used to control
    the life time of automatically created repository tags
    (`CVM-982 <https://sft.its.cern.ch/jira/browse/CVM-982>`_)

  * For the S3 storage backend: removal of the bucket number in the bucket name
    if only a single bucket is used.

  * Performance improvements and reduced memory footprint for client and server.

  * New platforms: Fedora 24 on x86_64, SLES 12 on x86_64, CentOS 7 on AArch64

As with previous releases, upgrading should be seamless just by installing the
new package from the repository. As usual, we recommend to update only a few
worker nodes first and gradually ramp up once the new version proves to work
correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading.  After
the software upgrade, the directory layout on the release manager needs to be
adjusted by a call to ``cvmfs_server migrate`` for each repository.

**Note**: if the configuration of the Stratum 0 server is handled by a configuration management system (Puppet, Chef, ...), please see Section :ref:`sct_manual_migration`.

**Note for garbage collectable repositories**: For garbage collected repositories on Stratum 0 and Stratum 1 servers, please run ``cvmfs_server gc`` manually once after the software update.  The automatic garbage collection will not work until the manual garbage collection run.

For Stratum 1 server, there should be no running snapshots during the upgrade.

Please find below the list of bugfixes and smaller improvements.

Bug Fixes
---------

  * Client: fix rare corruption on NFS maps during mount / reload

  * Client: fix ``mount -t cvmfs -o remount ...``
    (`CVM-1068 <https://sft.its.cern.ch/jira/browse/CVM-1068>`_)

  * Client: fix potential null pointer dereference for authz extended attribute

  * Client: fix segfault in debug logging of certain download failures
    (`CVM-1076 <https://sft.its.cern.ch/jira/browse/CVM-1076>`_)

  * Client: fix a few small memory leaks during ``cvmfs_config reload``

  * Client: gracefully deal with proxies without http:// prefix
    (`CVM-1045 <https://sft.its.cern.ch/jira/browse/CVM-1045>`_)

  * Client: fix up ``cvmfs_talk external ...`` commands
    (`CVM-981 <https://sft.its.cern.ch/jira/browse/CVM-981>`_)

  * Client: prevent fallback proxies from interfering with external data
    (`CVM-1058 <https://sft.its.cern.ch/jira/browse/CVM-1058>`_)

  * Server: clean environment before calling ``cvmfs_suid_helper``

  * Server: fix a rare crash when parsing the whitelist

  * Server: fix crash when publishing a symlink to a recreated directory

  * Server: fix lookup of sbin binaries in the ``cvmfs_server`` script

  * Server: fix publishing of auto catalog markers
    (`CVM-1079 <https://sft.its.cern.ch/jira/browse/CVM-1079>`_)

  * Server: fix false warning on graft files when removing trees on overlayfs
    (`CVM-932 <https://sft.its.cern.ch/jira/browse/CVM-932>`_)

  * Server: fix ``lsof`` report in ``cvmfs_server`` on newer Linux distributions

  * Server: fix error reporting when downloading replication sentinal file
    (`CVM-1078 <https://sft.its.cern.ch/jira/browse/CVM-1078>`_)

  * Server: prevent ``cvmfs_server migrate`` on a repository that is in a
    transaction

  * Server: reset file capabilities of ``cvmfs_swissknife`` on package update
    (`CVM-1038 <https://sft.its.cern.ch/jira/browse/CVM-1038>`_)

Improvements
------------

  * Client: add support for a default.conf in the config repository
    (`CVM-993 <https://sft.its.cern.ch/jira/browse/CVM-993>`_)

  * Client: improve debuggability with Valgrind

  * Server: add help text for ``cvmfs_server mount`` command
    (`CVM-996 <https://sft.its.cern.ch/jira/browse/CVM-996>`_)

  * Server: Warn before forcfully remounting the file system stack, new
    parameter ``CVMFS_FORCE_REMOUNT_WARNING``

  * Server: add support for ``cvmfs_server publish -f`` to force publishing in
    the presence of open file descriptors


.. _sct_manual_migration:

Manual Migration from 2.2 Release Manager Machines
--------------------------------------------------

Release manager machines that maintain Stratum 0 repositories can be migrated from version 2.2 with the following steps:

  1. Ensure that there are no open transactions before updating the server software and during the repository layout migration.

  2. Install the ``cvmfs-server`` 2.3 package.

The following steps have to be performed for all repositories on the release manager machine:

  3. Unmount /cvmfs/<REPOSITORY>

  4. In /var/spool/cvmfs/<REPOSITORY>/scratch, create the subdirectories ``current`` and ``wastebin`` and make sure that they are owned by the user who owns the repository

  5. In /etc/fstab, update the aufs entry for /cvmfs/<REPOSITORY> such that the writable branch points to the new ``current`` subdirectory.  A new, valid fstab entry could look like this one

  ::

    aufs_cernvm-prod.cern.ch /cvmfs/cernvm-prod.cern.ch aufs br=/var/spool/cvmfs/cernvm-prod.cern.ch/scratch/current=rw:/var/spool/cvmfs/cernvm-prod.cern.ch/rdonly=rr,udba=none,ro,noauto 0 0

  6. Mount /cvmfs/<REPOSITORY>

  7. Update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and set ``CVMFS_CREATOR_VERSION=2.3.0-1``

  8. *Only* garbage collectable repositories: run ``cvmfs_server gc <REPOSITORY>`` in order to migrate internal data structures

In agreement with the repository owner, it's recommended to make a test publish

::

    cvmfs_server transaction <REPOSITORY>
    cvmfs_server publish <REPOSITORY>

before resuming normal operation.
