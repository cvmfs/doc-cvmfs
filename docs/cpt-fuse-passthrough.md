# FUSE Passthrough

With `CVMFS_FUSE_PASSTHROUGH=on`, the client hands the kernel the cache file
of a regular (non-chunked) file on open, and reads of that file then bypass
`cvmfs2`. The kernel registers such a backing file only for a process with
`CAP_SYS_ADMIN`. The client itself drops all capabilities, so on a system
mount the watchdog of the client, which keeps `CAP_SYS_ADMIN` for the
unmount, registers backing files on its behalf.

A mount where no process holds `CAP_SYS_ADMIN`, such as one owned by an
unprivileged user or one with `CVMFS_DISABLE_WATCHDOG`, serves files through
`cvmfs2` as without passthrough and logs one warning to syslog. After a
reload, passthrough stays off until the next mount.

!!! note

    Passthrough requires `kernel >= 6.17` and `libfuse >= 3.17`. Chunked
    files are always served through `cvmfs2`.
