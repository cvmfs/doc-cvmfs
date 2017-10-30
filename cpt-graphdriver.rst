.. _cpt_graphdriver:

CernVM-FS Graph Driver Plugin for Docker
========================================

The CernVM-FS graph driver plugin for Docker provides a dockerized CernVM-FS
client that can be used by the Docker daemon to access and store container
images that reside in an extracted form on a CernVM-FS repository.
Because CernVM-FS downloads the files of a container image only when accessed
and because typically very little of a container image is accessed at runtime,
the CernVM-FS graph driver can remove the bottleneck of distributing (large)
container images to (many) nodes.

The CernVM-FS graph driver can run any normal image from a Docker registry.
Additionally, it can run so called *Thin Images*. A thin image is like a
symbolic link for container images. It is a regular, very small image in the
registry. It contains a single file, the *thin image descriptor*, that specifies
where in a CernVM-FS repository the actual image contents can be found. The
``docker2cvmfs`` utility can be used to convert a regular image to a thin image.

.. figure:: _static/thin_image.svg
   :alt: Comparision between regular container images and thin images
   :figwidth: 750
   :align: center


Requirements
------------

The graph driver plugin requires Docker version > 17 and a host kernel with
either aufs or overlay2 support, which includes RHEL >= 7.3. Please note that
on RHEL 7, Docker's data root should reside either on an ext file system or on
an xfs file system that is formatted with the ``ftype=1`` mount option.

The Docker graph driver plugin receives its CernVM-FS configuration by default
from the Docker host's /etc/cvmfs directory. The easiest way to populate
/etc/cvmfs is to install the ``cvmfs-config-default`` package (or any other
``cvmfs-config-...`` package) on the Docker host.  Alternatively, a directory
structure resembling the /etc/cvmfs hierarchy can by manually created and linked
to the graph driver plugin.


Installation
------------

The folling steps install and activate the CernVM-FS graph driver plugin.

 1. Install the plugin with ``docker plugin install cvmfs/graphdriver``. The
    command ``docker plugin ls`` should now show the new plugin as being
    activated.

 2. Create or edit the file ``/etc/docker/daemon.json`` so that it contains
    the following content ::

        {
          "experimental": true,
          "storage-driver": "cvmfs/graphdriver",

          // To change the docker data root to an ext formatted location (remove this line)
          "data-root": "/path/to/ext/mountpoint",

          // Add the following storage option on RHEL 7 (remove this line)
          "storage-opts": [
            "overlay2.override_kernel_check=true"
          ]
        }

 3. Restart the Docker daemon with ``systemctl restart docker``.

 4. Test the new plugin with a normal image ::

        docker run -it --rm ubuntu /bin/bash

    and with a thin image ::

        docker run -it --rm cvmfs/thin_ubuntu /bin/bash

In order to get debugging output, add ``"debug": true`` to the
/etc/docker/daemon.json file.


Location of the Plugin Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, the plugin tries to bind mount the host's /etc/cvmfs directory
as a source of configuration. Other locations can be linked to the container
by running ::

     docker plugin set cvmfs/graphdriver cvmfs_ext_config="/alternative/location"
     docker plugin set cvmfs/graphdriver minio_ext_config="/alternative/location"


Installation from a Plugin Tarball
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Instead of installing the plugin from the Docker registry, it can be installed
directly from a tarball. To do so, `download <https://ecsft.cern.ch/dist/cvmfs/docker-graphdriver>`_
and untar a graph driver plugin tarball.  Run ::

    docker plugin create my-graphdriver cvmfs-graphdriver-plugin-$VERSION
    docker plugin enable my-graphdriver

**Note**: currently, the graph driver name (``my-graphdriver``) must not contain
a colon (``:``) nor a comma (``,``).  This issue will be fixed in a lalter
version.
