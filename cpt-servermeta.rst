CernVM-FS Server Meta Information
=================================

The CernVM-FS server automatically maintains both global and repository specifc
meta information as JSON data. Release manager machines keep a list of hosted
Stratum0 and Stratum1 repositories and user-defined administrative meta
information.

Furthermore each repository contains user-maintained and signed meta information
gets replicated to Stratum1 servers automatically.

.. _sct_globalmetainfo:

Global Meta Information
-----------------------

This JSON data provides information about the CernVM-FS server itself. A list of
all repositories (both Stratum0 and Stratum1) hosted at this specific server is
automatically generated and can be accessed here::

  http://<server base URL>/cvmfs/info/v1/repositories.json

Furthermore there might be user-defined information like the administrator's
name, contact information and an arbitrary user-defined JSON portion here::

  http://<server base URL>/cvmfs/info/v1/meta.json

Using the  ``cvmfs_server`` utility, an administrator can edit the user-defined
portion of the data with a text editor (cf. ``$EDITOR``)s::

  cvmfs_server update-info

Note that the ``cvmfs_server`` package requires the ``jq`` utility, which validates
CVMFS JSON data.

Below are :ref:`examples <sct_jsonexamples>` of both the repository list and
user-defined JSON files.

Repository Specific Meta Information
------------------------------------

Each repository contains a JSON object with repository specific meta data. The
information is maintained by the repository's owner on the Stratum0 release
manager machine. It contains the maintainer's contact information, a description
of the repository's content and a list of recommended Stratum1 replica URLs.
Furthermore it provides a custom JSON region for arbitrary information.

Note that this JSON file is stored inside CernVM-FS's backend data structure and
gets replicated to Stratum1 servers automatically.

Editing is done per repository using the ``cvmfs_server`` utilitiy. As with the
:ref:`global meta information <sct_globalmetainfo>` ``cvmfs_server`` uses ``jq``
to validate edited JSON information before storing it::

  cvmfs_server update-repoinfo <repo name>

Besides the interactive editing (cf. ``$EDITOR``) one can specify a file path
that should be stored as the repository's meta information::

  cvmfs_server update-repoinfo -f <path to JSON file> <repo name>

An example of a repository specific meta information file can be found in
:ref:`the section below <sct_repometainfo_example>`.

.. _sct_jsonexamples:

Examples
--------

/cvmfs/info/v1/meta.json
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: json

  {
    "administrator" : "Your Name",
    "email"         : "you@organisation.org",
    "organisation"  : "Your Organisation",

    "custom" : {
      "_comment" : "Put arbitrary structured data here"
    }
  }


/cvmfs/info/v1/repositories.json
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: json

  {
    "schema"       : 1,
    "repositories" : [
      {
        "name"  : "atlas.cern.ch",
        "url"   : "/cvmfs/atlas.cern.ch"
      },
      {
        "name"  : "cms.cern.ch",
        "url"   : "/cvmfs/cms.cern.ch"
      }
    ],
    "replicas" : [
      {
        "name"  : "lhcb.cern.ch",
        "url"   : "/cvmfs/lhcb.cern.ch"
      }
    ]
  }

.. _sct_repometainfo_example:

Repository Specific Meta Information
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: json

  {
    "administrator" : "Your Name",
    "email"         : "you@organisation.org",
    "organisation"  : "Your Organisation",
    "description"   : "Repository content",
    "recommended-stratum1s" : [ "stratum1 url", "stratum1 url" ],

    "custom" : {
      "_comment" : "Put arbitrary structured data here"
    }
  }
