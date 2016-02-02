# 28. May 2014: CernVM-FS 2.1.19

Version 2.1.19 comes with new features and important bugfixes that are relevant for the upcoming migration of the WLCG repositories to the 2.1 repository format. Version 2.1.19 is the successor of version 2.1.17; version 2.1.18 was skipped. Updating from 2.1.17 works through an RPM upgrade assisted by the CernVM-FS hotpatching feature (please see the note at the end). For updating from version 2.0.X, please read the notes on the [2.1 release page](http://cernvm.cern.ch/portal/cvmfs/release-2.1). For all upgrades, we recommend to upgrade in stages starting with a small fraction of worker nodes first followed by a ramp up if there are no problems.

## Bugfixes
  * Client: fix race between cached chunked files and catalog updates.  Under heavy load, this bug can result in corrupted data served from memory caches for chunked files from 2.1 repositories.
  * Client: fix crash in exclusive cache mode if a catalog larger than 37.5% of the overall cache quota is loaded on mount ([JIRA CVM-267](https://sft.its.cern.ch/jira/browse/CVM-267))
  * Client: fix false parsing of /etc/cvmfs/domaind.d/cern.ch.* on mount of non *.cern.ch repositories ([JIRA CVM-600](https://sft.its.cern.ch/jira/browse/CVM-600))
  * Server: fix permissions of private keys on repository creation
  * Server: fix overwriting regular file or symlink with non-empty directory
  * Server: fix symlinked /var/spool/cvmfs/... ([JIRA CVM-607](https://sft.its.cern.ch/jira/browse/CVM-607))
  * Server: fix memory corruption during publish process ([JIRA CVM-608](https://sft.its.cern.ch/jira/browse/CVM-608))
  * Server: fix publishing when other shells are open on /cvmfs/$fqrn ([JIRA CVM-609](https://sft.its.cern.ch/jira/browse/CVM-609))
  * Server: fix abnormal termination of cvmfs_server on whitelist verification errors ([JIRA CVM-602](https://sft.its.cern.ch/jira/browse/CVM-602))
  * Fix RPM spec file for Fedora 20 and SL6.5 32bit ([JIRA CVM-596](https://sft.its.cern.ch/jira/browse/CVM-596))

## Changes and Improvements
  * Client: workaround for autofs bug on EL6.2 ([JIRA CVM-601](https://sft.its.cern.ch/jira/browse/CVM-601))
  * Client: interpret CVMFS_PAC_URLS instead of PAC_URLS ([JIRA CVM-456](https://sft.its.cern.ch/jira/browse/CVM-456))
  * Client: resolve “auto” PAC location to http://wpad/wpad.dat ([JIRA CVM-456](https://sft.its.cern.ch/jira/browse/CVM-456))
  * Client: log pacparser errors to syslog ([JIRA CVM-456](https://sft.its.cern.ch/jira/browse/CVM-456))
  * Client: parse /etc/cvmfs/default.d/*.conf after /etc/cvmfs/default.conf and before /etc/cvmfs/default.local
  * Client: add support for cvmfs-info HTTP header that contains the requested file path.  This behavior is turned off by default and can be turned on through CVMFS_SEND_INFO_HEADER ([JIRA CVM-580](https://sft.its.cern.ch/jira/browse/CVM-580))
  * Client: support for "volatile" repositories and volatile cache class ([JIRA CVM-263](https://sft.its.cern.ch/jira/browse/CVM-263))
  * Client: resolve most logged internal error numbers to text ([JIRA CVM-594](https://sft.its.cern.ch/jira/browse/CVM-594))
  * Client: improve error logging when loading the cvmfs binaries on mount ([JIRA CVM-595](https://sft.its.cern.ch/jira/browse/CVM-595))
  * Client: require a dot in the repository name when mounted through autofs
  * Server: re-enable support for the .cvmfsdirtab file (it was available in version 2.0.X).  Now it comes in an extended version that supports globbing and exclusion ([JIRA CVM-606](https://sft.its.cern.ch/jira/browse/CVM-606)).
  * Server: reduce default verbosity of 'cvmfs_server publish' ([JIRA CVM-269](https://sft.its.cern.ch/jira/browse/CVM-269))
  * Support for RIPEMD-160 hash algorithm in lieu of SHA-1 ([JIRA CVM-217](https://sft.its.cern.ch/jira/browse/CVM-217))
  * Update TBB dependency to version 4.2 update 2
  * Add bash completion for cvmfs_config and cvmfs_server

## Note on Hotpatching
Within the release process, we discovered a race when the automounter unmounts repositories during the reload of the cvmfs Fuse module.  This race has been in CernVM-FS 2.1 ever since and it can result in stale CernVM-FS mount points.  The problem typically only occurs on a small fraction of nodes and only when autmounter idle times are short (~ minutes).  We discovered it on a few nodes at CERN T1. The problem was fixed but unfortunately it was too late to include it in this release.  However, nodes in a locked-up state can be recovered manually without interrupting running jobs.

Note that it is normal during the hotpatch that CernVM-FS mountpoints become unresponsive for a short amount of time.  If all mountpoints hang for more than 15 minutes, it is likely that the hotpatch got stuck.  In this case, the following recipe recovers the node

  * Kill all processes (kill -9) doing `cvmfs_config reload`
  * Look for /var/run/cvmfs/pid.* files.  To all the process IDs listed in these files, send `kill -s USR1 <PID>`.
  * `rm -f /var/run/cvmfs/pid.* /var/run/cvmfs/guard_files /var/run/cvmfs/cvmfs.pause`
