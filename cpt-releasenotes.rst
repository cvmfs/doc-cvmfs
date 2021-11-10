Release Notes for CernVM-FS 2.9.0
=================================

CernVM-FS 2.9.0 is a feature release. Highlights are:

- Incremental conversion of container images, resulting in a large speed-up for
  publishing new container image versions to unpacked.cern.ch

- Support for maintaining repositories in S3 over HTTPS (not just HTTP)

- Significant speed-ups for S3 and gateway publisher deployments

- Various bugfixes and smaller improvements (error reporting, repository
  statistics, network failure handling, etc.)

New platforms: Debian 11, SLES 15, AArch64 RHEL 8

Two new features are introduced in this release, as technical previews (experimental):

- Publish support from ephemeral containers (e.g. in k8s pods)

- Container image conversion on push notification from Harbor registries (such as registry.cern.ch)

Bug fixes
---------

- [gw] Fix spurious keychain warning on transaction (CVM-1982)
- [gw] Fix lease statistics extraction during commit (CVM-1939)
- Fix cvmfs_talk host info for empty host chain (CVM-2023)
- [ducc] Fix access to authenticated registries
- Fix potential activation of corruption stratum 1 snapshot
- Fix union mountpoint handling on Fedora >= 34
- Fix potential crash when accessing extended attributes (CVM-2014)
- [gw] Fix publishing empty uncompressed files (CVM-2012)
- Fix building Doxygen documentation
- [ducc] Fix version string

Improvements and changes
------------------------

- Add initial implementation of cvmfs_publish commit
- [libcvmfs_server] Require repo key & certificate only on non-gw publishers
- Add `cvmfs_server check -a` command (CVM-1524)
- Add timestamp_last_error magic extended attribute (CVM-2003)
- Add logbuffer magic extended attribute
- Add check for usyslog writability in cvmfs_config (CVM-1946)
- [ducc] make output_format line in wish list optional (CVM-1786)
- [ducc] Add support for publish triggered by registry webhooks (CVM-2000)
- [rpm] Cleanup creation of cvmfs system user and group (CVM-2017)
- Clean up receiver processes when stopping the gateway (CVM-1989)
- Add support for importing repositories on S3
- [gw] Increase file descriptor limit for receiver (CVM-1997)
- Classify HTTP errors with X-Squid-Error or Proxy-Status headers
  as proxy errors
- Use UTC timestamp for .cvmfs_is_snapshotting (CVM-1986)
- [rpm] Remove version requirement from selinux-policy dependency
- Add 'cvmfs_config setup noautofs' option (CVM-1983)
- Add support for explicit server-side proxy, removing support for server-side
  system proxy; new parameters CVMFS_SERVER_PROXY and CVMFS_S3_PROXY
- Add `cvmfs_config fuser` command
- Add support for HTTPS S3 endpoints
- Add support for attaching mount to an existing fuse module
- Add support for "direct I/O" files (CVM-2001)
- Add 'device id' command to cvmfs_talk (CVM-2004)
- Add support for setting "compression" key in graft files
- Remove spinlock in S3 uploader
- Remove spinlock in gateway uploader
- Reduce time spent in lsof during publishing
- [gw] Fast merging of nested catalogs (CVM-1998)
- [gw] Accommodate cvmfs-gateway Go sources (CVM-1871)
- Install cvmfs_receiver_debug (CVM-1988)
- Register redundant bulk hashes in filestats db
- Add support for SLES15 (CVM-1656)
- Do not include an explicit default port number within S3 upload URI
  (see also libcurl issue #6769)
- Do not escape '@' in URI strings
- [ducc] Ingest images using "sneaky layers" and template transactions
