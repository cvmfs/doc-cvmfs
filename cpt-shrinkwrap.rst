.. _cpt_graphdriver:

CernVM-FS Shrinkwrap Utility
============================

The CernVM-FS shrinkwrap utility provides a means of exporting CVMFS
repositories. These exports may consist of the complete repository or
contain a curated subset of the repository.


The CernVM-FS shrinkwrap utility uses ``libcvmfs`` to export repositories
to a POSIX file tree. This file tree can then be packaged and exported in
several different ways, such as SquashFS, Docker layers, or TAR file.
The ``cvmfs_shrinkwrap`` utility supports multithreaded copying to increase
throughput and a file specification to create a subset of a repository.


Installation
------------

Compiling ``cvmfs_shrinkwrap`` from Sources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to compile ``cvmfs_shrinkwrap`` from sources, use the
``-DBUILD_SHRINKWRAP=on`` cmake option.


CernVM-FS Shrinkwrap Layout
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The structure used in the Shrinkwrap output mirrors that used internally
by CernVM-FS. The visible files are hardlinked to a hidden data directory.
By default ``cvmfs_shrinkwrap`` builds in a base directory (``/tmp/cvmfs``)
where a directory exists for each repository used and a ``.data`` directory
containing the content-addressed files for deduplication. 


======================================== =======================================
**File Path**                            **Description**
======================================== =======================================
  ``/tmp/cvmfs``                         **Default base directory**
                                         Single mount point that can be used to 
                                         package repositories, containing both the
                                         directory tree and the data directory.

  ``<base>/<fqrn>``                      **Repository file tree**
                                         Directory containing the visible structure
                                         and file names for a repository.

  ``<base>/.data``                       **File storage location for repositories**
                                         Content-addressed files in a hidden
                                         directory.

  ``<base>/.provenance``                 **Storage location for provenance**
                                         Hidden directory that stores the provenance
                                         information, including ``libcvmfs`` 
                                         configurations and specification files.

======================================== =======================================



Specification File
~~~~~~~~~~~~~~~~~~

The specification file allows for both positive entries and exlusion statements.
Inclusion can be specified directly for each file, can use wildcards for 
directories trees, and an anchor to limit to only the specified directory.
Directly specify file ::

     /lcg/releases/gcc/7.1.0/x86_64-centos7/setup.sh

Specify directory tree ::

     /lcg/releases/ROOT/6.10.04-4c60e/x86_64-cenots7-gcc7-opt/*

Specify only directory contents ::

     ^/lcg/releases/*

Negative entries will be left out of the traversal ::

     !/lcg/releases/uuid


Creating an Image for ROOT
--------------------------

Start out with either building ``cvmfs_shrinkwrap``, adding it to your path,
or locating it in your working directory.

The target directory should be mounted (either manually or with autofs).
Check with ``ls`` or ``cvmfs_talk``. ::

    ls /cvmfs/sft.cern.ch/lcg/releases/ROOT/

Optional (for repository subset):  Create a file specification to limit files.
Here is an example for ROOT version 6.10 (~8.3 GB). For our example put this in
a file named ``sft.cern.ch.spec``. ::

     /lcg/releases/ROOT/6.10.04-4c60e/x86_64-centos7-gcc7-opt/*
     /lcg/contrib/binutils/2.28/x86_64-centos7/lib/*
     /lcg/contrib/gcc/*
     /lcg/releases/gcc/*
     /lcg/releases/lcgenv/*

Write the ``libcvmfs`` configuration file that will be used for ``cvmfs_shrinkwrap``.
Example that uses the CERN HPC Stratum 0, written to ``sft.cern.ch.config``. ::

    CVMFS_REPOSITORY_NAME=sft.cern.ch
    CVMFS_CACHE_BASE=/home/nhazekam/test/lib/cvmfs/shrinkwrap
    CVMFS_CONFIG_REPOSITORY=cvmfs-config.cern.ch
    CVMFS_DEFAULT_DOMAIN=cern.ch
    CVMFS_HTTP_PROXY=DIRECT
    CVMFS_KEYS_DIR=/etc/cvmfs/keys/cern.ch
    CVMFS_MOUNT_DIR=/cvmfs
    CVMFS_REPOSITORIES=test.cern.ch,sft.cern.ch
    CVMFS_SERVER_URL='http://cvmfs-stratum-zero-hpc.cern.ch/cvmfs/sft.cern.ch;http://cvmfs-stratum-one.cern.ch/cvmfs/sft.cern.ch;http://cernvmfs.gridpp.rl.ac.uk/cvmfs/sft.cern.ch;http://cvmfs-s1bnl.opensciencegrid.org/cvmfs/sft.cern.ch;http://cvmfs-s1fnal.opensciencegrid.org/cvmfs/sft.cern.ch'
    CVMFS_SHARED_CACHE=no
    CVMFS_USER=cvmfs

Using the cvmfs repository ``sft.cern.ch`` ::

    sudo cvmfs_shrinkwrap -r sft.cern.ch -f sft.cern.ch.config -t sft.cern.ch.spec --dest-base /tmp/cvmfs -j 16

