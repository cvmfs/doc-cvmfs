Known Issues
============

These pages mentions known limitations that won't be fixed, and bugs affecting certain verisons that can interfere with operations. For a more details see the changelog pages and issue tracker.

Known Issues By Version
-----------------------

CernVM-FS 2.13.2
^^^^^^^^^^^^^^

* Race condition in auto-mounts/umounts can lead to stuck cvmfs processes

CernVM-FS 2.13.1
^^^^^^^^^^^^^^^^^^

* Race condition in auto-mounts/umounts can lead to stuck cvmfs processes
* Crashes due to Page Cache Tracker Mismatches


CernVM-FS 2.12.7
^^^^^^^^^^^^^^^^^^

* [server] ingesting a tarball with double slashes in base_dir corrupts repository
* Crashes due to Page Cache Tracker Mismatches


Description
----------


Race condition in auto-mounts/umounts can lead to stuck cvmfs processes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


The feature of pre-mounting the fuse device introduced in 2.13.0 can make issues when autofs unmounts the repository just as another process remounts it. This can be especially noticeable with short autofs timeouts and automatic checks that may remount the repositories. Github issue: `3993 <https://github.com/cvmfs/cvmfs/issues/3993>`__

Crashes due to Page Cache Tracker Mismatches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A mismatch in internal data structures triggered by repository updates can throw an assert, crashing cvmfs. Github issue: `3520 <https://github.com/cvmfs/cvmfs/issues/3520>`__

Slow Performance with a Very Large File Descriptor Limit
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before CernVM-FS 2.11, having the file descriptor limit set to a very large number
will result in a very slow ``cvmfs`` performance in certain situations.
This is due to certain operations looping over all possible file descriptors,
instead of just the used/opened ones.
This issue is resolved in CernVM-FS 2.11.

Publisher nodes with AUFS and XFS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the ``/tmp`` file system is on xfs, the publisher node cannot be used with AUFS.
On such systems, adding the mount option ``xino=/dev/shm/aufs.xino`` can be
a workaround. In general, new repositories should use OverlayFS if available.
