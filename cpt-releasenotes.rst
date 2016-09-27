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

For Stratum 1 server, there should be no running snapshots during the upgrade.

As was agreed in the Grid Deployment Board, this release was tested for 
two weeks before being moved to the production repositories.

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

  * Server: add ``cvmfs_server mount`` command
    (`CVM-996 <https://sft.its.cern.ch/jira/browse/CVM-996>`_)

  * Server: Warn before forcfully remounting the file system stack, new
    parameter ``CVMFS_FORCE_REMOUNT_WARNING``

  * Server: add support for ``cvmfs_server publish -f`` to force publishing in
    the presence of open file descriptors
