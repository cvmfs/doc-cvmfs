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

The main components of the notification system are a message broker, part of
the CernVM-FS repository gateway application, and a command-line tool to
publish new messages and subscribe to notifications. CernVM-FS clients can also
be configured to receive and react to notifications. Communication between the
notification system clients and the broker is done with standard HTTP. The
message broker does not require any specific configuration. Please consult the
relevant documentation (:ref:`cpt_repository_gateway`) for setting up a
gateway.

Command-line tool for the notification system
---------------------------------------------

There is a new ``notify`` sub-command in the ``cvmfs_swissknife`` command, which
is used to publish and subscribe to activity messages for a specific
repository.

Example:
========

* The CernVM-FS repository is located at ``http://stratum-zero.cern.ch/cvmfs/test.repo.ch``
* The repository gateway is located at ``http://gateway.cern.ch:4929/api/v1``

To publish the current manifest of the repository to the notification system, simply run: ::

  # cvmfs_swissknife notify -p \
    -u http://gateway.cern.ch:4929/api/v1 \
    -r http://stratum-zero.cern.ch/cvmfs/test.cern.ch

To subscribe to the stream of messages concerning the repository, run: ::

  # cvmfs_swissknife notify -s \
    -u http://gateway.cern.ch:4929/api/v1 \
    -t test.cern.ch

By default, once a message is received, the command will exit.

The subscription command has two optional flags:

* ``-c`` enables "continuous" mode. When messages are received, the command
  will output the message but will not exit.
* ``-m NUM`` specifies of minimum repository revision number to react to. For
  messages with a revision number smaller than or equal to ``NUM``, no output
  is printed and the command will not exit (when the ``-c`` flag is not given).

CernVM-FS client configuration
------------------------------

A CernVM-FS client can also be connected to a notification server, allowing the
client to react to activity messages by triggering a remount of the repository.

This functionality is enabled with the following client configuration option:
::

  CVMFS_NOTIFICATION_SERVER=http://gateway.cern.ch:4929/api/v1
