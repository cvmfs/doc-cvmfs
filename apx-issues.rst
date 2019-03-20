Known Issues
============

Publisher nodes with AUFS and XFS
---------------------------------

If the /tmp file system is on xfs, the publisher node cannot be used with AUFS.
On such systems, adding the mount option ``xino=/dev/shm/aufs.xino`` can be
a workaround. In general, new repositories should use OverlayFS if available.
