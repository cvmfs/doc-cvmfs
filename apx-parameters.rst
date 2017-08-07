.. _apx_paramters:

CernVM-FS Parameters
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
CVMFS_ALT_ROOT_PATH             If set to *yes*, use alternative root catalog path.  Only required for fixed catalogs (tag / hash) under the alternative path.
CVMFS_AUTO_UPDATE               If set to *no*, disables the automatic update of file catalogs.
CVMFS_AUTHZ_HELPER              Full path to an authz helper, overwrites the helper hint in the catalog.
CVMFS_AUTHZ_SEARCH_PATH         Full path to the directory that contains the authz helpers.
CVMFS_BACKOFF_INIT              Seconds for the maximum initial backoff when retrying to download data.
CVMFS_BACKOFF_MAX               Maximum backoff in seconds when retrying to download data.
CVMFS_CACHE_BASE                Location (directory) of the CernVM-FS cache.
CVMFS_CHECK_PERMISSIONS         If set to *no*, disable checking of file ownership and permissions (open all files).
CVMFS_CLAIM_OWNERSHIP           If set to *yes*, allows CernVM-FS to claim ownership of files and directories.
CVMFS_DEBUGLOG                  If set, run CernVM-FS in debug mode and write a verbose log the the specified file.
CVMFS_DEFAULT_DOMAIN            The default domain will be automatically appended to repository names when given without a domain.
CVMFS_DNS_RETRIES               Number of retries when resolving proxy names
CVMFS_DNS_TIMEOUT               Timeout in seconds when resolving proxy names
CVMFS_EXTERNAL_FALLBACK_PROXY   List of HTTP proxies similar to ``CVMFS_EXTERNAL_HTTP_PROXY``. The fallback proxies are added to the end of the normal proxies, and disable DIRECT connections.
CVMFS_EXTERNAL_HTTP_PROXY       Chain of HTTP proxy groups to be used when CernVM-FS is accessing external data
CVMFS_EXTERNAL_TIMEOUT          Timeout in seconds for HTTP requests to an external-data server with a proxy server
CVMFS_EXTERNAL_TIMEOUT_DIRECT   Timeout in seconds for HTTP requests to an external-data server without a proxy server
CVMFS_EXTERNAL_URL              Semicolon-separated chain of webservers serving external data chunks.
CVMFS_FALLBACK_PROXY            List of HTTP proxies similar to ``CVMFS_HTTP_PROXY``. The fallback proxies are added to the end of the normal proxies, and disable DIRECT connections.
CVMFS_FOLLOW_REDIRECTS          When set to *yes*, follow up to 4 HTTP redirects in requests.
CVMFS_HIDE_MAGIC_XATTRS         If set to *yes* the client will not expose CernVM-FS specific extended attributes
CVMFS_HOST_RESET_AFTER          See ``CVMFS_PROXY_RESET_AFTER``.
CVMFS_HTTP_PROXY                Chain of HTTP proxy groups used by CernVM-FS. Necessary. Set to ``DIRECT`` if you don't use proxies.
CVMFS_IGNORE_SIGNATURE          When set to *yes*, don't verify CernVM-FS file catalog signatures.
CVMFS_INITIAL_GENERATION        Initial inode generation.  Used for testing.
CVMFS_IPFAMILY_PREFER           Which IP protocol to prefer when connecting to proxies.  Can be either 4 or 6.
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
CVMFS_PROXY_TEMPLATE            Overwrite the default proxy template in Geo-API calls.  Only needed for debugging.
CVMFS_PUBLIC_KEY                Colon-separated list of repository signing keys.
CVMFS_QUOTA_LIMIT               Soft-limit of the cache in Megabyte.
CVMFS_RELOAD_SOCKETS            Directory of the sockets used by the CernVM-FS loader to trigger hotpatching/reloading.
CVMFS_REPOSITORIES              Comma-separated list of fully qualified repository names that shall be mountable under /cvmfs.
CVMFS_REPOSITORY_DATE           A timestamp in ISO format (e.g. ``2007-03-01T13:00:00Z``).  Selects the repository state as of the given date.
CVMFS_REPOSITORY_TAG            Select a named repository snapshot that should be mounted instead of ``trunk``.
CVMFS_CONFIG_REPO_REQUIRED      If set to *yes*, no repository can be mounted unless the config repository is available.
CVMFS_ROOT_HASH                 Hash of the root file catalog, implies ``CVMFS_AUTO_UPDATE=no``.
CVMFS_SEND_INFO_HEADER          If set to *yes*, include the cvmfs path of downloaded data in HTTP headers.
CVMFS_SERVER_CACHE_MODE         Enable special cache semantics for a client used as a release manager repository base line.
CVMFS_SERVER_URL                Semicolon-separated chain of Stratum~1 servers.
CVMFS_SHARED_CACHE              If set to *no*, makes a repository use an exclusive cache.
CVMFS_STRICT_MOUNT              If set to *yes*, mount only repositories that are listed in ``CVMFS_REPOSITORIES``.
CVMFS_SYSLOG_FACILITY           If set to a number between 0 and 7, uses the corresponding LOCAL$n$ facility for syslog messages.
CVMFS_SYSLOG_LEVEL              If set to 1 or 2, sets the syslog level for CernVM-FS messages to LOG_DEBUG or LOG_INFO respectively.
CVMFS_SYSTEMD_NOKILL            If set to *yes*, modify the command line to ``@vmfs2 ...`` in order to act as a systemd lowlevel storage manager.
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
CVMFS_AUFS_WARNING                  Set to *false* to silence AUFS kernel deadlock warning.
CVMFS_AUTO_GC                       Enables the automatic garbage collection on *publish* and *snapshot*
CVMFS_AUTO_GC_TIMESPAN              Date-threshold for automatic garbage collection |br| (For example: `3 days ago`, `1 week ago`, ...)
CVMFS_AUTO_REPAIR_MOUNTPOINT        Set to *true* to enable automatic recovery from bogus server mount states.
CVMFS_AUTO_TAG                      Creates a generic revision tag for each published revision (if set to *true*).
CVMFS_AUTO_TAG_TIMESPAN             Date-threshold for automatic tags, after which auto tags get removed (For example: `4 days ago`)
CVMFS_AUTOCATALOGS                  Enable/disable automatic catalog management using autocatalogs.
CVMFS_AUTOCATALOGS_MAX_WEIGHT       Maximum number of entries in an autocatalog to be considered overflowed. Default value: 100000 |br| (see also *CVMFS_AUTOCATALOGS*)
CVMFS_AUTOCATALOGS_MIN_WEIGHT       Minimum number of entries in an autocatalog to be considered underflowed. Default value: 1000 |br| (see also *CVMFS_AUTOCATALOGS*)
CVMFS_AVG_CHUNK_SIZE                Desired Average size of a file chunk in bytes |br| (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_CATALOG_ALT_PATHS             Enable/disable generation of catalog bootstrapping shortcuts during publishing. (Useful when backend directory `/data` is not publicly accessible)
CVMFS_COMPRESSION_ALGORITHM         Compression algorithm to be used during publishing |br| (currently either 'default' or 'none')
CVMFS_CREATOR_VERSION               The CernVM-FS version that was used to create this repository (do not change manually).
CVMFS_DONT_CHECK_OVERLAYFS_VERSION  Disable checking of OverlayFS version before usage. Using OverlayFS in kernel older than 4.2.x is not supported! (see :ref:`sct_reporequirements`)
CVMFS_ENFORCE_LIMITS                Set to *true* to cause exceeding \*LIMIT variables to be fatal to a publish instead of a warning
CVMFS_EXTERNAL_DATA                 Set to *true* to mark repository to contain external data that is served from an external HTTP server
CVMFS_FILE_MBYTE_LIMIT              Maximum number of megabytes for a published file, default value: 1024 |br| (see also *CVMFS_ENFORCE_LIMITS*)
CVMFS_FORCE_REMOUNT_WARNING         Enable/disable warning through ``wall`` and grace period before forcefully remounting a CernVM-FS repository on the release managere machine.
CVMFS_GARBAGE_COLLECTION            Enables repository garbage collection |br| (Stratum~0 only | if set to *true*)
CVMFS_GC_DELETION_LOG               Log file path to track all garbage collected objects during sweeping for bookkeeping or debugging
CVMFS_HASH_ALGORITHM                Define which secure hash algorithm should be used by CernVM-FS for CAS objects |br| (supported are: *sha1*, *rmd160* and *shake128*)
CVMFS_IGNORE_XDIR_HARDLINKS         If set to *yes*, do not abort the publish operation when cross-directory hardlinks are found.  Instead automatically break the hardlinks across directories.
CVMFS_INCLUDE_XATTRS                Set to *true* to process extended attributes
CVMFS_MAX_CHUNK_SIZE                Maximal size of a file chunk in bytes |br| (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_MAXIMAL_CONCURRENT_WRITES     Maximal number of concurrently processed files during publishing.
CVMFS_MIN_CHUNK_SIZE                Minimal size of a file chunk in bytes |br| (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_NESTED_KCATALOG_LIMIT         Maximum thousands of files allowed in nested catalogs, default 500 |br| (see also *CVMFS_ROOT_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*)
CVMFS_NUM_WORKERS                   Maximal number of concurrently downloaded files during a Stratum1 pull operation (Stratum~1 only).
CVMFS_PUBLIC_KEY                    Path to the public key file of the repository to be replicated. (Stratum 1 only).
CVMFS_REPLICA_ACTIVE                Stratum1-only: Set to *no* to skip this Stratum1 when executing ``cvmfs_server snapshot -a``
CVMFS_REPOSITORY_NAME               The fully qualified name of the specific repository.
CVMFS_REPOSITORY_TYPE               Defines if the repository is a master copy (*stratum0*) or a replica (*stratum1*).
CVMFS_ROOT_KCATALOG_LIMIT           Maximum thousands of files allowed in root catalogs, default 200 |br| (see also *CVMFS_NESTED_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*)
CVMFS_SPOOL_DIR                     Location of the upstream spooler scratch directories; the read-only CernVM-FS moint point and copy-on-write storage reside here.
CVMFS_STRATUM0                      URL of the master copy (*stratum0*) of this specific repository.
CVMFS_STRATUM1                      URL of the Stratum1 HTTP server for this specific repository.
CVMFS_UNION_DIR                     Mount point of the union file system for copy-on-write semantics of CernVM-FS. Here, changes to the repository are performed (see :ref:`sct_repocreation_update`).
CVMFS_UNION_FS_TYPE                 Defines the union file system to be used for the repository. |br| (currently `aufs` and `overlayfs` are fully supported)
CVMFS_UPSTREAM_STORAGE              Upstream spooler description defining the basic upstream storage type and configuration.
CVMFS_USE_FILE_CHUNKING             Allows backend to split big files into small chunks (*true* | *false*)
CVMFS_USER                          The user name that owns and manipulates the files inside the repository.
CVMFS_VOMS_AUTHZ                    Membership requirement (e.g. VOMS authentication) to be added into the file catalogs
=================================== ============================================================================================================================================================
