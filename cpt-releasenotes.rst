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
