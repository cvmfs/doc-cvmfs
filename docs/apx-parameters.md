# CernVM-FS Parameters
> <br />

## Client parameters
Parameters recognized in configuration files under /etc/cvmfs:

CVMFS_ALIEN_CACHE
: If set, use an alien cache at the given location

CVMFS_ALT_ROOT_PATH
: alternative root catalog path. catalogs (tag / hash) under the alternative path.  If set to *yes*, use Only required for fixed

CVMFS_ARCH
: reflect the CPU architecture on which the client runs (using `uname -m`). symlinks with cvmfs installations to auto-select the architecture.  Automatically set by CVMFs to Allows to utilize variant

CVMFS_AUTO_UPDATE
: If set to *no*, disables the automatic update of file catalogs.

CVMFS_AUTHZ_HELPER
: Full path to an authz helper, overwrites the helper hint in the catalog.

CVMFS_AUTHZ_SEARCH_PATH
: Full path to the directory that contains the authz helpers.

CVMFS_BACKOFF_INIT
: Seconds for the maximum initial backoff when retrying to download data.

CVMFS_BACKOFF_MAX
: Maximum backoff in seconds when retrying to download data.

CVMFS_BLACKLIST
: that denies mounting any revision < revision N. is the repository name, N is the revision number, separated by whitespace. allowed after N, not even whitespace.  File name of the blacklist Format: `<REPO N` where REPO and the two parts are Note: no extra characters are

CVMFS_CATALOG_WATERMARK
: when their number surpasses the given watermark. explicitly set by shrinkwrap.  Try to release pinned catalogs Defaults to 1/4 CVMFS_NFILES;

CVMFS_CACHE_ALIEN
: Deprecated, legacy parameter. Use `CVMFS_ALIEN_CACHE` instead.

CVMFS_CACHE_BASE
: Location (directory) of the CernVM-FS cache.

CVMFS_CACHE_DIR
: but automatically set by cvmfs. overwriting when using `libcvmfs`  Similar to `CVMFS_CACHE_BASE`, Only might need manual

CVMFS_CACHE_PRIMARY
: Type of cache to use. By default it is `posix`. (see also the [Advanced Cache Configuration](cpt-configure.md#advanced-cache-configuration) section)

CVMFS_CACHE_REFCOUNT
: If set to *yes*, deduplicate open file descriptors by refcounting.

CVMFS_CACHE\<name\>\_\<param\>
: Parameters used by advanced cache configuration for cache type `<name>`. Values for `<param>` can include e.g. `ALIEN`, `WORKSPACE`, `LOCATOR`, `TYPE`, and `CMDLINE`.  (see also the [Advanced Cache Configuration](cpt-configure.md#advanced-cache-configuration) section)


CVMFS_CACHE_SYMLINKS
: If set to *yes*, enables symlink caching in the kernel.

CVMFS_CHECK_PERMISSIONS
: If set to *no*, disable checking of file ownership and permissions (open all files).

CVMFS_CLAIM_OWNERSHIP
: If set to *yes*, allows CernVM-FS to claim ownership of files and directories.

CVMFS_CONFIG_REPOSITORY
: client will get its config from. `cvmfs-config-default` sets this parameter to `cvmfs-config.cern.ch`  CVMFS repository where a CVMFS The default configuration rpm

CVMFS_CPU_AFFINITY
: Comma-separated list to set CPU affinity for all `cvmfs` components.

CVMFS_DEBUGLOG
: If set, run CernVM-FS in debug mode and write a verbose log the the specified file.

CVMFS_DEFAULT_DOMAIN
: automatically appended to repository names  The default domain will be when given without a domain.

CVMFS_DNS_MIN_TTL
: seconds for DNS queries of proxy server names 1 minute.  Minimum effective TTL in (not Stratum 1s). Defaults to

CVMFS_DNS_MAX_TTL
: seconds for DNS queries of proxy server names 1 day.  Maximum effective TTL in (not Stratum 1s). Defaults to

CVMFS_DNS_RETRIES
: Number of retries when resolving proxy names

CVMFS_DNS_SERVER
: IP of the DNS server CVMFS should use.

CVMFS_DNS_TIMEOUT
: Timeout in seconds when resolving proxy names

CVMFS_DNS_ROAMING
: If true, watch /etc/resolv.conf for nameserver changes

CVMFS_ENFORCE_ACLS
: the repository. Requires libfuse 3.  Enforce POSIX ACLs stored in

CVMFS_EXTERNAL_FALLBACK_PROXY
: to `CVMFS_EXTERNAL_HTTP_PROXY`. to the end of the normal proxies, connections.  List of HTTP proxies similar The fallback proxies are added and disable DIRECT

CVMFS_EXTERNAL_HTTP_PROXY
: Chain of HTTP proxy groups to be used when CernVM-FS is accessing external data

CVMFS_EXTERNAL_MAX_SERVERS
: hosts to the given number (after geo-sorting them)  Caps the list of external

CVMFS_EXTERNAL_METALINK
: Semi-colon-separated chain of RFC6249-compliant servers to locate webservers serving external data.

CVMFS_EXTERNAL_TIMEOUT
: Timeout in seconds for HTTP requests to an external-data server with a proxy server

CVMFS_EXTERNAL_TIMEOUT_DIRECT
: Timeout in seconds for HTTP requests to an external-data server without a proxy server

CVMFS_EXTERNAL_URL
: Semicolon-separated chain of webservers serving external data chunks.

CVMFS_FALLBACK_PROXY
: to `CVMFS_HTTP_PROXY`. The fallback proxies are proxies, and disable DIRECT connections.  List of HTTP proxies similar added to the end of the normal

CVMFS_FUSE_NOTIFY_INVALIDATION
: invalidation. By default disabled on macOS to fix stability issues. recommended to turn it off.  Disable fuse notify On Linux systems, it is NOT

CVMFS_FUSE3_MAX_THREADS
: Set max number of fuse threads (requires: libfuse3 3.12)

CVMFS_FUSE3_IDLE_THREADS
: Set max number of idle fuse threads (requires: libfuse3 3.12)

CVMFS_FOLLOW_REDIRECTS
: When set to *yes*, follow up to 4 HTTP redirects in requests.

CVMFS_HIDE_MAGIC_XATTRS
: If set to *yes* the client will not expose CernVM-FS specific extended attributes

CVMFS_HOST_RESET_AFTER
: See `CVMFS_PROXY_RESET_AFTER`, for server URLs.

CVMFS_HTTP_PROXY
: used by CernVM-FS. Necessary. use proxies.  Chain of HTTP proxy groups Set to `DIRECT` if you don't

CVMFS_HTTP_TRACING
: Activates that a tracing header is attached to each CURL request. Consists of `uid`, `pid`, and `gid`. Default is `off`.

CVMFS_HTTP_TRACING_HEADERS
: Adds additional static, user-defined tracing headers. Format: `key1:val1 Needs `CVMFS_HTTP_TRACING` to be set to `on`.  key2:val2  key3:val3`.

CVMFS_IGNORE_SIGNATURE
: When set to *yes*, don't verify CernVM-FS file catalog signatures.

CVMFS_INITIAL_GENERATION
: Initial inode generation. Used for testing.

CVMFS_INSTRUMENT_FUSE
: performance statistics about the FUSE callbacks. `cvmfs_talk internal affairs`.  When set to *true* gather The results are displayed with

CVMFS_NFS_INTERLEAVED_INODES
: In NFS mode, use only inodes of the form an+b, specified as "b%a".

CVMFS_INFLUX_EXTRA_FIELDS
: Static fields always attached to the (absolute) output of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_EXTRA_TAGS
: Static tags always attached to the (absolute + delta) output of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_HOST
: Host name or IP address of the receiver of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_METRIC_NAME
: Name of the measurement of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_PORT
: Port of the host (receiver) of the InfluxDB Telemetry Aggregator

CVMFS_IPFAMILY_PREFER
: Which IP protocol to prefer when connecting to proxies. Can be either 4 or 6.

CVMFS_IPV4_ONLY
: If set to a non-empty value, CVMFS does not try to resolve IPv6 records.

CVMFS_KCACHE_TIMEOUT
: Timeout in seconds for path names and file attributes in the kernel file system buffers.

CVMFS_KEYS_DIR
: files used as repository signing keys. precedence over `CVMFS_PUBLIC_KEY`.  Directory containing \*.pub If set, this parameter has

CVMFS_LIBRARY_PATH
: Allows `cvmfs2` to discover libraries not installed in one of standard search paths.  For standalone deployment. `libcvmfs_<...>.so` that are

CVMFS_LOW_SPEED_LIMIT
: Minimum transfer rate in bytes/second a server or proxy must provide.

CVMFS_MAGIC_XATTRS_VISIBILITY
: attributes to be listed. Options: `always`, `never`, `rootonly`. listing can only be requested for `/cvmfs/<repo>`. For any other file, specific extended attribute will work.  Allows to hide extended `rootonly` means that the only a direct request to a

CVMFS_MAX_EXTERNAL_SERVERS
: sorted) stratum 1 servers for external data  Limit the number of (geo that are effectively used.

CVMFS_MAX_IPADDR_PER_PROXY
: addresses a proxy names resolves into. up to the limit are randomly selected.  Limit the number of IP From all registered addresses,

CVMFS_MAX_RETRIES
: Maximum number of retries for a given proxy/host combination.

CVMFS_MAX_SERVERS
: Limit the number of (geo sorted) stratum 1 servers that are effectively used.

CVMFS_MAX_TTL
: Maximum file catalog TTL in minutes. Can overwrite the TTL stored in the catalog.

CVMFS_MEMCACHE_SIZE
: Size of the CernVM-FS metadata memory cache in Megabytes.

CVMFS_MOUNT_DIR
: Directory where CernVM-FS is mounted to. Default is <code class="cvmfs-inline-path">/cvmfs</code> and cannot be overwritten.

CVMFS_METALINK_URL
: Semi-colon-separated chain of RFC6249-compliant servers to locate Stratum-1 servers.

CVMFS_METALINK_RESET_AFTER
: See `CVMFS_PROXY_RESET_AFTER`, for metalink servers.

CVMFS_MOUNT_RW
: read/write file system. Write operations will fail faulty `open()` flags.  Mount CernVM-FS as a but this option can workaround

CVMFS_NFILES
: Maximum number of open file descriptors that can be used by the CernVM-FS process.

CVMFS_NFS_SOURCE
: If set to *yes*, act as a source for the NFS daemon (NFS export).

CVMFS_NFS_SHARED
: the NFS maps in an SQlite database, storage in the cache directory.  If set a path, used to store instead of the usual LevelDB

CVMFS_PAC_URLS
: Chain of URLs pointing to PAC files with HTTP proxy configuration information.

CVMFS_OOM_SCORE_ADJ
: out-of-memory killer priority \[-1000 - 1000\].  Set the Linux kernel's for the CernVM-FS client

CVMFS_PROXY_RESET_AFTER
: CernVM-FS will retry the primary proxy group another group.  Delay in seconds after which in case of a fail-over to

CVMFS_PROXY_SHARD
: requests across all proxies within the current consistent hashing.  If set to *yes*, shard load-balancing group using

CVMFS_PROXY_TEMPLATE
: Overwrite the default proxy template in Geo-API calls. Only needed for debugging.

CVMFS_PUBLIC_KEY
: Colon-separated list of repository signing keys.

CVMFS_QUOTA_LIMIT
: Soft-limit of the cache in Megabyte.

CVMFS_RELOAD_SOCKETS
: Directory of the sockets used by the CernVM-FS loader to trigger hotpatching/reloading.

CVMFS_REPOSITORIES
: qualified repository names utilities such as `cvmfs_talk` and `cvmfs_config`. repositories may be mounted, unless `CVMFS_STRICT_MOUNT` is  Comma-separated list of fully to include in use of client Does not limit which set to *yes*.

CVMFS_REPOSITORY_DATE
: (e.g. `2007-03-01T13:00:00Z`). as of the given date.  A timestamp in ISO format Selects the repository state

CVMFS_REPOSITORY_TAG
: Select a named repository snapshot that should be mounted instead of `trunk`.

CVMFS_CONFIG_REPO_REQUIRED
: If set to *yes*, no repository can be mounted unless the config repository is available.

CVMFS_ROOT_HASH
: Hash of the root file catalog, implies `CVMFS_AUTO_UPDATE=no`.

CVMFS_SEND_INFO_HEADER
: If set to *yes*, include the cvmfs path of downloaded data in HTTP headers.

CVMFS_SERVER_CACHE_MODE
: Enable special cache semantics for a client used as a publisher's repository base line.

CVMFS_SERVER_URL
: Semicolon-separated chain of Stratum\~1 servers.

CVMFS_SHARED_CACHE
: If set to *no*, makes a repository use an exclusive cache.

CVMFS_STATFS_CACHE_TIMEOUT
: seconds (no caching by default). frequency can be expensive.  Caching time of `statfs()` in Calling `statfs()` in high

CVMFS_STREAMING_CACHE
: If set to *yes*, use a download manager to download regular files on read.

CVMFS_STRICT_MOUNT
: If set to *yes*, mount only repositories that are listed in `CVMFS_REPOSITORIES`.

CVMFS_SUID
: If set to *yes*, enable suid magic on the mounted repository. Requires mounting as root.

CVMFS_SYSLOG_FACILITY
: and 7, uses the corresponding messages.  If set to a number between 0 and 7, uses the corresponding LOCALn facility for syslog

CVMFS_SYSLOG_LEVEL
: syslog level for CernVM-FS messages to respectively.  If set to 1 or 2, sets the LOG_DEBUG or LOG_INFO

CVMFS_SYSLOG_PREFIX
: Prefix for each CVMFS message in the syslog. By default it is the repo name.

CVMFS_SYSTEMD_NOKILL
: command line to `@vmfs2 ...` in order to storage manager.  If set to *yes*, modify the act as a systemd lowlevel

CVMFS_TALK_SOCKET
: Internal usage. Used for `cvmfs_talk`. Default socket is `/v ar/spool/cvmfs/<repo>/cvmfs_io`.

CVMFS_TALK_OWNER
: Internal usage. Used for `cvmfs_talk`. By default it is the repo owner.

CVMFS_TELEMETRY_RATE
: Rate in seconds for Telemetry Aggregator to send the telemetry. Minimum send rate >= 5 sec.

CVMFS_TELEMETRY_SEND
: `ON` to activate Telemetry Aggregator.

CVMFS_TIMEOUT
: Timeout in seconds for HTTP requests with a proxy server.

CVMFS_TIMEOUT_DIRECT
: Timeout in seconds for HTTP requests without a proxy server.

CVMFS_TRACEBUFFER
: Internal usage. Max number of entries of the tracebuffer.

CVMFS_TRACEBUFFER_THRESHOLD
: Internal usage. Flush treshold after how many entries the tracebuffer is flushed to file.

CVMFS_TRACEFILE
: If set, enables the tracer and trace file system calls to the given file.

CVMFS_USE_GEOAPI
: Request order of Stratum 1 servers and fallback proxies via Geo-API.

CVMFS_USE_SSL_SYSTEM_CA
: endpoints, provided by the system.  When connecting to an HTTPS it will load the certificates

CVMFS_USER
: Sets the `gid` and `uid` mount options. Don't touch or overwrite.

CVMFS_USYSLOG
: logged to syslog are re-directed to the given file. and there is one step of log rotation.  All messages that normally are This file can grow up to 500kB Required for muCernVM.

CVMFS_XATTR_PRIVILEGED_GIDS
: Comma-separated list of (main) group IDs that are allowed to access the extended attributes listed by `CVMFS_XATTR_PROTECTED_XATTRS`.

CVMFS_XATTR_PROTECTED_XATTRS
: Comma-separated list of extended attributes (full name, e.g. `user.fqrn`) that are only accessible by `root` and the group IDs listed by `CVMFS_XATTR_PRIVILEGED_GIDS`.

CVMFS_WORKSPACE
: Set the local directory for storing special files (defaults to the cache directory).

CVMFS_WORLD_READABLE
: Override posix read permissions to make files in repository globally readable

## Server parameters
CVMFS_AUFS_WARNING
: Set to *false* to silence AUFS kernel deadlock warning.

CVMFS_AUTO_GC
: Enables the automatic garbage collection on *publish* and *snapshot*

CVMFS_AUTO_GC_TIMESPAN
: garbage collection ago]{.title-ref}, [1 week ago]{.title-ref}, \...)  Date-threshold for automatic (For example: [3 days

CVMFS_AUTO_GC_LAPSE
: collection, only garbage collect if last GC is (For example: [1 day ago]{.title-ref})  Frequency of auto garbage before the given threshold

CVMFS_AUTO_REPAIR_MOUNTPOINT
: Set to *true* to enable automatic recovery from bogus server mount states.

CVMFS_AUTO_TAG
: Creates a generic revision tag for each published revision (if set to *true*).

CVMFS_AUTO_TAG_TIMESPAN
: tags, after which auto tags get removed ago]{.title-ref})  Date-threshold for automatic (For example: [4 days

CVMFS_AUTOCATALOGS
: Enable/disable automatic catalog management using autocatalogs.

CVMFS_AUTOCATALOGS_MAX_WEIGHT
: an autocatalog to be considered overflowed. also *CVMFS_AUTOCATALOGS*)  Maximum number of entries in Default value: 100000 (see

CVMFS_AUTOCATALOGS_MIN_WEIGHT
: an autocatalog to be considered underflowed. *CVMFS_AUTOCATALOGS*)  Minimum number of entries in Default value: 1000 (see also

CVMFS_AVG_CHUNK_SIZE
: chunk in bytes *CVMFS_USE_FILE_CHUNKING*)  Desired Average size of a file (see also

CVMFS_CATALOG_ALT_PATHS
: catalog bootstrapping shortcuts during publishing. [/data]{.title-ref} is not publicly accessible)  Enable/disable generation of (Useful when backend directory

CVMFS_CHECK_ALL_MIN_DAYS
: checking each repository with `cvmfs_server check -a`  Minimum number of days between Default value: 30

CVMFS_COMPRESSION_ALGORITHM
: used during publishing or 'none')  Compression algorithm to be (currently either 'default'

CVMFS_CREATOR_VERSION
: used to create this repository  The CernVM-FS version that was (do not change manually).

CV MFS_DONT_CHECK_OVERLAYFS_VERSION
: Disable checking of OverlayFS version before usage.

CVMFS_ENABLE_MTIME_NS
: Use nanosecond-granularity for modification time of files (instead of milliseconds)

CVMFS_ENFORCE_LIMITS
: exceeding \*LIMIT variables to be fatal to a publish  Set to *true* to cause instead of a warning

CVMFS_EXTENDED_GC_STATS
: the volume of garbage collected files (increases GC running time)  Set to *true* to keep track of

CVMFS_EXTERNAL_DATA
: repository to contain external data external HTTP server  Set to *true* to mark that is served from an

CVMFS_FILE_MBYTE_LIMIT
: for a published file, default value: 1024 *CVMFS_ENFORCE_LIMITS*)  Maximum number of megabytes (see also

CVMFS_FORCE_REMOUNT_WARNING
: `wall` and grace period before forcefully repository on the release managere machine.  Enable/disable warning through remounting a CernVM-FS

CVMFS_GARBAGE_COLLECTION
: Enables repository garbage collection (Stratum\~0 only \ if set to *true*)

CVMFS_GC_DELETION_LOG
: garbage collected objects during sweeping  Log file path to track all for bookkeeping or debugging

CVMFS_GEO_DB_FILE
: Path to externally updated location of geolite2 city database, or 'None' for no database.

CVMFS_GEO_LICENSE_KEY
: A license key for downloading the geolite2 city database from maxmind.

CVMFS_GID_MAP
: Path of a file for the mapping of file owner group ids.

CVMFS_HASH_ALGORITHM
: algorithm should be used by CernVM-FS for CAS objects *rmd160* and *shake128*)  Define which secure hash (supported are: *sha1*,

CVMFS_IGNORE_SPECIAL_FILES
: Set to *true* to skip special files (pipes, sockets, block device and character device files) during publish without aborting.

CVMFS_INCLUDE_XATTRS
: Set to *true* to process extended attributes

CVMFS_MAX_CHUNK_SIZE
: Maximal size of a file chunk in bytes (see also *CVMFS_USE_FILE_CHUNKING*)

CVMFS_MAXIMAL_CONCURRENT_WRITES
: Maximal number of concurrently processed files during publishing.

CVMFS_MIN_CHUNK_SIZE
: Minimal size of a file chunk in bytes (see also *CVMFS_USE_FILE_CHUNKING*)

CVMFS_NESTED_KCATALOG_LIMIT
: allowed in nested catalogs, default 500 *CVMFS_ROOT_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*)  Maximum thousands of files (see also

CVMFS_NUM_UPLOAD_TASKS
: commit data to storage during publication. local backend.  Number of threads used to Currently only used by the

CVMFS_NUM_WORKERS
: downloaded files during a Stratum1 pull operation  Maximal number of concurrently (Stratum\~1 only).

CVMFS_PUBLIC_KEY
: Colon-separated path to the public key file(s) or directory(ies) of the repository to be replicated. (Stratum 1 only).

CVMFS_PRINT_STATISTICS
: publisher statistics on the console  Set to *true* to show

CVMFS_REPLICA_ACTIVE
: skip this repository when executing  Stratum1-only: Set to *no* to `cvmfs_server snapshot -a`

CVMFS_REPOSITORY_NAME
: The fully qualified name of the specific repository.

CVMFS_REPOSITORY_TYPE
: Defines if the repository is a master copy (*stratum0*) or a replica (*stratum1*).

CVMFS_REPOSITORY_TTL
: client lookups for changes in the repository.  The frequency in seconds of Defaults to 4 minutes.

CVMFS_ROOT_KCATALOG_LIMIT
: allowed in root catalogs, default 200 *CVMFS_NESTED_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*)  Maximum thousands of files (see also

CVMFS_SNAPSHOT_GROUP
: repositories used with `cvmfs_server snapshot -a -g`. `cvmfs_server add-replica -g`.  Group name for subset of Added with

CVMFS_SPOOL_DIR
: spooler scratch directories; point and copy-on-write storage reside here.  Location of the upstream the read-only CernVM-FS moint

CVMFS_STATISTICS_DB
: publisher statistics database  Set a custom path for the

CVMFS_STATS_DB_DAYS_TO_KEEP
: the publisher statistics database (365 by default)  Sets the pruning interval for

CVMFS_STRATUM0
: URL of the master copy (*stratum0*) of this specific repository.

CVMFS_STRATUM1
: URL of the Stratum1 HTTP server for this specific repository.

CVMFS_SYNCFS_LEVEL
: by called by `cvmfs_server` operations. 'default', 'cautious'.  Controls how often `sync` will Possible levels are 'none',

[CVMFS_S3]()<param>
: S3-related parameters. See the S3 parameter table.

CVMFS_UID_MAP
: Path of a file for the mapping of file owner user ids.

CVMFS_UNION_DIR
: Mount point of the union file system for copy-on-write semantics of CernVM-FS. Here, changes to the repository are performed.

CVMFS_UNION_FS_TYPE
: to be used for the repository. supported, `aufs` has no active support anymore)  Defines the union file system (only `overlayfs` is fully

CVMFS_UPLOAD_STATS_DB
: data file to the Stratum 0 /stats location  Publish repository statistics

CVMFS_UPLOAD_STATS_PLOTS
: plots and webpage to the Stratum 0 /stats location (requires ROOT)  Publish repository statistics

CVMFS_UPSTREAM_STORAGE
: defining the basic upstream storage type  Upstream spooler description and configuration (see below).

CVMFS_USE_FILE_CHUNKING
: Allows backend to split big files into small chunks (*true* \  *false*)

CVMFS_USER
: The user name that owns and manipulates the files inside the repository.

CVMFS_VIRTUAL_DIR
: hidden, virtual `.cvmfs/snapshots` directory named tags.  Set to *true* to enable the containing entry points to all

CVMFS_VOMS_AUTHZ
: Membership requirement (e.g. VOMS authentication) to be added into the file catalogs

CVMFS_STATISTICS_DB
: statistics. Default is pool/cvmfs/<REPO_NAME>/stats.db` .  SQLite file path to store the `/var/s

CVMFS_PRINT_STATISTICS
: Set to *true* to enable statistics printing to the standard output.

X509_CERT_BUNDLE
: Bundle file with CA certificates for HTTPS connections.

X509_CERT_DIR
: Directory file with CA certificates for HTTPS connections, defaults to `/etc/grid-security/certificates`.

### Deprecated parameters

Will be removed in future versions.

C VMFS_GENERATE_LEGACY_BULK_CHUNKS
: enable generation of whole-file objects for large files.  Deprecated, set to *true* to

CVMFS_IGNORE_XDIR_HARDLINKS
: automatically break the hardlinks across directories.  Deprecated, defaults to *true* hardlinks are found. Instead

### Format of CVMFS_UPSTREAM_STORAGE

The format of the `CVMFS_UPSTREAM_STORAGE` parameter depends on the
storage backend. Note that this parameter is initialized by
`cvmfs_server mkfs` resp. `cvmfs_server add-replica`. The internals of
the parameter are only relevant if the configuration is maintained by a
configuration management system.

For the local storage backend, the parameter specifies the storage
directory (to be served by Apache) and a temporary directory in the form
`local,<path for temporary files>,<path to storage>`, e.g.

    CVMFS_UPSTREAM_STORAGE=local,/srv/cvmfs/sw.cvmfs.io/data/txn,/srv/cvmfs/sw.cvmfs.io

For the S3 backend, the parameter specifies a temporary directory and
the location of the S3 config file in the form
`s3,<path for temporary files>,<repository entry URL on the S3 server>@<S3 config file>`,
e.g.

    CVMFS_UPSTREAM_STORAGE=S3,/var/spool/cvmfs/sw.cvmfs.io/tmp,cvmfs/sw.cvmfs.io@/etc/cvmfs/s3.conf

The gateway backend can only be used on a remote publisher (not on a
stratum 1). The parameter specifies a temporary directory and the
endpoint of the gateway service, e.g.

    CVMFS_UPSTREAM_STORAGE=gw,/var/spool/cvmfs/sw.cvmfs.io/tmp,http://cvmfs-gw.cvmfs.io:4929/api/v1

## Tiered Cache Parameters
The following parameters are used to configure a tiered cache manager
instance.

[CVMFS_CACHE]()\$name_UPPER
: Name of the upper layer cache instance

[CVMFS_CACHE]()\$name_LOWER
: Name of the lower layer cache instance

CVMFS_CACHE_LOWER_READONLY
: Set to *true* to avoid populating the lower layer

## External Cache Plugin Parameters

The following parameters are used to configure an external cache plugin
as a cache manager instance.

[CVMFS_CACHE]()\$name_CMDLINE
: plugin, the executable and command line separated by comma.  If the client should start the parameters of the plugin,

[CVMFS_CACHE]()\$name_LOCATOR
: The address of the socket used for communication with the plugin.

## In-memory Cache Plugin Parameters

The following parameters are interpreted from the configuration file
provided to the in-memory cache plugin (see the [Advanced Cache
Configuration](cpt-configure.md#advanced-cache-configuration) section).

CVMFS_CACHE_PLUGIN_DEBUGLOG
: If set, run CernVM-FS in debug mode and write a verbose log the the specified file.

CVMFS_CACHE_PLUGIN_LOCATOR
: The address of the socket used for client communication

CVMFS_CACHE_PLUGIN_SIZE
: The amount of RAM in megabyte used by the plugin for caching.
