Overview
========

The CernVM File System (CernVM-FS) is a read-only file system designed
to deliver scientific software onto virtual machines and physical worker
nodes in a fast, scalable, and reliable way. Files and file metadata are
downloaded on demand and aggressively cached. For the distribution of
files, CernVM-FS uses a standard HTTP [1, 3] transport, which allows
exploitation of a variety of web caches, including commercial content
delivery networks. CernVM-FS ensures data authenticity and integrity
over these possibly untrusted caches and connections. The
CernVM-FS software comprises client-side software to mount
“CernVM-FS repositories” (similar to AFS volumes) as well as a
server-side toolkit to create such distributable CernVM-FS repositories.

.. figure:: _static/concept-generic.svg
   :alt: General overview over CernVM-File System's Architecture

   A CernVM-FS client provides a virtual file system that loads data
   only on access. In this example, all releases of a sofware package
   (such as an HEP experiment framework) are hosted as a
   CernVM-FS repository on a web server.

The first implementation of CernVM-FS was based on grow-fs [2, 8], which
was originally provided as one of the private file system options
available in Parrot. Ever since the design evolved and diverged, taking
into account the works on HTTP-Fuse [7] and content-delivery
networks [4, 6, 9]. Its current implementation provides the following
key features:

-  Use of the the Fuse kernel module that comes with in-kernel caching
   of file data and file attributes

-  Cache quota management

-  Use of a content addressable storage format resulting in immutable
   files and automatic file de-duplication

-  Possibility to split a directory hierarchy into sub catalogs at
   user-defined levels

-  Automatic updates of file catalogs controlled by a time to live
   stored inside file catalogs

-  Digitally signed repositories

-  Transparent file compression/decompression and transparent file
   chunking

-  Capability to work in offline mode providing that all required files
   are cached

-  File system versioning

-  File system hotpatching

-  Dynamic expansion of environment variables embedded in symbolic links

-  Automatic mirror server selection based on geographic proximity

-  Automatic load-balancing of proxy servers

-  Support for WPAD/PAC auto-configuration of proxy servers

-  Efficient replication of repositories

-  Possibility to use S3 compatible storage instead of a file system as
   repository storage

In contrast to general purpose network file systems such as nfs or afs,
CernVM-FS is particularly crafted for fast and scalable software
distribution. Running and compiling software is a use case general
purpose distributed file systems are not optimized for. In contrast to
virtual machine images or Docker images, software installed in
CernVM-FS does not need to be further packaged. Instead it is
distributed and versioned file-by-file. In order to create and update a
CernVM-FS repository, a distinguished machine, the so-called *Release
Manager Machine*, is used. On such a release manager machine, a
CernVM-FS repository is mounted in read/write mode by means of a union
file system [10]. The union file system overlays the CernVM-FS read-only
mount point by a writable scratch area. The CernVM-FS server tool kit
merges changes written to the scratch area into the
CernVM-FS repository. Merging and publishing changes can be triggered at
user-defined points in time; it is an atomic operation. As such, a
CernVM-FS repository is similar to a repository in the sense of a
versioning system.

On the client, only data and metadata of the software releases that are
actually used are downloaded and cached.

.. figure:: _static/fuse.svg
   :alt: CernVM-FS client architectural overview
   :figwidth: 550
   :align: center

   Opening a file on CernVM-FS. CernVM-FS resolves the name by means of
   an SQLite catalog. Downloaded files are verified against the
   cryptographic hash of the corresponding catalog entry. The ``read()``
   and the ``stat()`` system call can be entirely served from the
   in-kernel file system buffers.

.. raw:: html

   <div id="refs" class="references">

.. raw:: html

   <div id="ref-rfc1945">

[1] Berners-Lee, T. et al. 1996. *Hypertext Transfer Protocol –
HTTP/1.0*. Technical Report #1945. Internet Engineering Task Force.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-growfs09">

[2] Compostella, G. et al. 2010. CDF software distribution on the Grid
using Parrot. *Journal of Physics: Conference Series*. 219, (2010).

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-rfc2616">

[3] Fielding, R. et al. 1999. *Hypertext Transfer Protocol – HTTP/1.1*.
Technical Report #2616. Internet Engineering Task Force.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-coral03">

[4] Freedman, M.J. and Mazières, D. 2003. Sloppy hashing and
self-organizing clusters. M.F. Kaashoek and I. Stoica, eds. Springer.
45–55.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-fuse">

[5] Henk, C. and Szeredi, M. Filesystem in Userspace (FUSE).
http://fuse.sourceforge.net.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-akamai10">

[6] Nygren, E. et al. 2010. The Akamai network: A platform for
high-performance internet applications. *ACM SIGOPS Operating Systems
Review*. 44, 3 (2010), 2–19.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-httpfuse06">

[7] Suzaki, K. et al. 2006. HTTP-FUSE Xenoppix. *Proc. of the 2006 linux
symposium* (2006), 379–392.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-parrot05">

[8] Thain, D. and Livny, M. 2005. Parrot: an application environment for
data-intensive computing. *Scalable Computing: Practice and Experience*.
6, 3 (18 2005), 9.

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-caspar03">

[9] Tolia, N. et al. 2003. Opportunistic use of content addressable
storage for distributed file systems. *Proc. of the uSENIX annual
technical conference* (2003).

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-unionfs04">

[10] Wright, C.P. et al. 2004. *Versatility and unix semantics in a
fan-out unification file system*. Technical Report #FSL-04-01b. Stony
Brook University.

.. raw:: html

   </div>

.. raw:: html

   </div>
