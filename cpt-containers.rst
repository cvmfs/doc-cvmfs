.. _cpt_containers:

Container Images and CernVM-FS
==============================

CernVM-FS interacts with container technologies in two main ways:

1. CernVM-FS application repositories (e.g. /cvmfs/atlas.cern.ch) can be mounted into a stock container (e.g. CentOS 8)
2. The container root filesystem (e.g. the root file system "/" of CentOS 8) itself can be served directly from CernVM-FS

Both ways have a similar goal, that is to give users access to a reproducible,
ready-to-use environment while retaining the advantages of CernVM-FS regarding
data distribution, content de-duplication, software preservation and ease of
operations.

Mounting ``/cvmfs`` inside a container
--------------------------------------

The simplest way to access ``/cvmfs`` from inside a container is to bind-mount
the ``/cvmfs`` host directory inside the container.

Using this approach will allow using small images to create a basic operating
system environment, and to access all the necessary application software through
``/cvmfs``.

This is supported by all the common containers runtimes, including:

1. Docker
2. Podman
3. Apptainer
4. Kubernetes

Examples
~~~~~~~~

To bind-mount CVMFS inside a docker container, it is sufficient to use the
``--volume/-v`` flag.

For instance:

::

    docker run -it --volume /cvmfs:/cvmfs:shared ubuntu ls -lna /cvmfs/atlas.cern.ch


Of course, it is also possible to limit the bind-mount to only one repository, or a few repositories:

::

    $ docker run -it -v /cvmfs/alice.cern.ch:/cvmfs/alice.cern.ch \
                     -v /cvmfs/sft.cern.ch:/cvmfs/sft.cern.ch ubuntu
    root@808d42605e97:/# ll /cvmfs/
    total 17
    drwxr-xr-x 17  125  130 4096 Nov 27  2012 alice.cern.ch/
    drwxr-xr-x  8  125  130 4096 Oct 15  2018 sft.cern.ch/


Podman has the same interface as docker, but it requires the ``ro`` options when mounting a single repository.

::

    $ podman run -it -v /cvmfs/alice.cern.ch:/cvmfs/alice.cern.ch:ro ubuntu ls -lna /cvmfs/
    total 13
    drwxr-xr-x  3     0     0 4096 Apr 20 11:34 .
    drwxr-xr-x 22     0     0 4096 Apr 20 11:34 ..
    drwxr-xr-x 17 65534 65534 4096 Nov 27  2012 alice.cern.ch

A similar approach is possible with apptainer, but the syntax is a little different.

::

    $ apptainer exec --bind /cvmfs docker://library/ubuntu ls -l /cvmfs/lhcb.cern.ch
    total 2
    drwxrwxr-x.  3 cvmfs cvmfs  3 Jan  6  2011 etc
    lrwxrwxrwx.  1 cvmfs cvmfs 16 Aug  6  2011 group_login.csh -> lib/etc/LHCb.csh
    lrwxrwxrwx.  1 cvmfs cvmfs 15 Aug  6  2011 group_login.sh -> lib/etc/LHCb.sh
    drwxrwxr-x. 20 cvmfs cvmfs  3 Apr 24 12:39 lib


Also in apptainer it is possible to use the syntax
``host_directory:container_directory`` and it is possible to mount multiple
paths at the same time separating the ``--bind`` arguments with a comma.

::

    $ apptainer exec --bind /cvmfs/alice.cern.ch:/cvmfs/alice.cern.ch,/cvmfs/lhcb.cern.ch \
	docker://library/ubuntu ls -l /cvmfs/
    total 5
    drwxr-xr-x 17      125      130 4096 Nov 27  2012 alice.cern.ch/
    drwxrwxr-x  4      125      130    6 Nov 16  2010 lhcb.cern.ch/


For Kubernetes, the approach is more heterogeneous and it depends on the cluster settings.
A recommended approach is creating a DaemonSet so that on every node one pod exposes /cvmfs to other pods.
This pod may use the cvmfs service container.

Alternatively, a `CSI-plugin <https://clouddocs.web.cern.ch/containers/tutorials/cvmfs.html#kubernetes>`_
makes it simple to mount a repository inside a Kubernetes managed container.
The plugin is distributed and available to the CERN Kubernetes managed clusters.


Distributing container images on CernVM-FS
------------------------------------------

Image distribution on CernVM-FS works with *unpacked* layers or image root
file systems.  Any CernVM-FS repository can store container images.

A number of images are already provided in ``/cvmfs/unpacked.cern.ch``, a
repository managed at CERN to host container images for various purposes and
groups. The repository is managed using the CernVM-FS container tools to
publish images from registries on CernVM-FS.

Every container image is stored in two forms on CernVM-FS

1. All the unpacked layers of the image
2. The whole unpacked root filesystem of the image

With the whole filesystem root directory in /cvmfs, ``apptainer`` can directly start a container.

::

    apptainer exec /cvmfs/unpacked.cern.ch/registry.hub.docker.com/library/centos\:centos7 /bin/bash

The layers can be used, e.g., with containerd and the CernVM-FS snapshotter.
In addition, the container tools create the *chains* of an image.
Chains are partial root filesystem directores where layers are applied one after another.
This is used internally to incrementally publish image updates if only a subset of layers changed.

Using unpacked.cern.ch
~~~~~~~~~~~~~~~~~~~~~~

The ``unpacked.cern.ch`` repository provides a centrally managed container
image hub without burdening users with managing their CernVM-FS repositories
or conversion of images.  It also enables saving storage space because
of cvmfs deduplication of files that are common between different images.
The repository is publicly available.

To add your image to ``unpacked.cern.ch`` you can add the image name to any one
of the following two files, the so-called *wishlists*.

1. https://gitlab.cern.ch/unpacked/sync/-/blob/master/recipe.yaml
2. https://github.com/cvmfs/images-unpacked.cern.ch/blob/master/recipe.yaml

The first file is accessible from CERN infrastructure, while the second is on
Github open to everybody.

A simple pull request against one of those files is sufficient, the image is
vetted, and the pull request merged. Soon after the pull request is merged DUCC
publishes the image to /cvmfs/unpacked.cern.ch. Depending on the size of the
image, ingesting an image in unpacked.cern.ch takes ~15 minutes.

The images are continuously checked for updates. If you push another version of
the image with the same tag, the updated propagates to CernVM-FS usually within
~15 minutes of delay.

Image wishlist syntax
^^^^^^^^^^^^^^^^^^^^^

The image must be specified like the following examples:

::

    https://registry.hub.docker.com/library/centos:latest
    https://registry.hub.docker.com/cmssw/cc8:latest
    https://gitlab-registry.cern.ch/clange/jetmetanalysis:latest

The first two refer to images in Docker Hub, the standard
``centos`` using the latest tag and the ``cms`` version of centos8, again using
the latest tag. The third image refers to an image hosted on CERN GitLab
that contains the code for an analysis by a CERN user.

It is possible to use the ``*`` wildcard to specify multiple tags.

For instance:

::

    https://registry.hub.docker.com/atlas/analysisbase:21.2.1*

is a valid image specification, and triggers conversion of all the
``atlas/analysisbase`` images whose tags start with ``21.2.1``, including:

::

    atlas/analysisbase:21.2.10
    atlas/analysisbase:21.2.100-20191127
    atlas/analysisbase:21.2.15-20180118

But **not** ``atlas/analysisbase:21.3.10``.

The ``*`` wildcard can also be used to specify all the tags of an image, like
in this example:

::

    https://registry.hub.docker.com/pyhf/pyhf:*

All the tags of the image ``pyhf/pyhf`` that are published on Docker Hub
will be published in unpacked.cern.ch.


Updated images and new tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The unpacked.cern.ch service polls the upstream registries continuously.
As soon as a new or modified container image is detected it starts the conversion process.


``containerd`` snapshotter plugin (pre-production)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CernVM-FS integration with ``containerd`` is achieved by the cvmfs snapshotter plugin,
a specialized component responsible for assembling all the layers of container
images into a stacked filesystem that ``containerd`` can use.
The snapshotter takes as input the list of required layers and outputs a directory
containing the final filesystem. It is also responsible to clean-up the output
directory when containers using it are stopped.

How to use the CernVM-FS Snapshotter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The CernVM-FS snapshotter runs alongside the containerd service.
The snapshotter communicates with ``containerd`` via gRPC over a UNIX domain socket.
The default socket is ``/run/containerd-cvmfs-grpc/containerd-cvmfs-grpc.sock``.
This socket is created automatically by the snapshotter if it does not exist.

The containerd snapshotter is available from http://ecsft.cern.ch/dist/cvmfs/snapshotter/.
Packages will be made available in future.

The binary accepts the following command line options:

- ``--address``: address for the snapshotter's GRPC server. The default one is ``/run/containerd-cvmfs-grpc/containerd-cvmfs-grpc.sock``
- ``--config``: path to the configuration file. Creating a configuration file is useful to customize the default values.
- ``--log-level``: logging level [trace, debug, info, warn, error, fatal, panic]. The default value is ``info``.
- ``--root``: path to the root directory for this snapshotter. The default one is ``/var/lib/containerd-cvmfs-grpc``.

By default, the repository used to search for the layers is ``unpacked.cern.ch``.
The default values can be overwritten in the ``config.toml`` file using the ``--config`` option.
A template ``config.toml`` file looks like this:

::

    version = 2

    # Source of image layers
    repository = "unpacked.cern.ch"
    absolute-mountpoint = "/cvmfs/unpacked.cern.ch"

    # Ask containerd to use this particular snapshotter
    [plugins."io.containerd.grpc.v1.cri".containerd]
        snapshotter = "cvmfs-snapshotter"
        disable_snapshot_annotations = false

    # Set the communication endpoint between containerd and the snapshotter
    [proxy_plugins]
        [proxy_plugins.cvmfs]
            type = "snapshot"
            address = "/run/containerd-cvmfs-grpc/containerd-cvmfs-grpc.sock"


Note that if only the repository is specified under the key value ``repository``, the mountpoint
(under the key value ``absolute-mountpoint``) is by default constructed as ``/cvmfs/<repo_name>``.


``podman`` integration (pre-production)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to use images from unpacked.cern.ch with podman,
the podman client needs to point to an *image store* that references the images on /cvmfs.
The image store is a directory is a directory with a a certain file structure
that provides an index of images and layers.
The CernVM-FS container tools by default create a podman image store for published images.

In order to set the image store, edit ``/etc/containers/storage.conf`` or ``${HOME}/.config/containers/storage.conf`` like in this example:

::

    [storage]
    driver = "overlay"

    [storage.options]
    additionalimagestores = [ "/cvmfs/unpacked.cern.ch/podmanStore" ]
    # mount_program = "/usr/bin/fuse-overlayfs"

    [storage.options.overlay]
    mount_program = "/usr/bin/fuse-overlayfs"


The configuration can be checked with the ``podman images`` command.

**Note:** the image store in the unpacked.cern.ch repository currently provides access only to test images.
This is due to poor performance in the image conversion when the image store is updated.
This will be fixed in a future version.

