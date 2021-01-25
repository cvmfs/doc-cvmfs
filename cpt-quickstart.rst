Getting Started
===============

This section describes how to install the CernVM-FS client.
The CernVM-FS client is supported on x86, x86\_64, and ARM architectures running Linux and
macOS \ :math:`\geq 10.14` as well as on Windows Services for Linux (WSL2).
There is experimental support for Power and RISC-V architectures.

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

    sudo dnf install https://ecsft.cern.ch/dist/cvmfs/cvmfs-2.8.0/cvmfs-2.8.0-1.fc29.x86_64.rpm https://ecsft.cern.ch/dist/cvmfs/cvmfs-config/cvmfs-config-default-latest.noarch.rpm


Docker Container
~~~~~~~~~~~~~~~~

The CernVM-FS service container can expose the /cvmfs directory tree to the host.
Import the container with

::

    docker pull cvmfs/service

or with

::

    curl https://ecsft.cern.ch/dist/cvmfs/cvmfs-2.8.0/cvmfs-service-2.8.0-1.x86_64.docker.tar.gz | docker load

Run the container as a system service with

::

    docker run -d --rm \
      -e CVMFS_CLIENT_PROFILE=single \
      -e CVMFS_REPOSITORIES=sft.cern.ch,... \
      --cap-add SYS_ADMIN \
      --device /dev/fuse \
      --volume /cvmfs:/cvmfs:shared \
      cvmfs/service:2.8.0-1

Use ``docker stop`` to unmount the /cvmfs tree.
Note that if you run multiple nodes (a cluster), you should use ``-e CVMFS_HTTP_PROXY`` to set a proper site proxy as described further down.

Mac OS X
~~~~~~~~

On Mac OS X, CernVM-FS is based on `macFUSE <http://osxfuse.github.io>`_.
Note that as of macOS 11 Big Sur, `kernel extensions need to be enabled <https://support.apple.com/guide/mac-help/change-startup-disk-security-settings-a-mac-mchl768f7291/mac>`_
to install macFUSE.
Verify that fuse is available with

::

    kextstat | grep -i fuse

Download the CernVM-FS client package in the terminal in order to avoid signature warnings

::

    curl -o ~/Downloads/cvmfs-2.8.0.pkg https://ecsft.cern.ch/dist/cvmfs/cvmfs-2.8.0/cvmfs-2.8.0.pkg

Install the CernVM-FS package by opening the .pkg file and reboot.
Future releases will provide a signed and notarized package.


Windows / WSL2
~~~~~~~~~~~~~~

Follow the `Windows instructions <https://docs.microsoft.com/en-us/windows/wsl/install-win10>`_ to install the Windows Subsytem for Linux (WSL2).
Install any of the Linux distributions and follow the instructions for the distribution in this guide.
Whenever you open the Linux distribution, run

::

    sudo cvmfs_config wsl2_start

to start the CernVM-FS service.


Setting up the Software
-----------------------

Configure AutoFS
~~~~~~~~~~~~~~~~

For the basic setup, run ``cvmfs_config setup``.
This ensures that the file /etc/auto.master.d/cvmfs.autofs exists containing ``/cvmfs /etc/auto.cvmfs`` and that the autofs service is running. Reload the autofs service in order to apply an updated configuration.

NB: For OpenSUSE uncomment the line ``#+dir:/etc/auto.master.d/`` in the file /etc/auto.master and restart the autofs service.

::

    sed -i 's%#+dir:/etc/auto.master.d%+dir:/etc/auto.master.d%' /etc/auto.master
    systemctl restart autofs


Mac OS X
~~~~~~~~

Due to the lack of autofs on macOS, mount the individual repositories manually like

::

    sudo mkdir -p /cvmfs/cvmfs-config.cern.ch
    sudo mount -t cvmfs cvmfs-config.cern.ch /cvmfs/cvmfs-config.cern.ch

For optimal configuration settings, mount the config repository before any other repositories.


Create default.local
~~~~~~~~~~~~~~~~~~~~

Create ``/etc/cvmfs/default.local`` and open the file for editing.
Select the desired repositories by setting ``CVMFS_REPOSITORIES=repo1,repo2,...``. For ATLAS, for instance, set

::

    CVMFS_REPOSITORIES=atlas.cern.ch,atlas-condb.cern.ch,grid.cern.ch

For an individual workstation or laptop, set

::

    CVMFS_CLIENT_PROFILE=single

If you setup a cluster of cvmfs nodes, specify the HTTP proxy servers on your site with

::

    CVMFS_HTTP_PROXY="http://myproxy1:port|http://myproxy2:port"

If you're unsure about the proxy names, set ``CVMFS_HTTP_PROXY=DIRECT``.
This should *only* be done for a small number of clients (< 5), because large numbers can put a heavy load on the Stratum 1 servers and result, amongst others, in poorer performance for the client.
For the syntax of more complex HTTP proxy settings, see :ref:`sct_network`.
If there are no HTTP proxies yet at your site, see :ref:`cpt_squid` for instructions on how to set them up.

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
