.. |br| raw:: html

   <br />

.. _apx_serverinfra:

CernVM-FS Server Infrastructure
===============================

This section provides technical details on the CernVM-FS server setup
including the infrastructure necessary for an individual repository. It
is highly recommended to first consult ":ref:`sct_serveranatomy`" for a
more general overview of the involved directory structure.

Prerequisites
-------------

A CernVM-FS server installation depends on the following environment
setup and tools to be in place:

-  Appropriate kernel version.  You must have ONE of the following:

   -   kernel 4.2.x or later.
   -   RHEL7.3 kernel (for OverlayFS)

-  Backend storage location available through HTTP

-  Backend storage accessible at ``/srv/cvmfs/...`` (unless stored on
   S3)

-  **cvmfs** and **cvmfs-server** packages installed

Local Backend Storage Infrastructure
------------------------------------

CernVM-FS stores the entire repository content (file content and
meta-data catalogs) into a content addressable storage (CAS). This
storage can either be a file system at ``/srv/cvmfs`` or an S3
compatible object storage system (see ":ref:`sct_s3storagesetup`" for
details). In the former case the contents of ``/srv/cvmfs`` are as
follows:

===================================== ==================================================
**File Path**                         **Description**
===================================== ==================================================
``/srv/cvmfs``                        **Central repository storage location** |br|
                                      Can be mounted or symlinked to another location
                                      *before* creating the first repository.
``/srv/cvmfs/<fqrn>``                 **Storage location of a specific repository** |br|
                                      Can be symlinked to another location *before*
                                      creating the repository ``<fqrn>``. This location
                                      needs to be both writable by the repository owner
                                      and accessible through an HTTP server.
``/srv/cvmfs/<fqrn>/.cvmfspublished`` **Manifest file of the repository** |br|
                                      The manifest provides the entry point into the
                                      repository. It is the only file that needs to be
                                      signed by the repository's private key.
``/srv/cvmfs/<fqrn>/.cvmfswhitelist`` **List of trusted repository certificates** |br|
                                      Contains a list of certificate fingerprints that
                                      should be allowed to sign a repository manifest
                                      (see .cvmfspublished). The whitelist needs to be
                                      signed by a globally trusted private key.
``/srv/cvmfs/<fqrn>/data``            **CAS location of the repository** |br|
                                      Data storage of the repository. Contains catalogs,
                                      files, file chunks, certificates and history
                                      databases in a content addressable file format.
                                      This directory and all its contents need to be
                                      writable by the repository owner.
``/srv/cvmfs/<fqrn>/data/00..ff``     **Second CAS level directories** |br|
                                      Splits the flat CAS namespace into multiple
                                      directories. First two digits of the file content
                                      hash defines the directory the remainder is used
                                      as file name inside the corresponding directory.
``/srv/cvmfs/<fqrn>/data/txn``        **CAS transaction directory** |br|
                                      Stores partial files during creation. Once writing
                                      has completed, the file is committed into the CAS
                                      using an atomic rename operation.
===================================== ==================================================

Server Spool Area of a Repository (Stratum0)
--------------------------------------------

The spool area of a repository contains transaction infrastructure and
scratch area of a Stratum0 or specifically a release manager machine
installation. It is always located inside ``/var/spool/cvmfs`` with
directories for individual repositories. Note that the data volume of
the spool area can grow very large for massive repository updates since
it contains the writable union file system branch and a CernVM-FS client
cache directory.

========================================= =================================================
**File Path**                             **Description**
========================================= =================================================
``/var/spool/cvmfs``                      **CernVM-FS server spool area** |br|
                                          Contains administrative and scratch space for
                                          CernVM-FS repositories. This directory should
                                          only contain directories corresponding to
                                          individual CernVM-FS repositories.
``/var/spool/cvmfs/<fqrn>``               **Individual repository spool area** |br|
                                          Contains the spool area of an individual
                                          repository and might temporarily contain large
                                          data volumes during massive repository updates.
                                          This location can be mounted or symlinked to
                                          other locations. Furthermore it must be
                                          writable by the repository owner.
``/var/spool/cvmfs/<fqrn>/cache``         **CernVM-FS client cache directory** |br|
                                          Contains the cache of the CernVM-FS client
                                          mounting the r/o branch
                                          (i.e. ``/var/spool/cvmfs/<fqrn>/rdonly``) of the
                                          union file system mount point located at
                                          ``/cvmfs/<fqrn>``.
                                          The content of this directory is fully managed
                                          by the CernVM-FS client and hence must be
                                          configured as a CernVM-FS cache and writable for
                                          the repository owner.
``/var/spool/cvmfs/<fqrn>/rdonly``        **CernVM-FS client mount point** |br|
                                          Serves as the mount point of the CernVM-FS
                                          client exposing the latest published state of
                                          the CernVM-FS repository. It needs to be owned
                                          by the repository owner and should be empty if
                                          CernVM-FS is not mounted to it.
``/var/spool/cvmfs/<fqrn>/scratch``       **Writable union file system scratch area** |br|
                                          All file system changes applied to
                                          ``/cvmfs/<fqrn>`` during a transaction will be
                                          stored in this directory. Hence, it potentially
                                          needs to accommodate a large data volume
                                          during massive repository updates. Furthermore
                                          it needs to be writable by the repository
                                          owner.
``/var/spool/cvmfs/<fqrn>/tmp``           **Temporary scratch location** |br|
                                          Some CernVM-FS server operations like
                                          publishing store temporary data files here,
                                          hence it needs to be writable by the repository
                                          owner. If the repository is idle this directory
                                          should be empty.
``/var/spool/cvmfs/<fqrn>/client.config`` **CernVM-FS client configuration** |br|
                                          This contains client configuration variables for
                                          the CernVM-FS client mounted to
                                          ``/var/spool/cvmfs/<fqrn>/rdonly``. Most notibly
                                          it needs to contain ``CVMFS_ROOT_HASH``
                                          configured to the latest revision published in
                                          the corresponding repository. This file needs to
                                          be writable by the repository owner.
========================================= =================================================

Repository Configuration Directory
----------------------------------

The authoritative configuration of a CernVM-FS repository is located in
``/etc/cvmfs/repositories.d`` and should only be writable by the
administrator. Furthermore the repository's keychain is located in
``/etc/cvmfs/keys`` and follows the naming convention ``<fqrn>.crt`` for
the certificate, ``<fqrn>.key`` for the repository's private key and
``<fqrn>.pub`` for the public key. All of those files can be symlinked
somewhere else if necessary.

==================================== ==================================================
**File Path**                        **Description**
==================================== ==================================================
``/etc/cvmfs/repositories.d``        **CernVM-FS server config directory** |br|
                                     This contains the configuration directories for
                                     individual CernVM-FS repositories. Note that this
                                     path is shortened using ``/.../repos.d/`` in the
                                     rest of this table.
``/.../repos.d/<fqrn>``              **Config directory for specific repo** |br|
                                     This contains the configuration files for one
                                     specific CernVM-FS repository server.
``/.../repos.d/<fqrn>/server.conf``  **Server configuration file** |br|
                                     Authoriative configuration file for the CernVM-FS
                                     server tools. This file should only contain
                                     :ref:`valid server configuration variables
                                     <apxsct_serverparameters>` as it controls the
                                     behaviour of the CernVM-FS server operations like
                                     publishing, pulling and so forth.
``/.../repos.d/<fqrn>/client.conf``  **Client configuration file** |br|
                                     Authoriative configuration file for the CernVM-FS
                                     client used to mount the latest revision of a
                                     Stratum 0 release manager machine. This file should
                                     only contain :ref:`valid client configuration
                                     variables <apxsct_clientparameters>`. This file
                                     must not exist for Stratum 1 repositories.
``/.../repos.d/<fqrn>/replica.conf`` **Replication configuration file** |br|
                                     Contains configuration variables for Stratum 1
                                     specific repositories. This file must not exist
                                     for Stratum 0 repositories.
==================================== ==================================================

Environment Setup
-----------------

Apart from file and directory locations a CernVM-FS server installation
depends on a few environment configurations. Most notably the
possibility to access the backend storage through HTTP and to allow for
mounting of both the CernVM-FS client at
``/var/spool/cvmfs/<fqrn>/rdonly`` and a union file system on ``/cvmfs/<fqrn>``.

Granting HTTP access can happen in various ways and depends on the
chosen backend storage type. For an S3 hosted backend storage, the
CernVM-FS client can usually be directly pointed to the S3 bucket used
for storage (see ":ref:`sct_s3storagesetup`" for details). In case of a
local file system backend any web server can be used for this purpose.
By default CernVM-FS assumes Apache and uses that automatically.

Internally the CernVM-FS server uses a SUID binary (i.e.
``cvmfs_suid_helper``) to manipulate its mount points. This is necessary
since transactional CernVM-FS commands must be accessible to the
repository owner that is usually different from root. Both the mount
directives for ``/var/spool/cvmfs/<fqrn>/rdonly`` and ``/cvmfs/<fqrn>``
must be placed into ``/etc/fstab`` for this reason. By default
CernVM-FS uses the following entries for these mount points:

::

    cvmfs2#<fqrn> /var/spool/cvmfs/<fqrn>/rdonly fuse \
    allow_other,config=/etc/cvmfs/repositories.d/<fqrn>/client.conf: \
    /var/spool/cvmfs/<fqrn>/client.local,cvmfs_suid 0 0

    aufs_<fqrn> /cvmfs/<fqrn> aufs br=/var/spool/cvmfs/<fqrn>/scratch=rw: \
    /var/spool/cvmfs/<fqrn>/rdonly=rr,udba=none,ro 0 0
