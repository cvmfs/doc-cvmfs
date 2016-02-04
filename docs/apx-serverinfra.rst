.. _apx_serverinfra:

CernVM-FS Server Infrastructure
===============================

This section provides technical details on the CernVM-FS server setup
including the infrastructure necessary for an individual repository. It
is highly recommended to first consult ":ref:`sct_serveranatomy`" for a
more general overview of the involved directory structure.

Prerequisites
-------------

A CernVM-FS server installation depends on the following environment
setup and tools to be in place:

-  aufs support in the kernel (see Section [sct:customkernelinstall])

-  Backend storage location available through HTTP

-  Backend storage accessible at ``/srv/cvmfs/...`` (unless stored on
   S3)

-  **cvmfs** and **cvmfs-server** packages installed

Local Backend Storage Infrastructure
------------------------------------

CernVM-FS stores the entire repository content (file content and
meta-data catalogs) into a content addressable storage (CAS). This
storage can either be a file system at ``/srv/cvmfs`` or an S3
compatible object storage system (see ":ref:`sct_s3storagesetup`" for
details). In the former case the contents of ``/srv/cvmfs`` are as
follows:

TODO: figures/tablocalstorageanatomy.tex

Server Spool Area of a Repository (Stratum0)
--------------------------------------------

The spool area of a repository contains transaction infrastructure and
scratch area of a Stratum0 or specifically a release manager machine
installation. It is always located inside ``/var/spool/cvmfs`` with
directories for individual repositories. Note that the data volume of
the spool area can grow very large for massive repository updates since
it contains the writable AUFS branch and a CernVM-FS client cache
directory.

TODO: figures/tabrepospoolanatomy.tex

Repository Configuration Directory
----------------------------------

The authoritative configuration of a CernVM-FS repository is located in
``/etc/cvmfs/repositories.d`` and should only be writable by the
administrator. Furthermore the repository’s keychain is located in
``/etc/cvmfs/keys`` and follows the naming convention ``<fqrn>.crt`` for
the certificate, ``<fqrn>.key`` for the repository’s private key and
``<fqrn>.pub`` for the public key. All of those files can be symlinked
somewhere else if necessary.

TODO: figures/tabrepoconfiganatomy.tex

Environment Setup
-----------------

Apart from file and directory locations a CernVM-FS server installation
depends on a few environment configurations. Most notably the
possibility to access the backend storage through HTTP and to allow for
mounting of both the CernVM-FS client at
``/var/spool/cvmfs/<fqrn>/rdonly`` and aufs on ``/cvmfs/<fqrn>``.

Granting HTTP access can happen in various ways and depends on the
chosen backend storage type. For an S3 hosted backend storage, the
CernVM-FS client can usually be directly pointed to the S3 bucket used
for storage (see ":ref:`sct_s3storagesetup`" for details). In case of a
local file system backend any web server can be used for this purpose.
By default CernVM-FS assumes Apache and uses that automatically.

Internally the CernVM-FS server uses a SUID binary (i.e.
``cvmfs_suid_helper``) to manipulate its mount points. This is necessary
since transactional CernVM-FS commands must be accessible to the
repository owner that is usually different from root. Both the mount
directives for ``/var/spool/cvmfs/<fqrn>/rdonly`` and ``/cvmfs/<fqrn>``
must be placed into ``/etc/fstab`` for this reason. By default
CernVM-FS uses the following entries for these mount points:

::

    cvmfs2#<fqrn> /var/spool/cvmfs/<fqrn>/rdonly fuse \
    allow_other,config=/etc/cvmfs/repositories.d/<fqrn>/client.conf: \
    /var/spool/cvmfs/<fqrn>/client.local,cvmfs_suid 0 0

    aufs_<fqrn> /cvmfs/<fqrn> aufs br=/var/spool/cvmfs/<fqrn>/scratch=rw: \
    /var/spool/cvmfs/<fqrn>/rdonly=rr,udba=none,ro 0 0

.. raw:: html

   <div id="refs" class="references">

.. raw:: html

   </div>
