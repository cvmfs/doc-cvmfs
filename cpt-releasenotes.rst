Release Notes for CernVM-FS 2.10.1
=================================

CernVM-FS 2.10.1 is a patch release, containing several minor bug fixes and improvements.
As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
For publisher and gateway nodes, all transactions must be closed and no active
leases must be present before upgrading.

Packages are available for both the x86_64 and aarch64 architectures. This version starts to deprecate support for Ubuntu 16.04.

Bug Fixes and Improvements
--------------------------

  * [server] cvmfs_server check can be extremely slow with many references to deduplicated files (`#3138 <https://github.com/cvmfs/cvmfs/issues/3138>`_)
  * [server] Make a parallelization limit on ``cvmfs_server snapshot -a`` (`#3064 <https://github.com/cvmfs/cvmfs/issues/3064>`_) 
  * [server] Succeeding cvmfs_server check should clear status in .cvmfs_status.json (`#3147 <https://github.com/cvmfs/cvmfs/issues/3147>`_)
  * [server] Reflog always recreated when running ``cvmfs_server check -r -i FQRN`` (`#3123 <https://github.com/cvmfs/cvmfs/issues/3123>`_)
  * [server] Unable to recover from publish failure (`#3088 <https://github.com/cvmfs/cvmfs/issues/3088>`_)
  * [server] Snapshot data file has doubled data (`#2991 <https://github.com/cvmfs/cvmfs/issues/2991>`_)
  * [gw/server]  Allow aborting a transaction when session token is missing (`#3159 <https://github.com/cvmfs/cvmfs/issues/3159>`_)
  * [client] attr -g logbuffer can overflow (`#2979 <https://github.com/cvmfs/cvmfs/issues/2979>`_)
  * [client] Misleading "Transfer fuse connection to new mount...success" message (`#2956 <https://github.com/cvmfs/cvmfs/issues/2956>`_)
  * [client] Error when creating sqlite-backed NFS maps (`#3150 <https://github.com/cvmfs/cvmfs/issues/3150>`_)
  * [client] ``cvmfs_config fuser`` runs too long on host with afs (`#3090 <https://github.com/cvmfs/cvmfs/issues/3090>`_)
  * [container] Container conversion does not recognize OCI manifest lists (`#3164 <https://github.com/cvmfs/cvmfs/issues/3164>`_)
  * [build system] Fix patching of leveldb external with busybox (`#3112 <https://github.com/cvmfs/cvmfs/issues/3112>`_)
  * [build system] Wrong permission in EL9 ARM package (`#3106 <https://github.com/cvmfs/cvmfs/issues/3106>`_)
  * [geo] Allow for missing location info in geo record (`#3190 <https://github.com/cvmfs/cvmfs/issues/3190>`_)





Release Notes for CernVM-FS 2.10.0
==================================

CernVM-FS 2.10.0 is a feature release containing new features, bug fixes and performance improvements.
Highlights are:

  * Support for proxy sharding with the new client option ``CVMFS_PROXY_SHARD={yes|no}``

  * Improved use of the kernel page cache resulting in significant client performance improvements in some scenarios (e.g., `#2879 <https://github.com/cvmfs/cvmfs/issues/2879>`_)

  * Fix for a long-standing open issue regarding the concurrent reading of changing files (`CVM-2001 <https://sft.its.cern.ch/jira/browse/CVM-2001>`_)

  * Support for unpacking container images through Harbor registry proxies in the container conversion tools

  * Various bugfixes and smaller improvements

New platforms: EL 9 (x86_64 and AArch64), AArch64 on Ubuntu

As with previous releases, upgrading should be seamless just by installing the new package from the repository. As usual, we recommend to update only a few worker nodes first and gradually ramp up once the new version proves to work correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading. For Stratum 1 servers, there should be no running snapshots during the upgrade. After the software upgrade, publisher nodes require doing cvmfs_server migrate for each repository.

.. note:: For gateway deployments, the cvmfs-server package on remote publishers needs to be updated in lockstep with the cvmfs-gateway package due to a `backwards compatibility bug <https://github.com/cvmfs/cvmfs/issues/3097>`_.

.. note:: The machine-readable output of ``cvmfs_server tag -x -l`` and ``cvmfs_server tag -x -i`` changed following the removal of the (unused) concept of "channels" from the CernVM-FS repository meta-data. In the output of these two commands, the second-last "channel" column has been removed.

.. note:: This release introduces a new base package, cvmfs-libs, that is now required by the cvmfs-server package. In future releases, more packages will depend on cvmfs-libs.

Bug fixes
---------

  * [client] Gracefully handle open, changing files (`CVM-2001 <https://sft.its.cern.ch/jira/browse/CVM-2001>`_)
  * [client] Fix race in the startup of the shared cache manager in debug mode (`#2910 <https://github.com/cvmfs/cvmfs/issues/2910>`_)
  * [client] Fix minor memory leak during reload (`#2976 <https://github.com/cvmfs/cvmfs/issues/2976>`_)
  * [client] Fix latency measurement of fuse callbacks (`#3025 <https://github.com/cvmfs/cvmfs/issues/3025>`_)
  * [server] Fix ingestion with a new nested catalog of an empty tarfile (`#3055 <https://github.com/cvmfs/cvmfs/issues/3055>`_)
  * [server] Fix creation of stratum 1 from HTTPS stratum 0 (`#2974 <https://github.com/cvmfs/cvmfs/issues/2974>`_)
  * [server] Avoid double-slash URLs in HTTP HEAD requests (`#2989 <https://github.com/cvmfs/cvmfs/issues/2989>`_)
  * [server] Fix check for open file descriptors before publishing
  * [server] Catch unexpected errors in transaction command (`#3004 <https://github.com/cvmfs/cvmfs/issues/3004>`_)
  * [gw] Remove too strict repository name check (`#2973 <https://github.com/cvmfs/cvmfs/issues/2973>`_)
  * Fixes for compiling on macOS > 10.15


Improvements and changes
------------------------

  * [client] Change default visibility of synthetic extended attributes to ``rootonly``
  * [client] Cancel network fail-over cycle when fuse request is canceled (`#2983 <https://github.com/cvmfs/cvmfs/issues/2983>`_)
  * [client] Add catalog hash to catalog_counters xattr (`#2900 <https://github.com/cvmfs/cvmfs/issues/2900>`_)
  * [server] Remove partial support for "channels" from manifest (`#2838 <https://github.com/cvmfs/cvmfs/issues/2838>`_)
  * [server] Ignore size of directories in ``cvmfs_server diff`` output
  * [server] Add OS version to meta.json (`#2863 <https://github.com/cvmfs/cvmfs/issues/2863>`_)
  * [server] Add /var/log/cvmfs to cvmfs-server rpm including SELinux label (`CVM-2070 <https://sft.its.cern.ch/jira/browse/CVM-2070>`_)
  * [container tools] Add support for container registry proxies through ``DUCC_<REGISTRY_NAME>_PROXY`` environment variable (`#2893 <https://github.com/cvmfs/cvmfs/issues/2893>`_)
  * [container tools] Support images with OCI manifest (`#2851 <https://github.com/cvmfs/cvmfs/issues/2851>`_)
