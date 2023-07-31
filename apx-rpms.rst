.. _apx_rpms:

Available Packages
==================

The CernVM-FS software is available in form of several packages:

**cvmfs-release**
    Adds the CernVM-FS yum/apt repository.

**cvmfs-config-default**
    Contains a configuration and public keys suitable for nodes in the
    Worldwide LHC Computing Grid. Provides access to repositories in the
    cern.ch, egi.eu, and opensciencegrid.org domains.

**cvmfs-config-none**
    Empty package to satisfy the ``cvmfs-config`` requirement of the cvmfs
    package without actually installing any configuration.

**cvmfs**
    Contains the Fuse module and additional client tools. It has
    dependencies to at least one of the ``cvmfs-config-...``
    packages.

**cvmfs-fuse3**
    Contains the additional client libraries necessary to mount with the
    libfuse3 system libraries.

**cvmfs-devel**
    Contains the ``libcvmfs.a`` static library and the ``libcvmfs.h``
    header file for use of CernVM-FS with Parrot [Thain05]_ as well as the
    ``libcvmfs_cache.a`` static library and ``libcvmfs_cache.h`` header in order
    to develop cache plugins.

**cvmfs-auto-setup**
    Only available through yum. This is a wrapper for
    ``cvmfs_config setup``. This is supposed to provide automatic
    configuration for the ATLAS Tier3s. Depends on cvmfs.

**cvmfs-server**
    Contains the CernVM-FS server tool kit for maintaining publishers and
    Stratum 1 servers.

**cvmfs-gateway**
    The publishing gateway services are installed on a node with access to the
    authoritative storage.

**cvmfs-ducc**
    Daemon that unpacks container images into a repository. Supposed to run
    on a publisher node.

**cvmfs-notify**
    WebSockets frontend for used for repository update notifications. Supposed
    to be co-located with a RabbitMQ service.

**kernel-...-.aufs21**
    Scientific Linux 6 kernel with ``aufs``. Required for SL6 based
    Stratum 0 servers. (Note: no active support for ``aufs`` anymore)

**cvmfs-shrinkwrap**
    Stand-alone utility to export file system trees into containers for HPC
    use cases.

**cvmfs-unittests**
    Contains the ``cvmfs_unittests`` binary. Only required for testing.
