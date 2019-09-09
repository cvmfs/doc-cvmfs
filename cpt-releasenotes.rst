Release Notes for CernVM-FS 2.6.3
=================================

CernVM-FS 2.6.3 is a patch release.  It fixes parsing of the /etc/hosts file
for several corner cases
(`CVM-1796 <https://sft.its.cern.ch/jira/browse/CVM-1796>`_)
(`CVM-1797 <https://sft.its.cern.ch/jira/browse/CVM-1797>`_).  Otherwise it is
identical to version 2.6.2.

Release Notes for CernVM-FS 2.6.2
=================================

CernVM-FS 2.6.2 is a patch release.  It fixes a rare block during hotpatch
introduced with version 2.6.1
(`CVM-1795 <https://sft.its.cern.ch/jira/browse/CVM-1795>`_).  Otherwise it is
identical to version 2.6.1.

Release Notes for CernVM-FS 2.6.1
=================================

CernVM-FS 2.6.1 is a patch release.  It contains bugfixes and improvements for
clients, stratum 0 and stratum 1 servers.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update
only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS
mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

Together with CernVM-FS 2.6.1 we also release the CernVM-FS Gateway Services
version 1.1.0. This version of the gateway services includes the notification
service and therefore obsoletes the dedicated cvmfs-notify package.

Note for upgrades from versions prior to 2.6.0: please also see the specific
instructions in the release notes for version 2.6.0 and earlier.


Bug Fixes and Improvements
--------------------------

  * Client: fix potential hang during reload if a config repository is used
    `CVM-1466 <https://sft.its.cern.ch/jira/browse/CVM-1466>`_

  * Client: fix file descriptor exhaustion when browsing many small catalogs
    `CVM-1742 <https://sft.its.cern.ch/jira/browse/CVM-1742>`_

  * Client: fix potential mix-up of chunked files in NFS mode
    `CVM-1791 <https://sft.its.cern.ch/jira/browse/CVM-1791>`_

  * Client: disable active kernel cache eviction as workaround for stale
    negative file system entries
    `CVM-1759 <https://sft.its.cern.ch/jira/browse/CVM-1759>`_

  * Client: fix placement of cvmfschecksum.* files for uncommon cache setups
    `CVM-1728 <https://sft.its.cern.ch/jira/browse/CVM-1728>`_

  * Client: fix host file parsing in DNS resolver, triggered by gcc >= 9
    `CVM-1763 <https://sft.its.cern.ch/jira/browse/CVM-1763>`_

  * Client: check for missing autofs map directory include in
    `cvmfs_config chksetup`
    `CVM-1686 <https://sft.its.cern.ch/jira/browse/CVM-1686>`_

  * Server: fix exhaustive memory consumption in file processing pipeline
    `CVM-1687 <https://sft.its.cern.ch/jira/browse/CVM-1687>`_

  * Server: fix `snapshot -a` when no replicas are defined

  * Server: fix tarball ingestion at deeply nested catalog structures
    `CVM-1721 <https://sft.its.cern.ch/jira/browse/CVM-1721>`_

  * Server: fix Geo-API's Cloudflare support for known proxies
    `CVM-1774 <https://sft.its.cern.ch/jira/browse/CVM-1774>`_

  * Server: fix locking logic in Geo-API web service
    `CVM-1777 <https://sft.its.cern.ch/jira/browse/CVM-1777>`_

  * Server: periodically reload Geo-IP database
    `CVM-1739 <https://sft.its.cern.ch/jira/browse/CVM-1739>`_

  * Server: add GC support for legacy catalogs before 1.0 schema stabilized
    `CVM-1698 <https://sft.its.cern.ch/jira/browse/CVM-1698>`_

  * Server: fix master key card handling with openssl-pkcs11 >= 0.4.7
    `CVM-1788 <https://sft.its.cern.ch/jira/browse/CVM-1788>`_

  * Server: fix grafting of empty files
    `CVM-1785 <https://sft.its.cern.ch/jira/browse/CVM-1785>`_

  * Server: add `-g <snapshot group>` option to replication commands
    `CVM-1779 <https://sft.its.cern.ch/jira/browse/CVM-1779>`_

  * Server, S3: fix various issues in the HTTP 429 rate throttling behavior
    `CVM-1755 <https://sft.its.cern.ch/jira/browse/CVM-1755>`_

  * Server, S3: Fix name resolution with DNS style buckets

  * Server, S3: fix small memory leak

  * Server, S3: fix AWSv4 authentication when using a non standard port

  * Server, S3: fix potential race condition in the stats collector for the S3
    uploader

  * Server, gateway: fix repository checks from publisher nodes
    `CVM-1732 <https://sft.its.cern.ch/jira/browse/CVM-1732>`_

  * Gateway: fix garbage collection on the repository gateway node
    `CVM-1705 <https://sft.its.cern.ch/jira/browse/CVM-1705>`_

  * Gateway: relocation temporary files so that repository integrity checks pass
    `CVM-1704 <https://sft.its.cern.ch/jira/browse/CVM-1704>`_

  * Gateway: fix file mode for gateway keys in cvmfs_server import_keychain
    `CVM-1746 <https://sft.its.cern.ch/jira/browse/CVM-1746>`_

  * Gateway: fix key parser for keys containing repeated characters

  * Gateway: fix transaction lock name for tarball ingest

  * Gateway: more robust parsing of gateway API keys
    `CVM-1693 <https://sft.its.cern.ch/jira/browse/CVM-1693>`_

  * Notification service: use server-sent events instead of WebSockets

  * DUCC: fix usage of singularity in container publishing service

  * Fix syntax errors in external libraries build system
    `CVM-1781 <https://sft.its.cern.ch/jira/browse/CVM-1781>`_
    `CVM-1782 <https://sft.its.cern.ch/jira/browse/CVM-1782>`_


Release Notes for CernVM-FS 2.6.0
=================================

CernVM-FS 2.6 is a feature release that comes with performance improvements,
new functionality, and bugfixes. We would like to thank Dave Dykstra (FNAL),
Brian Bockelman and Derek Weitzel (U. Nebraska) and Nick Hazekamp
(U. Notre Dame) for their contributions to this release!

This release comes with several new, experimental satellite serivces around
the CernVM-FS core components:

  1. DUCC (daemon that unpacks container images into CernVM-FS).
     This new component automates the publication of container images from a
     Docker registry into CernVM-FS.

  2. Repository change notification system, which
     is complementary to the default, pull-based approach to propagate
     repository updates.

  3. Repository shrinkwrap utility. This new utility
     allows for exporting large parts of a CernVM-FS repository to an external
     file system or a "fat image" as they are used in some HPC environments.

Together with CernVM-FS 2.6.0, we also release the CernVM-FS Repository Gateway
version 1.0. The increased version number indicates that we are ready to assure
backward compatibility for the component, in line with
`semantic versioning <https://semver.org/>`_ rules.

Other notable changes include

  * A new server command ``cvmfs_server ingest``, that can be used to
    :ref:`directly publish tarballs <sct_tarball>` without extracting them
    first.

  * Publishing and garbage collection now maintain
    :ref:`operational statistics <sct_repo_stats>`, for instance about the
    number of files added and deleted.

  * Various improvements for the S3 backend.

  * A :ref:`file system call tracer <cpt_tracer>` that can be enabled on the
    client in order to log the file system accesses to a repository.

  * Support for bearer token authentication in addition to X.509 authentication
    for protected repositories.

  * Various new routines in libcvmfs that provide access to cvmfs-specific
    meta-data, such as the nested catalog structure.


As with previous releases, upgrading should be seamless just by installing the
new package from the repository. As usual, we recommend to update only a few
worker nodes first and gradually ramp up once the new version proves to work
correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading.
For Stratum 1 servers, there should be no running snapshots during the upgrade.
After the software upgrade, publisher nodes (``stratum 0``) require doing
``cvmfs_server migrate`` for each repository.

**Note**: if the configuration of the repository publisher node is handled by a
configuration management system (Puppet, Chef, ...), please see Section
:ref:`sct_manual_migration`.


Container Image Unpacker (DUCC)
-------------------------------

The :ref:`DUCC system <cpt_ducc>` manages the conversion of container images
from a Docker registry into an unpacked form on a CernVM-FS repository. The
converted images can be used with Docker and the :ref:`CernVM-FS graph driver
plugin <cpt_graphdriver>` for Docker.  They can also be used with Singularity
and other container engines that work with a flat root file system.

Starting containers from unpacked images in CernVM-FS often provides significant
time and network traffic savings, as only a small fraction of the files in the
container image is actually used at runtime.


Repository Change Notifications
-------------------------------

The new :ref:`repository change notification system <cpt_notification_system>`
provides a publish-subscribe service to instantaneously distribute repository
updates. On publish, a change notification can be pushed, which is sent to
via WebSockets to registered clients. The CernVM-FS client can be configured
to show the new content within few seconds. This facilitates, for instance,
CI pipelines where build artifacts from one build phase need to be available
as an input to the next build phase.


Shrinkwrap
----------

The :ref:`shrinkwrap <cpt_shrinkwrap>` utility is a stand-alone tool that
exports a part of a CernVM-FS repository directory hierarchy to another file
system.  This exported tree can then be re-packaged into a "fat image" for
HPC systems, or it can be used for benchmarks that exclude possible performance
effects caused by the CernVM-FS client, such as network accesses to populate the
cache.



Bug Fixes
---------

  * Client, macOS: fix hang during ``cvmfs_config reload``

  * Client: fix credentials handling on HTTP retries for protected repositories
    (`CVM-1660 <https://sft.its.cern.ch/jira/browse/CVM-1660>`_)

  * Server: prevent following dirtab entries that point outside the repository
    (`CVM-1608 <https://sft.its.cern.ch/jira/browse/CVM-1608>`_)

  * Server, S3: fix rare crash during file upload

  * Server, S3: throttle upload frequency on HTTP 429 "too many requests"
    replies (`CVM-1584 <https://sft.its.cern.ch/jira/browse/CVM-1584>`_)

  * Fix building on macOS Mojave

  * Fix warnings and errors in Debian packaging


Other Improvements
------------------

  * Client: log more details on HTTP host and proxy connection errors
    (`CVM-1662 <https://sft.its.cern.ch/jira/browse/CVM-1662>`_)

  * Client: generally replace ``@fqrn@`` and ``@org@`` in configuration files
    (`CVM-1526 <https://sft.its.cern.ch/jira/browse/CVM-1526>`_)

  * Client: add support for ``CVMFS_NFS_INTERLEAVED_INODES`` parameter
    (`CVM-1561 <https://sft.its.cern.ch/jira/browse/CVM-1561>`_,
    `Documentation <cpt-configure.html#sct-nfs-interleaved>`_)

  * Client: new parameter ``CVMFS_CATALOG_WATERMARK`` to unpin catalogs when
    their number surpasses the given watermark

  * Server: make publication process less likely to run out of file descriptors
    on the read-only union file system mount

  * Server, S3: retry upload requests on HTTP 502 errors in order to better
    handle high load on load-balancers

  * Server, S3: add support for CVMFS_S3_PEEK_BEFORE_PUT parameter, enabled by
    default (`CVM-1584 <https://sft.its.cern.ch/jira/browse/CVM-1584>`_)

  * Server: reduce number of I/O operations to the local storage backend

  * Server: add support for ``CVMFS_NUM_UPLOAD_TASKS`` parameter for local
    storage backend



.. _sct_manual_migration:

Manual Migration from 2.5.2 Release Manager Machines
----------------------------------------------------

If you do not want to use ``cvmfs_server migrate`` to automatically upgrade,
publisher nodes that maintain Stratum 0 repositories can be migrated from
version 2.5.2 with the following steps:

  1. Ensure that there are no open transactions and garbage collection processes
     before updating the server software and during the repository layout
     migration.

  2. Install the ``cvmfs-server`` 2.6.0 package.

  3. For each repository: adjust
     /etc/cvmfs/repositories.d/<REPOSITORY>/client.conf and add the
     ``CVMFS_NFILES=65536`` parameter.

  4. Update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and set
     ``CVMFS_CREATOR_VERSION=141``

In agreement with the repository owner it's recommended to make a test publish

::

    cvmfs_server transaction <REPOSITORY>
    cvmfs_server publish <REPOSITORY>

before resuming normal operation.
