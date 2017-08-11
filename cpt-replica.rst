.. _cpt_replica:

Setting up a Replica Server (Stratum 1)
=======================================

While a CernVM-FS Stratum 0 repository server is able to serve clients
directly, a large number of clients is better be served by a set of Stratum 1
replica servers. Multiple Stratum 1 servers improve the reliability, reduce
the load, and protect the Stratum 0 master copy of the repository from direct
accesses. Stratum 0 server, Stratum 1 servers and the site-local proxy servers
can be seen as content distribution network. The :ref:`figure below
<fig_stratum1>` shows the situation for the repositories hosted in the
cern.ch domain.

.. _fig_stratum1:

.. figure:: _static/stratum1.png
   :alt: Concept overview of the CernVM-FS Content Delivery Network
   :align: center

   CernVM-FS content distribution network for the cern.ch domain: Stratum1
   replica servers are located in Europe, the U.S. and Asia. One protected
   read/write instance (Stratum 0) is feeding up the public, distributed
   mirror servers. A distributed hierarchy of proxy servers fetches content
   from the closest public mirror server.

A Stratum 1 server is a standard web server that uses the
CernVM-FS server toolkit to create and maintain a mirror of a
CernVM-FS repository served by a Stratum 0 server. To this end, the
``cvmfs_server`` utility provides the ``add-replica`` command. This
command will register the Stratum 0 URL and prepare the local web
server. Periodical synchronization has to be scheduled, for instance
with ``cron``, using the ``cvmfs_server snapshot`` command. The
advantage over general purpose mirroring tools such as rSync is that all
CernVM-FS file integrity verifications mechanisms from the Fuse client
are reused. Additionally, by the aid of the CernVM-FS file catalogs, the
``cvmfs_server`` utility knows beforehand (without remote listing) which
files to transfer.

In order to prevent accidental synchronization from a repository, the
Stratum 0 repository maintainer has to create a
``.cvmfs_master_replica`` file in the HTTP root directory. This file is
created by default when a new repository is created. Note that
replication can thrash caches that might exist between Stratum 1 and
Stratum 0. A direct connection is therefore preferable.

Recommended Setup
-----------------

The vast majority of HTTP requests will be served by the site's local
proxy servers. Being a publicly available service, however, we recommend
to install a Squid frontend in front of the Stratum 1 web server.

We suggest the following key parameters:

**Storage**
    RAID-protected storage. The ``cvmfs_server`` utility should have low
    latency to the storage because it runs a large number of system
    calls (``stat()``) against it. For the local storage backends ext3/4
    filesystems are preferred (rather than XFS).

**Web server**
    A standard Apache server. Directory listing is not required. In
    addition, it is a good practice to exclude search engines from the
    replica web server by an appropriate robots.txt. The webserver
    should be close to the storage in terms of latency.

**Squid frontend**
    Squid should be used as a frontend to Apache, configured as a
    reverse proxy. It is recommended to run it on the same machine as
    Apache to reduce the number of points of failure. Alternatively,
    separate Squid server machines may be configured in load-balance
    mode forwarding to the Apache server, but note that if any of them
    are down the entire service will be considered down by
    CernVM-FS clients. The Squid frontend should listen on ports 80 and
    8000. The more RAM that the operating system can use for file system
    caching, the better.

    **Note**: Port 8000 might be assigned to ``soundd``.  On SElinux systems,
    this assignment must be changed to the HTTP service by
    ``semanage port -m -t http_port_t -p tcp 8000``.  The ``cvmfs-server``
    RPM executes this command as a post-installation script.

**DNS cache**
    A Stratum 1 does a lot of DNS lookups, so we recommend installing a
    DNS caching mechanism on the machine such as ``dnsmasq`` or
    ``bind``. We do not recommend ``nscd`` since it does not honor the
    DNS Time-To-Live protocol.

Squid Configuration
-------------------

The Squid configuration differs from the site-local Squids because the
Stratum 1 Squid servers are transparent to the clients (*reverse
proxy*). As the expiry rules are set by the web server, Squid cache
expiry rules remain unchanged.

The following lines should appear accordingly in /etc/squid/squid.conf:

::

      http_port 80 accel
      http_port 8000 accel
      http_access allow all
      cache_peer <APACHE_HOSTNAME> parent <APACHE_PORT> 0 no-query originserver

      cache_mem <MEM_CACHE_SIZE> MB
      cache_dir ufs /var/spool/squid <DISK_CACHE_SIZE in MB> 16 256
      maximum_object_size 1024 MB
      maximum_object_size_in_memory 128 KB

|
| Note that ``http_access allow all`` has to be inserted before (or
  instead of) the line ``http_access deny all``. If Apache is running on
  the same host, the ``APACHE_HOSTNAME`` will be ``localhost``. Also, in
  that case there is not a performance advantage for squid to cache
  files that came from the same machine, so you can configure squid to
  not cache files. Do that with the following lines:

::

      acl CVMFSAPI urlpath_regex ^/cvmfs/[^/]*/api/
      cache deny !CVMFSAPI

Then the squid will only cache API calls. You can then set
``MEM_CACHE_SIZE`` and ``DISK_CACHE_SIZE`` quite small.

Check the configuration syntax by ``squid -k parse``. Create the hard
disk cache area with ``squid -z``. In order to make the increased number
of file descriptors effective for Squid, execute ``ulimit -n 8192``
prior to starting the squid service.

Monitoring
----------

The ``cvmfs_server`` utility reports status and problems to ``stdout``
and ``stderr``.

For the web server infrastructure, we recommend standard Nagios HTTP
checks. They should be configured with the URL
http://$replica-server/cvmfs/$repository_name/.cvmfspublished. This file
can also be used to monitor if the same repository revision is served by
the Stratum 0 server and all the Stratum 1 servers. In order to tune the
hardware and cache sizes, keep an eye on the Squid server's CPU and I/O
load.

Keep an eye on HTTP 404 errors. For normal CernVM-FS traffic, such
failures should not occur. Traffic from CernVM-FS clients is marked by
an ``X-CVMFS2`` header.
