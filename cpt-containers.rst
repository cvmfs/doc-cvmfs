.. _cpt_containers:

==================================================
Containers images and CVMFS
==================================================

CernVM-FileSystem interacts with containers technologies in two main ways.

1. CVMFS can be mounted inside the container filesystem
2. The container filesystem can be served directly from CVMFS

Both ways have a similar goal to give users access to a reproducible
environment while retaining the advantages of CVMFS regarding data
data distribution, content deduplication and ease of operations.


Mount ``/cvmfs`` inside a container
===================================

The simplest way to access ``/cvmfs`` from inside a container is to bind-mount the ``/cvmfs`` host directory inside the container.

Using this approach will allow using small images to create a basic reproducible environment, and to access all the necessary software through ``/cvmfs``.

This is supported by all the common containers runtimes, including: 

1. Docker
2. Podman
3. Singularity
4. Kubernetes

Examples
~~~~~~~~

To bind-mount CVMFS inside a container docker, it is sufficient to use the ``--volume/-v`` flag.

For instance:

::

    docker run -it --volume /cvmfs:/cvmfs ubuntu ls -lna /cvmfs/unpacked.cern.ch 


Of course, it is also possible to limit the bind-mount to only one repository, or few repositories:

::

    $ docker run -it -v /cvmfs/alice.cern.ch:/cvmfs/alice.cern.ch \
                     -v /cvmfs/unpacked.cern.ch:/cvmfs/unpacked.cern.ch ubuntu 
    root@808d42605e97:/# ll /cvmfs/
    total 17
    drwxr-xr-x 17  125  130 4096 Nov 27  2012 alice.cern.ch/
    drwxr-xr-x  8  125  130 4096 Oct 15  2018 unpacked.cern.ch/


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
    Singularity> ll /cvmfs/unpacked.cern.ch/
    total 8
    drwxr-xr-x   8 125 130 4096 Oct 15  2018 ./
    drwxr-xr-x 186 125 130   16 Apr 17 17:10 .flat/
    drwxr-xr-x 257 125 130  116 Apr  3 13:02 .layers/
    drwxr-xr-x   4 125 130   37 Aug  1  2019 .metadata/
    drwxr-xr-x   6 125 130   24 Apr 17 15:13 gitlab-registry.cern.ch/
    drwxr-xr-x   2 125 130   40 Apr 19 21:02 logDir/
    drwxr-xr-x  21 125 130   21 Apr 16 09:18 registry.hub.docker.com/


Also in singularity is possible to use the syntax ``host_directory:container_directory`` and it is possible to mount multiple paths at the same time separating the ``--bind`` arguments with a comma.

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

However, CERN-IT has developed a `CSI-plugin <https://clouddocs.web.cern.ch/containers/tutorials/cvmfs.html#kubernetes>`_ to make simple to mount a repository inside a Kubernetes managed container. 
The plugin is distributed and available to the CERN Kubernetes managed clusters.

Use CVMFS to distribute images
==============================

Another approach is to serve the container images filesystem directly from CVMFS. 

A repository can store their images or it can leverage ``unpacked.cern.ch`` a CVMFS repository managed by CERN to host containers images from different entities and groups. 
The repository is managed using `the DUCC utility <https://github.com/cvmfs/cvmfs/tree/devel/ducc>`_.

There are two ways to store images in CVMFS:

1. Store all the (unpacked) layers of the image
2. Store the whole (unpacked) filesystem of the image

Storing the layers of an image in cvmfs allows using (after creation) the ``docker thin images`` described in :ref:`cpt_graphdriver`. 
Very small docker containers that compose the image's filesystem from the layers stored in CVMFS.	

The docker thin image can be created using the DUCC utility.

If the whole filesystem of an image is store in ``/cvmfs`` is then possible to run the image using ``singularity``.

::

    singularity exec /cvmfs/unpacked.cern.ch/registry.hub.docker.com/library/centos\:centos7 /bin/bash

Using unpacked.cern.ch
======================

``unpacked.cern.ch`` is a CVMFS repository to managed containers images in a centralized way, without burden users with managing their cvmfs repository or conversion of images.

The repository is managed inside CERN and it is available in lxplus and lxbatch and on the WLCG.

Several images from different organizations are available, but it is possible to add your images or set of images.

To add your image to ``unpacked.cern.ch`` is sufficient to add the image to one of these two files.

1. https://gitlab.cern.ch/unpacked/sync/-/blob/master/recipe.yaml
2. https://github.com/cvmfs/images-unpacked.cern.ch/blob/master/recipe.yaml

The first file is accessible from CERN infrastructure, while the second is on Github open to everybody.

A simple pull request against one of those files is sufficient, the image is vetted, and the pull request merged. 
Soon after the pull request is merged DUCC starts to work on the image. 
Depending on the size of the image, ingesting an image in unpacked.cern.ch takes ~15 minutes.

The images are continuously checked for updates. 
If you push another version of the image with the same tag, DUCC updates the image on CVMFS. 
Again with ~15 minutes of delay.

DUCC syntax for images
~~~~~~~~~~~~~~~~~~~~~~

The image in DUCC must be specified following a simple format, the following are valid image specifications:

::

    https://registry.hub.docker.com/library/centos:latest
    https://registry.hub.docker.com/cmssw/cc8:latest
    https://gitlab-registry.cern.ch/clange/jetmetanalysis:latest

The first two refer to images in the classical docker hub, the standard ``centos`` using the latest tag and the ``cms`` version of centos8, again using the latest tag.

The third image refers to a docker image hosted on CERN GitLab that contains the code for an analysis by a CERN user.

It is possible to use the ``*`` wildcard which acts as the ``*`` glob in the terminal shell to specify multiple tags.

For instance:

::

    https://registry.hub.docker.com/atlas/analysisbase:21.2.1*

Is a valid image specification, and require that all the ``atlas/analysisbase`` images which tags start with ``21.2.1`` are ingested inside unpacked.cern.ch this will include:

::

    atlas/analysisbase:21.2.10
    atlas/analysisbase:21.2.100-20191127
    atlas/analysisbase:21.2.15-20180118

But **not**:

::

    atlas/analysisbase:21.3.10

Since it is 21. **3** .10 and not 21.2

The ``*`` wildcard can also be used to specify all the tags of an image, like in this case:

::

    https://registry.hub.docker.com/pyhf/pyhf:*

All the tags of the image ``pyhf/pyhf`` that are published in the docker hub will eventually get ingested in unpacked.cern.ch.

DUCC repository structure
~~~~~~~~~~~~~~~~~~~~~~~~~

DUCC exposes to the users only the directory that contains the whole unpacked filesystem of an image.
Those directories contain only links to hidden directories where the content is stored.

Other hidden directories stores the single unpacked layers and metadata information about the image and the repository.

Update images and new tags
~~~~~~~~~~~~~~~~~~~~~~~~~~

DUCC polls the docker registries continuously. As soon as a new container image is detected it starts the conversion process.

It is possible to overwrite an image, pushing an image with the identical tag (for instance the ``latest`` tag). 
The symbolic link in the public directory is moved to point to the new image, but the old image is not deleted.

Work in progress
================

There are several lines of development that we are pursuing to make simpler to use containers served by CVMFS

``containerd`` remote-snapshotter plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This will allow running images from Kubernetes looking for the layers first in CVMFS and if the layers are not to be found, downloading them from the standard docker registry.

``podman`` integration
~~~~~~~~~~~~~~~~~~~~~~

Similarly to the ``containerd`` integration, this development will allow running a standard docker image using podman fetching the layers, unpacked, from a CVMFS repository. Falling back to downloading the files from the registry if necessary.

DUCC registry interface
~~~~~~~~~~~~~~~~~~~~~~~

This development will allow to push the image to a special registry and find the image already in the CVMFS repository as soon as the push finish. Of course, this will mean slower push operations since the layers need to be ingested into CVMFS, but it will guarantee full distribution of the image as soon as the push complete.
