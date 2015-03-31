# 31. March 2015: CernVM-FS 2.1.20

CernVM-FS version 2.1.20 is out. Version 2.1.20 contains a number of new features and several bugfixes. We would like to thank our collegues from Fermilab and from CERN openlab for their many contributions!

Together with CernVM-FS 2.1.20, we also release a new version of the [documentation](http://cernvm.cern.ch/portal/filesystem/techinformation) and a new version of the [Nagios check](http://cernvm.cern.ch/portal/filesystem/downloads#nagios).

Substential improvements in this release are

  - Better separation of the cvmfs software and its configuration.  The cvmfs-keys package is replaced by one or multiple packages providing the "cvmfs-config" capability (see below).

  - Automatic selection of stratum 1 servers by the clients according to geographical location.

  - Support for S3 compatible storage as a backend for stratum 0 and stratum 1 servers.  Please see the updated documentation for details and configuration.

  - Support for garbage-collected repositories that can be used to host nightly build products in a way that is more gentle on resources. Please see the updated documentation for details and configuration.

On the client side, new platforms are SL/CentOS 7, Fedora 21, and openSuSE 13.1.  Please note that support for SL/CentOS 7 for the stratum 0 is scheduled for the next release.

As in previous releases, upgrading should be seamless just by installing the new RPM from the repository.  The RPM upgrade should also take care of replacing the cvmfs-keys package by the cvmfs-config-default package except for SL5 systems, which require `yum erase ...` followed by `yum install ...` (see below). For all upgrades, we recommend to upgrade in stages starting with a small fraction of worker nodes first followed by a ramp up if there are no problems.

This release has been tested at two WLCG Tier 1 centers for the last couple of weeks.

**Please note that some configuration recommendations change with this release. In particular the manual stratum 1 server ordering in the file /etc/cvmfs/domain.d/cern.ch.local should be removed. If the location of the keys has been copied from the /etc/cvmfs/domain.d/cern.ch.conf file (e.g. the file contains a line "CVMFS_PUBLIC_KEY=/etc/cvmfs/keys/cern.ch.pub"), it will overwrite the new location of the public keys from the cvmfs-config-default package and the hot patch will fail.  Setting CVMFS_PUBLIC_KEY in /etc/cvmfs/domain.d/cern.ch.local is not recommended but the parameter might be present nevertheless.**

Below you'll find details on the new features and changes, followed by the usual list of bugfixes and smaller improvements.


## The cvmfs-config-... RPMs

Following the request to separate the cvmfs software from the CERN configuration, the cvmfs package has now a clean vanilla configuration without references to CERN and without the corresponding public keys. As such the cvmfs package is not useful in most cases and should be accompanied by one or several cvmfs-config-... packages providing public keys and configuration files in /etc/cvmfs.  In RPM speak, these packages provide the "capability" cvmfs-config.  We provide two such packages.  The cvmfs-config-none package is empty and only satisfies the requirement of the cvmfs package.  The cvmfs-config-default packages provides access to repositories under the cern.ch, egi.eu, and opensciencegrid.org domains.  This package replaces the cvmfs-keys and the cvmfs-init-scripts packages.

On most systems, yum does the package migration automatically just by updating the cvmfs package from our testing repository. On Scientific Linux 5, the old cvmfs, cvmfs-keys, and cvmfs-init-scripts packages need to be manually removed (`yum erase ...`) before the new cvmfs and cvmfs-config-default can be installed.  The worker nodes do not need to be drained.  Repositories that are in use will not be unmounted by removing the old cvmfs rpm.  Installation of the new cvmfs rpm will then perform the hotpatch as ususal.

Note that the cvmfs-config-default package places the keys for the different domains (cern.ch, egi.eu, opensciencegrid.org) in different sub directories as compared to the plain directory layout in /etc/cvmfs/keys use by the cvmfs-keys package.  This is transparent for clients but not for stratum 1 servers.  Stratum 1 servers that replicate repositories from one of these domains can either

  1. continue to use the cvmfs-keys package if the cvmfs client package is not needed on the same machine
  2. Update to cvmfs-config-default and edit /etc/cvmfs/repositories.d/$repository/replica.conf and set CVMFS_PUBLIC_KEY accordingly

If you want to create a custom cvmfs-config-... rpm, we are happy to provide assistance!

Related JIRA tickets: [CVM-617](https://sft.its.cern.ch/jira/browse/CVM-617), [CVM-652](https://sft.its.cern.ch/jira/browse/CVM-652), [CVM-641](https://sft.its.cern.ch/jira/browse/CVM-641), [CVM-614](https://sft.its.cern.ch/jira/browse/CVM-614)


## The "Config Repository"

Clients can be configured with a single "config repository" such as cvmfs-config.cern.ch.  The config repository provides and additional location to store public keys and configuration using the same structure that exists under /etc/cvmfs.  This allows a stable set of keys and configuration to be distributed by cvmfs-config-... rpms, whereas smaller or more dynamic repositories can be maintained on the dedicated cvmfs config repository.  The config repository can be set by the CVMFS_CONFIG_REPOSITORY parameter.  In the cvmfs-config-default rpm, it is currently set to "cvmfs-config.cern.ch" but this might change in the future. The config repository is always mounted when any other repository gets mounted. On installations that do not use autofs, the config repository should be manually mounted.

The autofs package on Debian/Ubuntu systems unfortunately suffers from a bug that prevents the cvmfs config repository from being automatically mounted.  We are looking into a workaround.

Related JIRA tickets: [CVM-616](https://sft.its.cern.ch/jira/browse/CVM-616), [CVM-618](https://sft.its.cern.ch/jira/browse/CVM-618), [CVM-619](https://sft.its.cern.ch/jira/browse/CVM-619), [CVM-771](https://sft.its.cern.ch/jira/browse/CVM-671)


## Automatic Selection of Stratum 1 Servers

As of this version, stratum 1 servers provide a Geo-IP service to clients.  That allows clients starting with a static list of available stratum 1 servers to contact them in order of their geographical proximity. To use this feature, set CVMFS_USE_GEOAPI=yes in the client configuration. This is the default setting in the cvmfs-config-default rpm for repositories in the cern.ch domain. The automatic selection overwrites the manual ordering in /etc/cvmfs/domain.d/cern.ch.local and in fact removes the need for manually creating a custom order entirely.

Through the new 'host probe geo' command to cvmfs_talk, the ordering of stratum 1 servers can be triggered manually. The extended attribute 'host_list' shows the currently effective order of stratum 1 servers.

Related JIRA tickets: [CVM-629](https://sft.its.cern.ch/jira/browse/CVM-629), [CVM-630](https://sft.its.cern.ch/jira/browse/CVM-630)


## Round-Robin DNS Aliases for Proxies

DNS round-robin aliases used for proxy servers in CVMFS_HTTP_PROXY are now automatically resolved to a load-balancing group. That means cvmfs selects one of the IP addresses at random and tries all the other IP addresses in case of a failure. This feature removes the need to specify all the proxies manually.  For example:

    CVMFS_HTTP_PROXY="http://ca-proxy.cern.ch:3128|http://ca11.cern.ch:3128|http://ca12.cern.ch:3128"

can simply be written as

    CVMFS_HTTP_PROXY="http://ca-proxy.cern.ch:3128"

This feature is not implemented for Stratum 1 servers because usually the proxy server performs the name resolution of the stratum 1 server and using an IP address instead of a host name can interfere with the proxy's permission checking.

Related JIRA ticket: [CVM-457](https://sft.its.cern.ch/jira/browse/CVM-457)



## Smaller Changes and Improvements

### Backwards Incompatible Changes:

  - library: change libcvmfs to access /cvmfs instead of /cvmfs/<repo>. As far as we know the only user of libcvmfs is currently [parrot](http://ccl.cse.nd.edu/software/parrot/). A corresponding patch for parrot has been released. This change doesn't affect the Fuse client nor the server.

### Bugfixes

  - client: fix rebuilding cache database on XFS after a crash ([CVM-685](https://sft.its.cern.ch/jira/browse/CVM-685)). If your cache runs on an XFS partition, please clear the cache in order to ensure a clean start.
  - client: fix race when autofs unmounts a repository during reload
  - client: fix concurrent creation of cache sub directories ([CVM-672](https://sft.its.cern.ch/jira/browse/CVM-672))
  - client: fix concurrent access to alien cache on NFS (link/unlink instead of rename)
  - client: support alien cache on hadoop-dfs-fuse which doesn't report file size immediately ([CVM-659](https://sft.its.cern.ch/jira/browse/CVM-659))
  - client: support alien cache on Lustre and other file systems where file locking is difficult
  - client: fix alien cache catalog updates ([CVM-653](https://sft.its.cern.ch/jira/browse/CVM-653))
  - client: fix error reporting when creating alien cache ([CVM-677](https://sft.its.cern.ch/jira/browse/CVM-677))
  - client: install auto.cvmfs binary in /usr/libexec/cvmfs and make /etc/auto.cvmfs a symlink ([CVM-645](https://sft.its.cern.ch/jira/browse/CVM-645))
  - server: fix traversal of nested catalogs in intermediate catalogs during snapshot
  - server: fix false zero return code of 'cvmfs_server transaction' ([CVM-658](https://sft.its.cern.ch/jira/browse/CVM-658))
  - server: fix whitelist resign period from one month to 30 days to match the documentation ([CVM-628](https://sft.its.cern.ch/jira/browse/CVM-628))
  - server: apply umask to the file mode when creating files on the Stratum 0/1 ([CVM-660](https://sft.its.cern.ch/jira/browse/CVM-660))

### Improvements

  - client: add CVMFS_LOW_SPEED_LIMIT parameter, increase threshold for stale connections from 100B/s to 1kB/s ([CVM-718](https://sft.its.cern.ch/jira/browse/CVM-718))
  - client: transfer ownership of files and directories to the cvmfs user. The default behavior can be changed by CVMFS_CLAIM_OWNERSHIP ([CVM-678](https://sft.its.cern.ch/jira/browse/CVM-678)).
  - client: add support for geographically ordered fallback proxies that can be used instead of DIRECT connections to Stratum 1 servers ([CVM-708](https://sft.its.cern.ch/jira/browse/CVM-708))
  - client: ensure autofs is running after `cvmfs_config setup`
  - client: add support for HTTP redirects through CVMFS_FOLLOW_REDIRECTS ([CVM-766](https://sft.its.cern.ch/jira/browse/CVM-766)).  This feature is turned off by default and it is only useful in special installations, e.g. when cvmfs is used as a client to dCache servers.
  - client: use custom cvmfs_cache_t SELinux label for the cache directory ([CVM-644](https://sft.its.cern.ch/jira/browse/CVM-644))
  - client: fail gracefully if one of the public RSA keys is unreadable ([CVM-667](https://sft.its.cern.ch/jira/browse/CVM-667))
  - client: add extended attribute user.tag
  - client: add CVMFS_REPOSITORY_DATE client parameter to mount a repository tag that corresponds to a given date
  - client: add underscore and tilde to the set of unescaped URI characters
  - server: make server transaction handling more robust against failures and concurrent operations ([CVM-665](https://sft.its.cern.ch/jira/browse/CVM-665), [CVM-666](https://sft.its.cern.ch/jira/browse/CVM-666), [CVM-650](https://sft.its.cern.ch/jira/browse/CVM-650))
  - server: enable default auto tagging (CVMFS_AUTO_TAG)
  - server: allow for setting a revision number using `cvmfs_server publish -n` ([CVM-633](https://sft.its.cern.ch/jira/browse/CVM-633))
  - server: allow for importing externally created keys in `cvmfs_server mkfs` ([CVM-646](https://sft.its.cern.ch/jira/browse/CVM-646))
  - server: load only required file catalogs when processing .cvmfsdirtab ([CVM-620](https://sft.its.cern.ch/jira/browse/CVM-620))
  - server: add 'list-catalogs' command
  - server: compact inflated catalogs on publish
  - server: add CVMFS_MAXIMAL_CONCURRENT_WRITES configuration parameters for number of I/O streams during publishing ([CVM-703](https://sft.its.cern.ch/jira/browse/CVM-703))
  - server: concurrent initial snapshots will not wait for each other but all but the first one fail with a non-zero exit code ([CVM-278](https://sft.its.cern.ch/jira/browse/CVM-278))
  - server: restrict the number of in-flight file processing jobs in the server in order to not exhaust file descriptor limit
  - server: use AllowOverride Limit instead of AllowOverride All in Stratum 0/1 default configuration ([CVM-661](https://sft.its.cern.ch/jira/browse/CVM-661))
  - server: warn when aufs version is known to potentially cause deadlocks