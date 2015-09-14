# 14. September 2015: CernVM-FS 2.2.0 Server Only Pre-Release

Bugfix release version CernVM-FS 2.2.0-0 is out.  This release mostly fixes a number of problems for Stratum 0 and Stratum 1 servers while we are preparing the 2.2.0-1 full release for server and client.  Besides the server, we also release bugfixed versions of

  - the Mac Client
  - the library (libcvmfs.a)

Please note that this release is _not_ for the Linux file system client.  The latest Linux client is still 2.1.20 (also for updated Stratum 0 servers).

Updating the server is seamless through yum package upgrades.  Please ensure that there are no open transactions on stratum 0 and no running replication processes on a stratum 1 during the RPM upgrade.

## Fixes in the server

  - Fix leak of temporary files in .cvmfsdirtab processing ([CVM-818](https://sft.its.cern.ch/jira/browse/CVM-818)). This renders the workaround described at [http://cernvm.cern.ch/portal/cvmfs/fix-leaked-dirtab-tmp-files](http://cernvm.cern.ch/portal/cvmfs/fix-leaked-dirtab-tmp-files) obsolete.
  - Fix crash in `cvmfs_swissknife dirtab` if .cvmfsdirtab contains `/*`
  - Fix several CentOS 7 issues in the cvmfs_server script ([CVM-737](https://sft.its.cern.ch/jira/browse/CVM-737))
  - Disable caching for mutable objects in S3 backend ([CVM-808](https://sft.its.cern.ch/jira/browse/CVM-808))
  - Follow HTTP redirects in S3 backend
  - Fix verification of partial file chunks ([CVM-842](https://sft.its.cern.ch/jira/browse/CVM-842))
  - Fix leak of temporary files during garbage collection ([CVM-846](https://sft.its.cern.ch/jira/browse/CVM-846))
  - Handle import of repositories with an expired whitelist ([CVM-780](https://sft.its.cern.ch/jira/browse/CVM-780))
  - Avoid use of attr utility in the server ([CVM-853](https://sft.its.cern.ch/jira/browse/CVM-853))
  - Fix moving of magic symlinks into nested catalogs ([CVM-874](https://sft.its.cern.ch/jira/browse/CVM-874))
  - Fix rare crashes on publish due to false whiteout handling ([CVM-880](https://sft.its.cern.ch/jira/browse/CVM-880))
  - Add `-s <S3 config file>` switch to add-replica command
  - Fix leak of temporary files in the S3 backend ([CVM-881](https://sft.its.cern.ch/jira/browse/CVM-881))

## Fixes in libcvmfs

  - Restore 2.1.19 option names (regression in 2.1.20)
  - Fix cleanup of global state
  - Fix initialization of quota manager (regression in 2.1.20)
  - Fix resolving absolute symlinks into the same repository (regression in 2.1.20)

## Fixes in the Mac Client

  - Fix stack trace generation
  - Fix OS X mount helper for osxfuse 3
  - Tuned mount options for OS X
