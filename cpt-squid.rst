.. _cpt_squid:

Setting up a Local Squid Proxy
==============================

For clusters of nodes with CernVM-FS clients, we strongly recommend 
setting up two or more `Squid forward proxy <http://www.squid-
cache.org>`_ servers as well. The forward proxies will reduce the
latency for the local worker nodes, which is critical for cold cache
performance. They also reduce the load on the Stratum 1 servers.

From what we have seen, a Squid server on commodity hardware scales well
for at least a couple of hundred worker nodes. The more RAM and hard
disk you can devote for caching the better. We have good experience with
memory cache and hard disk cache. We suggest setting up two
identical Squid servers for reliability and load-balancing. Assuming the
two servers are A and B, set

::

      CVMFS_HTTP_PROXY="http://A:3128|http://B:3128"

Squid is very powerful and has lots of configuration and tuning
options. For CernVM-FS we require only the very basic static content
caching. If you already have a
`Frontier Squid <https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid>`_
installed you can use it as well for CernVM-FS.

One option that is particularly important when there are a lot of worker
nodes and jobs that start close together is the `collapsed_forwarding`
option.  This combines multiple simultaneous requests for the same
object into a single request to a Stratum 1 server.  This did not work
properly on squid versions prior to 3.5.28, which includes the default
squid on EL7.  This also works properly in Frontier Squid.

In any case, cache sizes and access control needs to be configured in
order to use the Squid server with CernVM-FS. In order to do so, browse
through your /etc/squid/squid.conf and make sure the following lines
appear accordingly:

::

      collapsed_forwarding on
      minimum_expiry_time 0
      maximum_object_size 1024 MB

      cache_mem 128 MB
      maximum_object_size_in_memory 128 KB
      # 50 GB disk cache
      cache_dir ufs /var/spool/squid 50000 16 256

Furthermore, Squid needs to allow access to all Stratum 1 servers. This
is controlled through Squid ACLs.  Most sites allow all of their IP
addresses to connect to any destination address.  By default squid
allows that for the standard private IP addresses, but if you're not
using a private network then add your public address ranges, with
something like this:

::

      acl localnet src A.B.C.D/NN

If you instead want to limit the destinations to major cvmfs Stratum 1s,
it is better to use the list built in to 
`Frontier Squid <https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Restricting_the_destination>`_
because the list is sometimes updated with new releases.

The Squid configuration can be verified by ``squid -k parse``. Before
the first service start, the cache space on the hard disk needs to be
prepared by ``squid -z``. In order to make enough file descriptors
available to squid, execute ``ulimit -n 8192`` or some higher number
prior to starting the squid service.
