.. _cpt_gateway_services:

==================================================
 CernVM-FS Repository Gateway and Release Managers
==================================================

This page details the installation and configuration of a repository setup
involving a gateway machine and separate release manager machines.

Glossary
========

Gateway (GW)
  The machine running an instance of the `CVMFS repository gateway
  <https://github.com/cvmfs/cvmfs_gateway>`_ which
  has access to the authoritative storage of the managed repositories.
  This storage is made accessible either as a locally
  mounted partition or through an S3 API. The purpose of the GW is to
  manage access to a set of repositories by assigning exclusive leases
  to specific repository sub-paths to different release manager (RM)
  machines. The RM can publish files to the sub-path for which it
  currently holds a lease and send object packs to the GW. Having
  received the published payload from the RM, the final task of the GW
  in the publication lifecycle is to rebuild the catalogs and
  repository manifests for the modified repositories.

Release manager (RM)
  A machine running the CVMFS server tools which can request leases
  from a GW and publish changes to different repositories where it
  currently holds valid leases.

  The computationally heavy parts of the publication operation take
  place on the RM: compressing and hashing the files which are to be
  added or modified. The processed files are then packed together and
  sent to the GW to be inserted into the repository and made available
  to clients.

Repository Gateway Configuration
================================

As a prerequisite, we need to install the CVMFS client and server
packages on the gateway. This means that the gateway machine can be
used as a "master" release manager to perform some repository
transformations before a separate release manager machine
is set up.

The repository gateway application is currently packaged for Ubuntu
16.04, SLC 6 and Cern CentOS 7. Once the package is installed, the
setup script needs to be run: ::

  $ /opt/cvmfs_gateway/scripts/setup.sh

Create the repository for the following section of this guide: ::

  $ cvmfs_server mkfs test.cern.ch

Create an API key file for the new repo (replace ``<KEY_ID>`` and ``<SECRET>`` with actual values): ::

  $ cat <<EOF > /etc/cvmfs/keys/test.cern.ch.gw
  plain_text <KEY_ID> <SECRET>
  EOF

Add the API key file to the repository configuration in the gateway application: ::

  $ cat <<EOF > /etc/cvmfs/gateway/repo.json
  {
    "repos": [
      {
        "domain": "test.cern.ch",
        "keys": ["<KEY_ID>"]
      }
    ],
    "keys": [
      {
        "type": "file",
        "file_name": "/etc/cvmfs/keys/test.cern.ch.gw",
        "repo_subpath": "/"
      }
    ]
  }
  EOF

Start the repository gateway application: ::

  $ /opt/cvmfs_gateway/scripts/run_cvmfs_gateway.sh start

The ports 80/TCP and 8080/TCP need to be opened in the firewall, to
allow access to the repository contents and to the gateway service
API.


Release Manager Configuration
=============================

This section describes the steps needed to set up a release manager
for a specific CVMFS repository. The precondition is a working gateway
machine where the repository has been created as a Stratum 0.

Example:
--------

* The gateway machine is ``gateway.cern.ch``.
* The release manager is ``rm.cern.ch``.
* The new repository's fully qualified name is ``test.cern.ch``.
* The repository's public key is ``test.cern.ch.pub``.
* The GW API key is ``test.cern.ch.gw``.
* The GW gateway application is running on port 8080 at the URL ``http:://gateway.cern.ch:8080/api/v1``.
* The repository keys have been copied from the gateway machine onto the release manager machine, in ``/tmp/test.cern.ch_keys``.

To create the repository in the release manager configuration, run the following command on ``rm.cern.ch``: ::

  $ cvmfs_server mkfs -w http://gateway.cern.ch/cvmfs/test.cern.ch \
                      -u gw,/srv/cvmfs/test.cern.ch/data/txn,http://gateway.cern.ch:8080/api/v1 \
                      -k /tmp/test.cern.ch_keys -o `whoami` test.cern.ch

At this point, from the RM we can publish to the repository: ::

  $ cvmfs_server transaction test.cern.ch

... make changes to the repository ... ::

  $ cvmfs_server publish test.cern.ch
