.. _cpt_graphdriver:

CernVM-FS Shrinkwrap Utility
============================

The CernVM-FS Shrinkwrap utility provides a means of exporting CVMFS
repositories. These exports may consist of the complete repository or
contain a curated subset of the repository.


The CernVM-FS shrinkwrap utility uses ``libcvmfs`` to export repositories
to a POSIX file tree. This file tree can then be packaged and exported in
several different ways, such as SquashFS, Docker layers, or TAR file.
The ``cvmfs_shrinkwrap`` utility supports multithreaded copying to increase
throughput and a file specification to create a subset of a repository.


Installation
------------

Compiling ``cvmfs_shrinkwrap`` from source
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to compile ``cvmfs_shrinkwrap`` from sources, use the
``-DBUILD_SHRINKWRAP=on`` cmake option.


CernVM-FS Shrinkwrap Layout
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The structure used in the Shrinkwrap output mirrors that used internally
by CernVM-FS. The visible files are hardlinked to a hidden data directory.
By default ``cvmfs_shrinkwrap`` builds in a base directory (``/tmp/cvmfs``)
where a directory exists for each repository and a ``.data`` directory
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
Directly specify file : ::

     /lcg/releases/gcc/7.1.0/x86_64-centos7/setup.sh

Specify directory tree : ::

     /lcg/releases/ROOT/6.10.04-4c60e/x86_64-cenots7-gcc7-opt/*

Specify only directory contents : ::

     ^/lcg/releases/*

Negative entries will be left out of the traversal : ::

     !/lcg/releases/uuid


Creating an image for ROOT
--------------------------

Start out with either building ``cvmfs_shrinkwrap``, adding it to your path,
or locating it in your working directory.

Optional (for repository subset):  Create a file specification to limit files.
Here is an example for ROOT version 6.10 (~8.3 GB). For our example put this in
a file named ``sft.cern.ch.spec``. ::

     /lcg/releases/ROOT/6.10.04-4c60e/x86_64-centos7-gcc7-opt/*
     /lcg/contrib/binutils/2.28/x86_64-centos7/lib/*
     /lcg/contrib/gcc/*
     /lcg/releases/gcc/*
     /lcg/releases/lcgenv/*

Write the ``libcvmfs`` configuration file that will be used for ``cvmfs_shrinkwrap``.
Here is an example that uses the CERN HPC Stratum 0, written to ``sft.cern.ch.config``. ::

    CVMFS_REPOSITORIES=sft.cern.ch
    CVMFS_REPOSITORY_NAME=sft.cern.ch
    CVMFS_CONFIG_REPOSITORY=cvmfs-config.cern.ch
    CVMFS_DEFAULT_DOMAIN=cern.ch
    CVMFS_SERVER_URL='http://cvmfs-stratum-zero-hpc.cern.ch/cvmfs/sft.cern.ch;http://cvmfs-stratum-one.cern.ch/cvmfs/sft.cern.ch'
    CVMFS_HTTP_PROXY=DIRECT # Adjust to your site
    CVMFS_MOUNT_DIR=/cvmfs
    CVMFS_CACHE_BASE=/var/lib/cvmfs/shrinkwrap
    CVMFS_KEYS_DIR=/etc/cvmfs/keys/cern.ch # Need to be provided for shrinkwrap
    CVMFS_SHARED_CACHE=no # Important as libcvmfs does not support shared caches
    CVMFS_USER=cvmfs

Note: Keys will need to be provided. The location in this configuration is the default used for CVMFS with FUSE.

Using the cvmfs repository ``sft.cern.ch`` : ::

    sudo cvmfs_shrinkwrap -r sft.cern.ch -f sft.cern.ch.config -t sft.cern.ch.spec --dest-base /tmp/cvmfs -j 16

Creating an image in userspace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Start by using the above setup.

Alternatively, shrinkwrap images can be created in user space. This is achieved using
the UID and GID mapping feature of ``libcvmfs``. First mapping files need to be written. ::

Example (Assuming UID 1000). Write ``* 1000`` into ``uid.map`` at ``/tmp/cvmfs``. 
Add this rule ``sft.cern.ch.config``. : ::

   CVMFS_UID_MAP=/tmp/cvmfs/uid.map

The same is done with GID into ``gid.map``.

Using the cvmfs repository ``sft.cern.ch`` : ::

   cvmfs_shrinkwrap -r sft.cern.ch -f sft.cern.ch.config -t sft.cern.ch.spec --dest-base /tmp/cvmfs -j 16

Note on CVMFS Variables
~~~~~~~~~~~~~~~~~~~~~~~

CVMFS variables athat are used in the organization of repositories are
evaluated at the time of image creation. As such, the OS the image is created
on should be the expected OS the image will be used with. Specification rules 
can be written to include other OS compatible version, but symlinks will
resolve to the original OS.

Using a shrinkwrap image
------------------------

Shrinkwrap was developed to address similar restriction as the CVMFS Preloader.
Having created an image from your specification there are a number of ways this
can be used and moved around.

Exporting image
~~~~~~~~~~~~~~~

Having a fully loaded repository, including the hardlinked data, the image can
be exported to a number of different formats and packages. Some examples of this
could be ZIP, tarballs, or squashfs. The recommendation is to use squashfs as
it provides a great amount of portability and is supported for directly mounting
on most OS.

If tools for creating squashfs are not already available try : ::

   apt-get install squashfs-tools

-- or -- ::

   yum install squashfs-tools


After this has been install a squashfs image can be created using the above image : ::

   mksquashfs /tmp/cvmfs root-sft-image.sqsh

This process may take time to create depending on the size of the shrinkwrapped image.
The squashfs image can now be moved around and mounted using : ::

   mount -t squashfs /PATH/TO/IMAGE/root-sft-image.sqsh /cvmfs

Bind mounting an image
~~~~~~~~~~~~~~~~~~~~~~

The shrinkwrap image can also be directly moved and mounted 
using bind mounts. ::

  mount --bind /tmp/cvmfs /cvmfs

This provides a quick method for testing created images and verifying
the contents will run your expected workload.

Important note on use
~~~~~~~~~~~~~~~~~~~~~

Shrinkwrap images mirror the data organization of CVMFS. As such it is important
that the data and the filesystem tree be co-located in the filesystem/mountpoint.
If the data is separated from the filesystem tree you are likely to encounter an
error.


.. Advanced : Docker Image injection
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   To be added later with formalized process
