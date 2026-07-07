# Filebundle Prefetching

!!! note

    This feature is still considered experimental.

File bundles let a repository declare that opening one file should trigger
prefetching of a set of related files. Many applications repeatedly open the
same group of files together (shared libraries, data files, configuration).
Fetched individually, each of these incurs a separate network round trip on a
cold cache. A file bundle groups them so that a single `open()` of a *trigger*
file pulls in the whole set in parallel.

## Bundle specification files

A bundle is described by a specification file placed next to its trigger file
in the same directory. The specification file is named
`.cvmfsbundle-<filename>`, where `<filename>` is the file that triggers the
bundle. For example, to make opening `libexample.so` prefetch its companion
files, place a `.cvmfsbundle-libexample.so` next to it.

The specification is a small, versioned JSON document. It lists the files to
prefetch as absolute paths from the repository root:

```json
{
  "name": "CVMFS_BUNDLE",
  "version": "1.0.0",
  "encoding": "UTF-8",
  "dependencies": [
    "/lib/libexample.so",
    "/lib/libexample-helper.so",
    "/share/example/data.bin"
  ]
}
```

The `dependencies` array holds the files that are fetched and decompressed
when the trigger file is opened. The trigger file itself does not need to be
listed.

## Publishing a bundle

Bundle specification files are published like any other file in the
repository. Inside a transaction, create the trigger file and its
`.cvmfsbundle-<filename>` specification in the same directory, then publish:

```bash
cvmfs_server transaction example.cern.ch

cat > /cvmfs/example.cern.ch/lib/.cvmfsbundle-libexample.so <<EOF
{
  "name": "CVMFS_BUNDLE",
  "version": "1.0.0",
  "encoding": "UTF-8",
  "dependencies": [
    "/lib/libexample.so",
    "/lib/libexample-helper.so",
    "/share/example/data.bin"
  ]
}
EOF

cvmfs_server publish example.cern.ch
```

The publisher links each specification file to its trigger file. Removing the
specification file (and publishing again) removes the bundle; the trigger file
then behaves like a normal file.

You can verify that a file is recognized as a bundle trigger through the
`bundle_trigger` extended attribute, which is `1` for a trigger file and `0`
otherwise:

```bash
$ attr -g bundle_trigger /cvmfs/example.cern.ch/lib/libexample.so
1
```

## Enabling prefetching on the client

File bundle prefetching is **off by default** and must be enabled per mount
through the client option `CVMFS_PREFETCH_FILEBUNDLES`:

```
CVMFS_PREFETCH_FILEBUNDLES=yes
```

When enabled, opening a trigger file spawns a dedicated pool of fetcher
threads that retrieve and decompress the bundle's dependencies in parallel,
populating the local cache ahead of the application's subsequent `open()`
calls. The decision whether bundle prefetching is active is made once at mount
time, so clients that leave the option disabled incur no additional overhead.
