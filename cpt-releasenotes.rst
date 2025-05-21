
Release Notes for CernVM-FS 2.13.0
==================================

CernVM-FS 2.13.0 is a minor release that has a number of  important fixes for cvmfs_server ingest, mounting cvmfs on Ubuntu 24.10+, and some small improvements.

NOTE for admins of stratum-1s: The cvmfs-server package now installs default logrotate configs to /etc/logrotate.d/cvmfs and /etc/logrotate.d/cvmfs-statsdb.
If you prefer not to use logrotate for snapshot logs and stats db, create an empty file under these paths or remove them after installation.
When installed or upgraded from the packages, cvmfs-server should not overwrite any modification you make.

NOTE for package maintainers: You may want to install the previously mentioned logrotate files with the appropriate config file behavior,
 and add an optional dependency on logrotate.


As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend updating only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed; no active leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures, for current debian- and rhel-based distros.
We no longer provide packages for Centos7 and Ubuntu 20.04, but add packages for Debian 13.


Bug fixes
---------

  * [server] Do not corrupt repository when ingesting a tarball to a base dir that contains a double slash (#3786)
  * [server] swissknife_lease: Fix bug in response receiver callback (#3823)
  * [client] Fixed unmounting after stopping autofs in Ubuntu 24.04 (#3808)
  * [client] Fixed permission issue in mounting cvmfs with apparmor (Ubuntu 25.10+) (#3795)
  * [server] Fixed garbage collection lock to avoid spurious check failures (#3815)
  * [shrinkwrap] Avoid possible copy errors by ensuring that directories are writeable (#3798)
  * [macos] Chksetup for macfuse no longer complains about missing FUSE-T (#3800)
  * [macos] Run apfs.util after creating firmlinks on macos (#3776)


Improvements and changes
------------------------

  * [client] Bugreport no longer blocks and collects as much data as possible when client stuck (#3768)
  * [client] Improved EIO logging (#3723)
  * [gateway, ducc, snapshotter] bump and cleanup golang dependencies
  * [server] Ingest command can now delete paths containing colons (:) (#3792)
  * [server] Install default logrotate configs for /var/log/cvmfs and statsdb (#3839)
  * [client] Add cvmfs_config killall options -r(reset fuse) / -s(stuck fuse reset) to abort fuse connection (#3831)
  * [rpm] Automatically set permissions for cvmfs_ducc (#3790)
  * [client] chksetup: Now uses max-time instead of connect-timeout to avoid blocking when contacting stratum 1s (#3822)
