Release Notes for CernVM-FS 2.7.0
=================================

CernVM-FS 2.7 is a feature release that comes with performance improvements,
new functionality, support for new platforms, and bugfixes.

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

Bug Fixes
---------

  * Client:
    (`CVM-XXX <https://sft.its.cern.ch/jira/browse/CVM-XXX>`_)


Other Improvements
------------------

