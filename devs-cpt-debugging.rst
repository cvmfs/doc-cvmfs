Debugging
=========

Live Debugging
~~~~~~~~~~~~~~

The easiest way of live debugging is to mount the client in debug (``-d``) and foreground (``-f``) using ``cvmfs2``.
Mounting with ``cvmfs2`` allows also to set a few parameters, e.g. ``libfuse=`` to select ``Fuse2`` or 
``Fuse3``.

Example mounting with ``Fuse3``
::

    export CVMFS_REPO=symlink.test.repo
    sudo /usr/bin/cvmfs2    -d -f \
                            -o rw,system_mount,fsname=cvmfs2,allow_other,grab_mountpoint,uid=998,gid=997,libfuse=3 \
                            $CVMFS_REPO \
                            /mnt/test


Delete local kernel caches
^^^^^^^^^^^^^^^^^^^^^^^^^^
::

    sudo echo 3 > /proc/sys/vm/drop_caches


Running CernVM-FS tests
~~~~~~~~~~~~~~~~~~~~~~~

Integration tests can be split in two groups: client tests and server tests.
Client tests are run against some CERN repo, e.g. ``/cvmfs/grid.cern.ch``.
Server tests are test that create their own CernVM-FS repository during testing.
Both of them are found in ``cvmfs/test/src``.
All tests with a number < 500 are client tests.
And all tests >= 500 are server tests.



Setup
^^^^^

Go to ``test`` directiory withing ``cvmfs``.

Client Tests
^^^^^^^^^^^^

::

    # CVMFS_TEST_USER = user name executing the command
    CVMFS_TEST_USER=<user> ./run.sh /tmp/cvmfs-integration.log src/087-xattrs


Server Tests
^^^^^^^^^^^^

::
    
    # CVMFS_TEST_USER = user name executing the command
    # CVMFS_TEST_REPO = repo created for the test

    CVMFS_TEST_REPO=just.test.repo CVMFS_TEST_USER=<user> ./run.sh /tmp/cvmfs-integration.log src/701-xattr-catalog_counters



Writing your own tests
~~~~~~~~~~~~~~~~~~~~~~

Writing your own integration tests is done the following:

- Decide what type of test you need: client or server test
- Create a new subfolder in ``cvmfs/test/src/`` with the appropriate number and name

    - Client test = number < 500
    - Server test = number >= 500
- Create a ``main`` script

    - It is a ``bash``-script.
    - It has NO file ending
- Your test can be executed like all the other tests. No compilation of the ``cmvfs`` source code needed.


Tipps
    - ``return`` values must be handed up to the parent function ``my_sub_func || return $?``
    - for readability it might be nice to split the test routines in multiple files

        - Use the line ``source ./src/701-xattr-catalog_counters/setup_teardown`` to include another file in the file ``main``. It should be positioned after the ``cvmfs_test_suites`` parameter
        
