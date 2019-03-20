.. _cpt_repository_gateway:

=================================================
 The CernVM-FS Repository Gateway and Publishers
=================================================

This page describes the distributed CernVM-FS publication architecture,
composed of a repository gateway machine and separate publisher machines.

Glossary
========

Publisher
  A machine running the CernVM-FS server tools which can publish to a number of
  repositories, using a repository gateway as mediator.

  The resource-intensive parts of the publication operation take place here:
  compressing and hashing the files which are to be added or modified. The
  processed files are then packed together and sent to the gateway to be
  inserted into the repository and made available to clients.

Repository gateway
  This machine runs the ``cvmfs-gateway`` application. It is the sole entity
  able to write to the authoritative storage of the managed repositories,
  either by mounting the storage volume or through an S3 API.

  The role of the gateway is to intermediate access to a set of repositories by
  assigning exclusive leases for specific repository sub-paths to different
  publisher machines. The gateway receives payloads from publishers, in the
  form of object packs, which it processes and writes to the repository
  storage. Its final task is to rebuild the catalogs and repository manifest of
  the modified repositories at the end of a successful publication transaction.


Repository gateway configuration
================================

The ``cvmfs-gateway`` application needs to run on the gateway machine. The
application is currently packaged for CentOS 7, SLC 6, and Ubuntu 16.04 and
18.04.

When the CernVM-FS client and server packages are also installed, it's possible
to use the gateway machine as a "master" publisher, reserved for performing
some initial repository transformations, before a separate publisher machine is
set up. To avoid any possible repository corruption, the gateway application
should always be stopped before opening a repository transaction on the gateway
machine.

With the gateway application installed, create the repository which will be
used for the rest of this guide: ::

  # cvmfs_server mkfs -o root test.cern.ch

Create an API key file for the new repo (replace ``<KEY_ID>`` and ``<SECRET>``
with actual values): ::

  # cat <<EOF > /etc/cvmfs/keys/test.cern.ch.gw
  plain_text <KEY_ID> <SECRET>
  EOF
  # chmod 600 /etc/cvmfs/keys/test.cern.ch.gw

Since version 1.0 of ``cvmfs-gateway``, the repository and key configuration
has been greatly simplified. If an API key file is present at the conventional
location (``/etc/cvmfs/keys/<REPOSITORY_NAME>.gw``), it will be used by default
as key for the repository. The repository configuration file only needs to
specify which repositories are to be handled by the application: ::

  # cat <<EOF > /etc/cvmfs/gateway/repo.json
  {
    "version": 2,

    "repos": [
      "test.cern.ch"
    ]
  }
  EOF

The ``"version": 2`` property enables the use of the improved configuration
systax. If this property is omitted, the parser will interpret the file using
the legacy configuration syncta, maintaining compatibility with existing
configuration files (see `Legacy repository configuration syntax`_). The
`Advanced repository configuration`_ section shows how to implement more
complex key setups.

To start the gateway application, either use `systemctl`, if systemd is
available: ::

  # systemctl start cvmfs-gateway.service

otherwise use the service command: ::

  # service cvmfs-gateway start

To access the gateway service API, port 4929/TCP needs to be open in the
firewall. If the gateway machine also serves as a repository stratum 0 (i.e.
the repository is created with "local" upstream), then port 80/TCP also needs
to be open.

In addition to ``repo.json``, there is another configuration
file,``user.json``, which contains runtime parameters for the gateway
application. The most important are:

* ``max_lease_time`` - the maximum duration, in seconds, of an acquired lease
* ``fe_tcp_port`` - the port on which the gateway application listens,
  4929 by default

By default, the gateway application only spawns a single ``cvmfs_receiver``
worker process. It is possible to run multiple worker processes by increasing
the value of the ``size`` entry in the ``receiver_config`` map, found in
``user.json``. This value should not be increased beyond the number of
available CPU cores.

Publisher configuration
=============================

This section describes how to set up a publisher for a specific CVMFS
repository. The precondition is a working gateway machine where the repository
has been created as a Stratum 0.

Example:
--------

* The gateway machine is ``gateway.cern.ch``.
* The publisher is ``publisher.cern.ch``.
* The new repository's fully qualified name is ``test.cern.ch``.
* The repository's public key is ``test.cern.ch.pub``.
* The gateway API key is ``test.cern.ch.gw``.
* The gateway application is running on port 4929 at the URL
  ``http:://gateway.cern.ch:4929/api/v1``.
* The repository keys have been copied from the gateway machine onto the
  publisher machine, in ``/tmp/test.cern.ch_keys``.

To make the repository available for writing on ``publisher.cern.ch``, run the
following command on that machine as an unprivileged user with sudo access: ::

  $ sudo cvmfs_server mkfs -w http://gateway.cern.ch/cvmfs/test.cern.ch \
                           -u gw,/srv/cvmfs/test.cern.ch/data/txn,http://gateway.cern.ch:4929/api/v1 \
                           -k /tmp/test.cern.ch_keys -o `whoami` test.cern.ch

At this point, it's possible to start writing into the repository from the
publisher machine: ::

  $ cvmfs_server transaction test.cern.ch

  ... make changes to the repository ... ::

  $ cvmfs_server publish


Displaying and clearing leases on the gateway machine
=====================================================

The ``cvmfs-gateway`` package includes two scripts intended to help gateway administrators debug or unblock the gateway in case of problems.
The first one displays the list of currently active leases: ::

  $ /usr/libexec/cvmfs-gateway/scripts/get_leases.sh

The second one will clear all the currently active leases: ::

  $ /usr/libexec/cvmfs-gateway/scripts/clear_leases.sh


Advanced repository configuration
=================================

It's possible to register multiple API keys with each repository, and each key
can be restricted to a specific subpath of the repository: ::

  {
    "version": 2,
    "repos" : [
      {
        "domain": "test.cern.ch",
        "keys": [
          {
            "id": "keyid1",
            "path": "/"
          },
          {
            "id": "keyid2",
            "path": "/restricted/to/subdir"
          }
        ]
      }
    ]
  }

Keys can be either be loaded from a file, or declared inline: ::

  {
    "version": 2,
    "keys": [
      {
        "type": "file",
        "file_name": "/etc/cvmfs/keys/test.cern.ch.gw"
      },
      {
        "type": "plain_text",
        "id": "keyid2",
        "secret": "<SECRET>"
      }
    ]
  }

The ``"version": 2`` property needs to be specified for this configuration
format to be accepted.

Legacy repository configuration syntax
======================================

In the legacy repository configuration format, subpath restrictions are given
with the key declaration, not when associating the keys with the repository: ::

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
