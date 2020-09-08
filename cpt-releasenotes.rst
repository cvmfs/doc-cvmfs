Release Notes for CernVM-FS 2.7.4
=================================

CernVM-FS 2.7.4 is a patch release. It contains bugfixes and improvements for
Ubuntu clients and servers. At the same time, we release a new
cvmfs-config-default package (see below).

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to
update only a few worker nodes first and gradually ramp up once the new version
proves to work correctly. Please take special care when upgrading a cvmfs
client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

Note for upgrades from versions prior to 2.7.3: please also see the specific
instructions in the release notes for version 2.7.3 and earlier.


Updates in cvmfs-config-default 2.0
-----------------------------------

The new cvmfs-config-default packages brings several improvements and
simplifications.

Please note that this does _not_ affect clients that use
the cvmfs-config-egi or the cvmfs-config-osg package (or another alternative
config package). In particular, most of the grid worker nodes do not use the
cvmfs-config-default package.

Note that while released together with CernVM-FS 2.7.4, the client package
and the cvmfs-config-default package can be deployed indepently from each
other and in any order.

The new cvmfs-config-default package brings the following changes:

  1. A number of minor improvements to the default configuration (tuning
     parameters, documentation, etc.)

  2. Making better use of the cvmfs config repository
     (/cvmfs/cvmfs-config.cern.ch), which now should, if available, override
     the configuration from the package; this allows for faster configuration
     fixes if necessary

  3. Auto-configuration of the proxy servers for users having the clients on
     roaming machines (laptops). For instance, CernVM-FS can now automatically
     pick the CERN site proxy when on site, while connecting directly to the
     stratum 1 server when the node is at home. Users with a single client (not
     a cluster) can now use ``CVMFS_CLIENT_PROFILE=single`` and do not need
     to explicitly set a proxy server.


Bug Fixes and Improvements
--------------------------

  * Client / Debian, Ubuntu: remove deprecated packages from the dependency list
    (`CVM-1897 <https://sft.its.cern.ch/jira/browse/CVM-1897>`_)
  * Client / Ubuntu: provide cvmfs-fuse3 package on Ubuntu 20.04
    (`CVM-1898 <https://sft.its.cern.ch/jira/browse/CVM-1898>`_)
  * Server: fix ingestion of tarballs with leading slashes
    (`CVM-1907 <https://sft.its.cern.ch/jira/browse/CVM-1907>`_)
  * Server: fix name clash with certain, concurrently hosted repository names
    (`CVM-1899 <https://sft.its.cern.ch/jira/browse/CVM-1899>`_)
  * Gateway: fix statistics counting when renaming trees with nested catalogs
    (`CVM-1906 <https://sft.its.cern.ch/jira/browse/CVM-1906>`_)

Note: there is a new `cvmfs_server fix-stats` command that can be used to
fix-up statistics counters for a repository.  This command allows to recover
from the bug fixed in CVM-1906.



Release Notes for CernVM-FS 2.7.3
=================================

CernVM-FS 2.7.3 is a patch release. It contains bugfixes and improvements for
clients and servers.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to
update only a few worker nodes first and gradually ramp up once the new version
proves to work correctly. Please take special care when upgrading a cvmfs
client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

Note for upgrades from versions prior to 2.7.2: please also see the specific
instructions in the release notes for version 2.7.2 and earlier.

Bug Fixes and Improvements
--------------------------

  * Add Ubuntu 20 and Fedora 32 packages
  * Client / EL8: fix spurious SElinux error message during package upgrade
    (`CVM-1878 <https://sft.its.cern.ch/jira/browse/CVM-1878>`_)
  * Client: fix `cvmfs_config chksetup` for squashed NFS alien cache
    (`CVM-1888 <https://sft.its.cern.ch/jira/browse/CVM-1888>`_)
  * Server: fix handling of .cvmfs_status.json after garbage collection
    (`CVM-1887 <https://sft.its.cern.ch/jira/browse/CVM-1887>`_)
  * Server: add `add-replica -P` option to create pass-through replicas
    (`CVM-1845 <https://sft.its.cern.ch/jira/browse/CVM-1845>`_)
  * Fix building with GCC >= 10
    (`CVM-1894 <https://sft.its.cern.ch/jira/browse/CVM-1894>`_)


Release Notes for CernVM-FS 2.7.2
=================================

CernVM-FS 2.7.2 is a patch release. It contains bugfixes and improvements for
clients and servers. Together with version 2.7.2, we release the cvmfs-gateway
1.1.1 patch release.  Publishers using the gateway should upgrade in lockstep.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to
update only a few worker nodes first and gradually ramp up once the new version
proves to work correctly. Please take special care when upgrading a cvmfs
client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading. The cvmfs-gateway package 1.1.1 should
be rolled out together with the cvmfs-server 2.7.2 package.

Note for upgrades from versions prior to 2.7.1: please also see the specific
instructions in the release notes for version 2.7.1 and earlier.

Bug Fixes and Improvements
--------------------------

  * Client: optimize loading of nested catalogs
    (`CVM-1848 <https://sft.its.cern.ch/jira/browse/CVM-1848>`_)

  * Client: improve logging when switching hosts
    (`CVM-1844 <https://sft.its.cern.ch/jira/browse/CVM-1844>`_)

  * Client: add `cvmfs_talk latency` command

  * Server: fix creation of nested catalogs by ingestion command
    (`CVM-1862 <https://sft.its.cern.ch/jira/browse/CVM-1862>`_)

  * Server: minor improvements to geo db command line interface
    (`CVM-1850 <https://sft.its.cern.ch/jira/browse/CVM-1850>`_, `CVM-1851 <https://sft.its.cern.ch/jira/browse/CVM-1851>`_)

  * Gateway: fix lease acquisiton on non-existing path
    (`CVM-1696 <https://sft.its.cern.ch/jira/browse/CVM-1696>`_)

  * Gateway: use watchdog for cvmfs_receiver
    (`CVM-1864 <https://sft.its.cern.ch/jira/browse/CVM-1864>`_)

  * Fix packaging for Fedora 31


Release Notes for CernVM-FS 2.7.1
=================================

CernVM-FS 2.7.1 is a patch release. It contains bugfixes and improvements for
clients and stratum 1 servers. Upgrading on publisher and gateway nodes is
not necessary.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to
update only a few worker nodes first and gradually ramp up once the new version
proves to work correctly. Please take special care when upgrading a cvmfs
client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

Note for stratum 1 servers: the upstream delivery mechanism for the GeoIP
database changed. See :ref:`Geo API Setup <sct_geoip_db>` for more details.

Note for upgrades from versions prior to 2.7.0: please also see the specific
instructions in the release notes for version 2.7.0 and earlier.

Bug Fixes and Improvements
--------------------------

  * Client: fix host fail-over for redirected stratum 1 sources
    (`CVM-1675 <https://sft.its.cern.ch/jira/browse/CVM-1675>`_)

  * Client: add Fuse 3 support on Debian 10 "buster"
    (`CVM-1825 <https://sft.its.cern.ch/jira/browse/CVM-1825>`_)

  * Client: add reboot notice to macOS Catalina installation screen

  * Server: add support for CVMFS_GEO_DB_FILE and CVMFS_GEO_LICENSE_KEY
    to adjust to upstream GeoIP database delivery mechanism
    (`CVM-1833 <https://sft.its.cern.ch/jira/browse/CVM-1833>`_)


Release Notes for CernVM-FS 2.7.0
=================================

CernVM-FS 2.7 is a feature release that comes with performance improvements,
new functionality, and bugfixes.

CernVM-FS 2.7 includes support for the new platform EL8 (RHEL8, CentOS8, etc.),
Debian 10, and macOS 10.15 "Catalina". Note that on Catalina, in contrast to
previous versions a reboot is required to finalize the installation.

As with previous releases, upgrading should be seamless just by installing the
new package from the repository. As usual, we recommend to update only a few
worker nodes first and gradually ramp up once the new version proves to work
correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading.
For Stratum 1 servers, there should be no running snapshots during the upgrade.
After the software upgrade, publisher nodes require doing
``cvmfs_server migrate`` for each repository.


Fuse 3 Support
--------------

This release adds support for libfuse 3 platforms in addition to libfuse 2. The
libfuse libraries are part of the system's fuse package. The libfuse libraries
take care of the low-level communication with the Fuse kernel module. The
libfuse 3 libraries provide new features and performance improvements; they
can be installed side-by-side with the libfuse 2 libraries. If libfuse 3 is
available and the ``cvmfs-fuse3`` package is installed, the CernVM-FS client
will automatically use libfuse 3, otherwise it falls back to libfuse 2. A
libfuse version can be enforced by setting the ``libfuse=[2,3]`` mount option.

For the EL6 and EL7 platforms, libfuse 3 libraries are provided in the
fuse3-libs package through EPEL.


Pre-mounted Repository
----------------------

This release adds support for "pre-mounted" repositories.  Mounting a CernVM-FS
repository involves calling the ``mount()`` system call on /dev/fuse. This is
usually done by the ``fusermount`` utility, which is part of the fuse system
package. As of libfuse 3, the task of mounting /dev/fuse can be offloaded to an
external, custom utility.  Such an external executable "pre-mounts" the
repository and allows for easier integration in special environments. This
functionality has been integrated with
`Singularity 3.4 <https://github.com/sylabs/singularity/releases/tag/v3.4.0>`_.
See :ref:`Pre-mounting <sct_premount>` for more details.


POSIX ACLs
----------

This release adds support for storing and enforcing POSIX ACLs. In order to store
ACLs during publication, simply enable extended attributes by setting
``CVMFS_INCLUDE_XATTRS=true`` in the repository's server.conf configuration
file. Note that ACLs require overlayfs as a union file system; aufs does not
support storing ACLs. For systems with both aufs and overlayfs installed, the
``CVMFS_UNION_FS_TYPE`` parameter can be used to select overlayfs.

In order to enforce ACLs on the client side, set ``CVMFS_ENFORCE_ACLS=true``
in the client configuration. Enforcing POSIX ACLs requires libfuse 3 on the
client node. If only libfuse 2 is available, the client will refuse to mount
with enforced ACLs.

Note that enforcing ACLs usually only makes sense in concert with a secure
distribution infrastructure (see :ref:`Large-Scale Data <sct_data>`,
:ref:`Authorization Helpers <sct_authz>`).


Client Performance Instrumentation
----------------------------------

The CernVM-FS client can now record a histogram of wall-clock time spent in the
different Fuse callback routines
(`CVM-1770 <https://sft.its.cern.ch/jira/browse/CVM-1770>`_).
Recording is enabled by setting the client configuration variable
``CVMFS_INSTRUMENT_FUSE=true``. The time distribution histograms are displayed
in the ``cvmfs_talk internal affairs`` command.


Bug Fixes
---------

  * Client: fix stale negative entries in active cache eviction
    (`CVM-1759 <https://sft.its.cern.ch/jira/browse/CVM-1759>`_)

  * Client: fix potentially incomplete parsing of /etc/hosts

  * Client: fix potential file descriptor mix-up of external cache manager
    after reload

  * Client: fix repository updates on shared, writable alien cache
    (`CVM-1803 <https://sft.its.cern.ch/jira/browse/CVM-1803>`_)

  * Client: fix missing package dependency on Debian 9 and Ubuntu 18.04
    (`CVM-1789 <https://sft.its.cern.ch/jira/browse/CVM-1789>`_)

  * Client: fix spurious error message when starting external cache manager

  * Client: fix spurious error message with ``auto;DIRECT`` if proxy auto
    discovery returns an empty list
    (`CVM-1818 <https://sft.its.cern.ch/jira/browse/CVM-1818>`_)

  * Client, macOS >= 10.15: set default mount point to /Users/Shared/cvmfs
    with a firm link from /cvmfs to the new destination
    (`CVM-1813 <https://sft.its.cern.ch/jira/browse/CVM-1813>`_)

  * Server: fix publish statistics for several corner cases
    (`CVM-1716 <https://sft.its.cern.ch/jira/browse/CVM-1716>`_ - `CVM-1720 <https://sft.its.cern.ch/jira/browse/CVM-1720>`_)

  * Server, gateway: fix clashing generic tags for short transactions
    (`CVM-1735 <https://sft.its.cern.ch/jira/browse/CVM-1735>`_)

  * Server, DUCC: use relative symbolic links
    (`CVM-1817 <https://sft.its.cern.ch/jira/browse/CVM-1817>`_)


Other Improvements
------------------

  * Client: enable default config repository on Debian stretch and newer
    (`CVM-1794 <https://sft.its.cern.ch/jira/browse/CVM-1794>`_)

  * Client: add new magic extended attribute ``repo_counters``
    (`CVM-1733 <https://sft.its.cern.ch/jira/browse/CVM-1733>`_)

  * Client: add new magic extended attribute ``repo_metainfo``
    (`CVM-1499 <https://sft.its.cern.ch/jira/browse/CVM-1499>`_)

  * Client: enforce ``CVMFS_NFILES`` parameter only when mounting through
    mount helper

  * Client: add support for ``CVMFS_LIBRARY_PATH`` environment variable in
    order to facilitate standalone deployment

  * Server: add support for extended attributes on directories

  * Server: add ``filestats`` command to ``cvmfs_swissknife``
    (`CVM-1756 <https://sft.its.cern.ch/jira/browse/CVM-1756>`_)

  * Server: add ``list_reflog`` command to ``cvmfs_swissknife``
    (`CVM-1756 <https://sft.its.cern.ch/jira/browse/CVM-1760>`_)
