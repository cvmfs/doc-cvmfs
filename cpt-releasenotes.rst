Release Notes for CernVM-FS 2.7.0
=================================

CernVM-FS 2.7 is a feature release that comes with performance improvements,
new functionality, and bugfixes.

CernVM-FS 2.7 includes support for the new platform EL8 (RHEL8, CentOS8, etc.),
Debian 10, and macOS 10.15 "Catalina".

As with previous releases, upgrading should be seamless just by installing the
new package from the repository. As usual, we recommend to update only a few
worker nodes first and gradually ramp up once the new version proves to work
correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading.
For Stratum 1 servers, there should be no running snapshots during the upgrade.
After the software upgrade, publisher nodes (``stratum 0``) require doing
``cvmfs_server migrate`` for each repository.


Fuse 3 Support
--------------

The CernVM-FS client support both libfuse 2 and libfuse 3 platforms. The
libfuse libraries are part of the system's fuse package. The libfuse libraries
take care of the low-level communication with the Fuse kernel module. The
libfuse 3 libraries provide new features and performance improvements; they
can be installed side-by-side to the libfuse 2 libraries. If libfuse 3 is
available and the ``cvmfs-fuse3`` package is installed, the CernVM-FS client
will automatically use libfuse 3, otherwise it falls back to libfuse 2. A
libfuse version can be enforced by setting the ``libfuse=[2,3]`` mount option.

For the EL6 and EL7 platforms, libfuse 3 libraries are provided in the
fuse3-libs package through EPEL.


Pre-mounted Repository
----------------------

Mounting a CernVM-FS repository involves calling the ``mount()`` system call
on /dev/fuse. This is ususally done by the ``fusermount`` utility, which is
part of the fuse system package. As of libfuse 3, the task of mounting
/dev/fuse can be offloaded to an external, custom utility.  Such an external
executable "pre-mounts" the repository and allows for easier integration in
special environments. This functionality has been integrated with
`Singularity 3.4 <https://github.com/sylabs/singularity/releases/tag/v3.4.0>`_.
See :ref:`Pre-mounting <sct_premount>` for more details.


POSIX ACLs
----------

CernVM-FS repositories can store and enforce POSIX ACLs. In order to store ACLs
during publication, simply enable extended attributes by setting
``CVMFS_INCLUDE_XATTRS=true`` in the repository's server.conf coniguration
file. In order to enforce ACLs on client side, set ``CVMFS_ENFORCE_ACLS=true``
in the client configuration. Enforcing POSIX ACLs requires libfuse 3 on the
client node. If only libfuse 2 is available, the client will reject to mount
with enforced ACLs.

Note that enforcing ALCs usually only makes sense in concert with a secure
distribution infrastructure (see :ref:`Large-Scale Data <sct_data>`,
:ref:`Authorization Helpers <sct_authz>`).


Client Performance Instrumentation
----------------------------------

The CernVM-FS client can record a histogram of wall-clock time spent in the
different Fuse callback routines
(`CVM-1770 <https://sft.its.cern.ch/jira/browse/CVM-1770>`_).
Recording is enabled by setting the client configuration variable
``CVMFS_INSTRUMENT_FUSE=true``. The time distribution historgrams are displayed
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

  * Client: fix sprious error message with ``auto;DIRECT`` if proxy auto
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

  * Server: add ``filestats`` command to ``cvmfs_swisknife``
    (`CVM-1756 <https://sft.its.cern.ch/jira/browse/CVM-1756>`_)

  * Server: add ``list_reflog`` command to ``cvmfs_swisknife``
    (`CVM-1756 <https://sft.its.cern.ch/jira/browse/CVM-1760>`_)
