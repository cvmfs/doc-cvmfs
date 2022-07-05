Release Notes for CernVM-FS 2.9.4
=================================

CernVM-FS 2.9.4 is a patch release, containing two important bug fixes: a fix for
a deadlock affecting the garbage collector, and an improvement of the link between
the watchdog process and the fuse module.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update
only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS
mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

This version introduces experimental support for Ubuntu 22.04 and CentOS Stream 9. Packages are available for both the x86_64 and aarch64 architectures. Due to a compatibility bug with the version of OpenSSL offered by the system, the cvmfs-server package is not currently working properly on CentOS Stream 9.

Bug Fixes and Improvements
--------------------------

  * [client] Improve robustness of link between watchdog and fuse module (#2971)
    ([#2971](https://github.com/cvmfs/cvmfs/pull/2971))
  * [server] Fix releasing of GC lock (#2982)
    ([#2982](https://github.com/cvmfs/cvmfs/pull/2982))


Release Notes for CernVM-FS 2.9.2
=================================

CernVM-FS 2.9.2 is a patch release. It includes fixes for clients and servers.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update
only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS
mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

The CernVM-FS 2.9.1 packages contained an issue which prevented the rebuilding of source RPMs. CernVM-FS 2.9.2 addressed this and was released in place of 2.9.1, containing no other changes.

Bug Fixes and Improvements
--------------------------

  * [client] Improve error reporting in watchdog process
    ([#2859](https://github.com/cvmfs/cvmfs/pull/2859))
  * [server] Fix potential use-after-free error in swissknife check
    ([#2860](https://github.com/cvmfs/cvmfs/pull/2860))
  * [server] Fix conflict in commandline arguments of cvmfs_ducc
    ([#2853](https://github.com/cvmfs/cvmfs/issues/2853))
  * [server] Running cvmfs_server check -a and gc -a is now mutually exclusive
    ([CVM-2043](https://sft.its.cern.ch/jira/projects/CVM/issues/CVM-2043))
  * [server] Enable external monitoring of geodb updates, add the
    CVMFS_GEO_AUTO_UPDATE option
    ([CVM-1857](https://sft.its.cern.ch/jira/projects/CVM/issues/CVM-1857))
  * [server[ Ignore trailing path after repo name in `cvmfs_server abort`
    ([CVM-2055](https://sft.its.cern.ch/jira/projects/CVM/issues/CVM-2055))
  * [client] New option to list magic xattrs on root node only
    ([CVM-2058](https://sft.its.cern.ch/jira/projects/CVM/issues/CVM-2058))
  * [server] Fix integrity check for external chunked files
    ([CVM-2050](https://sft.its.cern.ch/jira/projects/CVM/issues/CVM-2050))
  * [server] Fix for GeoAPI and Python3
    ([CVM-2052](https://sft.its.cern.ch/jira/projects/CVM/issues/CVM-2052))
  * [server] Fix initialization of upstream type in cvmfs_server ingest
    ([#2816](https://github.com/cvmfs/cvmfs/pull/2816))
  * [server] Fix bug where trailing slash in base dir crashes tarball ingest
    ([CVM-2044](https://sft.its.cern.ch/jira/projects/CVM/issues/CVM-2044))


Release Notes for CernVM-FS 2.9.0
=================================

CernVM-FS 2.9.0 is a feature release. Highlights are:

  * Incremental conversion of container images, resulting in a large speed-up for
    publishing new container image versions to unpacked.cern.ch

  * Support for maintaining repositories in S3 over HTTPS (not just HTTP)

  * Significant speed-ups for S3 and gateway publisher deployments

  * Various bugfixes and smaller improvements (error reporting, repository
    statistics, network failure handling, etc.)

New platforms: Debian 11, SLES 15, AArch64 RHEL 8

Two new features are introduced in this release, as technical previews (experimental):

  * Publish support from ephemeral containers (e.g. in k8s pods)

  * Container image conversion on push notification from Harbor registries (such as registry.cern.ch)

Starting with CernVM-FS 2.9.0, we use a unified version number for all packages (client, server, gateway, etc.). All required packages should be updated in concert.

As with previous releases, upgrading should be seamless just by installing the new package from the repository. As usual, we recommend to update only a few worker nodes first and gradually ramp up once the new version proves to work correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading. For Stratum 1 servers, there should be no running snapshots during the upgrade. After the software upgrade, publisher nodes require doing cvmfs_server migrate for each repository.

Bug fixes
---------

  * [gw] Fix spurious keychain warning on transaction (`CVM-1982 <https://sft.its.cern.ch/jira/browse/CVM-1982>`_)
  * [gw] Fix lease statistics extraction during commit (`CVM-1939 <https://sft.its.cern.ch/jira/browse/CVM-1939>`_)
  * Fix cvmfs_talk host info for empty host chain (`CVM-2023 <https://sft.its.cern.ch/jira/browse/CVM-2023>`_)
  * [ducc] Fix access to authenticated registries
  * Fix potential activation of corruption stratum 1 snapshot
  * Fix union mountpoint handling on Fedora >= 34
  * Fix potential crash when accessing extended attributes (`CVM-2014 <https://sft.its.cern.ch/jira/browse/CVM-2014>`_)
  * [gw] Fix publishing empty uncompressed files (`CVM-2012 <https://sft.its.cern.ch/jira/browse/CVM-2012>`_)
  * Fix building Doxygen documentation
  * [ducc] Fix version string

Improvements and changes
------------------------

  * Add initial implementation of cvmfs_publish commit (`CVM-2029 <https://sft.its.cern.ch/jira/browse/CVM-2029>`_)
  * [libcvmfs_server] Require repo key & certificate only on non-gw publishers
  * Add `cvmfs_server check -a` command (`CVM-1524 <https://sft.its.cern.ch/jira/browse/CVM-1524>`_)
  * Add timestamp_last_error magic extended attribute (`CVM-2003 <https://sft.its.cern.ch/jira/browse/CVM-2003>`_)
  * Add logbuffer magic extended attribute
  * Add check for usyslog writability in cvmfs_config (`CVM-1946 <https://sft.its.cern.ch/jira/browse/CVM-1946>`_)
  * [ducc] make output_format line in wish list optional (`CVM-1786 <https://sft.its.cern.ch/jira/browse/CVM-1786>`_)
  * [ducc] Add support for publish triggered by registry webhooks (`CVM-2000 <https://sft.its.cern.ch/jira/browse/CVM-2000>`_)
  * Clean up receiver processes when stopping the gateway (`CVM-1989 <https://sft.its.cern.ch/jira/browse/CVM-1989>`_)
  * Add support for importing repositories on S3
  * [gw] Increase file descriptor limit for receiver (`CVM-1997 <https://sft.its.cern.ch/jira/browse/CVM-1997>`_)
  * Use UTC timestamp for .cvmfs_is_snapshotting (`CVM-1986 <https://sft.its.cern.ch/jira/browse/CVM-1986>`_)
  * Add 'cvmfs_config setup noautofs' option (`CVM-1983 <https://sft.its.cern.ch/jira/browse/CVM-1983>`_)
  * Add support for explicit server-side proxy, removing support for server-side
    system proxy; new parameters CVMFS_SERVER_PROXY and CVMFS_S3_PROXY
  * Add `cvmfs_config fuser` command
  * Add support for HTTPS S3 endpoints
  * Add support for attaching mount to an existing fuse module
  * Add support for "direct I/O" files (`CVM-2001 <https://sft.its.cern.ch/jira/browse/CVM-2001>`_)
  * Add 'device id' command to cvmfs_talk (`CVM-2004 <https://sft.its.cern.ch/jira/browse/CVM-2004>`_)
  * Add support for setting "compression" key in graft files
  * Remove spinlock in S3 uploader
  * Remove spinlock in gateway uploader
  * Reduce time spent in lsof during publishing
  * [gw] Fast merging of nested catalogs (`CVM-1998 <https://sft.its.cern.ch/jira/browse/CVM-1998>`_)
  * [gw] Accommodate cvmfs-gateway Go sources (`CVM-1871 <https://sft.its.cern.ch/jira/browse/CVM-1871>`_)
  * Register redundant bulk hashes in filestats db
  * Add support for SLES15 (`CVM-1656 <https://sft.its.cern.ch/jira/browse/CVM-1656>`_)
  * Do not include an explicit default port number within S3 upload URI
    (see also libcurl issue `#6769 <https://github.com/curl/curl/issues/6769>`_)
  * [ducc] Ingest images using "sneaky layers" and template transactions


Manual Migration from CernVM-FS 2.8.2 Publishers
------------------------------------------------

If you do not want to use cvmfs_server migrate to automatically upgrade, publisher nodes that maintain Stratum 0 repositories can be migrated from version 2.8.2 with the following steps:

1. Ensure that there are no open transactions and garbage collection processes before updating the server software and during the repository layout migration.

2. Install the cvmfs-server 2.9.0 package.

3. If you use the gateway, install the cvmfs-gateway-2.9.0 package on the gateway node.

4. For each repository: adjust ``/etc/cvmfs/repositories.d/<REPOSITORY>/client.conf`` and add the ``CVMFS_USE_SSL_SYSTEM_CA=true`` parameter.

5. For each repository: adjust the line in ``/etc/fstab`` corresponding to the CVMFS read-only mount (beginning with ``cvmfs2#``), add the ``fsname=<REPOSITORY>`` option, and remount the repository.

6. Update ``/etc/cvmfs/repositories.d/<REPOSITORY>/server.conf`` and set ``CVMFS_CREATOR_VERSION=143``.

In agreement with the repository owner it’s recommended to make a test publish

.. code-block::

    cvmfs_server transaction <REPOSITORY>
    cvmfs_server publish <REPOSITORY>

before resuming normal operation.
