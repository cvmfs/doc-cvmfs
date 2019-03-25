.. _cpt_tracer:

Tracing File System Accesses
============================

The CernVM-FS Fuse client comes with a built-in tracer that can be used to
record file system accesses to repositories. The tracer produces a CSV file.
Every file system call, such as opening a file or listing a directory, is
written as another line into the log file.

In order to activate the tracer, set

::

    CVMFS_TRACEFILE=/tmp/cvmfs-trace-@fqrn@.log  # the cvmfs user must have write permission to the target directory

The ``@fqrn@`` syntax ensures that the trace file is different for every
repository.

The trace is internally buffered. Therefore, it is important to either unmount
the CernVM-FS client or to call ``cvmfs_talk tracebuffer flush`` at the end
of a tracing session in order to produce a complete record.

By default, the trace buffer can keep 8192 recorded calls, and it will start to
flush on disk at 7000 recorded system calls. The buffer parameters can be
adjusted with the two parameters ``CVMFS_TRACEBUFFER`` and
``CVMFS_TRACEBUFFER_THRESHOLD``.


Trace Log Format
----------------

The generated trace log is a CSV file with the following fields

==================== ===========================================================
**Field**            **Description**
==================== ===========================================================
  Timestamp          Seconds since the UNIX epoch, miliseconds precision

  Event code         Numerical ID for the system call.
                     Negative numbers indicate internal events, such as
                     mounting and unmounting.

  Path               The repository relative target path of the system call

  Event name         A string literal corresponding to the event code.
==================== ===========================================================

The following events are known:

============== =================================================================
**Event ID**   **Description**
============== =================================================================
  1            Open file

  2            List directory contents

  3            Read symbolic link

  4            Lookup path

  5            Get file system meta-data (e.g. df call)

  6            Get file/directory meta-data

  7            List extended attributes of a file/directory

  8            Read extended attributes of a file/directory
============== =================================================================
