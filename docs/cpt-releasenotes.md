# Release Notes for CernVM-FS 2.14.0

CernVM-FS 2.14.0 is a feature release with a number of notable additions
on both the client and the server side. On the client, it introduces
file bundle prefetching, and reworks the code to  reduce the required
client capabilities to a minimum. On the server, highlights include partial
replication of repositories, a mountless publisher mode (`mkfs -P`),
batched S3 deletes, and faster deletion of nested catalogs during
ingest. Additionally, a number of long standing issues, such as the auto-tag timespan setting being ignored on a publisher, or abort not working in out-of-disk-condition are fixed. The container unpacking tool DUCC gains multi-arch image support and can now convert images
without FUSE mounts.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend
updating only a few worker nodes first and gradually ramp up once the
new version proves to work correctly. Please take special care when
upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the
upgrade. For publisher and gateway nodes, all transactions must be
closed; no active leases must be present before upgrading.

!!! note

    For package maintainers: the bundled `vjson` JSON parser has been
    replaced by [nlohmann-json](https://github.com/nlohmann/json). The
    `vjson` dependency can be dropped; on RPM-based distributions the
    build now depends on `nlohmann-json` (a header-only library) instead.

Packages are available for both the x86_64 and aarch64 architectures,
for current debian- and rhel-based distros.

## New features and improvements

### Client

-   [client] File bundle prefetching
    ([#4002](https://github.com/cvmfs/cvmfs/issues/4002))
-   [client] Implement FUSE passthrough
    ([#4006](https://github.com/cvmfs/cvmfs/issues/4006))
-   [client] Reduce client capabilities to minimum
    ([#3730](https://github.com/cvmfs/cvmfs/issues/3730))
-   [client] Add support for xattrs with values up to 64k
    ([#3622](https://github.com/cvmfs/cvmfs/issues/3622))
-   [client] Add a `revision_timestamp` magic xattr
    ([#4183](https://github.com/cvmfs/cvmfs/issues/4183))
-   [client] Add `CVMFS_REPOSITORIES_NOMOUNT` parameter to reduce syslog
    noise ([#4181](https://github.com/cvmfs/cvmfs/issues/4181))
-   [client] Per-repo granularity of `CVMFS_DEBUGLOG` at reload
    ([#4085](https://github.com/cvmfs/cvmfs/issues/4085))
-   [client] Skip open files on cache cleanup when possible
    ([#4029](https://github.com/cvmfs/cvmfs/issues/4029))
-   [client] Allow rootless `cvmfs_config chksetup`
    ([#4214](https://github.com/cvmfs/cvmfs/issues/4214))
-   [client] Update prometheus exporter metric names
    ([#4282](https://github.com/cvmfs/cvmfs/issues/4282))

### Server

-   [server] Partial replication of a repository
    ([#4184](https://github.com/cvmfs/cvmfs/issues/4184))
-   [server] Convenience features: `mkfs -P` (mountless publisher) and
    `cvmfs_server connect-gw`
    ([#4182](https://github.com/cvmfs/cvmfs/issues/4182))
-   [server] Graceful abort of a transaction under out-of-diskspace
    conditions ([#4158](https://github.com/cvmfs/cvmfs/issues/4158))
-   [server] Batched S3 deletes, add `CVMFS_S3_BATCH_DELETE_SIZE`
    ([#4122](https://github.com/cvmfs/cvmfs/issues/4122),
    [#4210](https://github.com/cvmfs/cvmfs/issues/4210),
    [#4199](https://github.com/cvmfs/cvmfs/issues/4199))
-   [server] ingest: delete nested catalogs by unlinking their reference
    by default (fast delete); add `CVMFS_INGEST_FAST_DELETE` to restore
    legacy traversal
    ([#4124](https://github.com/cvmfs/cvmfs/issues/4124),
    [#4198](https://github.com/cvmfs/cvmfs/issues/4198))
-   [server] Add `cvmfs_server ingestsql` utility
    ([#4099](https://github.com/cvmfs/cvmfs/issues/4099))
-   [server] Add `cvmfs_swissknife rotate-statsdb`
    ([#4163](https://github.com/cvmfs/cvmfs/issues/4163))
-   [server] Add `CVMFS_INFO_HEADER`
    ([#3735](https://github.com/cvmfs/cvmfs/issues/3735))
-   [server] New tools for container overlays on catalog level
    ([#4092](https://github.com/cvmfs/cvmfs/issues/4092))
-   [server] Allow to send `CVMFS_AUTO_TAG_TIMESPAN` from publisher, and
    set a 2 week default for the autotag timespan
    ([#4204](https://github.com/cvmfs/cvmfs/issues/4204),
    [#4278](https://github.com/cvmfs/cvmfs/issues/4278))
-   [server] Summarize `cvmfs_server check` errors
    ([#4277](https://github.com/cvmfs/cvmfs/issues/4277))
-   [server] Reduce output for non-interactive status, and use proxy when
    contacting stratum 1s
    ([#4227](https://github.com/cvmfs/cvmfs/issues/4227))
-   [server] Allow `cvmfs_server resign` without `.crt` if
    `.cvmfswhitelist` exists
    ([#4128](https://github.com/cvmfs/cvmfs/issues/4128))

### Gateway

-   [gw] Implement tag removal on publishers connected to a gateway
    ([#4285](https://github.com/cvmfs/cvmfs/issues/4285))
-   [gw] Add endpoint to refresh lease
    ([#4294](https://github.com/cvmfs/cvmfs/issues/4294))

### DUCC

-   [ducc] Multi-arch image support
    ([#3897](https://github.com/cvmfs/cvmfs/issues/3897),
    [#4170](https://github.com/cvmfs/cvmfs/issues/4170))
-   [ducc] `cvmfs_ducc convert` without FUSE mounts
    ([#4288](https://github.com/cvmfs/cvmfs/issues/4288))
-   [ducc] Add `delete-images` and `prune-images`
    ([#4171](https://github.com/cvmfs/cvmfs/issues/4171))
-   [ducc] Support publishing to CVMFS repository subdirectories
    ([#4076](https://github.com/cvmfs/cvmfs/issues/4076))
-   [ducc] Limit concurrency in downloads and download only layers not
    already unpacked
    ([#4117](https://github.com/cvmfs/cvmfs/issues/4117),
    [#4130](https://github.com/cvmfs/cvmfs/issues/4130))
-   [ducc] Deprecate `loop` command
    ([#4120](https://github.com/cvmfs/cvmfs/issues/4120))

## Bug fixes

-   [client] Fix bug when using libcurl 8.20+
    ([#4252](https://github.com/cvmfs/cvmfs/issues/4252))
-   [server] Always refresh mountpoint for gateway publication to fix a
    race ([#4303](https://github.com/cvmfs/cvmfs/issues/4303))
-   [server] Never publish a snapshot with a missing root catalog
    ([#4272](https://github.com/cvmfs/cvmfs/issues/4272))
-   [gw] Don't hold `leaseMutex` during commit
    ([#4274](https://github.com/cvmfs/cvmfs/issues/4274))
-   [ducc] Ignore missing hardlink targets when ingesting container
    layers ([#4286](https://github.com/cvmfs/cvmfs/issues/4286))
-   [ducc] Fix gc for multiarch images
    ([#4197](https://github.com/cvmfs/cvmfs/issues/4197))
-   [ducc] Proper backoff on 429 responses from registry
    ([#4110](https://github.com/cvmfs/cvmfs/issues/4110))

## Packaging

-   [rpm] Replace the `vjson` dependency with `nlohmann-json`
-   [rpm] Migrate from bootstrap.sh to cmake: libarchive
    ([#4064](https://github.com/cvmfs/cvmfs/issues/4064))
-   [container] Add optional flag to run `cvmfs_fsck` at start
    ([#4188](https://github.com/cvmfs/cvmfs/issues/4188))
-   [macos] Compile with `cxxstd=11`
    ([#4101](https://github.com/cvmfs/cvmfs/issues/4101))
