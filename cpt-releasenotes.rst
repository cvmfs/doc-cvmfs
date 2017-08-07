Release Notes for CernVM-FS 2.4
===============================

CernVM-FS 2.4 is a feature release that comes with performance improvements,
new functionality, and bugfixes. We would like to thank Dave Dykstra (FNAL) and
Brian Bockelman (U. Nebraska) for their contributions to this release!

There are several substantial improvements in this release, which are further
described below.

  * A plugin interface for the client cache together with an in-memory plugin

  * A built-in tiered cache manager

  * Instant access to named snapshots through the hidden .cvmfs/snapshots
    directory

  * Support for branching in CernVM-FS' internal versioning

  * Faster propagation of repository updates

  * Support for Yubikey 4 & NEO for signing CernVM-FS repository

  * Improved apt repository structure for Debian/Ubuntu packages

  * New platforms: Fedora 25 and 26 on x86_64, Debian 8,
    gcc >= 6, OpenSSL >= 1.1

As with previous releases, upgrading should be seamless just by installing the
new package from the repository. As usual, we recommend to update only a few
worker nodes first and gradually ramp up once the new version proves to work
correctly. Please take special care when upgrading a client in NFS mode.

For Stratum 0 servers, all transactions must be closed before upgrading.  After
the software upgrade, the directory layout on the release manager needs to be
adjusted by a call to ``cvmfs_server migrate`` for each repository.

For Stratum 1 server, there should be no running snapshots during the upgrade.

**Note**: if the configuration of the Stratum 0/1 server is handled by a
configuration management system (Puppet, Chef, ...), please see Section
:ref:`sct_manual_migration`.

Cache Plugins
-------------

Tiered Cache
------------

Instant Access to Named Snapshots
---------------------------------

Branching
---------

Yubikey Support
---------------

New apt Repositories
--------------------


Please find below the list of bugfixes and smaller improvements.

Bug Fixes
---------

  * Client: fix small memory leak during remount of root catalog

  * Client: fix handling of file:// url in CVMFS_SERVER_URL

  * Client: fix ``cvmfs_config reload`` under root environment with dependencies
    into /cvmfs (`CVM-1352 <https://sft.its.cern.ch/jira/browse/CVM-1352>`_)

  * Client: fix mount helper for very long lines in /etc/group
    (`CVM-1304 <https://sft.its.cern.ch/jira/browse/CVM-1304>`_)

  * Client: fix mount helper if repository name resolves to local path
    (`CVM-1106 <https://sft.its.cern.ch/jira/browse/CVM-1106>`_)

  * Client: fix shell errors when required config repo cannot be mounted
    (`CVM-1300 <https://sft.its.cern.ch/jira/browse/CVM-1300>`_)

  * Client / macOS: fix cache size reporting in 'df'
    (`CVM-1286 <https://sft.its.cern.ch/jira/browse/CVM-1286>`_)

  * Client / macOS: fix ``cvmfs_config reload``

  * Client / X509 Auth: Use default X509_CERT_DIR also if it is empty string
    (`CVM-1083 <https://sft.its.cern.ch/jira/browse/CVM-1083>`_)

  * Server: resolve SElinux conflict on port 8000 with soundd on RHEL 7
    (`CVM-1308 <https://sft.its.cern.ch/jira/browse/CVM-1308>`_)

  * Server / S3: fix authentication timeouts for large transactions on Ceph
    (`CVM-1339 <https://sft.its.cern.ch/jira/browse/CVM-1308>`_)

Improvements
------------

  * Client: allow for config repository on Ubuntu >= 16.04, Debian >= 8
    (`CVM-771 <https://sft.its.cern.ch/jira/browse/CVM-771>`_)

  * Client: cache proxy settings in workspace directory
    (`CVM-1156 <https://sft.its.cern.ch/jira/browse/CVM-1156>`_)

  * Client: improve stratum 1 geo sorting with active fallback proxy
    (`CVM-769 <https://sft.its.cern.ch/jira/browse/CVM-769>`_)

  * Client: add support for CVMFS_OOM_SCORE_ADJ to adjust the out-of-memory
    priority (`CVM-1092 <https://sft.its.cern.ch/jira/browse/CVM-1092>`_)

  * Client: add support for revoking repository revisions up to a threshold in
    the blacklist (`CVM-992 <https://sft.its.cern.ch/jira/browse/CVM-992>`_)

  * Client: perform fail-over when whitelist or manifest is corrupted
    (`CVM-837 <https://sft.its.cern.ch/jira/browse/CVM-837>`_)

  * Client: add ``cvmfs_talk remount sync`` command

  * Cient: use cache for fetching history database on mount

  * Client: show all ``CVMFS_...`` parameters in ``cvmfs_config showconfig``
    (`CVM-1180 <https://sft.its.cern.ch/jira/browse/CVM-1180>`_)

  * Client: add ``cvmfs_config showconfig -s`` option to show only non-empty
    parameters

  * Client: add ``ncleanup24`` xattr and Nagios check for cleanup rate
    (`CVM-1097 <https://sft.its.cern.ch/jira/browse/CVM-1097>`_)

  * Client / macOS: use built-in LibreSSL on macOS
    (`CVM-1112 <https://sft.its.cern.ch/jira/browse/CVM-1112>`_)

  * Server: add ``cvmfs_server diff`` command
    (`CVM-1170 <https://sft.its.cern.ch/jira/browse/CVM-1170>`_)

  * Server: add ``cvmfs_server gc -a`` option to garbage collect all applicable
    repositories (`CVM-1095 <https://sft.its.cern.ch/jira/browse/CVM-1095>`_)

  * Server: make ``cvmfs_server catalog-chown`` command public
    (`CVM-1077 <https://sft.its.cern.ch/jira/browse/CVM-1077>`_)

  * Server: add ``cvmfs_server resign -w`` for stand-alone whitelist resigning
    (`CVM-1265 <https://sft.its.cern.ch/jira/browse/CVM-1265>`_)

  * Server: add ``cvmfs_server resign -p`` command to facilitate repository key
    rotation (`CVM-1140 <https://sft.its.cern.ch/jira/browse/CVM-1140>`_)

  * Server: add ``cvmfs_server resign -d`` option to change whitelist expiration
    duration (`CVM-1279 <https://sft.its.cern.ch/jira/browse/CVM-1279>`_)

  * Server: add ``cvmfs_server check -r`` command to repair reflog checksum
    (`CVM-1240 <https://sft.its.cern.ch/jira/browse/CVM-1240>`_)

  * Server: allow ext3 as spool file system on RHEL 7.3 / overlayfs
    (`CVM-1186 <https://sft.its.cern.ch/jira/browse/CVM-1186>`_)

  * Server: Optionally ignore special files with a warning on publish with
    ``CVMFS_IGNORE_SPECIAL_FILES``
    (`CVM-1106 <https://sft.its.cern.ch/jira/browse/CVM-1106>`_)

  * Server: increase maximum repostory name from ~30 chars to 60 chars
    (`CVM-1173 <https://sft.its.cern.ch/jira/browse/CVM-1173>`_)

  * Server: trim trailing whitespaces from .cvmfsdirtab entries
    (`CVM-1061 <https://sft.its.cern.ch/jira/browse/CVM-1061>`_)

  * Server / rsync: use rsync's "perishable" feature instead of list-catalogs
    (`CVM-1199 <https://sft.its.cern.ch/jira/browse/CVM-1199>`_)

  * Server: allow for Apache 2.4 style access controls on repositories
    (`CVM-1255 <https://sft.its.cern.ch/jira/browse/CVM-1255>`_)

  * Server: add support for ``CVMFS_{ROOT|NESTED}_KCATALOG_LIMIT``,
    ``CVMFS_FILE_MBYTE_LIMIT``, ``CVMFS_ENFORCE_LIMITS`` to set publish limits
    (`CVM-1094 <https://sft.its.cern.ch/jira/browse/CVM-1094>`_,
    `CVM-1123 <https://sft.its.cern.ch/jira/browse/CVM-1123>`_)

  * Server: improve error reporting
    (`CVM-1241 <https://sft.its.cern.ch/jira/browse/CVM-1241>`_,
    `CVM-1246 <https://sft.its.cern.ch/jira/browse/CVM-1246>`_,
    `CVM-1267 <https://sft.its.cern.ch/jira/browse/CVM-1267>`_,)


.. _sct_manual_migration:

Manual Migration from 2.3.5 Release Manager Machines and Stratum 0/1 Web Servers
--------------------------------------------------------------------------------

Release manager machines that maintain Stratum 0 repositories as well as web
servers serving stratum 0/1 repositories can be migrated from version 2.3.5 with
the following steps:

  1. Ensure that there are no open transactions and no active replication or
     garbage collection processes before updating the server software and during
     the repository layout migration.

  2. Install the ``cvmfs-server`` 2.4 package.

The Apache configuration on the release manager machine (resp. stratum 0) and
on stratum 1 repositories, as well as the configuration for the meta-data area
under ``/cvmfs/info``, should be adjusted as follows:

  3. Add to the ``<Directoy>`` directive for the repository

::

      <FilesMatch "^[^.]*$">
        ForceType application/octet-stream
      </FilesMatch>

  4. Change ``AllowOverride Limit`` to ``AllowOverride Limit AuthConfig``

  5. Reduce the cache expiry for files of type ``application/x-cvmfs`` and
     ``application/json`` from 2 minutes to 61 seconds

  6. Reload Apache

The following steps have to be performed for all repositories on the release
manager machine:

  7. *Only on release manager machines*: remove the
     ``CVMFS_CATALOG_ENTRY_WARN_THRESHOLD`` parameter.  If it was set to a value
     other than 500000, set ``CVMFS_ROOT_KCATALOG_LIMIT=500`` and
     ``CVMFS_NESTED_KCATALOG_LIMIT=500``.  Consider setting a lower limit for
     ``CVMFS_ROOT_KCATALOG_LIMIT``.

  8. Update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and set
     ``CVMFS_CREATOR_VERSION=137``

On release manager machines, in agreement with the repository owner it's
recommended to make a test publish

::

    cvmfs_server transaction <REPOSITORY>
    cvmfs_server publish <REPOSITORY>

before resuming normal operation.
