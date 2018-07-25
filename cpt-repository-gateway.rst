.. _cpt_repository_gateway:

==================================================
 CernVM-FS Repository Gateway and Release Managers
==================================================

This page details the installation and configuration of a repository setup
involving a gateway machine and separate release manager machines.

Glossary
========

Gateway (GW)
  The machine running an instance of the `CVMFS repository gateway
  <https://github.com/cvmfs/cvmfs-gateway>`_ which
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

The repository gateway application is currently packaged for Ubuntu 16.04,
Ubuntu 18.04, SLC 6 and Cern CentOS 7. On Ubuntu, an additional step is required
after the package is installed, the setup script needs to be run as root: ::

  # /usr/libexec/cvmfs-gateway/scripts/setup.sh

Create the repository for the following section of this guide: ::

  # cvmfs_server mkfs -o root test.cern.ch

Create an API key file for the new repo (replace ``<KEY_ID>`` and ``<SECRET>``
with actual values): ::

  # cat <<EOF > /etc/cvmfs/keys/test.cern.ch.gw
  plain_text <KEY_ID> <SECRET>
  EOF
  # chmod 600 /etc/cvmfs/keys/test.cern.ch.gw

Add the API key file to the repository configuration in the gateway application: ::

  # cat <<EOF > /etc/cvmfs/gateway/repo.json
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

If Systemd is available, the gateway application can be started with ``systemctl``: ::

  # systemctl start cvmfs-gateway.service

otherwise it can be manually started: ::

  # /usr/libexec/cvmfs-gateway/scripts/run_cvmfs_gateway.sh start

The ports 80/TCP and 4929/TCP need to be opened in the firewall, to
allow access to the repository contents and to the gateway service
API.

Alongside the ``repo.json`` file, there is another configuration file
for the repository gateway - ``user.json``. The most important options
in this file are:

* ``max_lease_time`` - the maximum duration, in seconds, of an acquired lease
* ``fe_tcp_port`` - the port on which the gateway application listens,
  4929 by default

By default, the gateway application only spawns a single
``cvmfs_receiver`` worker process. It is possible to run multiple
worker processes by increasing the value of the ``size`` entry in the
``receiver_config`` map, found in ``user.json``. This value should not
be increased beyond the number of available CPU cores.

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
* The GW gateway application is running on port 4929 at the URL ``http:://gateway.cern.ch:4929/api/v1``.
* The repository keys have been copied from the gateway machine onto
  the release manager machine, in ``/tmp/test.cern.ch_keys``.

To create the repository in the release manager configuration, run the following
command on ``rm.cern.ch`` as an unprivileged user with sudo access: ::

  $ sudo cvmfs_server mkfs -w http://gateway.cern.ch/cvmfs/test.cern.ch \
                           -u gw,/srv/cvmfs/test.cern.ch/data/txn,http://gateway.cern.ch:4929/api/v1 \
                           -k /tmp/test.cern.ch_keys -o `whoami` test.cern.ch

At this point, from the RM we can publish to the repository: ::

  $ cvmfs_server transaction test.cern.ch

... make changes to the repository ... ::

  $ cvmfs_server publish test.cern.ch


Updating from cvmfs-gateway-0.2.5
=================================

In the first published version, ``cvmfs-gateway-0.2.5``, the
application files were installed under ``/opt/cvmfs-gateway`` and the
database files under ``/opt/cvmfs-mnesia``. Starting with version 0.2.6,
the application is installed under ``/usr/libexec/cvmfs-gateway``, while
the database files are under ``/var/lib/cvmfs-gateway``.

When updating from 0.2.5, please make sure that the application is stopped: ::

  # systemctl stop cvmfs-gateway

and rerun the setup script: ::

  # /usr/libexec/cvmfs-gateway/scripts/setup.sh

At this point, the new version of the application can be started. If the
old directories are still present, they can be deleted: ::

  # rm -r /opt/cvmfs-{gateway,mnesia}
