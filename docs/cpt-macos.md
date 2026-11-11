# macOS Client Backends

!!! warning "Pre-release"

    This page describes the macOS client of CernVM-FS 2.15.0, which is
    currently only available as a pre-release (`2.15.0~pre1`). It is
    intended for testing, not for production use. The mount backends
    and their packaging may still change before the final release.

The macOS client supports several ways to present a repository to the
operating system. The backend is selected with
`CVMFS_MOUNT_BACKEND` (default in `/etc/cvmfs/default.d/11-osx-backend.conf`,
override in `/etc/cvmfs/default.local`):

| Backend | `CVMFS_MOUNT_BACKEND` | Needs macOS changes | Reboot | autofs | Status |
|---|---|---|---|---|---|
| NFS (kernel NFS client) | `nfs` | none | no | no | preferred |
| macFUSE, kernel extension | `fuse` | kext + reduced security | yes | no | stable |
| macFUSE, FSKit | `fskit` | enable FS extension in System Settings | no | no | experimental |
| FUSE-T | – | – | – | – | unsupported |

If the package was built with more than one backend, the default is the
first available of `nfs`, `fskit`, `fuse`.

## Common Setup

These points apply to all backends.

- **No autofs.** None of the backends integrate with the macOS
  automounter. Every repository has to be mounted explicitly with
  `mount -t cvmfs`. Mount the config repository (e.g.
  `cvmfs-config.cern.ch`) before any other repository.
- **`/cvmfs` is a firmlink.** The root file system is read-only since
  macOS 10.15. `cvmfs_config setup` adds `cvmfs	/Volumes/cvmfs` to
  `/etc/synthetic.conf`, creates `/Volumes/cvmfs` (mode `777`), and
  reloads it with `apfs.util -t`. If `/cvmfs` does not appear, reboot
  once.
- **Compatibility symlink.** `/Users/Shared/cvmfs` is a symlink to
  `/Volumes/cvmfs`, so that absolute symlinks inside repositories that
  point to `/Users/Shared/cvmfs/...` still resolve. If an older
  installation left a non-empty directory there, `cvmfs_config setup`
  warns; unmount, remove the directory and re-run setup.
- **Unprivileged mounts.** With every backend, `cvmfs2` runs as the
  mounting user (`CVMFS_USER=${SUDO_USER:-$(whoami)}`). The cache and
  sockets are per user:
  `~/Library/Caches/cvmfs` and `~/Library/Caches/cvmfs/run`.
- **Configuration** lives in `/usr/local/etc/cvmfs`, symlinked to
  `/etc/cvmfs`. Binaries are installed to `/usr/local`.
- Check the setup with `cvmfs_config chksetup`. It verifies the
  backend libraries and, for `fuse`/`fskit`, the macFUSE installation.

Unmount with

```bash
umount /cvmfs/<repository>
```

## NFS Backend (Preferred)

`cvmfs2 -o nfs` serves the repository as an NFSv4 server on
`127.0.0.1`, and the macOS kernel NFS client mounts it. No third-party
kernel or file system extension is involved.

- Most stable and maintainable option: it relies only on components
  that ship with macOS.
- The only backend that works on GitHub Actions macOS runners, because
  the kernel NFS client is pre-approved and needs no user interaction.
- No macFUSE installation required.
- Mounts appear as `127.0.0.1:/ on /Volumes/cvmfs/<repository>` in
  `mount`; `cvmfs_config stat` and `umount` report them under `/cvmfs`.

### Installation

Download and install the CernVM-FS package:

```bash
curl -O 'https://ecsft.cern.ch/dist/cvmfs/prerelease/cvmfs-2.15.0-pre1/cvmfs-2.15.0~pre1.pkg'
sudo installer -pkg 'cvmfs-2.15.0~pre1.pkg' -target /
```

The post-install script runs `cvmfs_config setup`. Configure the client
in `/etc/cvmfs/default.local`, for example

```bash
CVMFS_HTTP_PROXY=DIRECT
CVMFS_MOUNT_BACKEND=nfs
```

### Mounting

```bash
mkdir -p /cvmfs/cvmfs-config.cern.ch /cvmfs/sft.cern.ch
mount -t cvmfs cvmfs-config.cern.ch /cvmfs/cvmfs-config.cern.ch
mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch
```

Mounting with `sudo` also works; `cvmfs2` still runs as the invoking
user.

Workloads that open many files may need a higher limit:

```bash
sudo launchctl limit maxfiles 65536 65536
```

## macFUSE with Kernel Extension

The classic backend: `cvmfs2` talks to the macFUSE kernel extension
through `/dev/macfuse*`.

- Best performance and stability of the FUSE-based backends.
- Difficult to enable: since macOS 11 (Big Sur), third-party kernel
  extensions require lowering the system security policy in Recovery
  mode, approving the extension, and rebooting. On Apple Silicon this
  means switching to "Reduced Security". Managed (MDM) Macs may not
  allow it at all.
- Does not work on GitHub Actions runners.

### Installation

1. Install [macFUSE](https://macfuse.github.io/) and enable its kernel
   extension following the
   [macFUSE Getting Started guide](https://github.com/macfuse/macfuse/wiki/Getting-Started)
   and Apple's instructions on
   [changing startup security settings](https://support.apple.com/guide/mac-help/change-startup-disk-security-settings-a-mac-mchl768f7291/mac).
2. Reboot and verify that the extension is loaded:

    ```bash
    kextstat | grep -i fuse
    ```

3. Download and install the CernVM-FS package:

    ```bash
    curl -O 'https://ecsft.cern.ch/dist/cvmfs/prerelease/cvmfs-2.15.0-pre1/cvmfs-2.15.0~pre1.pkg'
    sudo installer -pkg 'cvmfs-2.15.0~pre1.pkg' -target /
    ```

4. Select the backend in `/etc/cvmfs/default.local`:

    ```bash
    CVMFS_MOUNT_BACKEND=fuse
    ```

### Mounting

```bash
mkdir -p /cvmfs/cvmfs-config.cern.ch /cvmfs/sft.cern.ch
mount -t cvmfs cvmfs-config.cern.ch /cvmfs/cvmfs-config.cern.ch
mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch
```

The macFUSE mount helper is setuid, so no root is needed; `sudo mount`
works as well.

## macFUSE with FSKit

macFUSE 5 can run file systems in user space through Apple's FSKit
framework instead of the kernel extension.

- Still somewhat experimental.
- Much easier to enable than the kernel extension: no change to the
  security policy and no reboot.
- Requires macFUSE >= 5.4.0; earlier releases fail to mount.
- Does not work on GitHub Actions runners (the extension must be
  enabled interactively).

Quirks:

- **No mounts under `sudo`.** Mount as the regular user. FSKit binds
  the mount to the user session.
- **Mounts only under `/Volumes`.** FSKit refuses other locations.
  Mount points under `/cvmfs` work because `/cvmfs` is a firmlink to
  `/Volumes/cvmfs`; the mount shows up as
  `/dev/diskN on /Volumes/cvmfs/<repository> (macfuse, ..., fskit)`.
- **Needs the extra symlinks** described in [Common Setup](#common-setup)
  (`/cvmfs` → `/Volumes/cvmfs`, `/Users/Shared/cvmfs` → `/Volumes/cvmfs`).
- `cvmfs2` stays in the foreground as the file system process for the
  lifetime of the mount; it does not daemonize.

### Installation

1. Install [macFUSE](https://macfuse.github.io/) >= 5.4.0.
2. Enable the file system extension in
   *System Settings > General > Login Items & Extensions > File System
   Extensions* (toggle macFUSE). No reboot is needed.
3. Install the [CernVM-FS package](https://ecsft.cern.ch/dist/cvmfs/prerelease/cvmfs-2.15.0-pre1/cvmfs-2.15.0~pre1.pkg) as described for the
   [NFS backend](#installation).
4. Select the backend in `/etc/cvmfs/default.local`:

    ```bash
    CVMFS_MOUNT_BACKEND=fskit
    ```

`cvmfs_config chksetup` checks the macFUSE version, the presence of the
FSKit modules, and warns if the extension does not appear enabled.

### Mounting

As the regular user, without `sudo`:

```bash
mkdir -p /cvmfs/cvmfs-config.cern.ch /cvmfs/sft.cern.ch
mount -t cvmfs cvmfs-config.cern.ch /cvmfs/cvmfs-config.cern.ch
mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch
```

## FUSE-T (Unsupported)

!!! warning

    FUSE-T is no longer supported. It has been found not to work in
    production. Use the NFS backend instead, which needs no kernel
    extension either.
