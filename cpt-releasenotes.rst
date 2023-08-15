Release Notes for CernVM-FS 2.11.0
==================================

CernVM-FS 2.11.0 is a sizeable feature release, containing a number of new features, bug fixes and performance improvements, some of which have been presented at `CHEP 2023 <https://indico.jlab.org/event/459/contributions/11483/attachments/9475/13736/presentation.pdf>`_.

Highlights are:

* Support for symlink kernel cacheing through CVMFS_CACHE_SYMLINKS

* A new refcounted cache manager mode that reduces the number of open file descriptors with CVMFS_CACHE_REFCOUNT, and a streaming cache mode with CVMFS_CACHE_STREAMING

* A bugfix for an issue that would slow down client startup when the limit for open file descriptors gets very high.


As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures, now also for Debian 12. Packages for Ubuntu 16.04 are no longer provided after the deprecation in 2.10.1.

.. note:: The base package, cvmfs-libs, introduced in 2.10, is now used more widely as a dependency, in particular by the cvmfs client package.



Bug fixes
---------

  * [client] Use http client auth only if membership is set (#3333)
  * [gw] Fix publication of uncompressed files through gateway (#3338)
  * [server] Verify meta-info object in cvmfs_server check (#3139)
  * [client] Allow CPU affinity setting through CVMFS_CPU_AFFINITY (#3330)
  * [server] Fix deadlock in uploading pipeline (#3195)
  * [gw] Fix transaction abort after gateway restart (#3128)
  * [gw] Fix occasional lease contention errors (#3259, #3077, #3272)
  * [client] Check for writable log file directories in chkconfig (#3310)
  * [server] Restrict error handling of readahead (#3305)
  * [client] Fix tmpfs recognition to skip readahead (#3316)
  * [client] Use dedicated log files for mount helper (#3314)
  * [client] Warn about potential incorrect use of cvmfs_talk (#3303)
  * [gc] Extend grep filter to accept microsecond precision in tags (#3301)
  * [client] Use logging settings in mount helper (#2962)
  * [client] Fix race in signal handling when authz helper is started (#3211)
  * [server] Fix race in parallel catalog traversal (#3171)
  * If CVMFS_SUPPRESS_ASSERTS is defined, keep retrying memory allocation on failure (#3244)
  * [server] Fix force abort after client crash (#3283)
  * [client] Error out early if certificate is invalid (#3238)
  * [client] Improve watchdog startup procedure (#3089)
  * [gc] Avoid duplicate delete requests (#3117)
  * Fix mount helper so that it works with libfuse3 auto_unmount (#3143)
  * Enable core file generation if watchdog is disabled (#3142)
  * Fix closing of file descriptors for very large nfiles limit (#3158)
  * Add AssertOrLog to conditionally continue on certain fatal errors (#3157)
  * [macOS] Fix xattr on symlinks (#3170)
  * [rpm] Bump base for service container to EL9
  * [client] Improve logging of I/O errors (#2941)
  * [client] Gracefully handle CURLE_SEND_ERROR in download manager (#2925)
  * Restrict ShortString overflow counters to debug mode (#3081)
  * [S3] Gracefully handle HTTP 500 return codes during upload (#2912)


Improvements and changes
------------------------

  * [client] Allow change to/from debug mode during cvmfs_config reload (#2897, #3359)
  * [client] Re-use the file descriptor for a file already open in the local cache (#3067)
  * [client] Support latest signature of fuse_lowlevel_notify_expire_entry (#3352)
  * [client] Placeholder for custom proxy health check and sharding policy (#3095)
  * [client] Custom http tracing headers (#3094)
  * [client] Add curl debug info to debug log (#3329)
  * [client] Add development option _CVMFS_DEVEL_IGNORE_SIGNATURE_FAILURES (#3317)
  * [client] Add streaming cache mode through CVMFS_STREAMING_CACHE=yes (#3263, #2948)
  * Add proxy_list and proxy_list_external magic xattrs (#3233)
  * [client] Add telemetry framework to send performance counters to influx (#3096)
  * [client] Add support for evicting chunked files through cvmfs_talk (#3122)
  * [client] Add support for symlink kernel cache through CVMFS_CACHE_SYMLINKS (#2949)
  * [s3] Add support for CVMFS_S3_X_AMZ_ACL server parameter (#2970)
  * Add support for protected xattrs, new client parameters
    CVMFS_XATTR_[PRIVILEGED_GIDS,PROTECTED_XATTRS] (#3103)
  * [gw] Store publisher hostname in lease (#3130)
  * [client] Make CVMFS_ARCH env available for variant symlinks (#3127, CVM-910)
  * Add user.external_url extended attribute (#3101)
  * [rpm] Change libcvmfs static library to libcvmfs_client shared library (#3113)
  * [gw] Add HTTPS support for connecting to gateway (#3060)
  * [client] Add CVMFS_WORLD_READABLE client option (#3115)
  * [rpm] Let client depend on cvmfs-libs (#3107)
  * [rpm] Bump libcurl to version 7.86.0 (#3093)
  * [client] Add CVMFS_STATFS_CACHE_TIMEOUT parameter to cache statfs results (#3015)
