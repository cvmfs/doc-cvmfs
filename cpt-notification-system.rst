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
havingpileup of new samples. Another case is the construction of a complex
software build and test pipeline, where later stages of the pipeline depend on
artifacts published at earlier stages of the pipeline already being available
on replicas of the repository.

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

RabbitMQ configuration
----------------------

1. Install ``rabbitmq-server``
2. Open firewall ports: 5672/TCP, 15672/TCP
3. Configure RabbitMQ
4. Start and enable the RabbitMQ service

cvmfs-notify configuration
--------------------------

1. Install the ``cvmfs-notify`` package
2. Open firewall port 4930/TCP
3. Edit ``/etc/cvmfs/notify/config.json``

::

  {
      "port": 4930,
      "log_level": "info",
      "amqp": {
          "url": "localhost",
          "exchange": "repository.activity",
          "port": 5672,
          "user": "<USERNAME>",
          "pass": "<PASSWORD>"
      }
  }

4. Start and enable the ``cvmfs-notify`` service

Command-line tool for the notification system
=============================================

CernVM-FS client configuration
==============================
