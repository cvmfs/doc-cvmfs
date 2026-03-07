# CernVM-FS Parameters
> <br />

## Client parameters
Parameters recognized in configuration files under /etc/cvmfs:

CVMFS_ALIEN_CACHE { #cvmfs_alien_cache }
: If set, use an alien cache at the given location

CVMFS_ALT_ROOT_PATH { #cvmfs_alt_root_path }
: If set to *yes*, use alternative root catalog path. Only required for fixed catalogs (tag / hash) under the alternative path.

CVMFS_ARCH { #cvmfs_arch }
: Automatically set by CVMFS to reflect the CPU architecture on which the client runs (using `uname -m`). Allows to utilize variant symlinks with `cvmfs` installations to auto-select the architecture.

CVMFS_AUTO_UPDATE { #cvmfs_auto_update }
: If set to *no*, disables the automatic update of file catalogs.

CVMFS_AUTHZ_HELPER { #cvmfs_authz_helper }
: Full path to an authz helper, overwrites the helper hint in the catalog.

CVMFS_AUTHZ_SEARCH_PATH { #cvmfs_authz_search_path }
: Full path to the directory that contains the authz helpers.

CVMFS_BACKOFF_INIT { #cvmfs_backoff_init }
: Seconds for the maximum initial backoff when retrying to download data.

CVMFS_BACKOFF_MAX { #cvmfs_backoff_max }
: Maximum backoff in seconds when retrying to download data.

CVMFS_BLACKLIST { #cvmfs_blacklist }
: File name of the blacklist that denies mounting any revision < revision N. Format: `<REPO N` where REPO is the repository name, N is the revision number, and the two parts are separated by whitespace. Note: no extra characters are allowed after N, not even whitespace.

CVMFS_CATALOG_WATERMARK { #cvmfs_catalog_watermark }
: Try to release pinned catalogs when their number surpasses the given watermark. Defaults to 1/4 `CVMFS_NFILES`; explicitly set by shrinkwrap.

CVMFS_CACHE_ALIEN { #cvmfs_cache_alien }
: Deprecated, legacy parameter. Use `CVMFS_ALIEN_CACHE` instead.

CVMFS_CACHE_BASE { #cvmfs_cache_base }
: Location (directory) of the CernVM-FS cache.

CVMFS_CACHE_DIR { #cvmfs_cache_dir }
: Similar to `CVMFS_CACHE_BASE`, but automatically set by `cvmfs`. Only might need manual overwriting when using `libcvmfs`.

CVMFS_CACHE_PRIMARY { #cvmfs_cache_primary }
: Type of cache to use. By default it is `posix`. (see also the [Advanced Cache Configuration](cpt-configure.md#advanced-cache-configuration) section)

CVMFS_CACHE_REFCOUNT { #cvmfs_cache_refcount }
: If set to *yes*, deduplicate open file descriptors by refcounting.

CVMFS_CACHE\<name\>\_\<param\> { #cvmfs_cache_name_param }
: Parameters used by advanced cache configuration for cache type `<name>`. Values for `<param>` can include e.g. `ALIEN`, `WORKSPACE`, `LOCATOR`, `TYPE`, and `CMDLINE`.  (see also the [Advanced Cache Configuration](cpt-configure.md#advanced-cache-configuration) section)


CVMFS_CACHE_SYMLINKS { #cvmfs_cache_symlinks }
: If set to *yes*, enables symlink caching in the kernel.

CVMFS_CHECK_PERMISSIONS { #cvmfs_check_permissions }
: If set to *no*, disable checking of file ownership and permissions (open all files).

CVMFS_CLAIM_OWNERSHIP { #cvmfs_claim_ownership }
: If set to *yes*, allows CernVM-FS to claim ownership of files and directories.

CVMFS_CONFIG_REPOSITORY { #cvmfs_config_repository }
: CVMFS repository where a CVMFS client will get its config from. The default configuration rpm `cvmfs-config-default` sets this parameter to `cvmfs-config.cern.ch`.

CVMFS_CPU_AFFINITY { #cvmfs_cpu_affinity }
: Comma-separated list to set CPU affinity for all `cvmfs` components.

CVMFS_DEBUGLOG { #cvmfs_debuglog }
: If set, run CernVM-FS in debug mode and write a verbose log the the specified file.

CVMFS_DEFAULT_DOMAIN { #cvmfs_default_domain }
: The default domain will be automatically appended to repository names when given without a domain.

CVMFS_DNS_MIN_TTL { #cvmfs_dns_min_ttl }
: Minimum effective TTL in seconds for DNS queries of proxy server names (not Stratum 1s). Defaults to 1 minute.

CVMFS_DNS_MAX_TTL { #cvmfs_dns_max_ttl }
: Maximum effective TTL in seconds for DNS queries of proxy server names (not Stratum 1s). Defaults to 1 day.

CVMFS_DNS_RETRIES { #cvmfs_dns_retries }
: Number of retries when resolving proxy names

CVMFS_DNS_SERVER { #cvmfs_dns_server }
: IP of the DNS server CVMFS should use.

CVMFS_DNS_TIMEOUT { #cvmfs_dns_timeout }
: Timeout in seconds when resolving proxy names

CVMFS_DNS_ROAMING { #cvmfs_dns_roaming }
: If true, watch /etc/resolv.conf for nameserver changes

CVMFS_ENFORCE_ACLS { #cvmfs_enforce_acls }
: Enforce POSIX ACLs stored in the repository. Requires `libfuse` 3.

CVMFS_EXTERNAL_FALLBACK_PROXY { #cvmfs_external_fallback_proxy }
: List of HTTP proxies similar to `CVMFS_EXTERNAL_HTTP_PROXY`. The fallback proxies are added to the end of the normal proxies, and disable DIRECT connections.

CVMFS_EXTERNAL_HTTP_PROXY { #cvmfs_external_http_proxy }
: Chain of HTTP proxy groups to be used when CernVM-FS is accessing external data

CVMFS_EXTERNAL_MAX_SERVERS { #cvmfs_external_max_servers }
: Caps the list of external hosts to the given number (after geo-sorting them)

CVMFS_EXTERNAL_METALINK { #cvmfs_external_metalink }
: Semi-colon-separated chain of RFC6249-compliant servers to locate webservers serving external data.

CVMFS_EXTERNAL_TIMEOUT { #cvmfs_external_timeout }
: Timeout in seconds for HTTP requests to an external-data server with a proxy server

CVMFS_EXTERNAL_TIMEOUT_DIRECT { #cvmfs_external_timeout_direct }
: Timeout in seconds for HTTP requests to an external-data server without a proxy server

CVMFS_EXTERNAL_URL { #cvmfs_external_url }
: Semicolon-separated chain of webservers serving external data chunks.

CVMFS_FALLBACK_PROXY { #cvmfs_fallback_proxy }
: List of HTTP proxies similar to `CVMFS_HTTP_PROXY`. The fallback proxies are added to the end of the normal proxies, and disable DIRECT connections.

CVMFS_FUSE_NOTIFY_INVALIDATION { #cvmfs_fuse_notify_invalidation }
: Disable fuse notify invalidation. By default disabled on macOS to fix stability issues. On Linux systems, it is NOT recommended to turn it off.

CVMFS_FUSE3_MAX_THREADS { #cvmfs_fuse3_max_threads }
: Set max number of fuse threads (requires: libfuse3 > 3.12)

CVMFS_FUSE3_IDLE_THREADS { #cvmfs_fuse3_idle_threads }
: Set max number of idle fuse threads (requires: libfuse3 > 3.12)

CVMFS_FOLLOW_REDIRECTS { #cvmfs_follow_redirects }
: When set to *yes*, follow up to 4 HTTP redirects in requests.

CVMFS_HIDE_MAGIC_XATTRS { #cvmfs_hide_magic_xattrs }
: If set to *yes* the client will not expose CernVM-FS specific extended attributes

CVMFS_HOST_RESET_AFTER { #cvmfs_host_reset_after }
: See `CVMFS_PROXY_RESET_AFTER`, for server URLs.

CVMFS_HTTP_PROXY { #cvmfs_http_proxy }
: Chain of HTTP proxy groups used by CernVM-FS. Necessary. Set to `DIRECT` if you don't use proxies.

CVMFS_HTTP_TRACING { #cvmfs_http_tracing }
: Activates that a tracing header is attached to each CURL request. Consists of `uid`, `pid`, and `gid`. Default is `off`.

CVMFS_HTTP_TRACING_HEADERS { #cvmfs_http_tracing_headers }
: Adds additional static, user-defined tracing headers. Format: `key1:val1|key2:val2|key3:val3`. Needs `CVMFS_HTTP_TRACING` to be set to `on`.

CVMFS_IGNORE_SIGNATURE { #cvmfs_ignore_signature }
: When set to *yes*, don't verify CernVM-FS file catalog signatures.

CVMFS_INITIAL_GENERATION { #cvmfs_initial_generation }
: Initial inode generation. Used for testing.

CVMFS_INSTRUMENT_FUSE { #cvmfs_instrument_fuse }
: When set to *true* gather performance statistics about the FUSE callbacks. The results are displayed with `cvmfs_talk internal affairs`.

CVMFS_NFS_INTERLEAVED_INODES { #cvmfs_nfs_interleaved_inodes }
: In NFS mode, use only inodes of the form an+b, specified as "b%a".

CVMFS_INFLUX_EXTRA_FIELDS { #cvmfs_influx_extra_fields }
: Static fields always attached to the (absolute) output of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_EXTRA_TAGS { #cvmfs_influx_extra_tags }
: Static tags always attached to the (absolute + delta) output of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_HOST { #cvmfs_influx_host }
: Host name or IP address of the receiver of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_METRIC_NAME { #cvmfs_influx_metric_name }
: Name of the measurement of the InfluxDB Telemetry Aggregator

CVMFS_INFLUX_PORT { #cvmfs_influx_port }
: Port of the host (receiver) of the InfluxDB Telemetry Aggregator

CVMFS_IPFAMILY_PREFER { #cvmfs_ipfamily_prefer }
: Which IP protocol to prefer when connecting to proxies. Can be either 4 or 6.

CVMFS_IPV4_ONLY { #cvmfs_ipv4_only }
: If set to a non-empty value, CVMFS does not try to resolve IPv6 records.

CVMFS_KCACHE_TIMEOUT { #cvmfs_kcache_timeout }
: Timeout in seconds for path names and file attributes in the kernel file system buffers.

CVMFS_KEYS_DIR { #cvmfs_keys_dir }
: Directory containing \*.pub files used as repository signing keys. If set, this parameter has precedence over `CVMFS_PUBLIC_KEY`.

CVMFS_LIBRARY_PATH { #cvmfs_library_path }
: For standalone deployment. Allows `cvmfs2` to discover libraries `libcvmfs_<...>.so` that are not installed in one of standard search paths.

CVMFS_LOW_SPEED_LIMIT { #cvmfs_low_speed_limit }
: Minimum transfer rate in bytes/second a server or proxy must provide.

CVMFS_MAGIC_XATTRS_VISIBILITY { #cvmfs_magic_xattrs_visibility }
: Allows to hide extended attributes to be listed. Options: `always`, `never`, `rootonly`. `rootonly` means that the listing can only be requested for `/cvmfs/<repo>`. For any other file, only a direct request to a specific extended attribute will work.

CVMFS_MAX_EXTERNAL_SERVERS { #cvmfs_max_external_servers }
: Limit the number of (geo sorted) stratum 1 servers for external data that are effectively used.

CVMFS_MAX_IPADDR_PER_PROXY { #cvmfs_max_ipaddr_per_proxy }
: Limit the number of IP addresses a proxy names resolves into. From all registered addresses, up to the limit are randomly selected.

CVMFS_MAX_RETRIES { #cvmfs_max_retries }
: Maximum number of retries for a given proxy/host combination.

CVMFS_MAX_SERVERS { #cvmfs_max_servers }
: Limit the number of (geo sorted) stratum 1 servers that are effectively used.

CVMFS_MAX_TTL { #cvmfs_max_ttl }
: Maximum file catalog TTL in minutes. Can overwrite the TTL stored in the catalog.

CVMFS_MEMCACHE_SIZE { #cvmfs_memcache_size }
: Size of the CernVM-FS metadata memory cache in Megabytes.

CVMFS_MOUNT_DIR { #cvmfs_mount_dir }
: Directory where CernVM-FS is mounted to. Default is <code class="cvmfs-inline-path">/cvmfs</code> and cannot be overwritten.

CVMFS_METALINK_URL { #cvmfs_metalink_url }
: Semi-colon-separated chain of RFC6249-compliant servers to locate Stratum-1 servers.

CVMFS_METALINK_RESET_AFTER { #cvmfs_metalink_reset_after }
: See `CVMFS_PROXY_RESET_AFTER`, for metalink servers.

CVMFS_MOUNT_RW { #cvmfs_mount_rw }
: Mount CernVM-FS as a read/write file system. Write operations will fail but this option can workaround faulty `open()` flags.

CVMFS_NFILES { #cvmfs_nfiles }
: Maximum number of open file descriptors that can be used by the CernVM-FS process.

CVMFS_NFS_SOURCE { #cvmfs_nfs_source }
: If set to *yes*, act as a source for the NFS daemon (NFS export).

CVMFS_NFS_SHARED { #cvmfs_nfs_shared }
: If set a path, used to store the NFS maps in an SQLite database, instead of the usual LevelDB storage in the cache directory.

CVMFS_PAC_URLS { #cvmfs_pac_urls }
: Chain of URLs pointing to PAC files with HTTP proxy configuration information.

CVMFS_OOM_SCORE_ADJ { #cvmfs_oom_score_adj }
: Set the Linux kernel's out-of-memory killer priority for the CernVM-FS client [-1000 - 1000].

CVMFS_PROXY_RESET_AFTER { #cvmfs_proxy_reset_after }
: Delay in seconds after which CernVM-FS will retry the primary proxy group in case of a fail-over to another group.

CVMFS_PROXY_SHARD { #cvmfs_proxy_shard }
: If set to *yes*, shard requests across all proxies within the current load-balancing group using consistent hashing.

CVMFS_PROXY_TEMPLATE { #cvmfs_proxy_template }
: Overwrite the default proxy template in Geo-API calls. Only needed for debugging.

CVMFS_PUBLIC_KEY { #cvmfs_public_key }
: Colon-separated list of repository signing keys.

CVMFS_QUOTA_LIMIT { #cvmfs_quota_limit }
: Soft-limit of the cache in Megabyte.

CVMFS_RELOAD_SOCKETS { #cvmfs_reload_sockets }
: Directory of the sockets used by the CernVM-FS loader to trigger hotpatching/reloading.

CVMFS_REPOSITORIES { #cvmfs_repositories }
: Comma-separated list of fully qualified repository names to include in use of client utilities such as `cvmfs_talk` and `cvmfs_config`. Does not limit which repositories may be mounted, unless `CVMFS_STRICT_MOUNT` is set to *yes*.

CVMFS_REPOSITORY_DATE { #cvmfs_repository_date }
: A timestamp in ISO format (e.g. `2007-03-01T13:00:00Z`). Selects the repository state as of the given date.

CVMFS_REPOSITORY_TAG { #cvmfs_repository_tag }
: Select a named repository snapshot that should be mounted instead of `trunk`.

CVMFS_CONFIG_REPO_REQUIRED { #cvmfs_config_repo_required }
: If set to *yes*, no repository can be mounted unless the config repository is available.

CVMFS_ROOT_HASH { #cvmfs_root_hash }
: Hash of the root file catalog, implies `CVMFS_AUTO_UPDATE=no`.

CVMFS_SEND_INFO_HEADER { #cvmfs_send_info_header }
: If set to *yes*, include the cvmfs path of downloaded data in HTTP headers.

CVMFS_SERVER_CACHE_MODE { #cvmfs_server_cache_mode }
: Enable special cache semantics for a client used as a publisher's repository base line.

CVMFS_SERVER_URL { #cvmfs_server_url }
: Semicolon-separated chain of Stratum\~1 servers.

CVMFS_SHARED_CACHE { #cvmfs_shared_cache }
: If set to *no*, makes a repository use an exclusive cache.

CVMFS_STATFS_CACHE_TIMEOUT { #cvmfs_statfs_cache_timeout }
: Caching time of `statfs()` in seconds (no caching by default). Calling `statfs()` in high frequency can be expensive.

CVMFS_STREAMING_CACHE { #cvmfs_streaming_cache }
: If set to *yes*, use a download manager to download regular files on read.

CVMFS_STRICT_MOUNT { #cvmfs_strict_mount }
: If set to *yes*, mount only repositories that are listed in `CVMFS_REPOSITORIES`.

CVMFS_SUID { #cvmfs_suid }
: If set to *yes*, enable suid magic on the mounted repository. Requires mounting as root.

CVMFS_SYSLOG_FACILITY { #cvmfs_syslog_facility }
: If set to a number between 0 and 7, uses the corresponding `LOCALn` facility for syslog messages.

CVMFS_SYSLOG_LEVEL { #cvmfs_syslog_level }
: If set to 1 or 2, sets the syslog level for CernVM-FS messages to `LOG_DEBUG` or `LOG_INFO` respectively.

CVMFS_SYSLOG_PREFIX { #cvmfs_syslog_prefix }
: Prefix for each CVMFS message in the syslog. By default it is the repo name.

CVMFS_SYSTEMD_NOKILL { #cvmfs_systemd_nokill }
: If set to *yes*, modify the command line to `@vmfs2 ...` in order to act as a systemd lowlevel storage manager.

CVMFS_TALK_SOCKET { #cvmfs_talk_socket }
: Internal usage. Used for `cvmfs_talk`. Default socket is `/var/spool/cvmfs/<repo>/cvmfs_io`.

CVMFS_TALK_OWNER { #cvmfs_talk_owner }
: Internal usage. Used for `cvmfs_talk`. By default it is the repo owner.

CVMFS_TELEMETRY_RATE { #cvmfs_telemetry_rate }
: Rate in seconds for Telemetry Aggregator to send the telemetry. Minimum send rate >= 5 sec.

CVMFS_TELEMETRY_SEND { #cvmfs_telemetry_send }
: `ON` to activate Telemetry Aggregator.

CVMFS_TIMEOUT { #cvmfs_timeout }
: Timeout in seconds for HTTP requests with a proxy server.

CVMFS_TIMEOUT_DIRECT { #cvmfs_timeout_direct }
: Timeout in seconds for HTTP requests without a proxy server.

CVMFS_TRACEBUFFER { #cvmfs_tracebuffer }
: Internal usage. Max number of entries of the tracebuffer.

CVMFS_TRACEBUFFER_THRESHOLD { #cvmfs_tracebuffer_threshold }
: Internal usage. Flush treshold after how many entries the tracebuffer is flushed to file.

CVMFS_TRACEFILE { #cvmfs_tracefile }
: If set, enables the tracer and trace file system calls to the given file.

CVMFS_USE_GEOAPI { #cvmfs_use_geoapi }
: Request order of Stratum 1 servers and fallback proxies via Geo-API.

CVMFS_USE_SSL_SYSTEM_CA { #cvmfs_use_ssl_system_ca }
: When connecting to an HTTPS endpoint, it will load the certificates provided by the system.

CVMFS_USER { #cvmfs_user }
: Sets the `gid` and `uid` mount options. Don't touch or overwrite.

CVMFS_USYSLOG { #cvmfs_usyslog }
: All messages that normally are logged to syslog are re-directed to the given file. This file can grow up to 500kB and there is one step of log rotation. Required for muCernVM.

CVMFS_XATTR_PRIVILEGED_GIDS { #cvmfs_xattr_privileged_gids }
: Comma-separated list of (main) group IDs that are allowed to access the extended attributes listed by `CVMFS_XATTR_PROTECTED_XATTRS`.

CVMFS_XATTR_PROTECTED_XATTRS { #cvmfs_xattr_protected_xattrs }
: Comma-separated list of extended attributes (full name, e.g. `user.fqrn`) that are only accessible by `root` and the group IDs listed by `CVMFS_XATTR_PRIVILEGED_GIDS`.

CVMFS_WORKSPACE { #cvmfs_workspace }
: Set the local directory for storing special files (defaults to the cache directory).

CVMFS_WORLD_READABLE { #cvmfs_world_readable }
: Override posix read permissions to make files in repository globally readable

## Server parameters
CVMFS_AUFS_WARNING { #cvmfs_aufs_warning }
: Set to *false* to silence AUFS kernel deadlock warning.

CVMFS_AUTO_GC { #cvmfs_auto_gc }
: Enables the automatic garbage collection on *publish* and *snapshot*

CVMFS_AUTO_GC_TIMESPAN { #cvmfs_auto_gc_timespan }
: Date-threshold for automatic garbage collection (For example: *3 days ago*, *1 week ago*, ...)

CVMFS_AUTO_GC_LAPSE { #cvmfs_auto_gc_lapse }
: Frequency of auto garbage collection, only garbage collect if last GC is before the given threshold (For example: *1 day ago*)

CVMFS_AUTO_REPAIR_MOUNTPOINT { #cvmfs_auto_repair_mountpoint }
: Set to *true* to enable automatic recovery from bogus server mount states.

CVMFS_AUTO_TAG { #cvmfs_auto_tag }
: Creates a generic revision tag for each published revision (if set to *true*).

CVMFS_AUTO_TAG_TIMESPAN { #cvmfs_auto_tag_timespan }
: Date-threshold for automatic tags, after which auto tags get removed (For example: *4 days ago*)

CVMFS_AUTOCATALOGS { #cvmfs_autocatalogs }
: Enable/disable automatic catalog management using autocatalogs.

CVMFS_AUTOCATALOGS_MAX_WEIGHT { #cvmfs_autocatalogs_max_weight }
: Maximum number of entries in an autocatalog to be considered overflowed. Default value: 100000 (see also *CVMFS_AUTOCATALOGS*)

CVMFS_AUTOCATALOGS_MIN_WEIGHT { #cvmfs_autocatalogs_min_weight }
: Minimum number of entries in an autocatalog to be considered underflowed. Default value: 1000 (see also *CVMFS_AUTOCATALOGS*)

CVMFS_AVG_CHUNK_SIZE { #cvmfs_avg_chunk_size }
: Desired average size of a file chunk in bytes (see also *CVMFS_USE_FILE_CHUNKING*)

CVMFS_CATALOG_ALT_PATHS { #cvmfs_catalog_alt_paths }
: Enable/disable generation of catalog bootstrapping shortcuts during publishing. (Useful when backend directory `/data` is not publicly accessible)

CVMFS_CHECK_ALL_MIN_DAYS { #cvmfs_check_all_min_days }
: Minimum number of days between checking each repository with `cvmfs_server check -a`. Default value: 30

CVMFS_COMPRESSION_ALGORITHM { #cvmfs_compression_algorithm }
: Compression algorithm to be used during publishing (currently either `default` or `none`)

CVMFS_CREATOR_VERSION { #cvmfs_creator_version }
: The CernVM-FS version that was used to create this repository (do not change manually).

CVMFS_DONT_CHECK_OVERLAYFS_VERSION { #cvmfs_dont_check_overlayfs_version }
: Disable checking of OverlayFS version before usage. (see also the [Requirements for a new Repository](cpt-repo.md#requirements-for-a-new-repository) section)

CVMFS_ENABLE_MTIME_NS { #cvmfs_enable_mtime_ns }
: Use nanosecond-granularity for modification time of files (instead of milliseconds)

CVMFS_ENFORCE_LIMITS { #cvmfs_enforce_limits }
: Set to *true* to cause exceeding `*LIMIT` variables to be fatal to a publish instead of a warning

CVMFS_EXTENDED_GC_STATS { #cvmfs_extended_gc_stats }
: Set to *true* to keep track of the volume of garbage collected files (increases GC running time)

CVMFS_EXTERNAL_DATA { #cvmfs_external_data }
: Set to *true* to mark that repository contains external data that is served from an external HTTP server

CVMFS_FILE_MBYTE_LIMIT { #cvmfs_file_mbyte_limit }
: Maximum number of megabytes for a published file, default value: 1024 (see also *CVMFS_ENFORCE_LIMITS*)

CVMFS_FORCE_REMOUNT_WARNING { #cvmfs_force_remount_warning }
: Enable/disable warning through `wall` and grace period before forcefully remounting a CernVM-FS repository on the release managere machine.

CVMFS_GARBAGE_COLLECTION { #cvmfs_garbage_collection }
: Enables repository garbage collection (*Stratum~0 only*, if set to *true*). A publish operation is needed after changing this setting to update the repository manifest before garbage collection can run.

CVMFS_GC_DELETION_LOG { #cvmfs_gc_deletion_log }
: Log file path to track all garbage collected objects during sweeping for bookkeeping or debugging

CVMFS_GEO_DB_FILE { #cvmfs_geo_db_file }
: Path to externally updated location of geolite2 city database, or 'None' for no database.

CVMFS_GEO_LICENSE_KEY { #cvmfs_geo_license_key }
: A license key for downloading the geolite2 city database from maxmind.

CVMFS_GID_MAP { #cvmfs_gid_map }
: Path of a file for the mapping of file owner group ids.

CVMFS_HASH_ALGORITHM { #cvmfs_hash_algorithm }
: Define which secure hash algorithm should be used by CernVM-FS for CAS objects (supported are: *sha1*, *rmd160* and *shake128*)

CVMFS_IGNORE_SPECIAL_FILES { #cvmfs_ignore_special_files }
: Set to *true* to skip special files (pipes, sockets, block device and character device files) during publish without aborting.

CVMFS_INCLUDE_XATTRS { #cvmfs_include_xattrs }
: Set to *true* to process extended attributes

CVMFS_MAX_CHUNK_SIZE { #cvmfs_max_chunk_size }
: Maximal size of a file chunk in bytes (see also *CVMFS_USE_FILE_CHUNKING*)

CVMFS_MAXIMAL_CONCURRENT_WRITES { #cvmfs_maximal_concurrent_writes }
: Maximal number of concurrently processed files during publishing.

CVMFS_MIN_CHUNK_SIZE { #cvmfs_min_chunk_size }
: Minimal size of a file chunk in bytes (see also *CVMFS_USE_FILE_CHUNKING*)

CVMFS_NESTED_KCATALOG_LIMIT { #cvmfs_nested_kcatalog_limit }
: Maximum thousands of files allowed in nested catalogs, default 500 (see also *CVMFS_ROOT_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*)

CVMFS_NUM_UPLOAD_TASKS { #cvmfs_num_upload_tasks }
: Number of threads used to commit data to storage during publication. Currently only used by the local backend.

CVMFS_NUM_WORKERS { #cvmfs_num_workers }
: Maximal number of concurrently downloaded files during a Stratum1 pull operation (*Stratum~1 only*).

CVMFS_PUBLIC_KEY { #cvmfs_public_key_2 }
: Colon-separated path to the public key file(s) or directory(ies) of the repository to be replicated. (Stratum 1 only).

CVMFS_PRINT_STATISTICS { #cvmfs_print_statistics }
: Set to *true* to show publisher statistics on the console

CVMFS_REPLICA_ACTIVE { #cvmfs_replica_active }
: Stratum1-only: Set to *no* to skip this repository when executing `cvmfs_server snapshot -a`

CVMFS_REPOSITORY_NAME { #cvmfs_repository_name }
: The fully qualified name of the specific repository.

CVMFS_REPOSITORY_TYPE { #cvmfs_repository_type }
: Defines if the repository is a master copy (*stratum0*) or a replica (*stratum1*).

CVMFS_REPOSITORY_TTL { #cvmfs_repository_ttl }
: The frequency in seconds of client lookups for changes in the repository. Defaults to 4 minutes.

CVMFS_ROOT_KCATALOG_LIMIT { #cvmfs_root_kcatalog_limit }
: Maximum thousands of files allowed in root catalogs, default 200 (see also *CVMFS_NESTED_KCATALOG_LIMIT* and *CVMFS_ENFORCE_LIMITS*)

CVMFS_SNAPSHOT_GROUP { #cvmfs_snapshot_group }
: Group name for subset of repositories used with `cvmfs_server snapshot -a -g`. Added with `cvmfs_server add-replica -g`.

CVMFS_SPOOL_DIR { #cvmfs_spool_dir }
: Location of the upstream spooler scratch directories; the read-only CernVM-FS moint point and copy-on-write storage reside here.

CVMFS_STATISTICS_DB { #cvmfs_statistics_db }
: Set a custom path for the publisher statistics database

CVMFS_STATS_DB_DAYS_TO_KEEP { #cvmfs_stats_db_days_to_keep }
: Sets the pruning interval for the publisher statistics database (365 by default)

CVMFS_STRATUM0 { #cvmfs_stratum0 }
: URL of the master copy (*stratum0*) of this specific repository.

CVMFS_STRATUM1 { #cvmfs_stratum1 }
: URL of the Stratum1 HTTP server for this specific repository.

CVMFS_SYNCFS_LEVEL { #cvmfs_syncfs_level }
: Controls how often `sync` will be called by `cvmfs_server` operations. Possible levels are `none`, `default`, `cautious`.

CVMFS_S3_&lt;param&gt; { #cvmfs_s3_param }
: S3-related parameters. See the [S3 Compatible Storage Systems](cpt-repo.md#s3-compatible-storage-systems) section.

CVMFS_UID_MAP { #cvmfs_uid_map }
: Path of a file for the mapping of file owner user ids.

CVMFS_UNION_DIR { #cvmfs_union_dir }
: Mount point of the union file system for copy-on-write semantics of CernVM-FS. Here, changes to the repository are performed (see the [CernVM-FS Repository Creation and Updating](cpt-repo.md#cernvm-fs-repository-creation-and-updating) section).

CVMFS_UNION_FS_TYPE { #cvmfs_union_fs_type }
: Defines the union file system to be used for the repository (only `overlayfs` is fully supported, `aufs` has no active support anymore)

CVMFS_UPLOAD_STATS_DB { #cvmfs_upload_stats_db }
: Publish repository statistics data file to the Stratum 0 `/stats` location

CVMFS_UPLOAD_STATS_PLOTS { #cvmfs_upload_stats_plots }
: Publish repository statistics plots and webpage to the Stratum 0 `/stats` location (requires ROOT)

CVMFS_UPSTREAM_STORAGE { #cvmfs_upstream_storage }
: Upstream spooler description defining the basic upstream storage type and configuration (see below).

CVMFS_USE_FILE_CHUNKING { #cvmfs_use_file_chunking }
: Allows backend to split big files into small chunks (*true* | *false*)

CVMFS_USER { #cvmfs_user_2 }
: The user name that owns and manipulates the files inside the repository.

CVMFS_VIRTUAL_DIR { #cvmfs_virtual_dir }
: Set to *true* to enable the hidden, virtual `.cvmfs/snapshots` directory containing entry points to all named tags.

CVMFS_VOMS_AUTHZ { #cvmfs_voms_authz }
: Membership requirement (e.g. VOMS authentication) to be added into the file catalogs

CVMFS_STATISTICS_DB { #cvmfs_statistics_db_2 }
: SQLite file path to store the statistics. Default is `/var/spool/cvmfs/<REPO_NAME>/stats.db`.

CVMFS_PRINT_STATISTICS { #cvmfs_print_statistics_2 }
: Set to *true* to enable statistics printing to the standard output.

X509_CERT_BUNDLE { #x509_cert_bundle }
: Bundle file with CA certificates for HTTPS connections (see [Large-Scale Data CernVM-FS](cpt-large-scale.md)).

X509_CERT_DIR { #x509_cert_dir }
: Directory file with CA certificates for HTTPS connections, defaults to `/etc/grid-security/certificates` (see [Large-Scale Data CernVM-FS](cpt-large-scale.md)).

### Deprecated parameters

Will be removed in future versions.

CVMFS_GENERATE_LEGACY_BULK_CHUNKS { #cvmfs_generate_legacy_bulk_chunks }
: Deprecated, set to *true* to enable generation of whole-file objects for large files.

CVMFS_IGNORE_XDIR_HARDLINKS { #cvmfs_ignore_xdir_hardlinks }
: Deprecated, defaults to *true* hardlinks are found. Instead automatically break the hardlinks across directories.

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

CVMFS_CACHE\_$name\_UPPER { #cvmfs_cache_name_upper }
: Name of the upper layer cache instance

CVMFS_CACHE\_$name\_LOWER { #cvmfs_cache_name_lower }
: Name of the lower layer cache instance

CVMFS_CACHE_LOWER_READONLY { #cvmfs_cache_lower_readonly }
: Set to *true* to avoid populating the lower layer

## External Cache Plugin Parameters

The following parameters are used to configure an external cache plugin
as a cache manager instance.

CVMFS_CACHE\_$name\_CMDLINE { #cvmfs_cache_name_cmdline }
: If the client should start the plugin, the executable and command line parameters of the plugin, separated by comma.

CVMFS_CACHE\_$name\_LOCATOR { #cvmfs_cache_name_locator }
: The address of the socket used for communication with the plugin.

## In-memory Cache Plugin Parameters

The following parameters are interpreted from the configuration file
provided to the in-memory cache plugin (see the [Advanced Cache
Configuration](cpt-configure.md#advanced-cache-configuration) section).

CVMFS_CACHE_PLUGIN_DEBUGLOG { #cvmfs_cache_plugin_debuglog }
: If set, run CernVM-FS in debug mode and write a verbose log the the specified file.

CVMFS_CACHE_PLUGIN_LOCATOR { #cvmfs_cache_plugin_locator }
: The address of the socket used for client communication

CVMFS_CACHE_PLUGIN_SIZE { #cvmfs_cache_plugin_size }
: The amount of RAM in megabyte used by the plugin for caching.
