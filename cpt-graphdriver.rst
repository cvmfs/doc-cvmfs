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


Conversion of Images
--------------------

**Note:** The usage of the ``cvmfs2docker`` utility is preliminary. A more
convenient transformation process is under development.

Download the latest version of the docker2cvmfs utility from
`https://ecsft.cern.ch/dist/cvmfs/docker2cvmfs/ <https://ecsft.cern.ch/dist/cvmfs/docker2cvmfs/>`_
and make it executable with ``chmod +x docker2cvmfs``.

On a cvmfs release manager machines, download the original images layers as
tarballs using ``docker2``, like ::

    ./docker2cvmfs --registry https://gitlab-registry.cern.ch/v2 pull cloud/image-name:latest /home/user/layers/

If you download from DockerHub, you can omit the ``--registry`` flag.

To extract the image layer tarballs into a CernVM-FS repository, run a bash
script like the following one ::

    DESTINATION=/cvmfs/images.cern.ch/layers
    for l in /home/user/layers/*; do
      hash=$(basename $l .tar.gz)
      dst_layer=/cvmfs/test.cern.ch/layers/$hash
      mkdir -p $dst_layer
      touch $dst_layer/.cvmfscatalog
      tar xf $l -C $dst_layer --owner=$(id -u) --group=$(id -u) --no-xattrs --exclude="*dev/*";
    done

Note that the CernVM-FS repository should have the settings
``CVMFS_IGNORE_SPECIAL_FILES=true``, ``CVMFS_INCLUDE_XATTRS=true``, and
``CVMFS_IGNORE_XDIR_HARDLINKS=true``.  If the repository is owned by the root
user on the release manager machine, the extra options to the tar command can
be omitted.

As a last step, the thin image needs to be pushed to a docker registry.  To
do so, run the following commands ::

    ./docker2cvmfs --registry https://gitlab-registry.cern.ch/v2 thin cloud/image-name:latest images.cern.ch/layers > thin.json
    tar cf - thin.json | docker import - cvmfs/thin_image-name
    docker push cvmfs/thin_image-name
