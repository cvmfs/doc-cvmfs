.. CernVM-FS documentation master file, created by
   sphinx-quickstart on Tue Feb  2 11:11:44 2016.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to CernVM-FS's documentation!
=====================================

What is CernVM-FS?
^^^^^^^^^^^^^^^^^^

The CernVM-File System (CernVM-FS) provides a scalable, reliable and low-
maintenance software distribution service. It was developed to assist High
Energy Physics (HEP) collaborations to deploy software on the worldwide-
distributed computing infrastructure used to run data processing applications.
CernVM-FS is implemented as a POSIX read-only file system in user space (a
FUSE module). Files and directories are hosted on standard web servers and
mounted in the universal namespace ``/cvmfs``.  Internally, CernVM-FS uses
content-addressable storage and Merkle trees in order to maintain file data
and meta-data. CernVM-FS uses outgoing HTTP connections only, thereby it
avoids most of the firewall issues of other network file systems. It transfers
data and meta-data on demand and verifies data integrity by cryptographic
hashes.

By means of aggressive caching and reduction of latency, CernVM-FS focuses
specifically on the software use case. Software usually comprises many small
files that are frequently opened and read as a whole. Furthermore, the
software use case includes frequent look-ups for files in multiple directories
when search paths are examined.

CernVM-FS is actively used by small and large HEP collaborations. In many
cases, it replaces package managers and shared software areas on cluster file
systems as means to distribute the software used to process experiment data.

Contents
^^^^^^^^

.. toctree::
   :maxdepth: 2

   cpt-releasenotes
   cpt-overview
   cpt-quickstart
   cpt-configure
   cpt-squid
   cpt-repo
   cpt-servermeta
   cpt-replica
   cpt-repository-gateway
   cpt-notification-system
   cpt-containers
   part-advanced
   part-appendix


Contact and Authors
^^^^^^^^^^^^^^^^^^^

Visit our website on `cernvm.cern.ch <http://cernvm.cern.ch/>`_.

Authors of this documentation:

   * Jakob Blomer
   * Brian Bockelman
   * Daniel-Florin Dosaru
   * Dave Dykstra
   * Nikola Hardi
   * Nick Hazekamp
   * René Meusel
   * Radu Popescu
   * Simone Mosciatti

