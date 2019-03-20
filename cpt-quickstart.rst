Getting Started
===============

This section describes how to install the CernVM-FS client.
The CernVM-FS client is supported on x86, x86\_64, and ARM architectures running Linux or Mac OS X \ :math:`\geq 10.12`.
There is experimental support for Power 8 and RISC-V.

Overview
--------
The CernVM-FS repositories are located under /cvmfs.
Each repository is identified by a *fully qualified repository name*.
On Linux, mounting and un-mounting of the CernVM-FS is usually controlled by autofs and automount.
That means that starting from the base directory /cvmfs different repositories are mounted automatically just by accessing them.
A repository will be automatically unmounted after some automount-defined idle time.
On macOS, mounting and un-mounting of the CernVM-FS is done by the user with ``sudo mount -t cvmfs /cvmfs/...`` commands.

Getting the Software
--------------------
The CernVM-FS source code and binary packages are available from the `CernVM website <https://cernvm.cern.ch/portal/filesystem/downloads>`_.
However it is recommended to use the available package repositories that are also provided for the supported operating systems.

Scientific Linux/CentOS
~~~~~~~~~~~~~~~~~~~~~~~
To add the CVMFS repository and install CVMFS run

::

    sudo yum install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
    sudo yum install -y cvmfs

Debian/Ubuntu
~~~~~~~~~~~~~
To add the CVMFS repository and install CVMFS run

::

    wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
    sudo dpkg -i cvmfs-release-latest_all.deb
    rm -f cvmfs-release-latest_all.deb
    sudo apt-get update
    sudo apt-get install cvmfs

Fedora
~~~~~~
To install the CVMFS package run

::

    sudo dnf install https://ecsft.cern.ch/dist/cvmfs/cvmfs-2.6.0/cvmfs-2.6.0-1.fc29.x86_64.rpm https://ecsft.cern.ch/dist/cvmfs/cvmfs-config/cvmfs-config-default-latest.noarch.rpm

Mac OS X
~~~~~~~~

Install the CernVM-FS package by opening the .pkg file.


Setting up the Software
-----------------------

Configure AutoFS
~~~~~~~~~~~~~~~~

For the basic setup, run ``cvmfs_config setup``.
This ensures that ``/cvmfs /etc/auto.cvmfs`` is set in /etc/auto.master and that the autofs service is running.
Reload the autofs service in order to apply an updated configuration.

Mac OS X
~~~~~~~~

On Mac OS X, CernVM-FS is based on `OSXFuse <http://osxfuse.github.io>`_.
It is not integrated with autofs hence mount the individual repositories using

::

    sudo mkdir -p /cvmfs/cms.cern.ch
    sudo mount -t cvmfs cms.cern.ch /cvmfs/cms.cern.ch

Create default.local
~~~~~~~~~~~~~~~~~~~~

Create ``/etc/cvmfs/default.local`` and open the file for editing.
Select the desired repositories by setting ``CVMFS_REPOSITORIES=repo1,repo2,...``. For ATLAS, for instance, set

::

    CVMFS_REPOSITORIES=atlas.cern.ch,atlas-condb.cern.ch,grid.cern.ch

Specify the HTTP proxy servers on your site with

::

    CVMFS_HTTP_PROXY="http://myproxy1:port|http://myproxy2:port"

If you're unsure about the proxy names, set ``CVMFS_HTTP_PROXY=DIRECT``.
This should *only* be done for a small number of clients (< 5), because large numbers can put a heavy load on the Stratum 1 servers and result, amongst others, in poorer performance for the client.
For the syntax of more complex HTTP proxy settings, see :ref:`sct_network`.

Verify the file system
~~~~~~~~~~~~~~~~~~~~~~

Check if CernVM-FS mounts the specified repositories by ``cvmfs_config probe``.
If the probe fails, try to restart autofs with ``sudo systemctl restart autofs``.

Building from source
--------------------

The CernVM-FS client is not relocatable and needs to be installed under /usr.
On Intel architectures, it needs a gcc :math:`\geq 4.2` compiler, on ARMv7 a gcc :math:`\geq 4.7` compiler. In order to compile and install from sources, use the following commands

::

    cd <source directory>
    mkdir build && cd build
    cmake ../
    make
    sudo make install

Troubleshooting
---------------

In order to check for common misconfigurations in the base setup, run

::

    cvmfs_config chksetup

CernVM-FS gathers its configuration parameter from various configuration files that can overwrite each others settings (default configuration, domain specific configuration, local setup, ...).
To show the effective configuration for *repository*.cern.ch, run

::

    cvmfs_config showconfig repository.cern.ch

In order to exclude autofs/automounter as a source of problems, you can try to mount *repository*.cern.ch manually with the following

::

    mkdir -p /mnt/cvmfs
    mount -t cvmfs repository.cern.ch /mnt/cvmfs

In order to exclude SELinux as a source of problems, you can try mounting after SELinux has been disabled by

::

    /usr/sbin/setenforce 0

Once the issue has been identified, ensure that the changes are taken by restarting autofs

::

    systemctl restart autofs
