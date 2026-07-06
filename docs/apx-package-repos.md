# Package Repositories

The [Getting Started](cpt-quickstart.md) guide installs the `cvmfs-release`
package, which is a convenience package that drops in the CernVM-FS
yum/apt repository definition and the signing keys for you. That is the
recommended path for most users.

This page documents the underlying package repositories directly, for
power users who want to:

* configure the repositories from a configuration-management system
  (Puppet, Ansible, ...) without installing the `cvmfs-release` package,
* enable the `testing` (release-candidate) or `future` (pre-release)
  channels,
* verify the signing keys out-of-band, or
* mirror the repositories internally.

For a description of the individual packages served from these
repositories, see [Available Packages](apx-rpms.md).

The stable `prod` channel is enabled by default. A `testing` channel
carrying release candidates and a `future` channel carrying pre-release
builds are also available but disabled by default; see
[Enabling the Testing and Prerelease Channels](#enabling-the-testing-and-prerelease-channels).
The `future` channel is currently only published for yum/dnf/zypper.

## Servers and Mirrors

The repositories are available from several endpoints:

| Endpoint | Purpose |
| --- | --- |
| `cvmrepo.s3.cern.ch` | **Primary production server.** Backed by S3; use this in package-manager configuration. |
| `cvmrepo.web.cern.ch` | Browsable mirror of the same content, served over the CERN web infrastructure. |
| `cvmrepo.s3-website.cern.ch` | Web front-end for browsing the contents of the underlying S3 bucket. |

The repository definition installed by `cvmfs-release` lists
`cvmrepo.s3.cern.ch` first and falls back to `cvmrepo.web.cern.ch`. The
examples below follow the same convention.

## Signing Keys

All packages are signed with the CernVM (`cvmadmin`) keys. Verify the
fingerprints before trusting the repositories:

| Key | Type | Fingerprint |
| --- | --- | --- |
| `RPM-GPG-KEY-CernVM` | DSA-1024 (2010) | `70B9 8904 8820 8E31 5ED4 5208 230D 389D 8AE4 5CE7` |
| `RPM-GPG-KEY-CernVM-2048` | RSA-4096 (2024) | `FD80 468D 49B3 B24C 3417 41FC 8CE0 A76C 497E A957` |

Both keys belong to the CernVM administrator
(`cernvm.administrator@cern.ch`), though the uid strings differ: the
DSA-1024 key reads `CernVM Administrator (cvmadmin)
<cernvm.administrator@cern.ch>`, while the RSA-4096 key reads
`cvmadmin <cernvm.administrator@cern.ch>`. The RSA-4096 key was introduced
in November 2024 and is used to sign newer packages; the legacy DSA-1024
key is kept for older packages.

The keys are served from the repository root:

* <https://cvmrepo.s3.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM>
* <https://cvmrepo.s3.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM-2048>
* <https://cvmrepo.s3.cern.ch/cvmrepo/apt/cernvm.gpg> (both keys, in the
  apt keyring format)

## RHEL / Fedora / SUSE (yum / dnf / zypper)

A repository definition equivalent to the one installed by
`cvmfs-release` is shown below. Write it to `/etc/yum.repos.d/cernvm.repo`
(or `/etc/zypp/repos.d/cernvm.repo` on SUSE). Each `baseurl` lists the
primary S3 server first and the browsable mirror second, so the package
manager falls back automatically:

```ini
[cernvm]
name=CernVM packages
baseurl=http://cvmrepo.s3.cern.ch/cvmrepo/yum/cvmfs/EL/$releasever/$basearch/ http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/$releasever/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM-2048
gpgcheck=1
enabled=1
protect=1

[cernvm-testing]
name=CernVM testing packages
baseurl=http://cvmrepo.s3.cern.ch/cvmrepo/yum/cvmfs-testing/EL/$releasever/$basearch/ http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-testing/EL/$releasever/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM-2048
gpgcheck=1
enabled=0
protect=1

[cernvm-future]
name=CernVM prerelease packages
baseurl=http://cvmrepo.s3.cern.ch/cvmrepo/yum/cvmfs-future/EL/$releasever/$basearch/ http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-future/EL/$releasever/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM-2048
gpgcheck=1
enabled=0
protect=1
```

The `$releasever` / `$basearch` variables are expanded by the package
manager. Import the signing keys into `/etc/pki/rpm-gpg/` first:

```bash
sudo curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM \
  https://cvmrepo.s3.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM
sudo curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM-2048 \
  https://cvmrepo.s3.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM-2048
```

!!! note "Distribution path"

    The `EL` path segment selects the distribution family. Replace it
    with `fedora` on Fedora and `suse` on SUSE, matching the layout under
    <https://cvmrepo.s3-website.cern.ch/cvmrepo/yum/>. On SUSE, also
    replace `$releasever` with `$releasever_major`. These substitutions
    are what the `cvmfs-release` package performs automatically at install
    time.

## Debian / Ubuntu (apt)

The apt repositories are keyed by distribution codename with `-prod` and
`-testing` suffixes. Install the keyring and add a source list.

Install the signing key into a dedicated keyring rather than the
system-wide `trusted.gpg.d/`, so it is only trusted for the CernVM-FS
repository:

```bash
sudo mkdir -p /etc/apt/keyrings
sudo curl -o /etc/apt/keyrings/cernvm.gpg \
  https://cvmrepo.s3.cern.ch/cvmrepo/apt/cernvm.gpg
```

Create `/etc/apt/sources.list.d/cernvm.sources` in the deb822 format,
substituting your distribution codename
(`. /etc/os-release; echo "$VERSION_CODENAME"`) in the `Suites` field.
For example, on Ubuntu 22.04 (`jammy`):

```text
Types: deb
URIs: http://cvmrepo.s3.cern.ch/cvmrepo/apt
Suites: jammy-prod
Components: main
Signed-By: /etc/apt/keyrings/cernvm.gpg
```

!!! note "Legacy `.list` format"

    The `cvmfs-release` package currently still installs the older
    one-line format in `/etc/apt/sources.list.d/cernvm.list`, with the key
    placed system-wide in `/etc/apt/trusted.gpg.d/cernvm.gpg`:

    ```text
    deb http://cvmrepo.s3.cern.ch/cvmrepo/apt jammy-prod main
    ```

    Both formats work; the deb822 `.sources` format above is recommended
    for new setups, as it also scopes the signing key to this repository.
    Use only one of the two to avoid duplicate-source warnings.

Then refresh and install:

```bash
sudo apt-get update
sudo apt-get install cvmfs
```

Supported codenames include:

=== "Debian"

    `jessie`, `stretch`, `buster`, `bullseye`, `bookworm`, `trixie`

=== "Ubuntu"

    `precise`, `trusty`, `xenial`, `bionic`, `focal`, `jammy`, `noble`,
    `questing`, `resolute`

If your exact release is not listed, the closest older release usually
works — this is the same fallback the `cvmfs-release` package applies for
unsupported distributions.

## Enabling the Testing and Prerelease Channels

The `testing` channel carries release candidates and the `future` channel
carries pre-release builds. Enable them only on nodes where you intend to
validate upcoming releases.

=== "yum / dnf"

    Set `enabled=1` in the `[cernvm-testing]` (or `[cernvm-future]`)
    section of `/etc/yum.repos.d/cernvm.repo`, or enable it for a single
    command:

    ```bash
    sudo dnf install --enablerepo=cernvm-testing cvmfs
    ```

=== "apt"

    Add the `-testing` suite to the `Suites` field in
    `/etc/apt/sources.list.d/cernvm.sources`, then run
    `sudo apt-get update`:

    ```text
    Suites: jammy-prod jammy-testing
    ```

    Pin the release with `apt` preferences if you want `prod` to remain
    the default. The `future` channel is not published for apt.

## Source Tarballs and Git

Release tarballs and the macOS / container packages for each version are
published under:

* <https://ecsft.cern.ch/dist/cvmfs/>

The source code is maintained on GitHub:

* <https://github.com/cvmfs/cvmfs>

See [Building from source](cpt-quickstart.md#building-from-source) for
compilation instructions.
