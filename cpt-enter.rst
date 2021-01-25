.. _cpt_enter:

Ephemeral Writable Container
============================

**Note:** this feature is still considered experimental.

The CernVM-FS ephemeral writable container can provide a short-lived shell with writable access to a regular, read-only CernVM-FS repository.
A writable CernVM-FS mountpoint is normally a functionality that only publisher nodes provide.
With the ephemeral writable container, this capability becomes available to every regular client.

The ephemeral writable container requires the ``cvmfs-server`` package to be installed.
Provided that the target repository is already mounted, a writable shell is opened with

::

    cvmfs_server enter <repository name> [-- <command>]

Changes to the writable mountpoint are only stored locally.
The changes are discarded when the shell is closed.
In a future release it will be possible to publish changes directly to a gateway.

Repository changes in the writable shell can be shown with

::

    cvmfs_server diff --worktree

Before closing the shell, changes can be manually copied to a publisher node for publication.
This helps with building and deploying non-relocatable packages to CernVM-FS.

The ephemeral writable container uses Linux user namespaces and fuse-overlayfs in order to construct the writable repository mountpoint.
Therefore, it requires a recent enough kernel.
The vanilla kernel >= 4.18 and the EL 8 kernel are known to work.

The container creates a session directory in ``$HOME/.cvmfs`` to store temporary files and changes to the repository.
By default, the session directory is removed when exiting the shell.
It can be preserved with the ``--keep-session`` parameter.
If only the logs should be preserved, use the ``--keep-logs`` parameter instead.

If necessary, the container can be opened as fake root user using the ``root`` option.

Note that by default a dedicated CernVM-FS cache directory is created for the lifetime of the ephemeral container.
It can be desireable to use a shared cache directory across several invocations of the ``cvmfs_server enter`` command.
To do so, use the ``--cvmfs-config <config file>`` parameter and set ``CVMFS_CACHE_BASE=/common/path`` in the passed configuration file.
