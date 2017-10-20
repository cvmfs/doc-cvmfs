Release Notes for CernVM-FS 2.4.2
=================================

CernVM-FS 2.4.2 is a patch release.  It contains bugfixes and adjustments for
stratum 0 and stratum 1 operations as well as for client-side cache plugins.
Clients not using the new cache plugins do not necessarily need to upgrade.

As with previous releases, upgrading clients should be seamless just by
installing the new package from the repository. As usual, we recommend to update
only a few worker nodes first and gradually ramp up once the new version proves
to work correctly. Please take special care when upgrading a cvmfs client in NFS
mode.

For Stratum 1 servers, there should be no running snapshots during the upgrade.
**Note**: if the configuration of the Stratum 1 server is handled by a
configuration management system (Puppet, Chef, ...), please see Section
:ref:`sct_manual_migration_242`.

For Release Manager Machines, all transactions must be closed before upgrading.

Note for upgrades from versions prior to 2.4.1: please also see the specific
instructions in the release notes for version 2.4.1 and earlier.

Bug Fixes and Improvements
--------------------------

  * Client: fix use of cached file catalog in cache plugins

  * Client: add ``cvmcache_get_session()`` to cache plugin API
    (`CVM-1368 <https://sft.its.cern.ch/jira/browse/CVM-1368>`_)

  * Client: improve logging for cache plugins

  * Server: skip external files during garbage collection
    (`CVM-1396 <https://sft.its.cern.ch/jira/browse/CVM-1396>`_)

  * Server: prevent diff viewer from recursing into hidden directories
    (`CVM-1384 <https://sft.its.cern.ch/jira/browse/CVM-1384>`_)

  * Server: fix variant symlink display on release manager machine
    (`CVM-1383 <https://sft.its.cern.ch/jira/browse/CVM-1383>`_)

  * Server: fix off-by-one error for chunk size when grafting files

  * Server: cache GeoAPI replies for 5 minutes, improve WSGI config
    (`CVM-1349 <https://sft.its.cern.ch/jira/browse/CVM-1349>`_)

  * Server: enforce explicit catalog TTL setting on publish
    (`CVM-1388 <https://sft.its.cern.ch/jira/browse/CVM-1388>`_)

  * Server: prevent overlayfs repositories on XFS ftype=0 spool directories
    (`CVM-1385 <https://sft.its.cern.ch/jira/browse/CVM-1385>`_)

  * Server: enforce numeric value when manually setting revision number
    (`CVM-1372 <https://sft.its.cern.ch/jira/browse/CVM-1372>`_)

.. _sct_manual_migration_242:

Manual Migration from 2.4.1 Stratum 1 Web Servers
-------------------------------------------------

If you are not using ``cvmfs_server migrate`` to automatically upgrade, web
servers serving Stratum 1 repositories can be migrated from version 2.4.1
with the following steps:

  1. Ensure that there are is no active replication or garbage collection
     process before updating the server software and during the repository
     layout migration.

  2. Install the ``cvmfs-server`` 2.4.2 package.

The Apache configuration for stratum 1 repositories should be adjusted as
follows:

  3. Remove the WSGI configuration, the ``Alias /cvmfs/$name/api``, and the
     ``<Directory /var/www/wsgi-scripts>`` directives from the
     repository-specific configuration

  4. Add a new Apache configuration file named ``cvmfs.+webapi.conf`` (sic,
     to make sure this file is alphabetically before the other configuration
     files) with the following content

::

      AliasMatch ^/cvmfs/([^/]+)/api/(.*)\$ /var/www/wsgi-scripts/cvmfs-server/cvmfs-api.wsgi/\$1/\$2
      WSGIDaemonProcess cvmfsapi threads=64 display-name=%{GROUP} \
        python-path=/usr/share/cvmfs-server/webapi
      <Directory /var/www/wsgi-scripts/cvmfs-server>
        WSGIProcessGroup cvmfsapi
        WSGIApplicationGroup cvmfsapi
        Options ExecCGI
        SetHandler wsgi-script
        # On Apache 2.4: replace the next two lines by
        # Require all granted
        Order allow,deny
        Allow from all
      </Directory>
      WSGISocketPrefix /var/run/wsgi


As a last step, update /etc/cvmfs/repositories.d/<REPOSITORY>/server.conf and
set ``CVMFS_CREATOR_VERSION=138``


Release Notes for CernVM-FS 2.4.1
=================================

CernVM-FS 2.4 is a feature release that comes with performance improvements,
new functionality, and bugfixes. We would like to thank Brian Bockelman
(U. Nebraska), Dave Dykstra (FNAL), and Tom Downes (U. Wisconsin) for their
contributions to this release!

There are several substantial improvements in this release, which are further
described below.

  * A plugin interface for the client cache together with an in-memory plugin

  * A built-in tiered cache manager

  * Instant access to named snapshots through the hidden .cvmfs/snapshots
    directory

  * Support for branching and diffing in CernVM-FS' internal versioning

  * Faster propagation of repository updates

  * Support for Yubikey 4 & NEO for signing CernVM-FS repository

  * Improved apt repository structure for Debian/Ubuntu packages

  * New platforms: Fedora 25 and 26 on x86_64, Debian 8 and 9,
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

**Note**: on Debian/Ubuntu platforms, please read Section
:ref:`sct_apt_migration` regarding hotpatching the client.


Cache Plugins
-------------

Every CernVM-FS client is configured to use a directory as local cache
of data and meta-data.  Instead of this directory, the task of maintaining a
local cache can optionally be performed by an external process, a "CernVM-FS
Cache Plugin" (`CVM-1054 <https://sft.its.cern.ch/jira/browse/CVM-1054>`_).
This allows for special-purpose cache managers in non-standard deployments, for
instance on supercomputers. Cache plugins can be developed and deployed
independently from the CernVM-FS client itself. CernVM-FS 2.4 provides one such
plugin, an in-memory cache that uses a fixed amount of RAM as a cache
(`CVM-1044 <https://sft.its.cern.ch/jira/browse/CVM-1044>`_).

See Section :ref:`sct_cache_advanced` for configuration and use of cache plugins
and Section :ref:`sct_plugin_cache` for an introduction on how to write cache
plugins.


Tiered Cache
------------

Together with support for cache plugins, there is now support for a multi-tier
client cache (`CVM-1050 <https://sft.its.cern.ch/jira/browse/CVM-1050>`_,
`CVM-1183 <https://sft.its.cern.ch/jira/browse/CVM-1183>`_). A tiered cache can
combine two other caches and organize them as an upper cache layer and a lower
cache layer. Data is first searched for in the upper layer. Upon an upper layer
cache miss, data is copied from the lower layer into the upper layer. Tiered
caches can be used to combine a small cache on fast storage (e.g. SSD, memory)
with a large cache on slower storage (e.g. HDD, network drive).

See Section :ref:`sct_cache_advanced` for configuration and use of a tiered
cache.


Instant Access to Named Snapshots
---------------------------------

A new server parameter, ``CVMFS_VIRTUAL_DIR=[true,false]``, can be used to
control the existance of the hidden top-level directory ``.cvmfs/snapshots`` in
a repository (`CVM-1062 <https://sft.its.cern.ch/jira/browse/CVM-1062>`_). If
enabled, the file system state referred to by the named tags can be browsed
through ``.cvmfs/snapshots/$tagname``. This feature requires a CernVM-FS 2.4
client, older clients show an empty ``.cvmfs/snapshots`` directory.

See Section :ref:`sct_instantsnapshotaccess` for further information.


Branching
---------

The new ``cvmfs_server checkout`` command can be used to branch off a certain
named snapshot in order to publish a fix for a previous repository state
(`CVM-1197 <https://sft.its.cern.ch/jira/browse/CVM-1197>`_). This feature makes
most sense for repositories that use the instant snapshot access (see above).

See Section :ref:`sct_branching` for further information.


Snapshot Diffs
--------------

The new ``cvmfs_server diff`` command can be used to show the difference set
between any two snapshots
(`CVM-1170 <https://sft.its.cern.ch/jira/browse/CVM-1170>`_). See Section
:ref:`sct_diffs` for further information.


Faster Propagation of Repository Updates
----------------------------------------

Several improvements have been made to reduce the time to propagate changes from
the release manager machine to clients.

  * The default repository time-to-live is reduced from 15 minutes to 4 minutes
    (`CVM-1336 <https://sft.its.cern.ch/jira/browse/CVM-1336>`_).
    Unless the ``CVMFS_REPOSITORY_TTL`` parameter is explicitly set, the first
    ``cvmfs_server publish`` command with version 2.4 reduces the time-to-live
    value.  Thus clients are instructed to check every 4 minutes for repository
    updates.

  * On RHEL 7 and newer, clients can actively evict old entries from kernel
    buffers (`CVM-1041 <https://sft.its.cern.ch/jira/browse/CVM-1041>`_).
    When clients see a new repository revision, they hence get rid of
    a 60 seconds delay to passively wait for local kernel buffers to expire.

  * The new server parameter ``CVMFS_GENERATE_LEGACY_BULK_CHUNKS=no`` can be
    used to omit creation of unchunked objects for large files
    (`CVM-640 <https://sft.its.cern.ch/jira/browse/CVM-640>`_).  This is most
    interesting for repositories hosting many files that are larger than 4MB.
    For those repositories, the speed of the publication process is improved by
    more than a factor of two.  This setting requires clients newer than version
    2.1.7.
    **Note for garbage collected repositories**: Besides the release manager
    machine, all stratum 1s need to run version 2.4, too. Otherwise they will
    delete the chunks of files with no bulk hash during garbage collection.


Yubikey Support
---------------

This release supports maintaining the repository master key on a Yubikey smart
card device (`CVM-1259 <https://sft.its.cern.ch/jira/browse/CVM-1259>`_). If the
masterkey is stored on such devices, it cannot be stolen even if the computer
hosting the repositories is compromised.

See Section :ref:`sct_master_keys` for further information.


.. _sct_apt_migration:

New apt Repositories
--------------------

Starting with this release, the apt repositories that provide deb packages for
Ubuntu and Debian are restructured. So far, all Debian based platforms got
packages built for Ubuntu 12.04. These packages are still used if the platform
is not recognized by the ``cvmfs-release`` package. For Debian stable platforms
and Ubuntu LTS releases, packages built for the specific platform are used
instead.

For Ubuntu 16.04 and Debian 8, the CernVM-FS apt repositories contain a fixed
version of the ``autofs`` package which is necessary to support the CernVM-FS
config repository.

**Note on client hotpatching**: packages from the new apt repository **cannot**
seamlessly upgrade previous cvmfs clients.  In order to upgrade the client,
please

  1. Run ``cvmfs_config umount`` to unmount all active repositories
  2. Upgrade to the cvmfs-release 2.X package and run ``apt-get update``
  3. Update the cvmfs client package.

This is a one-time migration. The next CernVM-FS release will again upgrade
seamlessly.


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

  * Server: fix potential deadlock during catalog commit phase
    (`CVM-1360 <https://sft.its.cern.ch/jira/browse/CVM-1360>`_)

  * Server: do not abort resiging on negative repository health check
    (`CVM-1358 <https://sft.its.cern.ch/jira/browse/CVM-1358>`_)

  * Server: resolve SElinux conflict on port 8000 with soundd on RHEL 7
    (`CVM-1308 <https://sft.its.cern.ch/jira/browse/CVM-1308>`_)

  * Server / S3: fix authentication timeouts for large transactions on Ceph
    (`CVM-1339 <https://sft.its.cern.ch/jira/browse/CVM-1308>`_)

Other Improvements
------------------

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

If you do not want to use ``cvmfs_server migrate`` to automatically upgrade,
release manager machines that maintain Stratum 0 repositories as well as web
servers serving stratum 0/1 repositories can be migrated from version 2.3.5 with
the following steps:

  1. Ensure that there are no open transactions and no active replication or
     garbage collection processes before updating the server software and during
     the repository layout migration.

  2. Install the ``cvmfs-server`` 2.4 package.

The Apache configuration on the release manager machine (resp. stratum 0) and
on stratum 1 repositories, as well as the configuration for the meta-data area
under ``/cvmfs/info``, should be adjusted as follows:

  3. Change ``AllowOverride Limit`` to ``AllowOverride Limit AuthConfig``

  4. Reduce the cache expiry for files of type ``application/x-cvmfs`` and
     ``application/json`` from 2 minutes to 61 seconds

  5. Add to the ``<Directoy>`` directive for the repository


::

      <FilesMatch "^[^.]*$">
        ForceType application/octet-stream
      </FilesMatch>


Reload the Apache service and perform the following steps for all repositories:

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
