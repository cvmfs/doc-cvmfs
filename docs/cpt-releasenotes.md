# Release Notes for CernVM-FS 2.13.3

CernVM-FS 2.13.3 is again a fairly voluminous patch release. Most
importantly it fixes a race in auto-mount/unmounts that could hang the
client process. As a failsafe, it also adds a config option
`CVMFS_PREMOUNT_FUSE` that can be set to "no" to go back to 2.12
behavior of using fusermount to mount cvmfs. Furthermore this patch
release includes a bugfix for garbage collection on stratum 1s - now
the garbage collection should really be skipped if it is not needed
(because it has not been run on the stratum 0).

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend
updating only a few worker nodes first and gradually ramp up once the
new version proves to work correctly. Please take special care when
upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the
upgrade. For publisher and gateway nodes, all transactions must be
closed; no active leases must be present before upgrading.

## Bug fixes

2.13.3:

-   [client] Fix a race with concurrent auto-mount/umounts
    ([#3993](https://github.com/cvmfs/cvmfs/issues/3993))
-   [server] cvmfs_server check: add -x option for custom scratch dir
    ([#4011](https://github.com/cvmfs/cvmfs/issues/4011))
-   [client] Fix CVMFS_VERSION and CVMFS_ARCH availability in config
    files ([#3999](https://github.com/cvmfs/cvmfs/issues/3999))
-   [client] Add extended info with cvmfs_config status \<repo\>
    ([#3973](https://github.com/cvmfs/cvmfs/issues/3973))
-   [server] Avoid accessing held mutexes after forking
    ([#3995](https://github.com/cvmfs/cvmfs/issues/3995))
-   [client] Fix spurious "failed to umount" messages
    ([#3970](https://github.com/cvmfs/cvmfs/issues/3970))
-   [server] Fix updating of last_gc when no gc is run under gc -a
    without dry run
    ([#3947](https://github.com/cvmfs/cvmfs/issues/3947))
-   [geoip] Change geoip database to openhtc source by default
    ([#3967](https://github.com/cvmfs/cvmfs/issues/3967))
-   [client] Add CVMFS_PREMOUNT_FUSE option to allow fallback to
    fusermount ([#4017](https://github.com/cvmfs/cvmfs/issues/4017))

# Release Notes for CernVM-FS 2.13.2

!!! note

    In CernVM-FS 2.13.2 there is a race when automounting/-unmounting
    repositories that lead to clients. A new patch release is in
    preparation. This issue can be mitigated by increasing the autofs
    timeout. See the "Known Issues" page for more details.

CernVM-FS 2.13.2 is a fairly large patch release. It fixes two long
standing issues in the core client code that have caused crashes in some
rare circumstances. A regression in 2.13 that has led to spurious
"failed to umount (errno 22)" log messages is fixed as well.
Furthermore this patch release includes some important improvements for
stratum one operations (As a reminder, the versioning of CVMFS is
semantic mostly for the client. New features may be added to the server
tools and unpacker even in patch releases).

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend
updating only a few worker nodes first and gradually ramp up once the
new version proves to work correctly. Please take special care when
upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the
upgrade. For publisher and gateway nodes, all transactions must be
closed; no active leases must be present before upgrading.

## Bug fixes

-   [client] Fix loader return value when automounter unmounts
    ([#3929](https://github.com/cvmfs/cvmfs/issues/3929))
-   [client] Fix race when using page cache tracker for chunked files
    ([#3685](https://github.com/cvmfs/cvmfs/issues/3685))
-   [client] Correct PCT Close in cvmfs_open
    ([#3917](https://github.com/cvmfs/cvmfs/issues/3917))
-   [server] Change gc -a to only do repos where gc was run on the
    stratum0 ([#3895](https://github.com/cvmfs/cvmfs/issues/3895))
-   [server] Move the no collectable repos message to gc.log
    ([#3915](https://github.com/cvmfs/cvmfs/issues/3915))
-   [server] Do only one gc -a at a time, and remove need for check -a
    to be run by root
    ([#3575](https://github.com/cvmfs/cvmfs/issues/3575))
-   [server] snapshot: Avoid recursion into history
    ([#3846](https://github.com/cvmfs/cvmfs/issues/3846))
-   [server] Optimize DNS lookups by cvmfs_geo.py to ignore short host
    names ([#3920](https://github.com/cvmfs/cvmfs/issues/3920))
-   [client] Add cvmfs_talk metrics prometheus command for faster
    telemetry ([#3944](https://github.com/cvmfs/cvmfs/issues/3944))
-   [rpm] Temporarily re-add fuse3 dependency to server to fix fstab
    [#3943](https://github.com/cvmfs/cvmfs/issues/3943)
-   [build system] cmake: add BUILTIN_EXTERNALS_LIST and EXCLUDE
    options ([#3940](https://github.com/cvmfs/cvmfs/issues/3940))
-   [client] Add CVMFS_VERSION and CVMFS_VERSION_NUMERIC env vars to
    config ([#3934](https://github.com/cvmfs/cvmfs/issues/3934))
-   [rpm] fix logrotate config for el8
    ([#3932](https://github.com/cvmfs/cvmfs/issues/3932))

# Release Notes for CernVM-FS 2.13.1

CernVM-FS 2.13.1 is a patch release that fixes a few bugs introduced in
2.13.0.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend
updating only a few worker nodes first and gradually ramp up once the
new version proves to work correctly. Please take special care when
upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the
upgrade. For publisher and gateway nodes, all transactions must be
closed; no active leases must be present before upgrading.

!!! note

    Packages no longer support libfuse2 for the new platforms: RHEL/Alma >=
    10, Fedora >= 42, Debian >= 13 and Ubuntu >= 25.04. For package
    maintainers: Libfuse2 support is turned off by default, and has to be
    enabled explicitly with the flag -DBUILD_LIBFUSE2 It will be deprecated
    completely in a future version, and the dependency can already be
    removed, as libfuse3 is required by default. The cvmfs package should
    now explicitly depend on the cvmfs_fuse3 libs packaged in cvmfs-fuse3
    package to ensure they are installed.

Packages are available for both the x86_64 and aarch64 architectures,
for current debian- and rhel-based distros. We've added packages for
Almalinux 10 and Fedora 42 on top of Debian 13 already introduced in the
previous release. Do try them out!

## Bug fixes

> -   \[client\] Fix mount options that can lead to "futimes" error
>     with docker ([#3872](https://github.com/cvmfs/cvmfs/issues/3872))
> -   \[rpm\] Allow builds without libfuse2
>     ([#3879](https://github.com/cvmfs/cvmfs/issues/3879))
> -   \[client\] Fix a segfault in one of the unmount branches of the
>     loader ([#3873](https://github.com/cvmfs/cvmfs/issues/3873))
> -   \[client\] Fix host reset timeout (CVMFS_HOST_RESET_AFTER)
>     ([#3864](https://github.com/cvmfs/cvmfs/issues/3864))

# Release Notes for CernVM-FS 2.13.0

CernVM-FS 2.13.0 is a minor release that has a number of important fixes
for cvmfs_server ingest, mounting cvmfs on Ubuntu 24.10+, and some small
improvements.

!!! note

    For admins of stratum-1s: The cvmfs-server package now installs default
    logrotate configs to /etc/logrotate.d/cvmfs and
    /etc/logrotate.d/cvmfs-statsdb. If you prefer not to use logrotate for
    snapshot logs and stats db, create an empty file under these paths or
    remove them after installation. When installed or upgraded from the
    packages, cvmfs-server should not overwrite any modification you make.

!!! note

    For package maintainers of cvmfs-server: You can install the previously
    mentioned logrotate files with the appropriate config file behavior, and
    add an optional dependency on logrotate.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend
updating only a few worker nodes first and gradually ramp up once the
new version proves to work correctly. Please take special care when
upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the
upgrade. For publisher and gateway nodes, all transactions must be
closed; no active leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures,
for current debian- and rhel-based distros. We no longer provide
packages for Centos7 and Ubuntu 20.04, but add packages for Debian 13.

## Bug fixes

> -   \[server\] Do not corrupt repository when ingesting a tarball to a
>     base dir that contains a double slash
>     ([#3786](https://github.com/cvmfs/cvmfs/issues/3786))
> -   \[server\] swissknife_lease: Fix bug in response receiver callback
>     ([#3823](https://github.com/cvmfs/cvmfs/issues/3823))
> -   \[client\] Fixed unmounting after stopping autofs in Ubuntu 24.04
>     ([#3808](https://github.com/cvmfs/cvmfs/issues/3808))
> -   \[client\] Fixed permission issue in mounting cvmfs with apparmor
>     (Ubuntu 24.10+)
>     ([#3795](https://github.com/cvmfs/cvmfs/issues/3795))
> -   \[server\] Fixed garbage collection lock to avoid spurious check
>     failures ([#3815](https://github.com/cvmfs/cvmfs/issues/3815))
> -   \[shrinkwrap\] Avoid possible copy errors by ensuring that
>     directories are writeable
>     ([#3798](https://github.com/cvmfs/cvmfs/issues/3798))
> -   \[macos\] Chksetup for macfuse no longer complains about missing
>     FUSE-T ([#3800](https://github.com/cvmfs/cvmfs/issues/3800))
> -   \[macos\] Run apfs.util after creating firmlinks on macos
>     ([#3776](https://github.com/cvmfs/cvmfs/issues/3776))

## Improvements and changes

> -   \[client\] Bugreport no longer blocks, and collects as much data
>     as possible when client stuck
>     ([#3768](https://github.com/cvmfs/cvmfs/issues/3768))
> -   \[client\] Improved EIO logging
>     ([#3723](https://github.com/cvmfs/cvmfs/issues/3723))
> -   \[gateway, ducc, snapshotter\] bump and cleanup golang
>     dependencies
> -   \[server\] Ingest command can now delete paths containing colons
>     (:) ([#3792](https://github.com/cvmfs/cvmfs/issues/3792))
> -   \[server\] Install default logrotate configs for /var/log/cvmfs
>     and statsdb ([#3839](https://github.com/cvmfs/cvmfs/issues/3839))
> -   \[client\] Add cvmfs_config killall options -r(reset fuse) /
>     -s(stuck fuse reset) to abort fuse connection
>     ([#3831](https://github.com/cvmfs/cvmfs/issues/3831))
> -   \[rpm\] Automatically set permissions for cvmfs_ducc
>     ([#3790](https://github.com/cvmfs/cvmfs/issues/3790))
> -   \[client\] chksetup: Now uses max-time instead of connect-timeout
>     to avoid blocking when contacting stratum 1s
>     ([#3822](https://github.com/cvmfs/cvmfs/issues/3822))
