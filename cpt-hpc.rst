.. _cpt_hpc:

CernVM-FS on Supercomputers
===========================

There are several characteristics in which supercomputers can differ from
other nodes with respect to CernVM-FS

  1. Fuse is not allowed on the individual nodes
  2. Individual nodes do not have Internet connectivity
  3. Nodes have no local hard disk to store the CernVM-FS cache

These problems can be overcome as described in the following sections.


Running CernVM-FS as an unprivileged user
-----------------------------------------
CernVM-FS can be run as an unprivileged user under several different
scenarios.  See documentation about that in the Security 
:ref:`sct_running_client_as_normal_user` section.


Parrot-Mounted CernVM-FS in lieu of Fuse Module
-----------------------------------------------
Instead of accessing /cvmfs through a Fuse module, processes can use the
`Parrot connector <http://cernvm.cern.ch/portal/filesystem/parrot>`_. The parrot
connector works on x86_64 Linux if the ``ptrace`` system call is not disabled.
In contrast to a plain copy of a CernVM-FS repository to a shared file system,
this approach has the following advantages:

  * Millions of synchronized meta-data operations per node (path lookups, in
    particular) will not drown the shared cluster file system but resolve
    locally in the parrot-cvmfs clients.
  * The file system is always consistent; applications never see
    half-synchronized directories.
  * After initial preloading, only change sets need to be transfered to the
    shared file system.  This is much faster than `rsync`, which always has to
    browse the entire name space.
  * Identical files are internally de-duplicated.  While space of the order of
    terabytes is usually not an issue for HPC shared file systems, file system
    caches benefit from deduplication. It is also possible to preload only
    specific parts of a repository namespace.
  * Support for extra functionality implemented by CernVM-FS such as versioning
    and variant symlinks (symlinks resolved according to environment variables).


Downloading complete snapshots of CernVM-FS repositories
--------------------------------------------------------

When there is no possible way to run the CernVM-FS client, an option
that has been used on some HPC systems is to download entire or
partial snapshots of CernVM-FS repositories using the
:ref:`cvmfs_shrinkwrap utility <cpt_shrinkwrap>`.  These snapshots
are also sometimes called "HPC fat container images".
This has many
disadvantages compared to running a CernVM-FS client so it is typically
a last resort.  


NFS Export with Cray DVS
------------------------

Some HPC sites have tried running the cvmfs client on just one server
and exporting to worker nodes over :ref:`NFS <sct_nfs_server_mode>`.
These installations can be made to work but it is very inefficient and
they often run into operational problems.   If you want to try it using
the Cray DVS please see the :ref:`workaround <sct_nfs_interleaved>` on
inode handling and DVS export.


Preloading the CernVM-FS Cache
------------------------------

When the CernVM-FS client can be installed on the worker node but for
whatever reason on-demand downloading to a local cache is difficult, the
`cvmfs_preload utility <http://cernvm.cern.ch/portal/filesystem/downloads>`_
can be used to preload a CernVM-FS cache onto the shared cluster file system.
Internally it uses the same code that is used to replicate between CernVM-FS
stratum 0 and stratum 1.  The ``cvmfs_preload`` command is a self-extracting
binary with no further dependencies and should work on a majority of x86_64
Linux hosts.  Note however that this method can significantly strain the
cluster file system's meta-data server(s) and that many HPC systems have
had better results with
:ref:`loopback filesystems <sct_loopback_filesystems>`
as node caches as discussed below.

The ``cvmfs_preload`` command replicates from a stratum 0 (not from a
stratum 1). Because this induces significant load on the source server,
stratum 0 administrators should be informed before using their server as a
source.  As an example, in order to preload the ALICE repository into
/shared/cache, one could run from a login node

::

    cvmfs_preload -u http://cvmfs-stratum-zero-hpc.cern.ch:8000/cvmfs/alice.cern.ch -r /shared/cache

This will preload the entire repository.  In order to preload only specific
parts of the namespace, you can create a _dirtab_ file with path prefixes.  The
path prefixes must not involve symbolic links.  An example dirtab file for ALICE
could look like

::

    /example/etc
    /example/x86_64-2.6-gnu-4.8.3/Modules
    /example/x86_64-2.6-gnu-4.8.3/Packages/GEANT3
    /example/x86_64-2.6-gnu-4.8.3/Packages/ROOT
    /example/x86_64-2.6-gnu-4.8.3/Packages/gcc
    /example/x86_64-2.6-gnu-4.8.3/Packages/AliRoot/v5*

The corresponding invokation of ``cvmfs_preload`` is

::

    cvmfs_preload -u http://cvmfs-stratum-zero-hpc.cern.ch:8000/cvmfs/alice.cern.ch -r /shared/cache \
      -d </path/to/dirtab>

The initial preloading can take several hours to a few days.  Subsequent
invokations of the same command only transfer a change set and typically finish
within seconds or minutes. These subsequent invokations need to be either done
manually when necessary or scheduled for instance with a cron job.

The ``cvmfs_preload`` command can preload files from multiple repositories
into the same cache directory.


Access from the Nodes
~~~~~~~~~~~~~~~~~~~~~

In order to access a preloaded cache from the nodes,
`set the path to the directory <http://cernvm.cern.ch/portal/filesystem/parrot>`_
as an *Alien Cache*. Since there won't be cache misses, parrot or fuse clients
do not need to download additional files from the network.

If clients do have network access, they might find a repository version online
that is newer than the preloaded version in the cache.  This results in
conflicts with ``cvmfs_preload`` or in errors if the cache directory is
read-only.  Therefore, we recommend to explicitly disable network access for the
parrot process on the nodes, for instance by setting

::

    HTTP_PROXY='INVALID-PROXY'

before the invocation of ``parrot_run``.

Compiling ``cvmfs_preload`` from Sources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to compile ``cvmfs_preload`` from sources, use the
``-DBUILD_PRELOADER=yes`` cmake option.


.. _sct_loopback_filesystems:

Loopback File Systems for Nodes' Caches
---------------------------------------

If nodes have Internet access but no local hard disk, it is preferable to
provide the CernVM-FS caches as loopback file systems on the cluster file
system. This way, CernVM-FS automatically populates the cache with the latest
upstream content. A Fuse mounted CernVM-FS will also automatically manage the
cache quota.

This approach requires a separate file for every node (not every mountpoint) on
the cluster file system. The file should be 15% larger than the configured
CernVM-FS cache size on the nodes, and it should be formatted with an ext3/4 or
an xfs file system. These files can be created with the ``dd`` and ``mkfs``
utilities. Nodes can mount these files as loopback file systems from the
shared file system.

Because there is only a single file for every node, the parallelism of
the cluster file system can be exploited and all the requests from
CernVM-FS circumvent the cluster file system's meta-data server(s).
That can be a very large advantage because very often the meta-data
server is the bottleneck under typical workloads.


Tiered Cache and Cache Plugins
------------------------------

Diskless compute nodes can also combine an in-memory cache with a preloaded
directory on the shared cluster file system. An example configuration can be
found in Section :ref:`sct_cache_advanced_example`.

