

Release Notes for CernVM-FS 2.13.1
==================================

CernVM-FS 2.13.1 is a patch release that fixes a few bugs introduced in 2.13.0.


As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend updating only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed; no active leases must be present before upgrading.

.. note::
  Packages no longer support libfuse2 for the new platforms: RHEL/Alma >= 10, Fedora >= 42, Debian >= 13 and Ubuntu >= 25.04.
  For package maintainers: Libfuse2 support is turned off by default, and has to be enabled explicitly with the flag -DBUILD_LIBFUSE2
  It will be deprecated completely in a future version, and  the dependency can already be removed, as libfuse3 is required by default.
  The cvmfs package should now explicitly depend on the cvmfs_fuse3 libs packaged in cvmfs-fuse3 package  to ensure they are installed.

Packages are available for both the x86_64 and aarch64 architectures, for current debian- and rhel-based distros.
We've added packages for Almalinux 10 and Fedora 42 on top of Debian 13 already introduced in the previous release. Do try them out!

Bug fixes
---------
  * [client] Fix mount options that can lead to "futimes" error with docker (`#3872 <https://github.com/cvmfs/cvmfs/issues/3872>`_)
  * [rpm] Allow builds without libfuse2 (`#3879 <https://github.com/cvmfs/cvmfs/issues/3879>`_)
  * [client] Fix a segfault in one of the unmount branches of the loader (`#3873 <https://github.com/cvmfs/cvmfs/issues/3873>`_)
  * [client] Fix host reset timeout (CVMFS_HOST_RESET_AFTER) (`#3864 <https://github.com/cvmfs/cvmfs/issues/3864>`_)



Release Notes for CernVM-FS 2.13.0
==================================

CernVM-FS 2.13.0 is a minor release that has a number of  important fixes for cvmfs_server ingest, mounting cvmfs on Ubuntu 24.10+, and some small improvements.

.. note::
  For admins of stratum-1s: The cvmfs-server package now installs default logrotate configs to /etc/logrotate.d/cvmfs and /etc/logrotate.d/cvmfs-statsdb.  If you prefer not to use logrotate for snapshot logs and stats db, create an empty file under these paths or remove them after installation. When installed or upgraded from the packages, cvmfs-server should not overwrite any modification you make.

.. note::
  For package maintainers of cvmfs-server: You can  install the previously mentioned logrotate files with the appropriate config file behavior, and add an optional dependency on logrotate.


As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend updating only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed; no active leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures, for current debian- and rhel-based distros.
We no longer provide packages for Centos7 and Ubuntu 20.04, but add packages for Debian 13.


Bug fixes
---------

  * [server] Do not corrupt repository when ingesting a tarball to a base dir that contains a double slash (`#3786 <https://github.com/cvmfs/cvmfs/issues/3786>`_)
  * [server] swissknife_lease: Fix bug in response receiver callback (`#3823 <https://github.com/cvmfs/cvmfs/issues/3823>`_)
  * [client] Fixed unmounting after stopping autofs in Ubuntu 24.04 (`#3808 <https://github.com/cvmfs/cvmfs/issues/3808>`_)
  * [client] Fixed permission issue in mounting cvmfs with apparmor (Ubuntu 24.10+) (`#3795 <https://github.com/cvmfs/cvmfs/issues/3795>`_)
  * [server] Fixed garbage collection lock to avoid spurious check failures (`#3815 <https://github.com/cvmfs/cvmfs/issues/3815>`_)
  * [shrinkwrap] Avoid possible copy errors by ensuring that directories are writeable (`#3798 <https://github.com/cvmfs/cvmfs/issues/3798>`_)
  * [macos] Chksetup for macfuse no longer complains about missing FUSE-T (`#3800 <https://github.com/cvmfs/cvmfs/issues/3800>`_)
  * [macos] Run apfs.util after creating firmlinks on macos (`#3776 <https://github.com/cvmfs/cvmfs/issues/3776>`_)


Improvements and changes
------------------------

  * [client] Bugreport no longer blocks, and collects as much data as possible when client stuck (`#3768 <https://github.com/cvmfs/cvmfs/issues/3768>`_)
  * [client] Improved EIO logging (`#3723 <https://github.com/cvmfs/cvmfs/issues/3723>`_)
  * [gateway, ducc, snapshotter] bump and cleanup golang dependencies
  * [server] Ingest command can now delete paths containing colons (:) (`#3792 <https://github.com/cvmfs/cvmfs/issues/3792>`_)
  * [server] Install default logrotate configs for /var/log/cvmfs and statsdb (`#3839 <https://github.com/cvmfs/cvmfs/issues/3839>`_)
  * [client] Add cvmfs_config killall options -r(reset fuse) / -s(stuck fuse reset) to abort fuse connection (`#3831 <https://github.com/cvmfs/cvmfs/issues/3831>`_)
  * [rpm] Automatically set permissions for cvmfs_ducc (`#3790 <https://github.com/cvmfs/cvmfs/issues/3790>`_)
  * [client] chksetup: Now uses max-time instead of connect-timeout to avoid blocking when contacting stratum 1s (`#3822 <https://github.com/cvmfs/cvmfs/issues/3822>`_)
