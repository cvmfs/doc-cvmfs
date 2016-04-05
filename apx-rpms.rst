.. _apx_rpms:

Available RPMs
==============

The CernVM-FS software is available in form of several RPM packages:

**cvmfs-release**
    Adds the CernVM-FS yum/apt repository.

**cvmfs-config-default**
    Contains a configuration and public keys suitable for nodes in the
    Worldwide LHC Computing Grid. Provides access to repositories in the
    cern.ch, egi.eu, and opensciencegrid.org domains.

**cvmfs-config-none**
    Empty package to satisfy the cvmfs-config requirement of the cvmfs
    package without actually installing any configuration.

**cvmfs**
    Contains the Fuse module and additional client tools. It has
    dependencies to at least one of the cvmfs-config-\ :math:`\cdots`
    packages.

**cvmfs-devel**
    Contains the ``libcvmfs.a`` static library and the ``libcvmfs.h``
    header file for use of CernVM-FS with Parrot [Thain05]_.

**cvmfs-auto-setup**
    Only available through yum. This is a wrapper for
    ``cvmfs_config setup``. This is supposed to provide automatic
    configuration for the ATLAS Tier3s. Depends on cvmfs.

**cvmfs-server**
    Contains the CernVM-FS server tool kit for maintaining Stratum 0 and
    Stratum 1 servers.

**kernel-...-.aufs21**
    Scientific Linux 6 kernel with aufs. Required for SL6 based
    Stratum 0 servers.

**cvmfs-unittests**
    Contains the ``cvmfs_unittests`` binary. Only required for testing.
