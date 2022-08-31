Codestyle
=========

In general all information about the codestyle can be found in `cvmfs/CONTRIBUTING.md <https://github.com/cvmfs/cvmfs/blob/devel/CONTRIBUTING.md>`_.

Important code style rules to know are:

- Tab indent: 2
- Max characters per line: 80

In case of a necessary linebreak, the following style should be followed
::

    // preferred
    foo()-> 
      bar()

    // not preferred
    foo()
      ->bar()