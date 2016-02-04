.. _cpt_squid:

Setting up a Local Squid Proxy
==============================

For clusters of nodes with CernVM-FS clients, we strongly recommend to
setup two or more Squid\  [1]_ forward proxy servers as well. The
forward proxies will reduce the latency for the local worker nodes,
which is critical for cold cache performance. They also reduce the load
on the Stratum 1 servers.

From what we have seen, a Squid server on commodity hardware scales well
for at least a couple of hundred worker nodes. The more RAM and hard
disk you can devote for caching the better. We have good experience with
of memory cache and of hard disk cache. We suggest to setup two
identical Squid servers for reliability and load-balancing. Assuming the
two servers are A and B, set

::

      CVMFS_HTTP_PROXY="http://A:3128|http://B:3128"

Squid is very powerful and has lots of configuration and tuning options.
For CernVM-FS we require only the very basic static content caching. If
you already have a *Frontier Squid*\  [2]_ [1, 2] installed you can use
it as well for CernVM-FS.

Otherwise, cache sizes and access control needs to be configured in
order to use the Squid server with CernVM-FS. In order to do so, browse
through your /etc/squid/squid.conf and make sure the following lines
appear accordingly:

::

      max_filedesc 8192
      maximum_object_size 1024 MB

      cache_mem 128 MB
      maximum_object_size_in_memory 128 KB
      # 50 GB disk cache
      cache_dir ufs /var/spool/squid 50000 16 256

Furthermore, Squid needs to allow access to all Stratum 1 servers. This
is controlled through Squid ACLs. For the Stratum 1 servers for the
cern.ch, egi.eu, and opensciencegrid.org domains, add the following
lines to you Squid configuration:

::

      acl cvmfs dst cvmfs-stratum-one.cern.ch
      acl cvmfs dst cernvmfs.gridpp.rl.ac.uk
      acl cvmfs dst cvmfs.racf.bnl.gov
      acl cvmfs dst cvmfs02.grid.sinica.edu.tw
      acl cvmfs dst cvmfs.fnal.gov
      acl cvmfs dst cvmfs-atlas-nightlies.cern.ch
      acl cvmfs dst cvmfs-egi.gridpp.rl.ac.uk
      acl cvmfs dst klei.nikhef.nl
      acl cvmfs dst cvmfsrepo.lcg.triumf.ca
      acl cvmfs dst cvmfsrep.grid.sinica.edu.tw
      acl cvmfs dst cvmfs-s1bnl.opensciencegrid.org
      acl cvmfs dst cvmfs-s1fnal.opensciencegrid.org
      http_access allow cvmfs

The Squid configuration can be verified by ``squid -k parse``. Before
the first service start, the cache space on the hard disk needs to be
prepared by ``squid -z``. In order to make the increased number of file
descriptors effective for Squid, execute ``ulimit -n 8192`` prior to
starting the squid service.

.. raw:: html

   <div id="refs" class="references">

.. raw:: html

   <div id="ref-frontier08">

[1] Blumenfeld, B. et al. 2008. CMS conditions data access using
FroNTier. *Journal of Physics: Conference Series*. 119, (2008).

.. raw:: html

   </div>

.. raw:: html

   <div id="ref-frontier10">

[2] Dykstra, D. and Lueking, L. 2010. Greatly improved cache update
times for conditions data with frontier/Squid. *Journal of Physics:
Conference Series*. 219, (2010).

.. raw:: html

   </div>

.. raw:: html

   </div>

.. [1]
   http://www.squid-cache.org

.. [2]
   http://frontier.cern.ch
