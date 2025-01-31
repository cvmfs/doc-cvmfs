
Release Notes for CernVM-FS 2.12.6 + 2.12.5
==================================

CernVM-FS 2.12.6 is a small patch release that fixes a packaging issue on platforms without systemd, as well as a spurious warning from cvmfs_check. 2.12.5 accidentally missed a commit, and is dropped - use 2.12.6 directly.

Bug fixes
---------

  * [client] Revert CVMFS_PATCH_LEVEL to 0 for check_cvmfs.sh (#3750)
  * [rpm] fix package install on wsl2 and other non-systemd platforms (#3749)
  
Release Notes for CernVM-FS 2.12.4
==================================

CernVM-FS 2.12.4 is a small patch release that adds a minor fix to ``cvmfs_config fsck -q`` and a minor fix to ``cvmfs_server mkfs``.

Bug fixes
---------

  * [client] Fix cvmfs_config fsck -q to work with rmd160, shake128 hashes (`#3739 <https://github.com/cvmfs/cvmfs/issues/3739>`_)
  * [server] Fix mkfs overwrite-manifest check when upstream is gateway (`#37240 <https://github.com/cvmfs/cvmfs/issues/3740>`_)


Release Notes for CernVM-FS 2.12.3
==================================

CernVM-FS 2.12.3 is a small patch release that fixes the issue with zeroed files in the cache seen in 2.12.0.

Bug fixes
---------

  * [client] Don't commit empty certificates to cache (`#3728 <https://github.com/cvmfs/cvmfs/issues/3728>`_)

Release Notes for CernVM-FS 2.12.2
==================================

CernVM-FS 2.12.2 is a small patch release that adds the "quick" ``cvmfs_config fsck -q`` option to check for and quarantine zeroed files in the cache.

Improvements and changes
------------------------

* [client] Add cvmfs_config fsck -q(uick) to check for zeroed files in cache (`#3726 <https://github.com/cvmfs/cvmfs/issues/3726>`_)

Release Notes for CernVM-FS 2.12.1
==================================

CernVM-FS 2.12.1 is a small patch release that fixes a packaging issue: it ensures that the service to reload cvmfs after package upgrades is correctly configured.

Bug fixes
---------

  * [rpm] bugfix for reload service after rpm upgrades (`#3725 <https://github.com/cvmfs/cvmfs/issues/3725>`_)

Release Notes for CernVM-FS 2.12.0
==================================

CernVM-FS 2.12.0 is a sizeable feature release with new features, bug fixes and performance improvements.
NOTE: Testing has shown instances of cache corruption with this release, it will not be released in production. On your testing instances, upgrade to 2.12.2, run ``cvmfs_config fsck -q`` frequently and report any errors. 

Highlights are:

* Experimental Support for FUSE-T on MacOS, allowing for easy installation without security tweaks. NOTE: There are some known issues with FUSE-T, do not expext this to be stable yet.

* Refcounted Cache Manager now the default

* Fully-featured Streaming Cache Manager for data / files that should not be cached

* Support for Metalink server discovery

* Several fixes in the fuse internals, for example the page cache tracker

* Reloading of CVMFS after package upgrades is now done via a daemon to avoid blocking the package transaction


As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend updating only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed; no active leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures, for current debian- and rhel-based distros.




Bug fixes
---------

  * [client] Add "cache limit set <MB>" function to cvmfs_talk (`#3623 <https://github.com/cvmfs/cvmfs/issues/3623>`_) 
  * [client] Fix replacement of stale inodes (`#3507 <https://github.com/cvmfs/cvmfs/issues/3507>`_)
  * [client] Print correct timezone in logbuffer (`#3679 <https://github.com/cvmfs/cvmfs/issues/3679>`_)
  * [client] log NOTFOUND in tracefile when lookup unsuccessful (`#3704 <https://github.com/cvmfs/cvmfs/issues/3704>`_)
  * [client] Close page cache tracker entry if cvmfs_open() fails (`#3588 <https://github.com/cvmfs/cvmfs/issues/3588>`_)
  * [client] Remove unnecessary remount fence in forget callback (`#3591 <https://github.com/cvmfs/cvmfs/issues/3591>`_)
  * [client] Move getxattr check of valid return value closer to its request (`#3516 <https://github.com/cvmfs/cvmfs/issues/3516>`_)
  * [client] Improve error logging in inode tracker (`#3502 <https://github.com/cvmfs/cvmfs/issues/3502>`_)
  * [client] Fix a few Log2Histogram bugs (`#3511 <https://github.com/cvmfs/cvmfs/issues/3511>`_)
  * [client] Reduce write lock contention in catalog mgr (`#3476 <https://github.com/cvmfs/cvmfs/issues/3476>`_)
  * [client] Log JobInfo object id and its respective CURL requests (`#3492 <https://github.com/cvmfs/cvmfs/issues/3492>`_)
  * [client] Avoid possible race in mount helper (`#3475 <https://github.com/cvmfs/cvmfs/issues/3475>`_)
  * [server] Ingest Tarball now with modifiyable ownership (`#3362 <https://github.com/cvmfs/cvmfs/issues/3362>`_)
  * [server] Fixes and improvements to concurrency in SessionContext (`#3546 <https://github.com/cvmfs/cvmfs/issues/3546>`_)
  * [server] Fix race when publishing to a gateway (`#3546 <https://github.com/cvmfs/cvmfs/issues/3546>`_)
  * [server] Consistently use 64bit ints for catalog revision (`#3478 <https://github.com/cvmfs/cvmfs/issues/3478>`_)
  * [server] Create scratch dir with consistent permissions (`#3660 <https://github.com/cvmfs/cvmfs/issues/3660>`_)
  * [rpm] Fix externals for RISC-V build (`#3446 <https://github.com/cvmfs/cvmfs/issues/3446>`_)
  * [service container] use all env vars in config (`#3677 <https://github.com/cvmfs/cvmfs/issues/3677>`_)





Improvements and changes
------------------------

  * [client] Better logging for host/proxies (`#3617 <https://github.com/cvmfs/cvmfs/issues/3617>`_)
  * [client] FUSE-T support for macOS (`#3587 <https://github.com/cvmfs/cvmfs/issues/3587>`_)
  * [client] Add metalink support (`#3683 <https://github.com/cvmfs/cvmfs/issues/3683>`_)
  * Add support for high-precision timestamps (`#3513 <https://github.com/cvmfs/cvmfs/issues/3513>`_)
  * [client] Turn CVMFS_CACHE_REFCOUNT on by default (`#3684 <https://github.com/cvmfs/cvmfs/issues/3684>`_)
  * [client] Add memory buffer to streaming cache manager (`#3632 <https://github.com/cvmfs/cvmfs/issues/3632>`_)
  * [client] Add "cache limit set <MB>" function to cvmfs_talk (`#3623 <https://github.com/cvmfs/cvmfs/issues/3623>`_)
  * [client] add eio.emfile counter for  open() operations (`#3625 <https://github.com/cvmfs/cvmfs/issues/3625>`_)
  * [server] mkfs: do not overwrite existing manifest in s3 bucket (`#3693 <https://github.com/cvmfs/cvmfs/issues/3693>`_) 
  * [server] allow absolute paths for ingest --base_dir and --to_delete (`#3695 <https://github.com/cvmfs/cvmfs/issues/3695>`_)
  * [ducc] Enable syncronous GC on webhook (`#3646 <https://github.com/cvmfs/cvmfs/issues/3646>`_)
  * [gw] Cache catalogs for cvmfs_receiver (`#3431 <https://github.com/cvmfs/cvmfs/issues/3431>`_)
  * [rpm] Run post-install reload in a unit (`#3707 <https://github.com/cvmfs/cvmfs/issues/3707>`_) 
  * [client] Support for the new CVMFS_FUSE3_IDLE_THREADS and CVMFS_FUSE3_MAX_THREADS parameters (`#3505 <https://github.com/cvmfs/cvmfs/issues/3505>`_)
  * [client] Add paging to xattr (`#3355 <https://github.com/cvmfs/cvmfs/issues/3355>`_)
