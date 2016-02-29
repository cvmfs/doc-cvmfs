Creating a Repository (Stratum 0)
=================================

CernVM-FS is a file system with a single source of (new) data. This
single source, the repository *Stratum 0*, is maintained by a dedicated
*release manager machine* or *installation box*. A read-writable copy of
the repository is accessible on the release manager machine. The
CernVM-FS server tool kit is used to *publish* the current state of the
repository on the release manager machine. Publishing is an atomic
operation.

All data stored in CernVM-FS have to be converted into a
CernVM-FS *repository* during the process of publishing. The
CernVM-FS repository is a form of content-addressable storage.
Conversion includes creating the file catalog(s), compressing new and
updated files and calculating content hashes. Storing the data in a
content-addressable format results in automatic file de-duplication. It
furthermore simplifies data verification and it allows for file system
snapshots.

In order to provide a writable CernVM-FS repository, CernVM-FS uses a union
file system that combines a read-only CernVM-FS mount point with a writable
scratch area [1, 2]. :ref:`This figure below <fig_updateprocess>` outlines the
process of publishing a repository.

CernVM-FS Server Quick-Start Guide
----------------------------------

System Requirements
~~~~~~~~~~~~~~~~~~~

-  Apache HTTP server *or* S3 compatible storage service

-  union file system in the kernel

   - AUFS (see :ref:`sct_customkernelinstall`)

   - OverlayFS (as of kernel version 4.2.x)

-  Officially supported platforms

   -  Scientific Linux 5 (64 bit)

   -  Scientific Linux 6 (64 bit - with custom AUFS enabled kernel -
      Appendix ":ref:`apx_rpms`")

   -  Fedora 22 and above (with kernel :math:`\ge` 4.2.x)

   -  Ubuntu 12.04 64 bit and above

       - Ubuntu < 15.10: with installed AUFS kernel module
         (cf. `linux-image-extra` package)

       - Ubuntu 15.10 and later (using upstream OverlayFS)

Installation
~~~~~~~~~~~~

#. Install ``cvmfs`` and ``cvmfs-server`` packages

#. Ensure enough disk space in ``/var/spool/cvmfs`` (>50GiB)

#. For local storage: Ensure enough disk space in ``/srv/cvmfs``

#. Create a repository with ``cvmfs_server mkfs`` (See :ref:`sct_repocreation`)

Content Publishing
~~~~~~~~~~~~~~~~~~

#. ``cvmfs_server transaction <repository name>``

#. Install content into ``/cvmfs/<repository name>``

#. Create nested catalogs at proper locations

   -  Create ``.cvmfscatalog`` files (See :ref:`sct_nestedcatalogs`)
      or

   -  Consider using a ``.cvmfsdirtab`` file (See :ref:`sct_dirtab`)

#. ``cvmfs_server publish <repository name>``

Backup Policy
~~~~~~~~~~~~~

-  Create backups of signing key files in ``/etc/cvmfs/keys``

-  Entire repository content

   -  For local storage: ``/srv/cvmfs``

   -  Stratum 1s can serve as last-ressort backup of repository content

.. _sct_customkernelinstall:

Installing the AUFS-enabled Kernel on Scientific Linux 6
--------------------------------------------------------

CernVM-FS uses the union file-system aufs [1] to efficiently determine
file-system tree updates while publishing repository transactions on the
server (see Figure :ref:`below <fig_updateprocess>`). Note that this is *only*
required on a CernVM-FS server and *not* on the client machines.

| We provide customised kernel packages for Scientific Linux 6 (see
  Appendix ":ref:`apx_rpms`") and keep them up-to-date with upstream kernel
  updates. The kernel RPMs are published in the ``cernvm-kernel`` yum
  repository.
| Please follow these steps to install the provided customised kernel:

#. Download the latest cvmfs-release package from the CernVM
   website [1]_

#. | Install the cvmfs-release package:
     ``yum install cvmfs-release*.rpm``
   | This adds the CernVM yum repositories to your machine’s
     configuration.

#. | Install the aufs enabled kernel from ``cernvm-kernel``:
   | ``yum --disablerepo=* --enablerepo=cernvm-kernel install kernel``

#. | Install the aufs user utilities:
   | ``yum --enablerepo=cernvm-kernel install aufs2-util``

#. Reboot the machine

Once a new kernel version is released ``yum update`` will *not* pick the
upstream version but it will wait until the patched kernel with
aufs support is published by the CernVM team. We always try to follow
the kernel updates as quickly as possible.

Publishing a new Repository Revision
------------------------------------

.. _fig_updateprocess:

.. figure:: _static/update_process.svg
   :alt: CernVM-FS server schematic update overview

   Updating a mounted CernVM-FS repository by overlaying it with a
   copy-on-write union file system volume. Any changes will be
   accumulated in a writable volume (yellow) and can be synchronized
   into the CernVM-FS repository afterwards. The file catalog contains
   the directory structure as well as file metadata, symbolic links, and
   secure hash keys of regular files. Regular files are compressed and
   renamed to their cryptographic content hash before copied into the
   data store.

Since the repositories may contain many file system objects (i.e. ATLAS
contains :math:`70 * 10^6` file system objects -- February 2016), we
cannot afford to generate an entire repository from scratch for every
update. Instead, we add a writable file system layer on top of a mounted
read-only CernVM-FS repository using a union file system.
This renders a read-only CernVM-FS mount point writable to the user,
while all performed changes are stored in a special writable scratch
area managed by the union file system. A similar approach is used by Linux
Live Distributions that are shipped on read-only media, but allow *virtual*
editing of files where changes are stored on a RAM disk.

If a file in the CernVM-FS repository gets changed, the union file system
first copies it to the writable volume and applies any changes to this copy
(copy-on-write semantics). Also newly created files or directories will be
stored in the writable volume. Additionally the union file system creates
special hidden files (called *white-outs*) to keep track of file
deletions in the CernVM-FS repository.

Eventually, all changes applied to the repository are stored in this
scratch area and can be merged into the actual CernVM-FS repository by a
subsequent synchronization step. Up until the actual synchronization
step takes place, no changes are applied to the CernVM-FS repository.
Therefore, any unsuccessful updates to a repository can be rolled back
by simply clearing the writable file system layer of the union file system.

Requirements for a new Repository
---------------------------------

In order to create a repository, the server and client part of
CernVM-FS must be installed on the release manager machine. Furthermore
you will need a kernel containing a union file system implementation as
well as a running ``Apache2`` web server. Currently we support Scientific
Linux 6, Ubuntu 12.04+ and Fedora 22+ distributions. Please note, that
Scientific Linux 6 *does not* ship with an aufs enabled kernel, therefore
we provide a compatible patched kernel as RPMs (see
:ref:`sct_customkernelinstall` for details).

Historically CernVM-FS solely used `aufs <http://aufs.sourceforge.net/>`_
as a union file system. However, the Linux kernel community favoured `OverlayFS
<https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt>`_, a
competing union file system implementation that was merged upstream. Hence,
since CernVM-FS 2.2.0 we support the usage of both OverlayFS and aufs.
Note however, that the first versions of OverlayFS were broken and will not
work properly with CernVM-FS. At least a 4.2.x kernel is needed to use
CernVM-FS with OverlayFS.

.. _sct_serveranatomy:

Notable CernVM-FS Server Locations and Files
--------------------------------------------

There are a number of possible customisations in the CernVM-FS server
installation. The following table provides an overview of important
configuration files and intrinsical paths together with some
customisation hints. For an exhaustive description of the
CernVM-FS server infrastructure please consult
Appendix ":ref:`apx_serverinfra`".

======================================== =======================================
**File Path**                            **Description**
======================================== =======================================
  ``/cvmfs``                             **Repository mount points**
                                         Contains read-only union file system
                                         mountpoints that become writable during
                                         repository updates. Do not symlink or
                                         manually mount anything here.

  ``/srv/cvmfs``                         **Central repository storage location**
                                         Can be mounted or symlinked to another
                                         location *before* creating the first
                                         repository.

  ``/srv/cvmfs/<fqrn>``                  **Storage location of a repository**
                                         Can be symlinked to another location
                                         *before* creating the repository
                                         ``<fqrn>``.

  ``/var/spool/cvmfs``                   **Internal states of repositories**
                                         Can be mounted or symlinked to another
                                         location *before* creating the first
                                         repository.
                                         Hosts the scratch area described
                                         :ref:`here <sct_repocreation_update>`,
                                         thus might consume notable disk space
                                         during repository updates.

  ``/etc/cvmfs``                         **Configuration files and keychains**
                                         Similar to the structure described in
                                         :ref:`this table <tab_configfiles>`. Do
                                         not symlink this directory.

  ``/etc/cvmfs/cvmfs_server_hooks.sh``   **Customisable server behaviour**
                                         See ":ref:`sct_serverhooks`" for
                                         further details

  ``/etc/cvmfs/repositories.d``          **Repository configuration location**
                                         Contains repository server specific
                                         configuration files.
======================================== =======================================


.. _sct_repocreation_update:

CernVM-FS Repository Creation and Updating
------------------------------------------

The CernVM-FS server tool kit provides the ``cvmfs_server`` utility in
order to perform all operations related to repository creation,
updating, deletion, replication and inspection. Without any parameters
it prints a short documentation of its commands.

.. _sct_repocreation:

Repository Creation
~~~~~~~~~~~~~~~~~~~

A new repository is created by ``cvmfs_server mkfs``:

::

      cvmfs_server mkfs my.repo.name

The utility will ask for a user that should act as the owner of the
repository and afterwards create all the infrastructure for the new
CernVM-FS repository. Additionally it will create a reasonable default
configuration and generate a new release manager certificate and
software signing key. The public key in
``/etc/cvmfs/keys/my.repo.name.pub`` needs to be distributed to all
client machines.

The ``cvmfs_server`` utility will use ``/srv/cvmfs`` as storage location
by default. In case a separate hard disk should be used, a partition can
be mounted on /srv/cvmfs or /srv/cvmfs can be symlinked to another
location (see :ref:`sct_serveranatomy`). Besides local storage it is
possible to use an :ref:`S3 compatible storage service <sct_s3storagesetup>`
as data backend.

Once created, the repository is mounted under ``/cvmfs/my.repo.name``
containing only a single file called ``new_repository``. The next steps
describe how to change the repository content.

Repositories for Volatile Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Repositories can be flagged as containing *volatile* files using the
``-v`` option:

::

      cvmfs_server mkfs -v my.repo.name

When CernVM-FS clients perform a cache cleanup, they treat files from
volatile repositories with priority. Such volatile repositories can be
useful, for instance, for experiment conditions data.

.. _sct_s3storagesetup:

S3 Compatible Storage Systems
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

CernVM-FS can store files directly to S3 compatible storage systems,
such as Amazon S3, Huawei UDS and OpenStack SWIFT. The S3 storage
settings are given as parameters to ``cvmfs_server mkfs`` or
``cvmfs_server add-replica``:

::

      cvmfs_server mkfs -s /etc/cvmfs/.../mys3.conf \
        -w http://s3.amazonaws.com/mybucket-1-1 my.repo.name

The file “mys3.conf” contains the S3 settings (see :ref: `table below
<tab_s3confparameters>`). The “-w” option is used define the S3 server URL,
e.g. http://localhost:3128, which is used for accessing the repository’s
backend storage on S3. Note that this URL can be different than the S3 server
address that is used for uploads, e.g. if a proxy server is deployed in front
of the server. Note that the buckets need to exist before the repository is
created. In the example above, a single bucket ``mybucket-1-1`` needs to be
created beforehand.

.. _tab_s3confparameters:

=============================================== ===========================================
**Parameter**                                   **Meaning**
=============================================== ===========================================
``CVMFS_S3_ACCOUNTS``                           Number of S3 accounts to be used, e.g. 1.
                                                With some S3 servers use of multiple
                                                accounts can increase the upload speed
                                                significantly
``CVMFS_S3_ACCESS_KEY``                         S3 account access key(s) separated with
                                                ``:``, e.g. KEY-A:KEY-B:...
``CVMFS_S3_SECRET_KEY``                         S3 account secret key(s) separated with
                                                ``:``, e.g. KEY-A:KEY-B:...
``CVMFS_S3_BUCKETS_PER_ACCOUNT``                S3 buckets used per account, e.g. 1. With
                                                some S3 servers use of multiple buckets can
                                                increase the upload speed significantly
``CVMFS_S3_HOST``                               S3 server hostname, e.g. s3.amazonaws.com
``CVMFS_S3_BUCKET``                             S3 bucket base name. Account and bucket
                                                index are appended to the bucket base name.
                                                If you use just one account and one bucket,
                                                e.g. named ``mybucket``, then you need to
                                                create only one bucket called
                                                ``mybucket-1-1``
``CVMFS_S3_MAX_NUMBER_OF_PARALLEL_CONNECTIONS`` Number of parallel uploads to the S3
                                                server, e.g. 400
=============================================== ===========================================

In addition, if the S3 backend is configured to use multiple accounts or
buckets, a proxy server is needed to map HTTP requests to correct
buckets. This mapping is needed because CernVM-FS does not support
buckets but assumes that all files are stored in a flat namespace. The
recommendation is to use a Squid proxy server (version
:math:`\geq 3.1.10`). The squid.conf can look like this:

::

    http_access allow all
    http_port 127.0.0.1:3128 intercept
    cache_peer swift.cern.ch parent 80 0 no-query originserver
    url_rewrite_program /usr/bin/s3_squid_rewrite.py
    cache deny all

The bucket mapping logic is implemented in ``s3_squid_rewrite.py`` file.
This script is not provided by CernVM-FS but needs to be written by the
repository owner (the CernVM-FS Git repository `contains an example
<https://github.com/cvmfs/cvmfs/blob/devel/add-ons/s3rewrite.py>`_). The script
needs to read requests from stdin and write mapped URLs to stdout, for instance:

::

    in: http://localhost:3128/data/.cvmfswhitelist
    out: http://swift.cern.ch/cernbucket-9-91/data/.cvmfswhitelist

.. _sct_repoupdate:

Repository Update
~~~~~~~~~~~~~~~~~

Typically a repository publisher does the following steps in order to
create a new revision of a repository:

#. Run ``cvmfs_server transaction`` to switch to a copy-on-write enabled
   CernVM-FS volume

#. Make the necessary changes to the repository, add new directories,
   patch certain binaries, …

#. Test the software installation

#. Do one of the following:

   -  Run ``cvmfs_server publish`` to finalize the new repository
      revision *or*

   -  Run ``cvmfs_server abort`` to clear all changes and start over
      again

CernVM-FS supports having more than one repository on a single server
machine. In case of a multi-repository host, the target repository of a
command needs to be given as a parameter when running the
``cvmfs_server`` utility. The ``cvmfs_server resign`` command should run
every 30 days to update the signatures of the repository. Most
``cvmfs_server`` commands allow for wildcards to do manipulations on
more than one repository at once, ``cvmfs_server migrate *.cern.ch``
would migrate all present repositories ending with ``.cern.ch``.

Repository Import
~~~~~~~~~~~~~~~~~

The CernVM-FS server tools support the import of a CernVM-FS file storage
together with its corresponding signing keychain. The import functionality is
useful to bootstrap a release manager machine for a given file storage.

``cvmfs_server import`` works similar to ``cvmfs_server mkfs`` (described in
:ref:`sct_repocreation`) except it uses the provided data storage instead of
creating a fresh (and empty) storage. In case of a CernVM-FS 2.0 file storage
``cvmfs_server import`` also takes care of the file catalog migration into the
latest catalog schema (see :ref:`sct_legacyrepoimport` for details).

During the import it might be necessary to resign the repository's whitelist.
Usually because the whitelist's expiry date has exceeded. This operations
requires the corresponding masterkey to be available in `/etc/cvmfs/keys`.
Resigning is enabled by adding ``-r`` to ``cvmfs_server import``.

An import can either use a provided repository keychain placed into
`/etc/cvmfs/keys` or generate a fresh repository key and certificate for the
imported repository. The latter case requires an update of the repository's
whitelist to incorporate the newly generated repository key. To generate a fresh
repository key add ``-t -r`` to ``cvmfs_server import``.

Refer to Section :ref:`sct_cvmfspublished_signature` for a comprehensive
description of the repository signature mechanics.

.. _sct_legacyrepoimport:

Legacy Repository Import
^^^^^^^^^^^^^^^^^^^^^^^^

We strongly recommend to install CernVM-FS 2.1 on a fresh or at least a
properly cleaned machine without any traces of the CernVM-FS 2.0
installation before installing CernVM-FS 2.1 server tools.

The command ``cvmfs_server import`` requires the full CernVM-FS 2.0 data
storage which is located at /srv/cvmfs by default as well as the
repository’s signing keys. Since the CernVM-FS 2.1 server backend
supports multiple repositories in contrast to its 2.0 counterpart, we
recommend to move the repository’s data storage to /srv/cvmfs/<FQRN>
upfront to avoid later inconsistencies.

The following steps describe the transformation of a repository from
CernVM-FS 2.0 into 2.1. As an example we are using a repository called
**legacy.cern.ch**.

#. Make sure that you have backups of both the repository’s backend
   storage and its signing keys

#. Install and test the CernVM-FS 2.1 server tools on the machine that
   is going to be used as new Stratum 0 maintenance machine

#. | Place the repository’s backend storage data in
     /srv/cvmfs/*legacy.cern.ch*
   | (default storage location)

#. Transfer the repository’s signing keychain to the machine (f.e. to
   /legacy\_keys/)

#. Run ``cvmfs_server import`` like this:

   ::

           cvmfs_server import
             -o <username of repo maintainer> \
             -k ~/legacy_keys \
             -l               \ # for 2.0.x file catalog migration
             -s               \ # for further repository statistics
             legacy.cern.ch

#. Check the imported repository with
   ``cvmfs_server check legacy.cern.ch`` for integrity
   (see :ref:`sct_checkintegrity`)

.. _sct_serverhooks:

Customizable Actions Using Server Hooks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``cvmfs_server`` utility allows release managers to trigger custom
actions before and after crucial repository manipulation steps. This can
be useful for example for logging purposes, establishing backend storage
connections automatically or other workflow triggers, depending on the
application.

There are six designated server hooks that are potentially invoked
during the :ref:`repository update procedure <sct_repoupdate>`:

-  When running ``cvmfs_server transaction``:

   -  *before* the given repository is transitioned into transaction
      mode

   -  *after* the transition was successful

-  When running ``cvmfs_server publish``:

   -  *before* the publish procedure for the given repository is started

   -  *after* it was published and remounted successfully

-  When running ``cvmfs_server abort``:

   -  *before* the unpublished changes will be erased for the given
      repository

   -  *after* the repository was successfully reverted to the last
      published state

All server hooks must be defined in a single shell script file called:

::

    /etc/cvmfs/cvmfs_server_hooks.sh

The ``cvmfs_server`` utility will check the existence of this script and
source it. To subscribe to the described hooks one needs to define one
or more of the following shell script functions:

-  ``transaction_before_hook()``

-  ``transaction_after_hook()``

-  ``publish_before_hook()``

-  ``publish_after_hook()``

-  ``abort_before_hook()``

-  ``abort_after_hook()``

The defined functions get called at the specified positions in the
repository update process and are provided with the fully qualified
repository name as their only parameter (\ ``$1``). Undefined functions
automatically default to a NO-OP. An example script is located at
``cvmfs/cvmfs_server_hooks.sh.demo`` in the CernVM-FS sources.

Maintaining a CernVM-FS Repository
----------------------------------

CernVM-FS is a versioning, snapshot-based file system. Similar to
versioning systems, changes to /cvmfs/…are temporary until they are
committed (``cvmfs_server publish``) or discarded
(``cvmfs_server abort``). That allows you to test and verify changes,
for instance to test a newly installed release before publishing it to
clients. Whenever changes are published (committed), a new file system
snapshot of the current state is created. These file system snapshots
can be tagged with a name, which makes them *named snapshots*. A named
snapshot is meant to stay in the file system. One can rollback to named
snapshots and it is possible, on the client side, to mount any of the
named snapshots in lieu of the newest available snapshot.

Two named snapshots are managed automatically by CernVM-FS, ``trunk``
and ``trunk-previous``. This allows for easy unpublishing of a mistake,
by rolling back to the ``trunk-previous`` tag.

.. _sct_checkintegrity:

Integrity Check
~~~~~~~~~~~~~~~

CernVM-FS provides an integrity checker for repositories. It is invoked
by

::

    cvmfs_server check

The integrity checker verifies the sanity of file catalogs and verifies
that referenced data chunks are present. Ideally, the integrity checker
is used after every publish operation. Where this is not affordable due
to the size of the repositories, the integrity checker should run
regularly.

The checker can also run on a nested catalog subtree. This is useful to
follow up a specific issue where a check on the full tree would take a
lot of time::

    cvmfs_server check -s <path to nested catalog mountpoint>

Optionally ``cvmfs_server check`` can also verify the data integrity
(command line flag ``-i``) of each data object in the repository. This
is a time consuming process and we recommend it only for diagnostic
purposes.

.. _sct_namedsnapshots:

Named Snapshots
~~~~~~~~~~~~~~~

Named snapshots or *tags* are an easy way to organise checkpoints in the
file system history. CernVM-FS clients can explicitly mount a repository
at a specific named snapshot to expose the file system content published
with this tag. It also allows for rollbacks to previously created and
tagged file system revisions. Tag names need to be unique for each
repository and are not allowed to contain spaces or spacial characters.
Besides the actual tag’s name they can also contain a free descriptive
text and store a creation timestamp.

Named snapshots are best to use for larger modifications to the
repository, for instance when a new major software release is installed.
Named snapshots provide the ability to easily undo modifications and to
preserve the state of the file system for the future. Nevertheless,
named snapshots should not be used excessively. Less than 50 named
snapshots are a good number of named snapshots in many cases.

By default, new repositories will automatically create a generic tag if
no explicit tag is given during publish. The automatic tagging can be
turned off using the -g option during repository creation or by setting
``CVMFS_AUTO_TAG=false`` in the
/etc/cvmfs/repositories.d/$repository/server.conf file.

Creating a Named Snapshot
^^^^^^^^^^^^^^^^^^^^^^^^^

Tags can be added while publishing a new file system revision. To do so,
the -a and -m options for ``cvmfs_server publish`` are used. The
following command publishes a CernVM-FS revision with a new revision
that is tagged as “release-1.0”:

::

    cvmfs_server transaction
    # Changes
    cvmfs_server publish -a release-1.0 -m "first stable release"

Managing Existing Named Snapshots
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Management of existing tags is done by using the ``cvmfs_server tag``
command. Without any command line parameters, it will print all
currently available named snapshots. Snapshots can be inspected
(``-i <tag name>``), removed (``-r <tag name>``) or created
(``-a <tag name> -m <tag description> -h <catalog root hash>``).
Furthermore machine readable modes for both listing (``-l -x``) as well
as inspection (``-i <tag name> -x``) is available.

Rollbacks
^^^^^^^^^

A repository can be rolled back to any of the named snapshots. Rolling
back is achieved through the command
``cvmfs_server rollback -t release-1.0`` A rollback is, like restoring
from backups, not something one would do often. Use caution, a rollback
is irreversible.

.. _sct_nestedcatalogs:

Managing Nested Catalogs
~~~~~~~~~~~~~~~~~~~~~~~~

CernVM-FS stores meta-data (path names, file sizes, …) in file catalogs.
When a client accesses a repository, it has to download the file catalog
first and then it downloads the files as they are opened. A single file
catalog for an entire repository can quickly become large and
impractical. Also, clients typically do not need all of the repository’s
meta-data at the same time. For instance, clients using software release
1.0 do not need to know about the contents of software release 2.0.

With nested catalogs, CernVM-FS has a mechanism to partition the
directory tree of a repository into many catalogs. Repository
maintainers are responsible for sensible cutting of the directory trees
into nested catalogs. They can do so by creating and removing magic
files named ``.cvmfscatalog``.

For example, in order to create a nested catalog for software release
1.0 in the hypothetical repository experiment.cern.ch, one would invoke

::

    cvmfs_server transaction
    touch /cvmfs/experiment.cern.ch/software/1.0/.cvmfscatalog
    cvmfs_server publish

In order to merge a nested catalog with its parent catalog, the
corresponding ``.cvmfscatalog`` file needs to be removed. Nested
catalogs can be nested on arbitrary many levels.

.. _sct_nestedrecommendations:

Recommendations for Nested Catalogs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Nested catalogs should be created having in mind which files and
directories are accessed together. This is typically the case for
software releases, but can be also on the directory level that separates
platforms. For instance, for a directory layout like

::

    /cvmfs/experiment.cern.ch
      |- /software
      |    |- /i686
      |    |    |- 1.0
      |    |    |- 2.0
      |    `    |- common
      |    |- /x86_64
      |    |    |- 1.0
      |    `    |- common
      |- /grid-certificates
      |- /scripts

it makes sense to have nested catalogs at

::

    /cvmfs/experiment.cern.ch/software/i686
    /cvmfs/experiment.cern.ch/software/x86_64
    /cvmfs/experiment.cern.ch/software/i686/1.0
    /cvmfs/experiment.cern.ch/software/i686/2.0
    /cvmfs/experiment.cern.ch/software/x86_64/1.0

A nested catalog at the top level of each software package release is
generally the best approach because once package releases are installed
they tend to never change, which reduces churn and garbage generated in
the repository from old catalogs that have changed. In addition, each
run only tends to access one version of any package so having a separate
catalog per version avoids loading catalog information that will not be
used. A nested catalog at the top level of each platform may make sense
if there is a significant number of platform-specific files that aren’t
included in other catalogs.

It could also make sense to have a nested catalog under
grid-certificates, if the certificates are updated much more frequently
than the other directories. It would not make sense to create a nested
catalog under /cvmfs/experiment.cern.ch/software/i686/common, because
this directory needs to be accessed anyway whenever its parent directory
is needed. As a rule of thumb, a single file catalog should contain more
than 1000 files and directories but not contain more than
:math:`\approx`\ 200000 files. See :ref:`sct_inspectnested` how to find
catalogs that do not satisfy this recommendation.

Restructuring the repository’s directory tree is an expensive operation
in CernVM-FS. Moreover, it can easily break client applications when
they switch to a restructured file system snapshot. Therefore, the
software directory tree layout should be relatively stable before
filling the CernVM-FS repository.

.. _sct_dirtab:

Managing Nested Catalogs with ``.cvmfsdirtab``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rather than managing ``.cvmfscatalog`` files by hand, a repository
administrator may create a file called ``.cvmfsdirtab``, in the top
directory of the repository, which contains a list of paths relative to
the top of the repository where ``.cvmfscatalog`` files will be created.
Those paths may contain shell wildcards such as asterisk (``*``) and
question mark (``?``). This is useful for specifying patterns for
creating nested catalogs as new files are installed. A very good use of
the patterns is to identify directories where software releases will be
installed.

In addition, lines in ``.cvmfsdirtab`` that begin with an exclamation
point (``!``) are shell patterns that will be excluded from those
matched by lines without an exclamation point. For example a
``.cvmfsdirtab`` might contain these lines for the repository of the
previous subsection:

::

    /software/*
    /software/*/*
    ! */common
    /grid-certificates

This will create nested catalogs at

::

    /cvmfs/experiment.cern.ch/software/i686
    /cvmfs/experiment.cern.ch/software/i686/1.0
    /cvmfs/experiment.cern.ch/software/i686/2.0
    /cvmfs/experiment.cern.ch/software/x86_64
    /cvmfs/experiment.cern.ch/software/x86_64/1.0
    /cvmfs/experiment.cern.ch/grid-certificates

Note that unlike the regular lines that add catalogs, asterisks in the
exclamation point exclusion lines can span the slashes separating
directory levels.

Automatic Management of Nested Catalogs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An alternative to ``.cvmfsdirtab`` is the automatic catalog generation.
This feature automatically generates nested catalogs based on their
weight (number of entries). It can be enabled by setting
``CVMFS_AUTOCATALOGS=true`` in the server configuration file.

Catalogs are split when their weight is greater than a specified maximum
threshold, or removed if their weight is less than a minimum threshold.
Automatically generated catalogs contain a ``.cvmfsautocatalog`` file
(along with the ``.cvmfscatalog`` file) in its root directory.
User-defined catalogs (containing only a ``.cvmfscatalog`` file) always
remain untouched. Hence one can mix both manual and automatically
managed directory sub-trees.

The following conditions are applied when processing a nested catalog:

-  If the weight is greater than ``CVMFS_AUTOCATALOGS_MAX_WEIGHT``, this
   catalog will be split in smaller catalogs that meet the maximum and
   minimum thresholds.

-  If the weight is less than ``CVMFS_AUTOCATALOGS_MIN_WEIGHT``, this
   catalog will be merged into its parent.

Both ``CVMFS_AUTOCATALOGS_MAX_WEIGHT`` and
``CVMFS_AUTOCATALOGS_MIN_WEIGHT`` have reasonable defaults and usually
do not need to be defined by the user.

.. _sct_inspectnested:

Inspecting Nested Catalog Structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command visualizes the current nested file catalog layout
of a repository.

::

    cvmfs_server list-catalogs

Additionally this command allows to spot degenerated nested catalogs. As
stated :ref:`here <sct_nestedrecommendations>` the recommended
maximal file entry count of a single catalog should not exceed
:math:`\approx`\ 200000. One can use the switch ``list-catalogs -e`` to
inspect the current nested catalog entry counts in the repository.
Furthermore ``list-catalgos -s`` will print the file sizes of the
catalogs in bytes.

Syncing files into a repository with cvmfs\_rsync
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A common method of publishing into CernVM-FS is to first install all the
files into a convenient shared filesystem, mount the shared filesystem
on the publishing machine, and then sync the files into the repository
during a transaction. The most common tool to do the syncing is
``rsync``, but ``rsync`` by itself doesn’t have a convenient mechanism
for avoiding generated ``.cvmfscatalog`` and ``.cvmfsautocatalog`` files
in the CernVM-FS repository. Actually the ``--exclude`` option is good
for avoiding the extra files, but the problem is that if a source
directory tree is removed, then ``rsync`` will not remove the
corresponding copy of the directory tree in the repository if it
contains a catalog, because the extra file remains in the repository.
For this reason, a tool called ``cvmfs_rsync`` is included in the
``cvmfs-server`` package. This is a small wrapper around ``rsync`` that
adds the ``--exclude`` options and removes ``.cvmfscatalog`` and
``.cvmfsautocatalog`` files from a repository when the corresponding
source directory is removed. This is the usage:

::

      cvmfs_rsync [rsync_options] srcdir /cvmfs/reponame[/destsubdir]

This is an example use case:

::

      $ cvmfs_rsync -av --delete /data/lhapdf /cvmfs/cms.cern.ch

Migrate File Catalogs
~~~~~~~~~~~~~~~~~~~~~

In rare cases the further development of CernVM-FS makes it necessary to
change the internal structure of file catalogs. Updating the
CernVM-FS installation on a Stratum 0 machine might require a migration
of the file catalogs.

It is recommended that ``cvmfs_server list`` is issued after any
CernVM-FS update to review if any of the maintained repositories need a
migration. Outdated repositories will be marked as “INCOMPATIBLE” and
``cvmfs_server`` refuses all actions on these repositories until the
file catalogs have been updated.

In order to run a file catalog migration use ``cvmfs_server migrate``
for each of the outdated repositories. This will essentially create a
new repository revision that contains the exact same file structure as
the current revision. However, all file catalogs will be recreated from
scratch using the updated internal structure. Note that historic file
catalogs of all previous repository revisions stay untouched and are not
migrated.

After ``cvmfs_server migrate`` has successfully updated all file
catalogs repository maintenance can continue as usual.

Change File Ownership on File Catalog Level
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CernVM-FS tracks the UID and GID of all contained files and exposes them
through the client to all using machines. Repository maintainers should
keep this in mind and plan their UID and GID assignments accordingly.

Repository operation might occasionally require to bulk-change many or all
UIDs/GIDs. While this is of course possible via ``chmod -R`` in a normal
repository transaction, it is cumbersome for large repositories. We provide
a tool to quickly do such adaption on :ref:`CernVM-FS catalog level
<sct_filecatalog>` using UID and GID mapping files::

  cvmfs_server catalog-chown -u <uid map> -g <gid map> <repo name>

Both the UID and GID map contain a list of rules to apply to each file
meta data record in the CernVM-FS catalogs. This is an example of such
a rules list::

  # map root UID/GID to 1001
  0 1001

  # swap UID/GID 1002 and 1003
  1002 1003
  1003 1002

  # map everything else to 1004
  * 1004

Note that running ``cvmfs_server catalog-chown`` produces a new repository
revision containing :ref:`CernVM-FS catalogs <sct_filecatalog>` with updated
UIDs and GIDs according to the provided rules. Thus, previous revisions of
the CernVM-FS repository will *not* be affected by this update.

Repository Garbage Collection
-----------------------------

Since CernVM-FS is a versioning file system it is following an
insert-only policy regarding its backend storage. When files are deleted
from a CernVM-FS repository, they are not automatically deleted from the
underlying storage. Therefore legacy revisions stay intact and usable
forever (cf. :ref:`sct_namedsnapshots`) at the expense of an
ever-growing storage volume both on the Stratum 0 and the Stratum 1s.

For this reason, applications that frequently install files into a
repository and delete older ones – for example the output from nightly
software builds – might quickly fill up the repository’s backend
storage. Furthermore these applications might actually never make use of
the aforementioned long-term revision preservation rendering most of the
stored objects “garbage”.

CernVM-FS supports garbage-collected repositories that automatically
remove unreferenced data objects and free storage space. This feature
needs to be enabled on the Stratum 0 and automatically scans the
repository’s catalog structure for unreferenced objects both on the
Stratum 0 and the Stratum 1 installations on every publish respectively
snapshot operation.

Garbage Sweeping Policy
~~~~~~~~~~~~~~~~~~~~~~~

The garbage collector of CernVM-FS is using a mark-and-sweep algorithm
to detect unused files in the internal catalog graph. Revisions that are
referenced by named snapshots (cf. :ref:`sct_namedsnapshots`) or that
are recent enough are preserved while all other revisions are condemned
to be removed. By default this time-based threshold is *three days* but
can be changed using the configuration variable
``CVMFS_AUTO_GC_TIMESPAN`` both on Stratum 0 and Stratum 1. The value of
this variable is expected to be parseable by the ``date`` command, for
example ``3 days ago`` or ``1 week ago``.

Enabling Garbage Collection
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Creating a Garbage Collectable Repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Repositories can be created as *garbage-collectable* from the start by adding
``-z`` to the ``cvmfs_server mkfs`` command (cf. :ref:`sct_repocreation`). It
is generally recommended to also add ``-g`` to switch off automatic tagging in
a garbage collectable repository.
For debugging or bookkeeping it is possible to log deleted objects into a file
by setting ``CVMFS_GC_DELETION_LOG`` to a writable file path.

Enabling Garbage Collection on an Existing Repository (Stratum 0)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| Existing repositories can be reconfigured to be garbage collectable by
  adding
| ``CVMFS_GARBAGE_COLLECTION=true`` and ``CVMFS_AUTO_GC=true`` to the
  ``server.conf`` of the repository. Furthermore it is recommended to
  switch off automatic tagging by setting ``CVMFS_AUTO_TAG=false`` for a
  garbage collectable repository. The garbage collection will be enabled
  with the next published transaction.

Enabling Garbage Collection on an Existing Replication (Stratum 1)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to use automatic garbage collection on a stratum 1 replica
``CVMFS_AUTO_GC=true`` needs to be added in the ``server.conf`` file of
the stratum 1 installation. This will only work if the upstream stratum
0 repository has garbage collection enabled.

Limitations on Repository Content
---------------------------------

Because CernVM-FS provides what appears to be a POSIX filesystem to
clients, it is easy to think that it is a general purpose filesystem and
that it will work well with all kinds of files. That is not the case,
however, because CernVM-FS is optimized for particular types of files
and usage. This section contains guidelines for limitations on the
content of repositories for best operation.

Data files
~~~~~~~~~~

First and foremost, CernVM-FS is designed to distribute executable code
that is shared between a large number of jobs that run together at grid
sites, clouds, or clusters. Worker node cache sizes and web proxy
bandwidth are generally engineered to accommodate that application. The
total amount read per job is expected to be roughly limited by the
amount of RAM per job slot. The same files are also expected to be read
from the worker node cache multiple times for the same type of job, and
read from a caching web proxy by multiple worker nodes.

If there are data files distributed by CernVM-FS that follow similar
access patterns and size limits as executable code, it will probably
work fine. In addition, if there are files that are larger but read
slowly throughout long jobs, as opposed to all at once at the beginning,
that can also work well if the same files are read by many jobs. That is
because web proxies have to be engineered for handling bursts at the
beginning of jobs and so they tend to be lightly loaded a majority of
the time.

In general, a good rule of thumb is to calculate the maximum rate at
which jobs typically start and limit the amount of data that might be
read from a web proxy to per thousand jobs, assuming a reasonable amount
of overlap of jobs onto the same worker nodes. Also, limit the amount of
data that will be put into any one worker node cache to . Of course, if
you have a special arrangement with particular sites to have large
caches and bandwidths available, these limits can be made higher at
those sites. Web proxies may also need to be engineered with faster
disks if the data causes their cache hit ratios to be reduced.

Also, keep in mind that the total amount of data distributed is not
unlimited. The files are stored and distributed compressed, and files
with the same content stored in multiple places in the same repository
are collapsed to the same file in storage, but the storage space is used
not only on the original repository server, it is also replicated onto
multiple Stratum 1 servers. Generally if only executable code is
distributed, there is no problem with the space taken on Stratum 1s, but
if many large data files are distributed they may exceed the Stratum 1
storage capacity. Data files also tend to not compress as well, and that
is especially the case of course if they are already compressed before
installation.

Tarballs, zip files, and other archive files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the contents of a tarball, zip file, or some other type of archive
file is desired to be distributed by CernVM-FS, it is usually better to
first unpack it into its separate pieces first. This is because it
allows better sharing of content between multiple releases of the file;
some pieces inside the archive file might change and other pieces might
not in the next release, and pieces that don’t change will be stored as
the same file in the repository. CernVM-FS will compress the content of
the individual pieces, so even if there’s no sharing between releases it
shouldn’t take much more space.

File permissions
~~~~~~~~~~~~~~~~

Care should be taken to make all the files in a repository readable by
“other”. This is because permissions on files in the original repository
are generally the same as those seen by end clients, except the files
are owned by the “cvmfs” user and group. The write permissions are
ignored by the client since it is a read-only filesystem. However,
unless the client has set

::

      CVMFS_CHECK_PERMISSIONS=no

(and most do not), unprivileged users will not be able to read files
unless they are readable by “other” and all their parent directories
have at least “execute” permissions. It makes little sense to publish
files in CernVM-FS if they won’t be able to be read by anyone.

Hardlinks
~~~~~~~~~

By default CernVM-FS does not allow hardlinks of a file to be in
different directories. If there might be any such hardlinks in a
repository, set the option

::

        CVMFS_IGNORE_XDIR_HARDLINKS=true

in the repository’s ``server.conf``. The file will not appear to be
hardlinked to the client, but it will still be stored as only one file
in the repository just like any other files that have identical content.
Note that if, in a subsequent publish operation, only one of these
cross-directory hardlinks gets changed, the other hardlinks remain
unchanged (the hardlink got “broken”).

.. raw:: html

   <div id="refs" class="references">

.. raw:: html

   <div id="ref-aufs">

[1] Okajima, J.R. Aufs - Advanced multi layered Unification FileSystem.
http://aufs.sourceforge.net/.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-unionfs04">

[2] Wright, C.P. et al. 2004. *Versatility and unix semantics in a
fan-out unification file system*. Technical Report #FSL-04-01b. Stony
Brook University.

.. raw:: html

   </div>

.. raw:: html

   </div>

.. [1]
   CernVM-FS download page:
   http://cernvm.cern.ch/portal/filesystem/downloads

