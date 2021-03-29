Release Notes for CernVM-FS 2.8.1
=================================

CernVM-FS 2.8.1 is a patch release.
It contains bugfixes for clients and servers.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to
update only a few worker nodes first and gradually ramp up once the new version
proves to work correctly. Please take special care when upgrading a cvmfs
client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

Bug Fixes and Improvements
--------------------------

  * [client] fix cache hitrate reporting, add new extended attribute ``hitrate``
    (`CVM-1965 <https://sft.its.cern.ch/jira/browse/CVM-1965>`_)
  * [server] fix server statistics display for JSROOT 6
    (`CVM-1970 <https://sft.its.cern.ch/jira/browse/CVM-1970>`_)
  * [server] fix ``cvmfs_server diff --worktree`` on managed publishers
    (`CVM-1972 <https://sft.its.cern.ch/jira/browse/CVM-1972>`_)
  * [server] gracefully handle template transaction failures
    (`CVM-1964 <https://sft.its.cern.ch/jira/browse/CVM-1964>`_)
  * [server] fix enter shell when repository uses multiple stratum 1 hosts
    (`CVM-1969 <https://sft.its.cern.ch/jira/browse/CVM-1969>`_)
  * [container] set ``CVMFS_USE_CDN=yes`` in service container
  * [shrinkwrap] fix parsing of the spec file
    (`CVM-1708 <https://sft.its.cern.ch/jira/browse/CVM-1708>`_)


Release Notes for CernVM-FS 2.8.0
=================================

CernVM-FS 2.8 is a feature release that comes with performance improvements,
new functionality, and bugfixes.

CernVM-FS 2.8 highlights include

  * A new "service container" aimed at easier kubernetes deployments
  * Support for macOS 11 Big Sur
  * Support for Windows Services for Linux (WSL2)
  * Parallelized garbage collection for greatly reduced GC durations
  * Support for generating podman image store meta-data in DUCC
  * Ability to show the diff of the current transaction using the
    ``cvmfs_server diff --worktree`` command
  * Two new experimental features: "template transactions" and ephemeral
    publish containers (see below)

Together with CernVM-FS 2.8.0, we release the CernVM-FS Repository Gateway
version 1.2. For gateway deployments, both package updates should be installed
in concert.

As with previous releases, upgrading should be seamless just by installing the
new package from the repository. As usual, we recommend to update only a few
worker nodes first and gradually ramp up once the new version proves to work
correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading.
For Stratum 1 servers, there should be no running snapshots during the upgrade.
After the software upgrade, publisher nodes require doing
``cvmfs_server migrate`` for each repository.


CernVM-FS Client Service Container
----------------------------------

As of this release, we provide the CernVM-FS client in addition to the regular
distribution packages as a minimal Docker container.  The container is available
`from Dockerhub <https://hub.docker.com/r/cvmfs/service>`_ and as a standalone tarball to be used with `docker load`.

The service container can be used to expose /cvmfs mountpoint to the container
host. It is meant for fully containerized Linux distributions such as
Fedora CoreOS. It can also be deployed as a Kubernetes DaemonSet to provide /cvmfs
to pods in kubernetes clusters.


Template Transactions
---------------------

To make meta-data heavy transactions faster, CernVM-FS now provides publishing
using "template transactions". In a template transaction, an existing directory
is used as a template for the changes to be published. Cloning the existing
directory tree is a fast, meta-data only operation. This can be useful, for
instance, when a new patch release differs only in a few files from an existing
software stack. In this case, the transaction to publish the patch release could
be started like

::

    cvmfs_server transaction -T /available/release=/patch/release
    # Install patched file in /cvmfs/<repository name>/patch/release
    cvmfs_server publish

Template transactions are an experimental feature for the time being.
Note that template transactions do not yet work for remote publishers connected
to a gateway. This limitation will be lifted in a future release.


Ephemeral Publish Container
---------------------------

This release provides the new ``cvmfs_server enter`` command that can open
an ephemeral, writable container for a repository. The ephemeral container
effectively promotes a regular, read-only client mountpoint under /cvmfs to
a writable mountpoint. Starting an ephemeral publish container does not require
a full installation of a publisher node; availability of the ``cvmfs``,
``cvmfs-server``, and ``fuse-overlayfs`` packages is sufficient.

Opening an ephemeral publish container is an unprivileged operation. It does
require, however, the relatively recent "user namespaces" and "unprivileged
fuse mounts" features from the Linux kernel.  CentOS 8, for instance, provides
a recent enough kernel.

Ephemeral publish containers are an experimental feature for the time being.
The changes written to /cvmfs within the container are discarded upon closing
the container. As long as the container is active, however, new and changed
files can be extracted, e.g. into tarballs, or shown using the new
``cvmfs_server diff --worktree`` command. In particular, build machines that
are not publisher nodes at the same time can make use of the new capability in
order to install software directly in the final location.

Publishing from the ephemeral container to the gateway will be implemented in
a future release.


Publisher Statistics Plots
--------------------------

An automatically generated web page can present key figures of publish and
garbage collections operations, such as number of files and processed volume.
To publish only the raw data file, set ``CVMFS_UPLOAD_STATS_DB=true`` in the repository server.conf
file. Plots and a webpage are also published to the stratum 0 /stats location
if ``CVMFS_UPLOAD_STATS_PLOTS=true`` is set and `ROOT <https://root.cern>`_ is installed.


Bug Fixes
---------

  * Client: fix reload if only the config repository is mounted

  * Client: fix reload on macOS >= 10.15

  * Client: fix ``cvmfs_config status`` output for broken mountpoints
    (`CVM-1959 <https://sft.its.cern.ch/jira/browse/CVM-1959>`_)

  * Server: fix reflog repair when there is a zombie hash in the manifest
    (`CVM-1919 <https://sft.its.cern.ch/jira/browse/CVM-1919>`_)

  * Server: fix ``cvmfs_server ingest`` into root directory

  * Server: fix ingestion of hardlinked catalog markers
    (`CVM-1931 <https://sft.its.cern.ch/jira/browse/CVM-1931>`_)

  * Server: refuse non-regular .cvmfscatalog files during publish
    (`CVM-1868 <https://sft.its.cern.ch/jira/browse/CVM-1868>`_)

  * Server: fix double counting in ``swissknife filestats`` command

  * Server, stratum 1: fix stuck Apache processes with disabled geo API
    (`CVM-1956 <https://sft.its.cern.ch/jira/browse/CVM-1956>`_)

  * Gateway: fix corrupted catalog when a nested catalog is replaced by a symlink
    (`CVM-1930 <https://sft.its.cern.ch/jira/browse/CVM-1930>`_)

  * Gateway: fix accidental creation of undeletable content caused by improper
    handling of the reflog

  * DUCC: preserve timestamp of extracted files
    (`CVM-1950 <https://sft.its.cern.ch/jira/browse/CVM-1950>`_)

  * DUCC: improve robustness against intermittent registry failures
    (`CVM-1829 <https://sft.its.cern.ch/jira/browse/CVM-1829>`_)


Improvements and Changes
------------------------

  * Client, macOS: update from osxfuse 3 to macFUSE 4
    (`CVM-1960 <https://sft.its.cern.ch/jira/browse/CVM-1960>`_)

  * Client: several performance improvements on newer kernel and fuse versions

  * Client: add ``chunk_list`` magic extended attribute
    (`CVM-1875 <https://sft.its.cern.ch/jira/browse/CVM-1875>`_)

  * Client: add ``catalog_counters`` extended attribute
    (`CVM-1824 <https://sft.its.cern.ch/jira/browse/CVM-1824>`_)

  * Client: log when geosort ends up switching a proxy
    (`CVM-1920 <https://sft.its.cern.ch/jira/browse/CVM-1920>`_)

  * Client: add POSIX external cache plugin
    (`CVM-1823 <https://sft.its.cern.ch/jira/browse/CVM-1823>`_)

  * Client: add ``cvmfs_talk chroot <hash>`` command

  * Server: make overlayfs the default union file system for new repositories
    (`CVM-1909 <https://sft.its.cern.ch/jira/browse/CVM-1909>`_)

  * Server: make ``CVMFS_IGNORE_XDIR_HARDLINKS=yes`` a default for new
    repositories

  * Server, S3: improve performance of uploading small objects

  * Server, S3: Add support for Azure blob storage

  * Server: indicate error type by return value in ``cvmfs_server transaction``
    (`CVM-1873 <https://sft.its.cern.ch/jira/browse/CVM-1873>`_)

  * Server: add support for wait & retry on opening transactions
    (`CVM-1937 <https://sft.its.cern.ch/jira/browse/CVM-1937>`_)

  * Server: show progress during garbage collection sweep phase
    (`CVM-1929 <https://sft.its.cern.ch/jira/browse/CVM-1929>`_)

  * Server: improve network error handling during garbage collection
    (`CVM-1957 <https://sft.its.cern.ch/jira/browse/CVM-1957>`_)

  * Server: Add ``CVMFS_STATS_DB_DAYS_TO_KEEP`` parameter to prune publish
    statistics database, defaults to 356 days
    (`CVM-1841 <https://sft.its.cern.ch/jira/browse/CVM-1841>`_)

  * Server: spawn watchdog for ``swissknife sync`` command

  * Gateway: multi-threaded, faster processing of incoming data
    (`CVM-1739 <https://sft.its.cern.ch/jira/browse/CVM-1739>`_)

  * DUCC: add support for wildcards in image tags
    (`CVM-1715 <https://sft.its.cern.ch/jira/browse/CVM-1715>`_)

  * DUCC: add support for converting from private registries

  * DUCC: add support for pulling Docker images with an authenticated user
    using ``CVMFS_DOCKERHUB_[USER|PASS]`` environment variables

  * DUCC: add ``convert-singularity-image`` command

  * DUCC: parallel check of image up-to-dateness

  * DUCC: add ``-t`` option to set location of temporary files
    (`CVM-1826 <https://sft.its.cern.ch/jira/browse/CVM-1826>`_)

  * DUCC: add systemd service unit

  * Debian packaging: change apache2 dependency from required to recommended

  * Removed perl as a package dependency


Manual Migration from CernVM-FS 2.7.5 Publishers
------------------------------------------------

If you do not want to use ``cvmfs_server migrate`` to automatically upgrade,
publisher nodes that maintain Stratum 0 repositories can be migrated from
version 2.7.5 with the following steps:

  1. Ensure that there are no open transactions and garbage collection processes
     before updating the server software and during the repository layout
     migration.

  2. Install the ``cvmfs-server`` 2.8.0 package.

  3. If you use the gateway, install the ``cvmfs-gateway-1.2.0`` package on the
     gateway node.

  4. For each repository: adjust
     /etc/cvmfs/repositories.d/<REPOSITORY>/client.conf and add the
     ``CVMFS_TALK_SOCKET=/var/spool/cvmfs/<REPOSITORY>/cvmfs_io`` parameter and
     the ``CVMFS_TALK_OWNER=<user name of repository owner>`` parameter

  5. For each repository: adjust
     /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and add the
     ``CVMFS_IGNORE_XDIR_HARDLINKS=true`` parameter if it is not already
     set.

  6. Update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and set
     ``CVMFS_CREATOR_VERSION=142``

In agreement with the repository owner it's recommended to make a test publish

::

    cvmfs_server transaction <REPOSITORY>
    cvmfs_server publish <REPOSITORY>

before resuming normal operation.
