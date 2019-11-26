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

Pre-mounted Repository
----------------------

POSIX ACLs
----------

Client Performance Instrumentation
----------------------------------

(CVM-1770)

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
    (`CVM-1716 <https://sft.its.cern.ch/jira/browse/CVM-1716>`_,
     `CVM-1717 <https://sft.its.cern.ch/jira/browse/CVM-1717>`_,
     `CVM-1718 <https://sft.its.cern.ch/jira/browse/CVM-1718>`_,
     `CVM-1719 <https://sft.its.cern.ch/jira/browse/CVM-1719>`_,
     `CVM-1720 <https://sft.its.cern.ch/jira/browse/CVM-1720>`_)

  * Server, gateway: fix clashing generic tags for short transactions
    (`CVM-1735 <https://sft.its.cern.ch/jira/browse/CVM-1735>`_)

  * Server, DUCC: use relative symbolic links
    (`CVM-1817 <https://sft.its.cern.ch/jira/browse/CVM-1817>`_)


Other Improvements
------------------

  * Client: enable default config repository on Debian stretch and newer
    (`CVM-1794 <https://sft.its.cern.ch/jira/browse/CVM-1794>`_)

  * Client: add new magic extended attribute ``repo_counters``
    (`CVM-1499 <https://sft.its.cern.ch/jira/browse/CVM-1499>`_)

  * Client: add new magic extended attribute ``repo_metainfo``
    (`CVM-1733 <https://sft.its.cern.ch/jira/browse/CVM-1733>`_)

  * Client: enforce ``CVMFS_NFILES`` parameter only when mounting through
    mount helper

  * Client: add support for ``CVMFS_LIBRARY_PATH`` environment variable in
    order to facilitate standalone deployment

  * Server: add support for extended attributes on directories

  * Server: add ``filestats`` command to ``cvmfs_swisknife``
    (`CVM-1756 <https://sft.its.cern.ch/jira/browse/CVM-1756>`_)

  * Server: add ``list_reflog`` command to ``cvmfs_swisknife``
    (`CVM-1756 <https://sft.its.cern.ch/jira/browse/CVM-1760>`_)

