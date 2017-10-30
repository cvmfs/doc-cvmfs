

Large-Scale Data CernVM-FS
==========================

CernVM-FS primarily is developed for distributing large software stacks.  However, by
combining several extensions to the base software, one can use CVMFS to distribute
large, non-public datasets.  While there are several ways to deploy a the service,
in this section we outline one potential path to achieve secure distribution of
terabytes-to-petabytes of data.

To deploy large-scale CVMFS, a few design decisions are needed:

-  **How is data distributed?** For the majority of repositories, data is replicated from a
   repository server to an existing content distribution network tuned for the object size
   common to software repositories.  The CDNs currently in use are tuned for working set
   size on the order of tens of gigabytes; they are not appropriately sized for terabytes
   of data.  You will need to put together a mechanism for delivering data at the rates
   your clients will need.

    -  For example, ``ligo.osgstorage.org`` has about 20TB of data; each scientific workflow
       utilizes about 2TB of data and each running core averages 1Mbps of input data.  So,
       to support the expected workflows at 10,000 running cores, several 10TB caches were
       deployed that could export a total of 40Gbps.
    -  The ``cms.osgstorage.org`` repository publishes 3PB of data.  Each analysis will
       read around 20TB and several hundred analyses will run simultaneously.  Given the
       large working set size, there is no caching layer and data is read directly from
       large repositories.

-  **How is data published?** By default, CVMFS publication will calculate checksums
   on its contents, compresses the data, and serves it from the Apache web server.  Implicitly,
   this means all data must be _copied_ to and _stored_ on the repository host; at larger scales,
   this is prohibitively expensive.  The ``cvmfs_swissknife graft`` tool provides a mechanism
   to publish files directly if the checksum is known ahead of time; see :ref:`sct_grafting`.

    -  For ``ligo.osgstorage.org``, a cronjob *copies* all new data to the repository from a cache,
       creates the checksum file, and immediately deletes the downloaded file.  Hence, the LIGO
       data is copied but not stored.
    -  The ``cms.osgstorage.org``, a cronjob queries the underlying filesystem for the relevant
       checksum information and published the checksum.  The data is neither copied nor stored
       on the repository

   On publication, the files may be marked as *non-compressed* and *externally stored*.  This
   allows the CVMFS client to be configured to be pointed at a non-CVMFS data (stored as the "logical
   name", not the "content addressed" form).  CVMFS clients can thus use existing data sources without
   change.
-  **How is data secured?** CVMFS was originally designed to distribute open-source software
   with strong data integrity guarantees.  More recently, read-access authorization has been added
   to the software.  An access control list is added to the repository (at creation time or publication
   time) and clients are configured to invoke a plugin for new process sessions.  The plugin enforces the ACLs
   *and* forwards the user's credential back to the CVMFS process.  This allows the authorization to be
   enforced for worker node cache access and the CDN to enforce authorization on the CVMFS process for
   downloading new files to the cache.

   The entire ACL is passed to the external plugin and not interpreted by CVMFS; the semantics are defined
   by the plugin.  The existing plugin is based on GSI / X509 proxies and authorization can be added based
   on DN or VOMS FQANs.

   In order to perform mounts, the root catalog must be accessible without authorization.  However, the repository
   server (or CDN) can be configured to require authorization for the remaining data in the namespace.

Creating Large, Secure Repositories
-----------------------------------

For large-scale repositories, a few tweaks are useful at creation time.  Here is the command used to
create the ``cms.osgstorage.org``::

   cvmfs_server mkfs -V cms:/cms -X -Z none -o cmsuser cms.osgstorage.org

-  The ``-V cms:/cms`` option indicates that only clients with an X509 proxy with a VOMS extension
   from CMS are allowed to access the mounted proxy.  If multiple VOMS extensions are needed, it's
   easiest to add this at publication time.
-  ``-X`` indicates that, by default, files published to this repository are served at an "external
   URL".  The clients will attempt to access the file by *name*, not content hash, and look for
   the server as specified by the client's setting of ``CVMFS_EXTERNAL_URL``.
-  ``-Z none`` indicates that, by default, files published to this repository will not be marked as
   compressed.

By combining the ``-X`` and ``-Z`` options, files at an HTTP endpoint can be published in-place: no compression
or copying into a different endpoint is necessary to publish.

