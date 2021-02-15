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
with ``cron``, using the ``cvmfs_server snapshot -a`` command. The
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
    Apache instead of a separate machine, to reduce the number of points
    of failure. In that case caching can be disabled for the data (since
    there's no need to store it again on the same disk), but caching is
    helpful for the responses to geo api calls. Using a squid is also
    helpful for participating in shared monitoring such as the `WLCG
    Squid Monitor <http://wlcg-squid-monitor.cern.ch>`.
    
    Alternatively, separate Squid server machines may be configured in a
    round-robin DNS and each forward to the Apache server, but note that
    if any of them are down the entire service will be considered down
    by CernVM-FS clients.  A front end hardware load balancer that
    quickly takes a machine that is down out of service would help
    reduce the impact.

**High availability**
    On the subject of availability, note that it is not advised to use
    two separate complete Stratum 1 servers in a single round-robin
    service because they will be updated at different rates.  That would
    cause errors when a client sees an updated catalog from one Stratum
    1 but tries to read corresponding data files from the other that does
    not yet have the files.  Different Stratum 1s should either be
    separately configured on the clients, or a pair can be configured as
    a high availability active/standby pair using the cvmfs-contrib
    `cvmfs-hastratum1 package <https://github.com/cvmfs-contrib/cvmfs-hastratum1>`.
    An active/standby pair can also be managed by switching a DNS name
    between two different servers.

**DNS cache**
    The geo api on a Stratum 1 does DNS lookups.  It caches lookups
    for 5 minutes so the DNS server load does not tend to be severe, but
    we still recommend installing a DNS caching mechanism on the machine
    such as ``dnsmasq`` or ``bind``.  We do not recommend ``nscd`` since
    it does not honor the DNS Time-To-Live protocol.  

Squid Configuration
-------------------

If you participate in the Open Science Grid (OSG) or the European Grid
Infrastructure (EGI), you are encouraged to use their distribution of
squid called frontier-squid.  It is kept up to date with the latest
squid bug fixes and has features for easier upgrading and monitoring.
Step-by-step instructions for setting it up with a Stratum 1 is
available in the `OSG documentation
https://opensciencegrid.org/docs/other/install-cvmfs-stratum1/#configuring-frontier-squid`.

Otherwise, a `squid` package is available in most Linux operating systems.
The Squid configuration differs from the site-local Squids because the
Stratum 1 Squid servers are transparent to the clients (*reverse
proxy*). As the expiry rules are set by the web server, Squid cache
expiry rules remain unchanged.

The following lines should appear accordingly in /etc/squid/squid.conf:

::

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
Even if squid is configured to cache everything it is best to keep
``MEM_CACHE_SIZE`` small, because it is generally better to leave as
much RAM to the operating system for file system caching as possible.

Check the configuration syntax by ``squid -k parse``. Create the hard
disk cache area with ``squid -z``. In order to make the increased number
of file descriptors effective for Squid, execute ``ulimit -n 8192``
prior to starting the squid service.

The Squid also needs to respond to port 80, but Squid might not have the
ability to directly listen there if it is run unprivileged, plus Apache
listens on port 80 by default.  Direct external port 80 traffic to port
8000 with the following command:

::

    iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000

If IPv6 is supported, do the same command with ``ip6tables``.  This will
leave localhost traffic to port 80 going directly to Apache, which is
good because cvmfs_server uses it that and it doesn't need to go
through squid.

**Note**: Port 8000 might be assigned to ``soundd``.  On SElinux systems,
this assignment must be changed to the HTTP service by
``semanage port -m -t http_port_t -p tcp 8000``.  The ``cvmfs-server``
RPM for EL7 executes this command as a post-installation script.

.. _sct_geoip_db:

Geo API Setup
-------------

One of the essential services supplied by Stratum 1s to CernVM-FS
clients is the Geo API.  This enables clients to share configurations
worldwide while automatically sorting Stratum 1s geographically to
prioritize connecting to the closest ones.  This makes use of a GeoIP
database from `Maxmind <https://dev.maxmind.com/geoip/geoip2/geolite2/>`_
that translates IP addresses of clients to longitude and latitude.

The database is free, but the Maxmind
`End User License Agreement <https://www.maxmind.com/en/geolite2/eula/>`_
requires that each user of the database
`sign up for an account <https://www.maxmind.com/en/geolite2/signup/>`_
and promise to update the database to the latest version within 30 days
of when they issue a new version.  The signup process will end with
giving you a License Key.  The ``cvmfs_server`` ``add-replica`` and
``snapshot`` commands will take care of automatically updating the
database if you put a line like the following in
``/etc/cvmfs/server.local``, replacing ``<license key>`` with the key
you get from the signup process:

::

      CVMFS_GEO_LICENSE_KEY=<license key>

To keep the key secret, set the mode of ``/etc/cvmfs/server.local`` to 600.
You can test that it works by running ``cvmfs_server update-geodb``.

Alternatively, if you have a separate mechanism of installing and
updating the Geolite2 City database file, you can instead set
``CVMFS_GEO_DB_FILE`` to the full path where you have installed it.  If
the path is ``NONE``, then no database will be required, but note that
this will break the client Geo API so only use it for testing, when the
server is not used by production clients.  If the database is installed
in the default directory used by Maxmind's own
`geoipupdate <https://dev.maxmind.com/geoip/geoipupdate/>`_ tool,
``/usr/share/GeoIP``, then ``cvmfs_server`` will use it from there and
neither variable needs to be set.

Normally repositories on Stratum 1s are created owned by root, and the
``cvmfs_server snapshot`` command is run by root.  If you want to use a
different user id while still using the builtin mechanism for updating
the geo database, change the owner of ``/var/lib/cvmfs-server/geo`` and
``/etc/cvmfs/server.local`` to the user id.

The builtin geo database update mechanism normally checks for updates
once a week on Tuesdays but can be controlled through a set of variables
defined in ``cvmfs_server`` beginning with ``CVMFS_UPDATEGEO_``.  Look
in the ``cvmfs_server`` script for the details.  An update can also be
forced at any time by running ``cvmfs_server update-geodb``.

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
