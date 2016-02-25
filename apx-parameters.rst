.. _apx_paramters:

CernVM-FS Parameters
====================

.. |br| raw:: html

   <br />

.. _apxsct_clientparameters:

Client parameters
-----------------

Parameters recognized in configuration files under /etc/cvmfs:


=============================== ====================================================================================================================================================================================
**Parameter**                   **Meaning**
=============================== ====================================================================================================================================================================================
CVMFS_ALIEN_CACHE               If set, use an alien cache at the given location
CVMFS_AUTO_UPDATE               If set to *no*, disables the automatic update of file catalogs.
CVMFS_BACKOFF_INIT              Seconds for the maximum initial backoff when retrying to download data. 
CVMFS_BACKOFF_MAX               Maximum backoff in seconds when retrying to download data.
CVMFS_CACHE_BASE                Location (directory) of the CernVM-FS cache.
CVMFS_CHECK_PERMISSIONS         If set to *no*, disable checking of file ownership and permissions (open all files).
CVMFS_CLAIM_OWNERSHIP           If set to *yes*, allows CernVM-FS to claim ownership of files and directories.
CVMFS_DEBUGLOG                  If set, run CernVM-FS in debug mode and write a verbose log the the specified file.
CVMFS_DEFAULT_DOMAIN            The default domain will be automatically appended to repository names when given without a domain.
CVMFS_FALLBACK_PROXY            List of HTTP proxies similar to ``CVMFS_HTTP_PROXY``. The fallback proxies are added to the end of the normal proxies, and disable DIRECT connections.
CVMFS_FOLLOW_REDIRECTS          When set to *yes*, follow up to 4 HTTP redirects in requests.
CVMFS_HOST_RESET_AFTER          See ``CVMFS_PROXY_RESET_AFTER``.
CVMFS_HTTP_PROXY                Chain of HTTP proxy groups used by CernVM-FS. Necessary. Set to ``DIRECT`` if you don't use proxies.
CVMFS_IGNORE_SIGNATURE          When set to *yes*, don't verify CernVM-FS file catalog signatures.
CVMFS_INITIAL_GENERATION        Initial inode generation.  Used for testing.
CVMFS_KCACHE_TIMEOUT            Timeout for path names and file attributes in the kernel file system buffers.
CVMFS_KEYS_DIR                  Directory containing \*.pub files used as repository signing keys.  If set, this parameter has precedence over ``CVMFS_PUBLIC_KEY``.
CVMFS_LOW_SPEED_LIMIT           Minimum transfer rate a server or proxy must provide.
CVMFS_MAX_IPADDR_PER_PROXY      Limit the number of IP addresses a proxy names resolves into.  From all registered addresses, up to the limit are randomly selected.
CVMFS_MAX_RETRIES               Maximum number of retries for a given proxy/host combination.
CVMFS_MAX_TTL                   Maximum file catalog TTL in minutes.  Can overwrite the TTL stored in the catalog.
CVMFS_MEMCACHE_SIZE             Size of the CernVM-FS meta-data memory cache in Megabyte.
CVMFS_MOUNT_RW                  Mount CernVM-FS as a read/write file system.  Write operations will fail but this option can workaround faulty ``open()`` flags.
CVMFS_NFILES                    Maximum number of open file descriptors that can be used by the CernVM-FS process.
CVMFS_NFS_SOURCE                If set to *yes*, act as a source for the NFS daemon (NFS export).
CVMFS_NFS_SHARED                If set a path, used to store the NFS maps in an SQlite database, instead of the usual LevelDB storage in the cache directory.
CVMFS_PAC_URLS                  Chain of URLs pointing to PAC files with HTTP proxy configuration information.
CVMFS_PROXY_RESET_AFTER         Delay in seconds after which CernVM-FS will retry the primary proxy group in case of a fail-over to another group.
CVMFS_PUBLIC_KEY                Colon-separated list of repository signing keys.
CVMFS_QUOTA_LIMIT               Soft-limit of the cache in Megabyte.
CVMFS_RELOAD_SOCKETS            Directory of the sockets used by the CernVM-FS loader to trigger hotpatching/reloading.
CVMFS_REPOSITORIES              Comma-separated list of fully qualified repository names that shall be mountable under /cvmfs.
CVMFS_REPOSITORY_TAG            Select a named repository snapshot that should be mounted instead of ``trunk``.
CVMFS_ROOT_HASH                 Hash of the root file catalog, implies ``CVMFS_AUTO_UPDATE=no``.
CVMFS_SERVER_URL                Semicolon-separated chain of Stratum~1 servers.
CVMFS_SHARED_CACHE              If set to *no*, makes a repository use an exclusive cache.
CVMFS_STRICT_MOUNT              If set to *yes*, mount only repositories that are listed in ``CVMFS_REPOSITORIES``.
CVMFS_SYSLOG_FACILITY           If set to a number between 0 and 7, uses the corresponding LOCAL$n$ facility for syslog messages.
CVMFS_SYSLOG_LEVEL              If set to 1 or 2, sets the syslog level for CernVM-FS messages to LOG_DEBUG or LOG_INFO respectively.
CVMFS_TIMEOUT                   Timeout in seconds for HTTP requests with a proxy server.
CVMFS_TIMEOUT_DIRECT            Timeout in seconds for HTTP requests without a proxy server.
CVMFS_TRACEFILE                 If set, enables the tracer and trace file system calls to the given file.
CVMFS_USE_GEOAPI                Request order of Stratum 1 servers and fallback proxies via Geo-API.
CVMFS_USER                      Sets the ``gid`` and ``uid`` mount options. Don't touch or overwrite.
CVMFS_USYSLOG                   All messages that normally are logged to syslog are re-directed to the given file.  This file can grow up to 500kB and there is one step of log rotation.  Required for $\mu$CernVM.
=============================== ====================================================================================================================================================================================


.. _apxsct_serverparameters:

Server parameters
-----------------

=================================== ============================================================================================================================================================
**Parameter**                       **Meaning**
=================================== ============================================================================================================================================================
CVMFS_CREATOR_VERSION               The CernVM-FS version that was used to create this repository (do not change manually).
CVMFS_IGNORE_XDIR_HARDLINKS         If set to *yes*, do not abort the publish operation when cross-directory hardlinks are found.  Instead automatically break the hardlinks across directories.
CVMFS_REPOSITORY_NAME               The fully qualified name of the specific repository.
CVMFS_REPOSITORY_TYPE               Defines if the repository is a master copy (*stratum0*) or a replica (*stratum1*).
CVMFS_SPOOL_DIR                     Location of the upstream spooler scratch directories; the read-only CernVM-FS moint point and copy-on-write storage reside here.
CVMFS_UPSTREAM_STORAGE              Upstream spooler description defining the basic upstream storage type and configuration.
CVMFS_STRATUM0                      URL of the master copy (*stratum0*) of this specific repository.
CVMFS_STRATUM1                      URL of the Stratum1 HTTP server for this specific repository.
CVMFS_AUTO_REPAIR_MOUNTPOINT        Set to *true* to enable automatic recovery from bogus server mount states.
CVMFS_UNION_DIR                     Mount point of the union file system between CernVM-FS and AUFS. Here, changes to the repository are performed (see :ref:`sct_repocreation_update`).
CVMFS_UNION_FS_TYPE                 Defines the union file system to be used for the repository. |br| (currently AUFS is fully supported)
CVMFS_AUFS_WARNING                  Set to *false* to silence AUFS kernel deadlock warning.
CVMFS_HASH_ALGORITHM                Define which secure hash algorithm should be used by CernVM-FS for CAS objects |br| (supported are: *sha1* and *rmd160*)
CVMFS_CATALOG_ENTRY_WARN_THRESHOLD  Threshold of catalog entry count before triggering a warning message.
CVMFS_USER                          The user name that owns and manipulates the files inside the repository.
CVMFS_USE_FILE_CHUNKING             Allows backend to split big files into small chunks (*true* | *false*)
CVMFS_MIN_CHUNK_SIZE                Minimal size of a file chunk in bytes |br| (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_AVG_CHUNK_SIZE                Desired Average size of a file chunk in bytes |br| (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_MAX_CHUNK_SIZE                Maximal size of a file chunk in bytes |br| (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_MAXIMAL_CONCURRENT_WRITES     Maximal number of concurrently processed files during publishing.
CVMFS_NUM_WORKERS                   Maximal number of concurrently downloaded files during a Stratum1 pull operation (Stratum~1 only).
CVMFS_PUBLIC_KEY                    Path to the public key file of the repository to be replicated. (Stratum~1 only).
CVMFS_AUTO_TAG                      Creates a generic revision tag for each published revision (if set to *true*).
CVMFS_GARBAGE_COLLECTION            Enables repository garbage collection |br| (Stratum~0 only | if set to *true*)
CVMFS_AUTO_GC                       Enables the automatic garbage collection on *publish* and *snapshot*
CVMFS_AUTO_GC_TIMESPAN              Date-threshold for automatic garbage collection |br| (For example: `3 days ago`, `1 week ago`, ...)
CVMFS_AUTOCATALOGS                  Enable/disable automatic catalog management using autocatalogs.
CVMFS_AUTOCATALOGS_MAX_WEIGHT       Maximum number of entries in an autocatalog to be considered overflowed. Default value: 100000 |br| (see also *CVMFS_AUTOCATALOGS*)
CVMFS_AUTOCATALOGS_MIN_WEIGHT       Minimum number of entries in an autocatalog to be considered underflowed. Default value: 1000 |br| (see also *CVMFS_AUTOCATALOGS*)
=================================== ============================================================================================================================================================


.. raw:: html

   <div id="refs" class="references">

.. raw:: html

   </div>
