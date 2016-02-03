Getting Started
===============

This section describes how to install the CernVM-FS client. The
CernVM-FS client is supported on x86, x86\_64, and ARMv7 architectures
running Scientific Linux 4–7, Ubuntu \ :math:`\geq12.04`, SLES 11 and
openSuSE 13.1, Fedora 19–21, or Mac OS X \ :math:`\geq 10.8`.

Getting the Software
--------------------

The CernVM-FS source code and binary packages are available under
https://cernvm.cern.ch/portal/downloads. Binary packages are produced
for rpm, dpkg, and Mac OS X (.pkg). yum repositories for 64 bit and 32
bit Scientific Linux 5 and 6 and 64 bit Scientific Linux 7 are available
under http://cvmrepo.web.cern.ch/cvmrepo/yum. The ``cvmfs-release``
packages can be used to add a these yum repositories to the local
yum installation. The ``cvmfs-release`` packages are available under
https://cernvm.cern.ch/portal/downloads.

The CernVM-FS client is not relocatable and needs to be installed under
/usr. On Intel architectures, it needs a gcc :math:`\geq 4.2` compiler,
on ARMv7 a gcc :math:`\geq 4.7` compiler. In order to compile and
install from sources, use the following cmake command:

::

      cmake .
      make
      sudo make install

Installation
------------

Linux
~~~~~

To install, proceed according to the following steps:

**Step 1**
    Install the CernVM-FS packages. With yum, run

    ::

          yum install cvmfs cvmfs-config-default

    If yum does not show the latest packages, clean the yum cache by
    ``yum clean all``. Packages can be also installed with rpm instead
    with the command ``rpm -vi``. On Ubuntu, use ``dpkg -i`` on the
    cvmfs and cvmfs-config-default .deb packages.

**Step 2**
    For the base setup, run ``cvmfs_config setup``. Alternatively, you
    can do the base setup by hand: ensure that ``user_allow_other`` is
    set in /etc/fuse.conf, ensure that ``/cvmfs /etc/auto.cvmfs`` is set
    in /etc/auto.master and that the autofs service is running. If you
    migrate from a previous version of CernVM-FS, check the release
    notes if there is anything special to do for migration.

**Step 3**
    Create /etc/cvmfs/default.local and open the file for editing.

**Step 4**
    Select the desired repositories by setting
    ``CVMFS_REPOSITORIES=repo1,repo2,...``. For ATLAS, for instance, set

    ::

          CVMFS_REPOSITORIES=atlas.cern.ch,atlas-condb.cern.ch,grid.cern.ch

    Specify the HTTP proxy servers on your site with

    ::

          CVMFS_HTTP_PROXY="http://myproxy1:port|http://myproxy2:port"

    For the syntax of more complex HTTP proxy settings, see
    Section [sct:config:network]. Make sure your local proxy servers
    allow access to all the Stratum 1 web servers (see
    Section [sct:squid]). For Cern repositories, the Stratum 1 web
    servers are listed in /etc/cvmfs/domain.d/cern.ch.conf.

**Step 5**
    Check if CernVM-FS mounts the specified repositories by
    ``cvmfs_config probe``.

Mac OS X
~~~~~~~~

On Mac OS X, CernVM-FS is based on OSXFuse\  [1]_. It is not integrated
with autofs. In order to install, proceed according to the following
steps:

**Step 1**
    Install the CernVM-FS package by opening the .pkg file.

**Step 2**
    Create /etc/cvmfs/default.local and open the file for editing.

**Step 3**
    Select the desired repositories by setting
    ``CVMFS_REPOSITORIES=repo1,repo2,...``. For CMS, for instance, set

    ::

          CVMFS_REPOSITORIES=cms.cern.ch

    Specify the HTTP proxy servers on your site with

    ::

          CVMFS_HTTP_PROXY="http://myproxy1:port|http://myproxy2:port"

    If you’re unsure about the proxy names, set
    ``CVMFS_HTTP_PROXY=DIRECT``.

**Step 4**
    Mount your repositories like

    ::

          sudo mkdir -p /cvmfs/cms.cern.ch
          sudo mount -t cvmfs cms.cern.ch /cvmfs/cms.cern.ch

Usage
-----

The CernVM-FS repositories are located under /cvmfs. Each repository is
identified by a *fully qualified repository name*. The fully qualified
repository name consists of a repository identifier and a domain name,
similar to DNS records [1]. The domain part of the fully qualified
repository name indicates the location of repository creation and
maintenance. For the ATLAS experiment software, for instance, the fully
qualified repository name is atlas.cern.ch although the hosting web
servers are spread around the world.

Mounting and un-mounting of the CernVM-FS is controlled by autofs and
automount. That is, starting from the base directory /cvmfs different
repositories are mounted automatically just by accessing them. For
instance, running the command ``ls /cvmfs/atlas.cern.ch`` will mount the
ATLAS software repository on the fly. This directory gets automatically
unmounted after some automount-defined idle time.

Debugging Hints
---------------

In order to check for common misconfigurations in the base setup, run

::

      cvmfs_config chksetup

CernVM-FS gathers its configuration parameter from various configuration
files that can overwrite each others settings (default configuration,
domain specific configuration, local setup, …). To show the effective
configuration for *repository*.cern.ch, run

::

      cvmfs_config showconfig repository.cern.ch

In order to exclude autofs/automounter as a source of problems, you can
try to mount *repository*.cern.ch manually by

::

      mkdir -p /mnt/cvmfs
      mount -t cvmfs repository.cern.ch /mnt/cvmfs

In order to exclude SELinux as a source of problems, you can try
mounting after SELinux has been disabled by

::

      /usr/sbin/setenforce 0

Once you sorted out a problem, make sure that you do not get the
original error served from the file system buffers by

::

      service autofs restart

In case you need additional assistance, please don’t hesitate to contact
us at `cernvm.support@cern.ch <cernvm.support@cern.ch>`__. Together with
the problem description, please send the system information tarball
created by ``cvmfs_config bugreport``.

.. raw:: html

   <div id="refs" class="references">

.. raw:: html

   <div id="ref-rfc1035">

[1] Mockapetris, P. 1987. *Domain names - implementation and
specification*. Technical Report #1035. Internet Engineering Task Force.

.. raw:: html

   </div>

.. raw:: html

   </div>

.. [1]
   http://osxfuse.github.io
