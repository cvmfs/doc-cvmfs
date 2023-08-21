# Specialized CVMFS Builds from Source

Building CVMFS from source allows personalizing CVMFS further to your needs.
This can be either due to setting certain build flags or through providing a custom
source-code plugin.

## Source-Code Plugins

Source-code plugins are plugins you write on your own that please a given interface.
In some cases, multiple source code plugins might be already made available by CVMFS,
e.g. there are multiple different cache mangers to choose from, but you can also write
your own.

| Name                                       | Description                                                                      |
| ------------------------------------------ | -------------------------------------------------------------------------------- |
| {ref}`sct_plugin_cache`                    | Write you own cache manager                                                      |
| {ref}`Telemetry Aggregator<cpt_telemetry>` | Write your own data format how ``cvmfs_talk internal affairs`` is sent to remote |




## Build flags

Build flags must be added to the `cmake`-configure step with `-D <extra-flag>` (see {ref}`sct_building_from_source` for more details).

### `CVMFS_SUPPRESS_ASSERTS`
-  Replaces certain `asserts` by a logging message instead and has an infinite backoff throttle for `out-of-memory` situations
-  Affects the client
-  Useful when the client has a very short TTL for catalogs and runs a lot of updates in parallel and at the same time
   has a high usage frequency
:::{warning}
  This is not a recommended build flag. In very rare cases can the removal of `asserts` lead to undefined client behavior
:::

