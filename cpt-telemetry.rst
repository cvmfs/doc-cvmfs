.. _cpt_telemetry:

Client Telemetry Aggregators
============================

It is possible to configure the client to send in regular intervals the performance counters listed by ``cvmfs_talk internal affairs``.
By default, an aggregator is available that exposes the counters in InfluxDB data format. 
It can easily be replaced by any other aggregator in a form of a source code plugin.

Independent of the aggregator following 2 client parameters must be set: 
::
    
    CVMFS_TELEMETRY_SEND=ON
    CVMFS_TELEMETRY_RATE=<rate in seconds> # minimum send rate >= 5 sec


Influx Telemetry Aggregator
---------------------------

The Influx Telemetry Aggregator sends per timestamp two versions of the counters: 
their absolute values and the delta between two timestamps to a socket.
For this, the measurement name given by ``CVMFS_INFLUX_METRIC_NAME`` is extended with either ``_absolute`` or ``_delta``.

Mandatory client parameters for the Influx Telemetry Aggregator are

::

    CVMFS_INFLUX_HOST=localhost                 # IP address
    CVMFS_INFLUX_PORT=8092                      # Port            
    CVMFS_INFLUX_METRIC_NAME=<measurement name> # "Table" name

And optional parameters are

::

    CVMFS_INFLUX_EXTRA_TAGS="some_tag=42,some_tag2=27" # always included 
    CVMFS_INFLUX_EXTRA_FIELDS="somefield=3"            # not included in delta

The general layout of the data send is

::

    # for absolute
    CVMFS_INFLUX_METRIC_NAME_absolute,repo=@fqrn,CVMFS_INFLUX_EXTRA_TAGS countername=value,...,CVMFS_INFLUX_EXTRA_FIELDS timestamp

    # for delta (no CVMFS_INFLUX_EXTRA_FIELDS)
    CVMFS_INFLUX_METRIC_NAME_delta,repo=@fqrn,CVMFS_INFLUX_EXTRA_TAGS countername=value_new - value_old,... timestamp



.. warning::
    In the output, counters are only included if they have been used at least once (value != 0). 
    And for the very first measurement no delta values are available.

Writing Your Own Aggregator
---------------------------

The ``TelemetryAggregator`` base class consists of a loop that for each time step 
snapshots the counters (saved to ``counters_``), and calls ``PushMetrics()``.
``PushMetrics()`` needs to be overwritten by your own aggregator to perform all manipulations
needed for the counters and the sending/storing of the counters.

To write your own aggregator you need the following parts:

* Your aggregator must inherit from ``TelemetryAggregator``
* Your aggregator's constructor must take care of additional client parameters needed.
  In case your object is incorrectly constructed, ``is_zombie_`` **MUST** be set to ``true``.
* Your aggregator must overwrite ``PushMetrics()``
* Create a new value for your aggregator in enum ``TelemetrySelector``
* Add your aggregator inside the ``Create()`` of ``TelemetryAggregator`` using the newly created value of ``TelemetrySelector``
* Change in ``mountpoint.cc`` the ``TelemetrySelector`` used in ``perf::TelemetryAggregator::Create``

.. note::

  Please feel free to contribute your aggregator to the CVMFS project, so we can expand the number of
  available aggregators to all users.


