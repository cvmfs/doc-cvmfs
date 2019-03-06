.. _cpt_notification_system:

==================================================
 The CernVM-FS Notification System (Experimental)
==================================================

This page describes the CernVM-FS notification system, a reactive repository
change propagation system, complementary to the default, pull-based, approach
based on the time-to-live value of cached repository manifests. This new system
is used when a more precise propagation method is needed. One such use case is
the distribution of conditions databases, which during data taking change at a
much higher rate than software repositories. In a conditions data workflow, it
is desired to process new data samples as soon as they are available, to avoid
the pileup of new samples. Another case is the construction of a complex
software build and test pipeline, where later stages of the pipeline depend on
artifacts published at earlier stages of the pipeline already being available
in replicas of the repository.

The main components of the notification system are the message broker and a
command-line tool used to publish new messages and subscribe to notifications.
Additionally, CernVM-FS clients can also be configured to receive and react to
notifications.

The message broker
==================

RabbitMQ, an open-source message broker, drives the notification system.
Besides offering very high performance, RabbitMQ ensures the reliable delivery
of messages and persists the message queue in case of crashes.

RabbitMQ clients communicate with the broker using the AMQ protocol (AQMP 0.9).
To avoid distributing the AMQP credentials (username and password) to every
client of the CernVM-FS notification system, the ``cvmfs-notify`` service,
installed from the package with the same name, functions as a proxy in front of
the broker: the cvmfs-notify daemon maintains an AMQP connection to the broker
and accepts message submissions over HTTP and subscriptions over Websockets.
The ``cvmfs-notify`` service should be colocated with the RabbitMQ instance.

Configuration
-------------

First,  install the ``rabbitmq-server`` package. The firewall port 5672/TCP
should be open if remote AMQP access is desired, while the web administration
console runs on port 15672/TCP.

Start and enable the RabbitMQ service: ::

  # systemctl start rabbitmq-server
  # systemctl enable rabbitmq-server

The web administration console can be enabled, if needed, simplifying the
configuration of RabbitMQ: ::

  # rabbitmq-plugins enable rabbitmq_management

The default guest user should be deleted: ::

  # rabbitmqctl delete_user guest

Add the "/cvmfs" vhost if needed: ::

  # rabbitmqctl add_vhost /cvmfs

Add and configure the administrator user, which can be used to login to the web
console: ::

  # rabbitmqctl add_user "admin" <ADMIN_PASSWORD>
  # rabbitmqctl set_permissions -p /cvmfs "admin" ".*" ".*" ".*"
  # rabbitmqctl set_user_tags "admin" administrator

``<ADMIN_PASSWORD>`` should be substituted for a suitable strong password.

Add and configure the worker user: ::

  # rabbitmqctl add_user "worker" <WORKER_PASSWORD>
  # rabbitmqctl set_permissions -p /cvmfs "worker" "^(amq\.gen.*|repository\.activity)$" "^(amq\.gen.*|repository\.activity)$" ".*"

As before, ``<WORKER_PASSWORD>`` should be substituted for a suitable strong
password.

With RabbitMQ installed and configured, the final steps are to install the
``cvmfs-notify`` package and open firewall port 4930/TCP.

``cvmfs-notify`` is configured in ``/etc/cvmfs/notify/config.json``: ::

  {
      "port": 4930,
      "log_level": "info",
      "amqp": {
          "url": "localhost",
          "exchange": "repository.activity",
          "vhost": "/cvmfs",
          "port": 5672,
          "user": "<USERNAME>",
          "pass": "<PASSWORD>"
      }
  }

Most of the fields can be kept at their default value, but the "user" and
"pass" fields should be changed to the values of the worker username and
password defined at the previous step.

4. Start and enable the ``cvmfs-notify`` service: ::

    # systemctl start cvmfs-notify
    # systemctl enable cvmfs-notify

Command-line tool for the notification system
=============================================

There is a new ``notify`` subcommand in the ``cvmfs_swissknife`` command, which
is used to publish and subscribe to activity messages for a specific
repository.

Example:
--------

* The CernVM-FS repository is located at ``http://stratum-zero.cern.ch/cvmfs/test.repo.ch``
* The notification server is located at ``http://notify.cern.ch:4930/api/v1``

To publish the current manifest of the repository to the notification system, simply run: ::

  # cvmfs_swissknife notify -p \
    -u http://notify.cern.ch:4930/api/v1/publish \
    -r http://stratum-zero.cern.ch/cvmfs/test.cern.ch

To subscribe to the stream of messages concerning the repository, run: ::

  # cvmfs_swissknife notify -s \
    -u http://notify.cern.ch:4930/api/v1/subscribe \
    -t test.cern.ch

By default, once a message is received, the command will exit.

The subscription command has two optional flags:

* ``-c`` enables "continuous" mode. When messages are received, the command
  will output the message but will not exit.
* ``-m NUM`` specifies of minimum repository revision number to react to. For
  messages with a revision number smaller than or equal to ``NUM``, no output
  is printed and the command will not exit (when the ``-c`` flag is not given).

CernVM-FS client configuration
==============================

A CernVM-FS client can also be connected to a notification server, allowing the
client to react to activity messages by triggering a remount of the repository.

This functionality is enabled with the following client configuration option:
::

  CVMFS_NOTIFICATION_SERVER=http://notify.cern.ch:4930/api/v1/subscribe
