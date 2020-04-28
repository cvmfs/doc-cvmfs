.. _cpt_containers:

Container Images and CernVM-FS
==============================

CernVM-FS interacts with containers technologies in two main ways:

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
3. runc
4. Singularity
5. Kubernetes

Examples
~~~~~~~~

To bind-mount CVMFS inside a container docker, it is sufficient to use the
``--volume/-v`` flag.

For instance:

::

    docker run -it --volume /cvmfs:/cvmfs:shared ubuntu ls -lna /cvmfs/atlas.cern.ch


Of course, it is also possible to limit the bind-mount to only one repository, or few repositories:

::

    $ docker run -it -v /cvmfs/alice.cern.ch:/cvmfs/alice.cern.ch \
                     -v /cvmfs/sft.cern.ch:/cvmfs/sft.cern.ch ubuntu
    root@808d42605e97:/# ll /cvmfs/
    total 17
    drwxr-xr-x 17  125  130 4096 Nov 27  2012 alice.cern.ch/
    drwxr-xr-x  8  125  130 4096 Oct 15  2018 sft.cern.ch/


Podman has the same interface of docker, but it requires the ``ro`` options when mounting a single repository.

::

    $ podman run -it -v /cvmfs/alice.cern.ch:/cvmfs/alice.cern.ch:ro ubuntu ls -lna /cvmfs/
    total 13
    drwxr-xr-x  3     0     0 4096 Apr 20 11:34 .
    drwxr-xr-x 22     0     0 4096 Apr 20 11:34 ..
    drwxr-xr-x 17 65534 65534 4096 Nov 27  2012 alice.cern.ch

A similar approach is possible with Singularity, but the syntax is a little different.

::

    $ singularity exec --bind /cvmfs docker://library/ubuntu:18.04 /bin/bash
    Singularity> ll /cvmfs/lhcb.cern.ch/
    total 2
    drwxrwxr-x.  3 cvmfs cvmfs  3 Jan  6  2011 etc
    lrwxrwxrwx.  1 cvmfs cvmfs 16 Aug  6  2011 group_login.csh -> lib/etc/LHCb.csh
    lrwxrwxrwx.  1 cvmfs cvmfs 15 Aug  6  2011 group_login.sh -> lib/etc/LHCb.sh
    drwxrwxr-x. 20 cvmfs cvmfs  3 Apr 24 12:39 lib


Also in singularity is possible to use the syntax
``host_directory:container_directory`` and it is possible to mount multiple
paths at the same time separating the ``--bind`` arguments with a comma.

::

    $ singularity exec --bind /cvmfs/alice.cern.ch:/cvmfs/alice.cern.ch,/cvmfs/lhcb.cern.ch \
	docker://library/ubuntu:18.04 /bin/bash
    Singularity> ll /cvmfs/
    total 5
    drwxr-xr-x  4 smosciat smosciat   80 Apr 20 11:16 ./
    drwxr-xr-x  1 smosciat smosciat  100 Apr 20 11:16 ../
    drwxr-xr-x 17      125      130 4096 Nov 27  2012 alice.cern.ch/
    drwxrwxr-x  4      125      130    6 Nov 16  2010 lhcb.cern.ch/


For Kubernetes, the approach is more heterogeneous and it depends on the cluster settings.

For Kubernetes, a `CSI-plugin <https://clouddocs.web.cern.ch/containers/tutorials/cvmfs.html#kubernetes>`_
makes it simple to mount a repository inside a Kubernetes managed container.
The plugin is distributed and available to the CERN Kubernetes managed clusters.


Distributing container images on CernVM-FS
------------------------------------------

Image distribution on CernVM-FS works with _unpacked_ layers or image root
file systems.  Any CernVM-FS repository can store container images.

A number of images is already provided by ``/cvmfs/unpacked.cern.ch``, a
repository managed at CERN to host containers images for various purposes and
groups. The repository is managed using
`the DUCC utility <https://github.com/cvmfs/cvmfs/tree/devel/ducc>`_.

Every container image is typically stored in two forms on CernVM-FS

1. All the unpacked layers of the image
2. The whole unpacked root filesystem of the image

Storing the layers of an image in CernVM-FS allows using (after creation) the
``docker thin images`` described in :ref:`cpt_graphdriver`, very small docker
containers that compose the image's filesystem from the layers stored in
CernVM-FS. The docker thin image can be created using the DUCC utility.

If the whole filesystem of an image is stored in the repository is possible to
run the image using ``singularity``:

::

    singularity exec /cvmfs/unpacked.cern.ch/registry.hub.docker.com/library/centos\:centos7 /bin/bash


Using unpacked.cern.ch
~~~~~~~~~~~~~~~~~~~~~~

The ``unpacked.cern.ch`` repository provides a centrally managed container
image hub without burden users with managing their CernVM-FS repositories or
conversion of images.  The repository publicly available including on lxplus,
lxbatch and on the WLCG.

To add your image to ``unpacked.cern.ch`` you can add the image name to any one
of the following two files.

1. https://gitlab.cern.ch/unpacked/sync/-/blob/master/recipe.yaml
2. https://github.com/cvmfs/images-unpacked.cern.ch/blob/master/recipe.yaml

The first file is accessible from CERN infrastructure, while the second is on
Github open to everybody.

A simple pull request against one of those files is sufficient, the image is
vetted, and the pull request merged. Soon after the pull request is merged DUCC
publishes the image to /cvmfs/unpacked.cern.ch. Depending on the size of the
image, ingesting an image in unpacked.cern.ch takes ~15 minutes.

The images are continuously checked for updates. If you push another version of
the image with the same tag, DUCC updates the image on CVMFS. Again with ~15
minutes of delay.

DUCC syntax for images
^^^^^^^^^^^^^^^^^^^^^^

The image in DUCC must be specified following a simple format. The following
examples are valid image specifications:

::

    https://registry.hub.docker.com/library/centos:latest
    https://registry.hub.docker.com/cmssw/cc8:latest
    https://gitlab-registry.cern.ch/clange/jetmetanalysis:latest

The first two refer to images in the classical docker hub, the standard
``centos`` using the latest tag and the ``cms`` version of centos8, again using
the latest tag. The third image refers to a docker image hosted on CERN GitLab
that contains the code for an analysis by a CERN user.

It is possible to use the ``*`` wildcard which acts like the ``*`` glob in the
terminal shell to specify multiple tags.

For instance:

::

    https://registry.hub.docker.com/atlas/analysisbase:21.2.1*

Is a valid image specification, and triggers conversion of all the
``atlas/analysisbase`` images whose tags start with ``21.2.1``, including:

::

    atlas/analysisbase:21.2.10
    atlas/analysisbase:21.2.100-20191127
    atlas/analysisbase:21.2.15-20180118

But **not**:

::

    atlas/analysisbase:21.3.10

Since it is 21. **3** .10 and not 21.2

The ``*`` wildcard can also be used to specify all the tags of an image, like
in this example:

::

    https://registry.hub.docker.com/pyhf/pyhf:*

All the tags of the image ``pyhf/pyhf`` that are published in the docker hub
will be published in unpacked.cern.ch.


Update images and new tags
^^^^^^^^^^^^^^^^^^^^^^^^^^

DUCC polls the docker registries continuously. As soon as a new or modified
container image is detected it starts the conversion process.


Work in progress
----------------

There are several lines of development that we are pursuing to make improve
the CernVM-FS container integration

``containerd`` remote-snapshotter plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This will allow running images from Kubernetes looking for the layers first in
CernVM-FS and if the layers are not to be found, downloading them from the
standard docker registry.


``podman`` integration
~~~~~~~~~~~~~~~~~~~~~~

Similarly to the ``containerd`` integration, this development will allow running
a standard docker image using podman fetching the layers, unpacked, from a
CernVM-FS repository. Falling back to downloading the files from the registry if
necessary.


DUCC registry interface
~~~~~~~~~~~~~~~~~~~~~~~

This development will allow for pushing the image to a special registry and
for finding the image already in the CernVM-FS repository as soon as the push
finishes. While this will results in slower push operations since the
layers need to be ingested into CernVM-FS, it will guarantee full distribution
of the image as soon as the push complete.
