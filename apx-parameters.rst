.. _apx_paramters:

CernVM-FS Parameters
====================

.. |br| raw:: html

   <br />

.. _apxsct_clientparameters:

Client parameters
-----------------

Parameters recognized in configuration files under /etc/cvmfs:


=============================== ========================================================================================
**Parameter**                   **Meaning**
=============================== ========================================================================================
CVMFS_ALIEN_CACHE               If set, use an alien cache at the given location
CVMFS_ALT_ROOT_PATH             | If set to *yes*, use alternative root catalog path.
                                | Only required for fixed catalogs (tag / hash) under the alternative path.
CVMFS_AUTO_UPDATE               If set to *no*, disables the automatic update of file catalogs.
CVMFS_AUTHZ_HELPER              Full path to an authz helper, overwrites the helper hint in the catalog.
CVMFS_AUTHZ_SEARCH_PATH         Full path to the directory that contains the authz helpers.
CVMFS_BACKOFF_INIT              Seconds for the maximum initial backoff when retrying to download data.
CVMFS_BACKOFF_MAX               Maximum backoff in seconds when retrying to download data.
CVMFS_CATALOG_WATERMARK         | Try to release pinned catalogs when their number surpasses the given watermark.
                                | Defaults to 1/4 CVMFS_NFILES; explicitly set by shrinkwrap.
CVMFS_CACHE_BASE                Location (directory) of the CernVM-FS cache.
CVMFS_CHECK_PERMISSIONS         If set to *no*, disable checking of file ownership and permissions (open all files).
CVMFS_CLAIM_OWNERSHIP           If set to *yes*, allows CernVM-FS to claim ownership of files and directories.
CVMFS_DEBUGLOG                  If set, run CernVM-FS in debug mode and write a verbose log the the specified file.
CVMFS_DEFAULT_DOMAIN            | The default domain will be automatically appended to repository names
                                | when given without a domain.
CVMFS_DNS_MIN_TTL               | Minimum effective TTL in seconds for DNS queries of proxy server names
                                | (not Stratum 1s). Defaults to 1 minute.
CVMFS_DNS_MAX_TTL               | Maximum effective TTL in seconds for DNS queries of proxy server names
                                | (not Stratum 1s). Defaults to 1 day.
CVMFS_DNS_RETRIES               Number of retries when resolving proxy names
CVMFS_DNS_TIMEOUT               Timeout in seconds when resolving proxy names
CVMFS_DNS_ROAMING               If true, watch /etc/resolv.conf for nameserver changes
CVMFS_ENFORCE_ACLS              | Enforce POSIX ACLs stored in the repository. Requires libfuse 3.
CVMFS_EXTERNAL_FALLBACK_PROXY   | List of HTTP proxies similar to ``CVMFS_EXTERNAL_HTTP_PROXY``.
                                | The fallback proxies are added to the end of the normal proxies,
                                | and disable DIRECT connections.
CVMFS_EXTERNAL_HTTP_PROXY       Chain of HTTP proxy groups to be used when CernVM-FS is accessing external data
CVMFS_EXTERNAL_TIMEOUT          Timeout in seconds for HTTP requests to an external-data server with a proxy server
CVMFS_EXTERNAL_TIMEOUT_DIRECT   Timeout in seconds for HTTP requests to an external-data server without a proxy server
CVMFS_EXTERNAL_URL              Semicolon-separated chain of webservers serving external data chunks.
CVMFS_FALLBACK_PROXY            | List of HTTP proxies similar to ``CVMFS_HTTP_PROXY``. The fallback proxies are
                                | added to the end of the normal proxies, and disable DIRECT connections.
CVMFS_FOLLOW_REDIRECTS          When set to *yes*, follow up to 4 HTTP redirects in requests.
CVMFS_HIDE_MAGIC_XATTRS         If set to *yes* the client will not expose CernVM-FS specific extended attributes
CVMFS_HOST_RESET_AFTER          See ``CVMFS_PROXY_RESET_AFTER``.
CVMFS_HTTP_PROXY                | Chain of HTTP proxy groups used by CernVM-FS. Necessary.
                                | Set to ``DIRECT`` if you don't use proxies.
CVMFS_IGNORE_SIGNATURE          When set to *yes*, don't verify CernVM-FS file catalog signatures.
CVMFS_INITIAL_GENERATION        Initial inode generation.  Used for testing.
CVMFS_INSTRUMENT_FUSE           | When set to *true* gather performance statistics about the FUSE callbacks.
                                | The results are displayed with `cvmfs_talk internal affairs`.
CVMFS_NFS_INTERLEAVED_INODES    In NFS mode, use only inodes of the form :math:`an+b`, specified as "b%a".
CVMFS_IPFAMILY_PREFER           Which IP protocol to prefer when connecting to proxies.  Can be either 4 or 6.
CVMFS_KCACHE_TIMEOUT            Timeout for path names and file attributes in the kernel file system buffers.
CVMFS_KEYS_DIR                  | Directory containing \*.pub files used as repository signing keys.
                                | If set, this parameter has precedence over ``CVMFS_PUBLIC_KEY``.
CVMFS_LOW_SPEED_LIMIT           Minimum transfer rate a server or proxy must provide.
CVMFS_MAX_EXTERNAL_SERVERS      | Limit the number of (geo sorted) stratum 1 servers for external data
                                | that are effectively used.
CVMFS_MAX_IPADDR_PER_PROXY      | Limit the number of IP addresses a proxy names resolves into.
                                | From all registered addresses, up to the limit are randomly selected.
CVMFS_MAX_RETRIES               Maximum number of retries for a given proxy/host combination.
CVMFS_MAX_SERVERS               Limit the number of (geo sorted) stratum 1 servers that are effectively used.
CVMFS_MAX_TTL                   Maximum file catalog TTL in minutes.  Can overwrite the TTL stored in the catalog.
CVMFS_MEMCACHE_SIZE             Size of the CernVM-FS meta-data memory cache in Megabyte.
CVMFS_MOUNT_RW                  | Mount CernVM-FS as a read/write file system.  Write operations will fail
                                | but this option can workaround faulty ``open()`` flags.
CVMFS_NFILES                    Maximum number of open file descriptors that can be used by the CernVM-FS process.
CVMFS_NFS_SOURCE                If set to *yes*, act as a source for the NFS daemon (NFS export).
CVMFS_NFS_SHARED                | If set a path, used to store the NFS maps in an SQlite database,
                                | instead of the usual LevelDB storage in the cache directory.
CVMFS_PAC_URLS                  Chain of URLs pointing to PAC files with HTTP proxy configuration information.
CVMFS_OOM_SCORE_ADJ             | Set the Linux kernel's out-of-memory killer priority
                                | for the CernVM-FS client [-1000 - 1000].
CVMFS_PROXY_RESET_AFTER         | Delay in seconds after which CernVM-FS will retry the primary proxy group
                                | in case of a fail-over to another group.
CVMFS_PROXY_TEMPLATE            Overwrite the default proxy template in Geo-API calls.  Only needed for debugging.
CVMFS_PUBLIC_KEY                Colon-separated list of repository signing keys.
CVMFS_QUOTA_LIMIT               Soft-limit of the cache in Megabyte.
CVMFS_RELOAD_SOCKETS            Directory of the sockets used by the CernVM-FS loader to trigger hotpatching/reloading.
CVMFS_REPOSITORIES              | Comma-separated list of fully qualified repository names
                                | that shall be mountable under /cvmfs.
CVMFS_REPOSITORY_DATE           | A timestamp in ISO format (e.g. ``2007-03-01T13:00:00Z``).
                                | Selects the repository state as of the given date.
CVMFS_REPOSITORY_TAG            Select a named repository snapshot that should be mounted instead of ``trunk``.
CVMFS_CONFIG_REPO_REQUIRED      If set to *yes*, no repository can be mounted unless the config repository is available.
CVMFS_ROOT_HASH                 Hash of the root file catalog, implies ``CVMFS_AUTO_UPDATE=no``.
CVMFS_SEND_INFO_HEADER          If set to *yes*, include the cvmfs path of downloaded data in HTTP headers.
CVMFS_SERVER_CACHE_MODE         Enable special cache semantics for a client used as a publisher's repository base line.
CVMFS_SERVER_URL                Semicolon-separated chain of Stratum~1 servers.
CVMFS_SHARED_CACHE              If set to *no*, makes a repository use an exclusive cache.
CVMFS_STRICT_MOUNT              If set to *yes*, mount only repositories that are listed in ``CVMFS_REPOSITORIES``.
CVMFS_SUID                      If set to *yes*, enable suid magic on the mounted repository. Requires mounting as root.
CVMFS_SYSLOG_FACILITY           | If set to a number between 0 and 7, uses the corresponding
                                | LOCAL$n$ facility for syslog messages.
CVMFS_SYSLOG_LEVEL              | If set to 1 or 2, sets the syslog level for CernVM-FS messages to
                                | LOG_DEBUG or LOG_INFO respectively.
CVMFS_SYSTEMD_NOKILL            | If set to *yes*, modify the command line to ``@vmfs2 ...`` in order to
                                | act as a systemd lowlevel storage manager.
CVMFS_TIMEOUT                   Timeout in seconds for HTTP requests with a proxy server.
CVMFS_TIMEOUT_DIRECT            Timeout in seconds for HTTP requests without a proxy server.
CVMFS_TRACEFILE                 If set, enables the tracer and trace file system calls to the given file.
CVMFS_USE_GEOAPI                Request order of Stratum 1 servers and fallback proxies via Geo-API.
CVMFS_USER                      Sets the ``gid`` and ``uid`` mount options. Don't touch or overwrite.
CVMFS_USYSLOG                   | All messages that normally are logged to syslog are re-directed to the given file.
                                | This file can grow up to 500kB and there is one step of log rotation.
                                | Required for $\mu$CernVM.
CVMFS_WORKSPACE                 Set the local directory for storing special files (defaults to the cache directory).
CVMFS_USE_SSL_SYSTEM_CA         | When connecting to an HTTPS endpoints,
                                | it will load the certificates provided by the system.
=============================== ========================================================================================


.. _apxsct_serverparameters:

Server parameters
-----------------

=================================== ====================================================================================
**Parameter**                       **Meaning**
=================================== ====================================================================================
CVMFS_AUFS_WARNING                  Set to *false* to silence AUFS kernel deadlock warning.
CVMFS_AUTO_GC                       Enables the automatic garbage collection on *publish* and *snapshot*
CVMFS_AUTO_GC_TIMESPAN              | Date-threshold for automatic garbage collection |br|
                                    | (For example: `3 days ago`, `1 week ago`, ...)
CVMFS_AUTO_GC_LAPSE                 | Frequency of auto garbage collection, only garbage collect if last GC is
                                    | before the given threshold (For example: `1 day ago`)
CVMFS_AUTO_REPAIR_MOUNTPOINT        Set to *true* to enable automatic recovery from bogus server mount states.
CVMFS_AUTO_TAG                      Creates a generic revision tag for each published revision (if set to *true*).
CVMFS_AUTO_TAG_TIMESPAN             | Date-threshold for automatic tags, after which auto tags get removed
                                    | (For example: `4 days ago`)
CVMFS_AUTOCATALOGS                  Enable/disable automatic catalog management using autocatalogs.
CVMFS_AUTOCATALOGS_MAX_WEIGHT       | Maximum number of entries in an autocatalog to be considered overflowed.
                                    | Default value: 100000 |br| (see also *CVMFS_AUTOCATALOGS*)
CVMFS_AUTOCATALOGS_MIN_WEIGHT       | Minimum number of entries in an autocatalog to be considered underflowed.
                                    | Default value: 1000 |br| (see also *CVMFS_AUTOCATALOGS*)
CVMFS_AVG_CHUNK_SIZE                | Desired Average size of a file chunk in bytes
                                    | (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_CATALOG_ALT_PATHS             | Enable/disable generation of catalog bootstrapping shortcuts during publishing.
                                    | (Useful when backend directory `/data` is not publicly accessible)
CVMFS_COMPRESSION_ALGORITHM         | Compression algorithm to be used during publishing
                                    | (currently either 'default' or 'none')
CVMFS_CREATOR_VERSION               | The CernVM-FS version that was used to create this repository
                                    | (do not change manually).
CVMFS_DONT_CHECK_OVERLAYFS_VERSION  | Disable checking of OverlayFS version before usage.
                                    | (see :ref:`sct_reporequirements`)
CVMFS_ENFORCE_LIMITS                | Set to *true* to cause exceeding \*LIMIT variables to be fatal to a publish
                                    | instead of a warning
CVMFS_EXTENDED_GC_STATS             | Set to *true* to keep track of the volume of garbage collected files (increases GC running time)
CVMFS_EXTERNAL_DATA                 | Set to *true* to mark repository to contain external data
                                    | that is served from an external HTTP server
CVMFS_FILE_MBYTE_LIMIT              | Maximum number of megabytes for a published file, default value: 1024
                                    | (see also *CVMFS_ENFORCE_LIMITS*)
CVMFS_FORCE_REMOUNT_WARNING         | Enable/disable warning through ``wall`` and grace period before forcefully
                                    | remounting a CernVM-FS repository on the release managere machine.
CVMFS_GARBAGE_COLLECTION            Enables repository garbage collection |br| (Stratum~0 only | if set to *true*)
CVMFS_GENERATE_LEGACY_BULK_CHUNKS   | Deprecated, set to *true* to enable generation of whole-file objects for large files.
CVMFS_GC_DELETION_LOG               | Log file path to track all garbage collected objects during sweeping
                                    | for bookkeeping or debugging
CVMFS_GEO_DB_FILE                   Path to externally updated location of geolite2 city database, or 'None' for no database.
CVMFS_GEO_LICENSE_KEY               A license key for downloading the geolite2 city database from maxmind.
CVMFS_GID_MAP                       Path of a file for the mapping of file owner group ids.
CVMFS_HASH_ALGORITHM                | Define which secure hash algorithm should be used by CernVM-FS for CAS objects
                                    | (supported are: *sha1*, *rmd160* and *shake128*)
CVMFS_IGNORE_SPECIAL_FILES          Set to *true* to skip special files during publish without aborting.
CVMFS_IGNORE_XDIR_HARDLINKS         | Deprecated, defaults to *true*
                                    | hardlinks are found. Instead automatically break the hardlinks across directories.
CVMFS_INCLUDE_XATTRS                Set to *true* to process extended attributes
CVMFS_MAX_CHUNK_SIZE                Maximal size of a file chunk in bytes (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_MAXIMAL_CONCURRENT_WRITES     Maximal number of concurrently processed files during publishing.
CVMFS_MIN_CHUNK_SIZE                Minimal size of a file chunk in bytes (see also *CVMFS_USE_FILE_CHUNKING*)
CVMFS_NESTED_KCATALOG_LIMIT         | Maximum thousands of files allowed in nested catalogs, default 500
                                    | (see also *CVMFS_ROOT_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*)
CVMFS_NUM_UPLOAD_TASKS              | Number of threads used to commit data to storage during publication.
                                    | Currently only used by the local backend.
CVMFS_NUM_WORKERS                   | Maximal number of concurrently downloaded files during a Stratum1 pull operation
                                    | (Stratum~1 only).
CVMFS_PUBLIC_KEY                    Colon-separated path to the public key file(s) or directory(ies) of the repository to be replicated. (Stratum 1 only).
CVMFS_PRINT_STATISTICS              | Set to *true* to show publisher statistics on the console
CVMFS_REPLICA_ACTIVE                | Stratum1-only: Set to *no* to skip this repository when executing
                                    | ``cvmfs_server snapshot -a``
CVMFS_REPOSITORY_NAME               The fully qualified name of the specific repository.
CVMFS_REPOSITORY_TYPE               Defines if the repository is a master copy (*stratum0*) or a replica (*stratum1*).
CVMFS_REPOSITORY_TTL                | The frequency in seconds of client lookups for changes in the repository.
                                    | Defaults to 4 minutes.
CVMFS_ROOT_KCATALOG_LIMIT           | Maximum thousands of files allowed in root catalogs, default 200
                                    | (see also *CVMFS_NESTED_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*
CVMFS_SNAPSHOT_GROUP                | Group name for subset of repositories used with ``cvmfs_server snapshot -a -g``.
                                    | Added with ``cvmfs_server add-replica -g``.
CVMFS_SPOOL_DIR                     | Location of the upstream spooler scratch directories;
                                    | the read-only CernVM-FS moint point and copy-on-write storage reside here.
CVMFS_STATISTICS_DB                 | Set a custom path for the publisher statistics database
CVMFS_STATS_DB_DAYS_TO_KEEP         | Sets the pruning interval for the publisher statistics database
CVMFS_STRATUM0                      URL of the master copy (*stratum0*) of this specific repository.
CVMFS_STRATUM1                      URL of the Stratum1 HTTP server for this specific repository.
CVMFS_SYNCFS_LEVEL                  | Controls how often ``sync`` will by called by ``cvmfs_server`` operations.
                                    | Possible levels are 'none', 'default', 'cautious'.
CVMFS_UID_MAP                       Path of a file for the mapping of file owner user ids.
CVMFS_UNION_DIR                     | Mount point of the union file system for copy-on-write semantics of CernVM-FS.
                                    | Here, changes to the repository are performed
                                    | (see :ref:`sct_repocreation_update`).
CVMFS_UNION_FS_TYPE                 | Defines the union file system to be used for the repository.
                                    | (currently `aufs` and `overlayfs` are fully supported)
CVMFS_UPLOAD_STATS_DB               | Publish repository statistics plots to the Stratum 0 /stats location
CVMFS_UPSTREAM_STORAGE              | Upstream spooler description defining the basic upstream storage type
                                    | and configuration (see below).
CVMFS_USE_FILE_CHUNKING             Allows backend to split big files into small chunks (*true* | *false*)
CVMFS_USER                          The user name that owns and manipulates the files inside the repository.
CVMFS_VIRTUAL_DIR                   | Set to *true* to enable the hidden, virtual ``.cvmfs/snapshots`` directory
                                    | containing entry points to all named tags.
CVMFS_VOMS_AUTHZ                    Membership requirement (e.g. VOMS authentication) to be added into the file catalogs
CVMFS_STATISTICS_DB                 | SQLite file path to store the statistics. Default is
                                    | ``/var/spool/cvmfs/<REPO_NAME>/stats.db`` .
CVMFS_PRINT_STATISTICS              Set to *true* to enable statistics printing to the standard output.
CVMFS_EXTENDED_GC_STATS             Set to *true* to count condemned bytes in the garbage collector process.
X509_CERT_BUNDLE                    Bundle file with CA certificates for HTTPS connections (see :ref:`sct_data`)
X509_CERT_DIR                       | Directory file with CA certificates for HTTPS connections,
                                    | defaults to /etc/grid-security/certificates (see :ref:`sct_data`)
=================================== ====================================================================================

Format of CVMFS_UPSTREAM_STORAGE
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The format of the ``CVMFS_UPSTREAM_STORAGE`` parameter depends on the storage backend.
Note that this parameter is initialized by ``cvmfs_server mkfs`` resp. ``cvmfs_server add-replica``.
The internals of the parameter are only relevant
if the configuration is maintained by a configuration management system.

For the local storage backend, the parameter specifies the storage directory (to be served by Apache)
and a temporary directory in the form ``local,<path for temporary files>,<path to storage>``, e.g.

::

    CVMFS_UPSTREAM_STORAGE=local,/srv/cvmfs/sw.cvmfs.io/data/txn,/srv/cvmfs/sw.cvmfs.io

For the S3 backend, the parameter specifies a temporary directory and the location of the S3 config file
in the form ``s3,<path for temporary files>,<repository entry URL on the S3 server>@<S3 config file>``, e.g.

::

    CVMFS_UPSTREAM_STORAGE=S3,/var/spool/cvmfs/sw.cvmfs.io/tmp,cvmfs/sw.cvmfs.io@/etc/cvmfs/s3.conf

The gateway backend can only be used on a remote publisher (not on a stratum 1).
The parameter specifies a temporary directory and the endpoint of the gateway service, e.g.

::

    CVMFS_UPSTREAM_STORAGE=gw,/var/spool/cvmfs/sw.cvmfs.io/tmp,http://cvmfs-gw.cvmfs.io:4929/api/v1


.. _apxsct_cacheparams:

Tiered Cache Parameters
-----------------------

The following parameters are used to configure a tiered cache manager instance.

=============================== =================================================
**Parameter**                   **Meaning**
=============================== =================================================
CVMFS_CACHE_$name_UPPER         Name of the upper layer cache instance
CVMFS_CACHE_$name_LOWER         Name of the lower layer cache instance
CVMFS_CACHE_LOWER_READONLY      Set to *true* to avoid populating the lower layer
=============================== =================================================


External Cache Plugin Parameters
--------------------------------

The following parameters are used to configure an external cache plugin as a
cache manager instance.

=============================== ========================================================================================
**Parameter**                   **Meaning**
=============================== ========================================================================================
CVMFS_CACHE_$name_CMDLINE       | If the client should start the plugin, the executable and command line
                                | parameters of the plugin, separated by comma.
CVMFS_CACHE_$name_LOCATOR       The address of the socket used for communication with the plugin.
=============================== ========================================================================================


In-memory Cache Plugin Parameters
---------------------------------

The following parameters are interpreted from the configuration file provided
to the in-memory cache plugin (see Section :ref:`sct_cache_advanced_example`).

=============================== ===================================================================================
**Parameter**                   **Meaning**
=============================== ===================================================================================
CVMFS_CACHE_PLUGIN_DEBUGLOG     If set, run CernVM-FS in debug mode and write a verbose log the the specified file.
CVMFS_CACHE_PLUGIN_LOCATOR      The address of the socket used for client communication
CVMFS_CACHE_PLUGIN_SIZE         The amount of RAM in megabyte used by the plugin for caching.
=============================== ===================================================================================
