Release Notes for CernVM-FS 2.11.0
==================================

CernVM-FS 2.11.0 is a sizeable feature release, containing a number of new features, bug fixes and performance improvements, some of which have been presented at `CHEP 2023 <https://indico.jlab.org/event/459/contributions/11483/attachments/9475/13736/presentation.pdf>`_.

Highlights are:

* Support for symlink kernel caching through CVMFS_CACHE_SYMLINKS (requires libfuse >= 3.16 and kernel >= 6.2-rc1)

* A new reference-counted cache manager mode that reduces the number of open file descriptors with CVMFS_CACHE_REFCOUNT, and a streaming cache mode with CVMFS_CACHE_STREAMING

* A bugfix for an issue that would slow down client startup when the limit for open file descriptors gets very high.

* A new telemetry option to send client performance counters to influx


As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend updating only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed; no active leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures, now also for Debian 12. Packages for Ubuntu 16.04 are no longer provided after the deprecation in 2.10.1.

.. note:: The base package, cvmfs-libs, introduced in 2.10, is now used more widely as a dependency, in particular by the cvmfs client package.



Bug fixes
---------

  * [client] Fix closing of file descriptors for very large nfiles limit (#3158)
  * [client] Fix occasional crashes of the watchdog helper process (#3089)
  * [client] Gracefully handle proxies that prematurely close connections (#2925)
  * [client] Fix changing to/from debug mode during cvmfs_config reload (#2897, #3359)
  * [client] Fix mount helper so that it works with libfuse3 auto_unmount option (#3143)
  * [client] Enable core file generation if watchdog is disabled (#3142)
  * [client] Error out early if certificate is invalid (#3238)
  * [client] Fix race in signal handling when authz helper is started (#3211)
  * [client] Use http client auth only if membership is set (#3333)
  * [client] Use logging settings in mount helper (#2962)
  * [client] Use dedicated log files for mount helper (#3314)
  * [client] Warn about potential incorrect use of cvmfs_talk (#3303)
  * [client] Fix tmpfs recognition to skip readahead (#3316)
  * [macOS] Fix xattr on symlinks (#3170)
  * [server] Fix rare deadlock in uploading pipeline (#3195)
  * [server] Verify meta-info object in cvmfs_server check (#3139)
  * [server] Fix spurious error message regarding readahead (#3305)
  * [S3] Gracefully handle HTTP 500 return codes during upload (#2912)
  * [gc] Fix race in parallel catalog traversal (#3171)
  * [gc] Extend grep filter to accept microsecond precision in tags (#3301)
  * [gw] Fix transaction abort after gateway restart (#3128)
  * [gw] Fix transaction abort after client crash (#3283)
  * [gw] Fix occasional lease contention errors (#3259, #3077, #3272)
  * [gw] Fix publication of uncompressed files through gateway (#3338)


Improvements and changes
------------------------

  * [client] Re-use the file descriptor for a file already open in the local cache (#3067)
  * [client] Add support for symlink kernel cache through CVMFS_CACHE_SYMLINKS (#2949)
  * [client] Add telemetry framework to send performance counters to influx (#3096)
  * [client] Add streaming cache mode through CVMFS_STREAMING_CACHE=yes (#3263, #2948)
  * [client] Add CVMFS_STATFS_CACHE_TIMEOUT parameter to cache statfs results (#3015)
  * [client] Make CVMFS_ARCH env available for use in variant symlinks (#3127, CVM-910)
  * [client] Add CVMFS_WORLD_READABLE client option (#3115)
  * [client] Restrict ShortString overflow counters to debug mode (#3081)
  * [client] Improve logging of I/O errors (#2941)
  * [client] Check for writable log file directories in chkconfig (#3310)
  * [client] Allow CPU affinity setting through CVMFS_CPU_AFFINITY (#3330)
  * [client] Add proxy_list and proxy_list_external magic xattrs (#3233)
  * [client] Add external_url magic xattr (#3101)
  * [client] Add support for protected xattrs, new client parameters
    CVMFS_XATTR_[PRIVILEGED_GIDS,PROTECTED_XATTRS] (#3103)
  * [client] Add support for custom http tracing headers (#3094)
  * [client] Add curl debug info to debug log (#3329)
  * [client] Add support for evicting chunked files through cvmfs_talk (#3122)
  * [S3] Add support for CVMFS_S3_X_AMZ_ACL server parameter (#2970)
  * [gc] Avoid duplicate delete requests (#3117)
  * [gw] Store publisher hostname in lease (#3130)
  * [gw] Add HTTPS support for connecting to gateway (#3060)
  * [container] Bump base for service container to EL9
  * [packaging] Change libcvmfs static library to libcvmfs_client shared library (#3113)
  * [packaging] Let client depend on cvmfs-libs (#3107)
