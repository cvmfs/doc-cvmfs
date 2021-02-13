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

  The role of the gateway is to mediate access to a set of repositories by
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
have been greatly simplified. If an API key file is present at the conventional
location (``/etc/cvmfs/keys/<REPOSITORY_NAME>.gw``), it will be used by default
as the key for that repository. The repository configuration file only needs to
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
syntax. If this property is omitted, the parser will interpret the file using
the legacy configuration syntax, maintaining compatibility with existing
configuration files (see `Legacy repository configuration syntax`_). The
`Advanced repository configuration`_ section shows how to implement more
complex key setups.

In addition to ``repo.json``, the ``user.json`` configuration file contains
runtime parameters for the gateway application. The most important are:

* ``max_lease_time`` - the maximum duration, in seconds, of an acquired lease
* ``port`` - the TCP port on which the gateway application listens,
  4929 by default (the legacy name for this option is "fe_tcp_port")
* ``num_receivers`` - the number of parallel ``cvmfs_receiver`` worker
processes to be spawned. Default value is 1, and it should not be increased
beyond the number of available CPU cores (the legacy name of this option is the
``size`` entry in the ``receiver_config`` map).

To access the gateway service API, the specified ``port`` needs to be open in
the firewall. If the gateway machine also serves as a repository stratum 0
(i.e. the repository is created with "local" upstream), then port 80/TCP also
needs to be open.

Finally, to start the gateway application, use `systemctl` if systemd is
available: ::

  # systemctl start cvmfs-gateway.service

otherwise use the service command: ::

  # service cvmfs-gateway start

Note that in order to apply any gateway configuration changes, including
changes to the API keys, the gateway service must be restarted.

If systemd is available, the application logs can be consulted with: ::

  # journalctl -u cvmfs-gateway

On CentOS 6, where systemd is not available, the log file can be accessed
directly at `/var/log/cvmfs-gateway.log`.

Running under a different user
******************************

By default, the `cvmfs-gateway` application is run as `root`. An included
systemd service template file allows running it as an arbitrary user: ::

  # systemctl start cvmfs-gateway@<USER>

To consult the logs of the application instance running as `<USER>`, run: ::

  # journalctl -u cvmfs-gateway@<USER>


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
* The repository's public key (RSA) is ``test.cern.ch.pub``.
* The repository's public key (encoded as a X.509 certificate) is ``test.cern.ch.crt``.
* The gateway API key is ``test.cern.ch.gw``.
* The gateway application is running on port 4929 at the URL
  ``http://gateway.cern.ch:4929/api/v1``.
* The three keys for the repository (.pub, .crt, and .gw) have been copied from the gateway machine onto the
  publisher machine, in the directory ``/tmp/test.cern.ch_keys/``.

To make the repository available for writing on ``publisher.cern.ch``, run the
following command on that machine as an unprivileged user with sudo access: ::

  $ sudo cvmfs_server mkfs -w http://gateway.cern.ch/cvmfs/test.cern.ch \
                           -u gw,/srv/cvmfs/test.cern.ch/data/txn,http://gateway.cern.ch:4929/api/v1 \
                           -k /tmp/test.cern.ch_keys -o `whoami` test.cern.ch

At this point, it's possible to start writing into the repository from the
publisher machine: ::

  $ cvmfs_server transaction test.cern.ch

Alternatively, to take advantage of the gateway functionality which allows concurrent transactions on different paths of a repository, or fine-grained permission to only publish changes in certain paths, you can request a publishing lease that is scoped to a subdirectory of the repository by starting a transaction like this: :: 

  $ cvmfs_server transaction test.cern.ch/example/path

Then to commit the changes to the repository and publish: ::

  $ cvmfs_server publish


Querying the gateway machine
============================

The configuration and current state of the gateway application can be queried using standard HTTP requests. A "GET" request to the "repos" endpoint returns the key configuration for all the repositories: ::

  $ curl http://example.gateway.org:4929/api/v1/repos | jq

  {
    "data": {
      "example.repo.org": {
        "key1": "/"
      }
    },
    "status": "ok"
  }

The configuration of a single repository can also be obtained: ::

  $ curl http://example.gateway.org:4929/api/v1/repos/example.repo.org | jq

  {
    "data": {
      "key1": "/"
    },
    "status": "ok"
  }

The list of current active leases can be obtained as follows: ::

  $ curl http://example.gateway.org:4929/api/v1/leases | jq

  {
    "data": {
      "example.repo.org/sub/dir/1": {
        "key_id": "key1",
        "expires": "2019-05-09 23:10:31.730136676 +0200 CEST"
      },
      "example.repo.org/sub/dir/2": {
        "key_id": "key1",
        "expires": "2019-05-09 23:10:32.497061458 +0200 CEST"
      },
      "example.repo.org/sub/dir/3": {
        "key_id": "key1",
        "expires": "2019-05-09 23:10:31.935336579 +0200 CEST"
      }
    },
    "status": "ok"
  }

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

It should be noted that when keys are loaded from a file, an `id` field needs
not be specified in the configuration file. The public id of the loaded key is
the one specified in the key file itself.

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
