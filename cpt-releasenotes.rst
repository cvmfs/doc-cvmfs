Release Notes for CernVM-FS 2.11.1
==================================

CernVM-FS 2.11.1 is a patch release, containing several minor bug fixes and improvements.
As with previous releases, upgrading clients should be seamless just by installing the new package from the repository.
As usual, we recommend updating only a few worker nodes first and gradually ramping up once the new version proves to work correctly.
Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active leases must be present before upgrading.

Bug fixes
---------

  * [client] Fix race condition on concurrent fuse3 mounts (`#3392 <https://github.com/cvmfs/cvmfs/issues/3392>`_)
  * [server, rpm] Limit initscripts dependency to EL <= 7 (`#3408 <https://github.com/cvmfs/cvmfs/issues/3408>`_)
  * [packaging] Remove hidden git build dependency (`#3376 <https://github.com/cvmfs/cvmfs/issues/3376>`_)


Release Notes for CernVM-FS 2.11.0
==================================

CernVM-FS 2.11.0 is a sizeable feature release, containing a number of new features, bug fixes and performance improvements, some of which have been presented at `CHEP 2023 <https://indico.jlab.org/event/459/contributions/11483/attachments/9475/13736/presentation.pdf>`_.

Highlights are:

* Support for symlink kernel caching through CVMFS_CACHE_SYMLINKS (requires libfuse >= 3.16 and kernel >= 6.2-rc1)

* A new reference-counted cache manager mode that reduces the number of open file descriptors with CVMFS_CACHE_REFCOUNT, and a streaming cache mode with CVMFS_STREAMING_CACHE

* A bugfix for an issue that would slow down client startup when the limit for open file descriptors gets very high.

* A new telemetry option to send client performance counters to influx; refer to the new `telemetry documentation <https://cvmfs.readthedocs.io/en/stable/cpt-telemetry.html>`_ for more details.


As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend updating only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed; no active leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures, now also for Debian 12. Packages for Ubuntu 16.04 are no longer provided after the deprecation in 2.10.1.

.. note:: The base package, cvmfs-libs, introduced in 2.10, is now used more widely as a dependency, in particular by the cvmfs client package.



Bug fixes
---------

  * [client] Fix closing of file descriptors for very large nfiles limit (`#3158 <https://github.com/cvmfs/cvmfs/issues/3158>`_)
  * [client] Fix occasional crashes of the watchdog helper process (`#3089 <https://github.com/cvmfs/cvmfs/issues/3089>`_)
  * [client] Gracefully handle proxies that prematurely close connections (`#2925 <https://github.com/cvmfs/cvmfs/issues/2925>`_)
  * [client] Fix changing to/from debug mode during cvmfs_config reload (`#2897 <https://github.com/cvmfs/cvmfs/issues/2897>`_, `#3359 <https://github.com/cvmfs/cvmfs/issues/3359>`_)
  * [client] Fix mount helper so that it works with libfuse3 auto_unmount option (`#3143 <https://github.com/cvmfs/cvmfs/issues/3143>`_)
  * [client] Enable core file generation if watchdog is disabled (`#3142 <https://github.com/cvmfs/cvmfs/issues/3142>`_)
  * [client] Error out early if certificate is invalid (`#3238 <https://github.com/cvmfs/cvmfs/issues/3238>`_)
  * [client] Fix race in signal handling when authz helper is started (`#3211 <https://github.com/cvmfs/cvmfs/issues/3211>`_)
  * [client] Use http client auth only if membership is set (`#3333 <https://github.com/cvmfs/cvmfs/issues/3333>`_)
  * [client] Use logging settings in mount helper (`#2962 <https://github.com/cvmfs/cvmfs/issues/2962>`_)
  * [client] Use dedicated log files for mount helper (`#3314 <https://github.com/cvmfs/cvmfs/issues/3314>`_)
  * [client] Warn about potential incorrect use of cvmfs_talk (`#3303 <https://github.com/cvmfs/cvmfs/issues/3303>`_)
  * [client] Fix tmpfs recognition to skip readahead (`#3316 <https://github.com/cvmfs/cvmfs/issues/3316>`_)
  * [macOS] Fix xattr on symlinks (`#3170 <https://github.com/cvmfs/cvmfs/issues/3170>`_)
  * [server] Fix rare deadlock in uploading pipeline (`#3195 <https://github.com/cvmfs/cvmfs/issues/3195>`_)
  * [server] Verify meta-info object in cvmfs_server check (`#3139 <https://github.com/cvmfs/cvmfs/issues/3139>`_)
  * [server] Fix spurious error message regarding readahead (`#3305 <https://github.com/cvmfs/cvmfs/issues/3305>`_)
  * [S3] Gracefully handle HTTP 500 return codes during upload (`#2912 <https://github.com/cvmfs/cvmfs/issues/2912>`_)
  * [gc] Fix race in parallel catalog traversal (`#3171 <https://github.com/cvmfs/cvmfs/issues/3171>`_)
  * [gc] Extend grep filter to accept microsecond precision in tags (`#3301 <https://github.com/cvmfs/cvmfs/issues/3301>`_)
  * [gw] Fix transaction abort after gateway restart (`#3128 <https://github.com/cvmfs/cvmfs/issues/3128>`_)
  * [gw] Fix transaction abort after client crash (`#3283 <https://github.com/cvmfs/cvmfs/issues/3283>`_)
  * [gw] Fix occasional lease contention errors (`#3259 <https://github.com/cvmfs/cvmfs/issues/3259>`_, `#3077 <https://github.com/cvmfs/cvmfs/issues/3077>`_, `#3272 <https://github.com/cvmfs/cvmfs/issues/3272>`_)
  * [gw] Fix publication of uncompressed files through gateway (`#3338 <https://github.com/cvmfs/cvmfs/issues/3338>`_)


Improvements and changes
------------------------

  * [client] Re-use the file descriptor for a file already open in the local cache (`#3067 <https://github.com/cvmfs/cvmfs/issues/3067>`_)
  * [client] Add support for symlink kernel cache through CVMFS_CACHE_SYMLINKS (`#2949 <https://github.com/cvmfs/cvmfs/issues/2949>`_)
  * [client] Add telemetry framework to send performance counters to influx (`#3096 <https://github.com/cvmfs/cvmfs/issues/3096>`_)
  * [client] Add streaming cache mode through CVMFS_STREAMING_CACHE=yes (`#3263 <https://github.com/cvmfs/cvmfs/issues/3263>`_, `#2948 <https://github.com/cvmfs/cvmfs/issues/2948>`_)
  * [client] Add CVMFS_STATFS_CACHE_TIMEOUT parameter to cache statfs results (`#3015 <https://github.com/cvmfs/cvmfs/issues/3015>`_)
  * [client] Make CVMFS_ARCH env available for use in variant symlinks (`#3127 <https://github.com/cvmfs/cvmfs/issues/3127>`_, CVM-910)
  * [client] Add CVMFS_WORLD_READABLE client option (`#3115 <https://github.com/cvmfs/cvmfs/issues/3115>`_)
  * [client] Restrict ShortString overflow counters to debug mode (`#3081 <https://github.com/cvmfs/cvmfs/issues/3081>`_)
  * [client] Improve logging of I/O errors (`#2941 <https://github.com/cvmfs/cvmfs/issues/2941>`_)
  * [client] Check for writable log file directories in chkconfig (`#3310 <https://github.com/cvmfs/cvmfs/issues/3310>`_)
  * [client] Allow CPU affinity setting through CVMFS_CPU_AFFINITY (`#3330 <https://github.com/cvmfs/cvmfs/issues/3330>`_)
  * [client] Add proxy_list and proxy_list_external magic xattrs (`#3233 <https://github.com/cvmfs/cvmfs/issues/3233>`_)
  * [client] Add external_url magic xattr (`#3101 <https://github.com/cvmfs/cvmfs/issues/3101>`_)
  * [client] Add support for protected xattrs, new client parameters
    CVMFS_XATTR_[PRIVILEGED_GIDS,PROTECTED_XATTRS] (`#3103 <https://github.com/cvmfs/cvmfs/issues/3103>`_)
  * [client] Add support for custom http tracing headers (`#3094 <https://github.com/cvmfs/cvmfs/issues/3094>`_)
  * [client] Add curl debug info to debug log (`#3329 <https://github.com/cvmfs/cvmfs/issues/3329>`_)
  * [client] Add support for evicting chunked files through cvmfs_talk (`#3122 <https://github.com/cvmfs/cvmfs/issues/3122>`_)
  * [S3] Add support for CVMFS_S3_X_AMZ_ACL server parameter (`#2970 <https://github.com/cvmfs/cvmfs/issues/2970>`_)
  * [gc] Avoid duplicate delete requests (`#3117 <https://github.com/cvmfs/cvmfs/issues/3117>`_)
  * [gw] Store publisher hostname in lease (`#3130 <https://github.com/cvmfs/cvmfs/issues/3130>`_)
  * [gw] Add HTTPS support for connecting to gateway (`#3060 <https://github.com/cvmfs/cvmfs/issues/3060>`_)
  * [container] Bump base for service container to EL9
  * [packaging] Change libcvmfs static library to libcvmfs_client shared library (`#3113 <https://github.com/cvmfs/cvmfs/issues/3113>`_)
  * [packaging] Let client depend on cvmfs-libs (`#3107 <https://github.com/cvmfs/cvmfs/issues/3107>`_)
