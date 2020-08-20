.. _cpt_building_for_cvmfs_distribution:

========================================
Building software for CVMFS distribution
========================================

This chapter tries to collect the best practice of the community around building software to be distributed with CVMFS.

Each project has different needs and tradeoffs and this page is only offering suggestions.


Set up a writable /cvmfs directory
==================================

Sometimes is necessary to set up a writable /cvmfs directory. For instance during the testing of a new package or while building a not relocatable package.

The simplest way to create a writable /cvmfs directory is to start a transaction, but this is not always possible. The repository manager can be busy publishing other files or the access to it is limited.

In such a case, it is possible to use an overlay filesystem. This method works on any CVMFS client, with and without `sudo` rights.

A writable overlay filesystem needs tree directories:

* a lower, readable, directory which provides the bulk of the filesystem (this will be your /cvmfs directory)
* a work directory, used internally by the software
* an upper directory, again used internally by the software.

Finally, the overlay filesystem is mounted on a fourth directory, that, even if backed by a read-only mounted CVMFS directory, will now appear readable.

We show now how to practically use these technologies with CVMFS. 

Simple example
**************

In this example, we have our CVMFS filesystem mounted in `/cvmfs/unpacked.cern.ch` and we want to create a writable copy in `/writable/unpacked.cern.ch`. we have complete `sudo` rights.

::

    $ ll /cvmfs/unpacked.cern.ch/
    total 10
    drwxr-xr-x   9 cvmfs cvmfs 4096 Okt 15  2018 ./
    drwxr-xr-x 248 cvmfs cvmfs   16 Aug  7 13:59 .flat/
    -rw-r--r--   1 cvmfs cvmfs    0 Apr 27 16:01 foo
    drwxr-xr-x   9 cvmfs cvmfs   24 Mai 14 20:11 gitlab-registry.cern.ch/
    drwxr-xr-x 258 cvmfs cvmfs   66 Mai  1 03:08 .layers/
    drwxr-xr-x   2 cvmfs cvmfs   40 Aug 16 21:02 logDir/
    drwxr-xr-x   4 cvmfs cvmfs   34 Aug  1  2019 .metadata/
    -rw-r--r--   1 cvmfs cvmfs  877 Jul 29 13:27 README.md
    drwxr-xr-x  26 cvmfs cvmfs   19 Jul 29 18:17 registry.hub.docker.com/
    -rw-r--r--   1 cvmfs cvmfs    4 Apr 22 17:11 test_gateway
    drwxr-xr-x   3 cvmfs cvmfs   17 Mai  4 15:59 util/


We start by creating the work and upper directory and the mount directory.

::

    mkdir -p ~/etc/writable/work ~/etc/writable/upper
    sudo mkdir /writable


At this point, we can create our overlay mount.

::

    sudo mount -t overlay overlay \
       -o lowerdir=/cvmfs/unpacked.cern.ch/,workdir=$HOME/etc/writable/work/,upperdir=$HOME/etc/writable/upper/ \
       /writable


We can now see that `/writable` has the exact same content than `/cvmfs/unpacked.cern.ch` but it is writable.

::

    $ touch /writable/baz
    $ ll /writable/ # we have created the empty baz file
    total 14
    drwxr-xr-x   1 smosciat smosciat 4096 Aug 18 12:25 ./
    drwxr-xr-x  32 root     root     4096 Aug 18 12:17 ../
    -rw-r--r--   1 smosciat smosciat    0 Aug 18 12:25 baz
    drwxr-xr-x 248 cvmfs    cvmfs      16 Aug  7 13:59 .flat/
    -rw-r--r--   1 cvmfs    cvmfs       0 Apr 27 16:01 foo
    drwxr-xr-x   9 cvmfs    cvmfs      24 Mai 14 20:11 gitlab-registry.cern.ch/
    drwxr-xr-x 258 cvmfs    cvmfs      66 Mai  1 03:08 .layers/
    drwxr-xr-x   2 cvmfs    cvmfs      40 Aug 16 21:02 logDir/
    drwxr-xr-x   4 cvmfs    cvmfs      34 Aug  1  2019 .metadata/
    -rw-r--r--   1 cvmfs    cvmfs     877 Jul 29 13:27 README.md
    drwxr-xr-x  26 cvmfs    cvmfs      19 Jul 29 18:17 registry.hub.docker.com/
    -rw-r--r--   1 cvmfs    cvmfs       4 Apr 22 17:11 test_gateway
    drwxr-xr-x   3 cvmfs    cvmfs      17 Mai  4 15:59 util/

All the modifications to the filesystem are recorded in the upper directory. In this case, we can see a new empty file.

::

    $ ll $HOME/etc/writable/upper/
    total 8
    drwxr-xr-x 2 smosciat smosciat 4096 Aug 18 12:25 ./
    drwxr-xr-x 4 smosciat smosciat 4096 Aug 18 12:16 ../
    -rw-r--r-- 1 smosciat smosciat    0 Aug 18 12:25 baz

This first example was useful to understand how to work with overlayfs, however, it creates a writable directory, with the same content of the CVMFS repository, but it is a different directory. 
Ideally, we would like the directory to be on `/cvmfs`.

The second example address just this other use case.

A writable /cvmfs directory
***************************

Building upon the first example, we can manually mount cvmfs in a directory which is not `/cvmfs`, and then use overlayfs to mount the writable filesystem on /cvmfs.

The first step is making sure that the directory we want to mount `/cvmfs/unpacked.cern.ch` is available, hence it is not mounted by the cvmfs automounter.

::

    sudo systemctl stop autofs
    sudo umount /cvmfs/unpacked.cern.ch
    

Now, we need a directory where the mount the default CVMFS filesystem, along with the workdir and the upperdir. And the /cvmfs directory.

::

    mkdir -p ~/etc/writable/work ~/etc/writable/upper ~/etc/writable/cvmfs 
    sudo mkdir -p /cvmfs/unpacked.cern.ch
    

Now we can mount the CVMFS filesystem in the new directory.

::

    sudo cvmfs2 unpacked.cern.ch $HOME/etc/writable/cvmfs
    CernVM-FS: loading Fuse module... done
    CernVM-FS: mounted cvmfs on /home/smosciat/etc/writable/cvmfs
    

Now we have mounted the content of the CVMFS repository in a third directory, the last step is to use overlay to create a writable `/cvmfs` directory that has the same path of the canonical one.

::

    sudo mount -t overlay overlay \
        -o lowerdir=$HOME/etc/writable/cvmfs,workdir=$HOME/etc/writable/work/,upperdir=$HOME/etc/writable/upper/ \
        /cvmfs/unpacked.cern.ch


At this point, the directory `/cvmfs/unpacked.cern.ch` is mounted as a writable directory by overlay and it contains the content of the `unpacked.cern.ch` repository.

As before, the modifications done to the overlay directory are stored in the upper directory.
