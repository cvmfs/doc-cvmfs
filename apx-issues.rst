Known Issues
============

Having a Very Large Number as File Descriptor Limit
---------------------------------------------------

Before CernVM-FS 2.11, having the file descriptor limit set to a very large number
will result in a very slow ``cvmfs`` performance in certain situations.
This is due to certain operations looping over all possible file descriptors,
instead of just the used/opened ones.
This issue is resolved in CernVM-FS 2.11.

Publisher nodes with AUFS and XFS
---------------------------------

If the /tmp file system is on xfs, the publisher node cannot be used with AUFS.
On such systems, adding the mount option ``xino=/dev/shm/aufs.xino`` can be
a workaround. In general, new repositories should use OverlayFS if available.
