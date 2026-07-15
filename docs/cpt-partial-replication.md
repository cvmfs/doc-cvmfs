# Partial Replication

Partial replication lets a Stratum 1 replicate only selected parts of a
repository.  It is useful when a site wants the persistence of hosting a local mirror for a
repository, but only needs a well-defined subset of the repository
content - for example binaries for only a certain architecture, when the repository provides several. 
Generally the recommendation is to just setup a large http proxy like squid in this situation, but partial replication, while more complex, offers some independence from the upstream server.

The partial Stratum 1 still serves the normal repository
manifest, catalogs, certificate, and whitelist, but it omits data objects
and nested catalogs for paths outside an inclusion specification.

A partial replica is configured on the Stratum 1.  Clients that use the
partial replica can configure if they prefer  partial-replica handling so they either
fall back to a full Stratum 1 for omitted content or fail explicitly when
omitted content is accessed.

!!! note

    Partial replication is available starting with CernVM-FS 2.14.0.

## How partial replication works

During `cvmfs_server snapshot`, the Stratum 1 reads an inclusion
specification file.  Paths listed in the specification are replicated;
subtrees that are not covered by an inclusion rule are skipped when objects are fetched from the upstream server.  The
specification itself is uploaded to the replica as
`.cvmfs_partial_replication`.  This file also marks the server as a partial replica.

Partial replication operates at [CernVM-FS catalog boundaries](cpt-repo.md#managing-nested-catalogs).  In
practice, paths that you want to include or exclude should be nested
catalog roots.  If a rule points inside an existing catalog, CernVM-FS
has to replicate the enclosing catalog and its objects.  Create nested
catalogs on the Stratum 0, for example with `.cvmfscatalog` marker files,
to get precise control over what the partial Stratum 1 stores.

## Inclusion specification

The inclusion specification is a text file.  The first non-empty,
non-comment line must be the format version:

```text
version 1
```

The remaining lines contain repository paths.  Paths are absolute within
the repository.  A positive rule includes a subtree.  A rule starting
with `!` excludes a subtree again, which is useful for removing a smaller
part from a larger included tree.  Empty lines and comments starting with
`#` are ignored.

For example:

```text
version 1
# Replicate the current software stack and common runtime data
/software/releases/2026
/software/runtime

# Replicate all calibration campaigns except temporary test data
/data/calibration/*
!/data/calibration/test
```

Important rule semantics:

- Anything not covered by a positive rule is excluded.
- Included paths also keep their parent catalogs reachable.
- Subpaths of an included path are included unless an exclusion rule
  matches them.
- Trailing slashes are ignored.
- Wildcards are supported by the same relaxed path filter syntax used by
  CernVM-FS path specifications, but they are most useful when they match
  nested catalog roots.

## Configuring a partial Stratum 1

Create the Stratum 1 as usual with `cvmfs_server add-replica`.  Then
store an inclusion specification on the Stratum 1 host.  A convenient
location is the repository configuration directory:

```bash
cat > /etc/cvmfs/repositories.d/example.cern.ch/partial-replication.spec <<EOF
version 1
/software/releases/2026
/software/runtime
/data/calibration/*
!/data/calibration/test
EOF
```

Enable partial replication in the replica's `server.conf`:

```bash
cat >> /etc/cvmfs/repositories.d/example.cern.ch/server.conf <<EOF
CVMFS_PARTIAL_REPLICATION=true
CVMFS_PARTIAL_REPLICATION_SPEC=/etc/cvmfs/repositories.d/example.cern.ch/partial-replication.spec
EOF
```

Run a snapshot.  The snapshot downloads and stores only the objects that
are required by the inclusion specification:

```bash
cvmfs_server snapshot example.cern.ch
```

You can verify that the replica advertises itself as partial by checking
for the uploaded specification file in the repository HTTP root:

```bash
curl -f http://stratum1.example.org/cvmfs/example.cern.ch/.cvmfs_partial_replication
```

The normal integrity checks and garbage collection are partial-aware as
long as the same server configuration remains in place.  For example:

```bash
cvmfs_server check -c example.cern.ch
cvmfs_server gc example.cern.ch
```

Keep `CVMFS_PARTIAL_REPLICATION_SPEC` available on the Stratum 1.  It is
used not only by snapshots, but also by check and garbage-collection
operations.

## Updating the replicated subset

To change the subset, edit the inclusion specification and run another
snapshot:

```bash
vi /etc/cvmfs/repositories.d/example.cern.ch/partial-replication.spec
cvmfs_server snapshot example.cern.ch
```

Newly included catalogs and objects are fetched during the snapshot.  If
paths are removed from the specification, they stop being part of the
current partial replica and can be removed from storage by garbage
collection once no served revision references them.

## Client configuration

Partial-replica handling is opt-in on the client.  Configure clients
that point at a partial Stratum 1 with `CVMFS_PARTIAL_REPLICA_MODE`.
Without this option, the client treats the server like a normal full
replica and omitted objects can appear as ordinary download failures.

### Transparent failover mode

In failover mode, the client first reads from the partial Stratum 1.  If
an object is missing from the partial replica, the client retries that
object from a full Stratum 1 specified by `CVMFS_FULL_STRATUM1_URL`.
This keeps the complete repository visible while using the partial
replica for the selected hot subset.

```text
CVMFS_SERVER_URL=http://partial-s1.example.org/cvmfs/example.cern.ch
CVMFS_PARTIAL_REPLICA_MODE=failover
CVMFS_FULL_STRATUM1_URL=http://full-s1.example.org/cvmfs/example.cern.ch
```

Only `404 Not Found` responses from the partial replica trigger the
fallback.  Other HTTP errors are treated as server or network problems
and are not hidden by failover.

### Fail mode

In fail mode, the client does not use a full-replica fallback.  Access to
content outside the replicated subset fails.  Where the client can
resolve metadata for excluded entries, they can be shown with mode `000`
and owner/group `65534` (`nobody`/`nogroup`) to indicate that the content
is intentionally unavailable.

```text
CVMFS_SERVER_URL=http://partial-s1.example.org/cvmfs/example.cern.ch
CVMFS_PARTIAL_REPLICA_MODE=fail
```

Use fail mode when jobs are expected to use only the replicated subset
and accidental access outside the subset should be caught immediately.

## Operational recommendations

- Stratum-1s also serve as backups and fallbacks for the repository. If your stratum-1 is public, consider replicating the whole repository, this will strengthen the infrastructure for everyonge.
- Align the inclusion specification with nested catalog boundaries.  Add
  nested catalogs on the Stratum 0 for large subtrees that should be
  included or excluded independently.
- Keep the inclusion specification under configuration management and use
  the same file for snapshot, check, and garbage-collection operations.
- After changing the specification, run `cvmfs_server check -c` to verify
  that the partial replica is self-consistent.
