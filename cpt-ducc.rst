.. _cpt_ducc:

==================================================
Working with DUCC and Docker Images (Experimental)
==================================================

DUCC (Daemon that Unpacks Container Images into CernVM-FS) helps in publishing
container images in CernVM-FS. The daemon publishes images in their extracted
form in order for clients to benefit from CernVM-FS' on-demand loading of files.
The DUCC service is deployed as an extra package and supposed to be co-located
with a publisher node having the ``cvmfs-server`` package installed.

Converted images are usable with Docker through the :ref:`CernVM-FS docker graph
driver <cpt_graphdriver>` and with container engines that can use a flat root
file system from CernVM-FS such as Singularity and runc. For use with Docker,
DUCC will upload a so-called "thin image" to the registry for every converted
image. Only the thin image makes an image available through CernVM-FS.

Vocabulary
==========

The following section introduces the terms used in the context of DUCC
publishing container images.

**Registry** A Docker image registry such as:

* https://registry.hub.docker.com
* https://gitlab-registry.cern.ch

**Image Repository** This specifies a group of images. Each image in an image
repository is addressed by tag or by digest. Examples are:

* library/redis
* library/ubuntu

The term **image repository** is unrelated to a CernVM-FS repository.

**Image Tag** An image tag identifies an image inside an image repository.
Tags are mutable and may refer to different container images over time.
Examples are:

* 4
* 3-alpine

**Image Digest** A digest is an immutable identifier for a container image.
Digests are calculated based on the result of a hash function to the content of
the image. Examples are:

* sha256:2aa24e8248d5c6483c99b6ce5e905040474c424965ec866f7decd87cb316b541
* sha256:d582aa10c3355604d4133d6ff3530a35571bd95f97aadc5623355e66d92b6d2c


To uniquely identify an image, we need to provide:
1. registry
2. image repository
3. image tag or image digest (or both)

We use a slash (`/`) to separate the `registry` from the `repository`, a
colon (`:`) to separate the `repository` from the `tag` and the at (`@`) to
separate the `digest` from the tag or from the `repository`.  The syntax is

::

    REGISTRY/REPOSITORY[:TAG][@DIGEST]

Examples of fully identified images are:

* https://registry.hub.docker.com/library/redis:4
* https://registry.hub.docker.com/minio/minio@sha256:b1e5dd4a7be831107822243a0675ceb5eabe124356a9815f2519fe02beb3f167
* https://registry.hub.docker.com/wurstmeister/kafka:1.1.0@sha256:3a63b48894bce633fb2f0d2579e162163367113d79ea12ca296120e90952b463


**Thin Image** A Docker image that contains only a reference to the image
contents in CernVM-FS. Requires the CernVM-FS Docker graph driver in order to
start.


Image Wish List
=================

The user specifices the set of images supposed to be published on CernVM-FS
in the form of a wish list. The wish list consists of triplets of input image,
the output thin image and the cvmfs destination repository for the unpacked
data.

::

    wish => (input_image, output_thin_image, cvmfs_repository)

The input image in your wish should unambigously specify an image as decribed
above.


Wish List Syntax v1
********************

The wish list is provided as YAML file. An example of a wish list containing
four images is show below.

::

    version: 1
    user: smosciat
    cvmfs_repo: unpacked.cern.ch
    output_format: '$(scheme)://registry.gitlab.cern.ch/thin/$(image)'
    input:
        - 'https://registry.hub.docker.com/econtal/numpy-mkl:latest'
        - 'https://registry.hub.docker.com/agladstein/simprily:version1'
        - 'https://registry.hub.docker.com/library/fedora:latest'
        - 'https://registry.hub.docker.com/library/debian:stable'

**version**: wish list version; at the moment only `1` is supported.

**user**: the account that will push the thin images into the docker registry.
The password must be stored in the ``DOCKER2CVMFS_DOCKER_REGISTRY_PASS``
environment variable.

**cvmfs_repo**: the target CernVM-FS repository to store the layers and the
flat root file systems.

**output_format**: how to name the thin images. It accepts a few variables that
refer to the input image.

* $(scheme), the image url protocol, most likely `http` or `https`

* $(registry), the Docker registry of the input image, in the case of the
  example it would be `registry.hub.docker.com`

* $(repository), the image repository of the input image, like
  `library/ubuntu` or `atlas/athena`

* $(tag), the tag of the image, which could be `latest`, `stable` or
  `v0.1.4`

* $(image), combines $(repository) and $(tag)

**input**: list of docker images to convert

The current wish list format requires all the images to be stored in the same
CernVM-FS repository and have the same thin output image format.

DUCC Commands
=============

DUCC supports the following commands.

convert
*******

The `convert` command provides the core functionality of DUCC:

::

    ducc convert wishlist.yaml


where `wishlist.yaml` is the path of a wish list file.

This command will try to ingest all the specified images into CernVM-FS.

The process consists of downloading the manifest of the image, downloading
and ingesting the layers that compose each image, uploading the thin image,
creating the flat root file system necessary to work with Singularity and
writing DUCC specific metadata in the CernVM-FS repository next to the unpacked
image data.

The layers are stored in the `.layer` subdirectory in the CernVM-FS repository,
while the flat root file systems are stored in the `.flat` subdirectory.

loop
****

The `loop` command continously executes the `convert` command. On each
iteration, the wish list file is read again in order to pick up changes.

::

    ducc loop recipe.yaml



Incremental Conversion
======================

The `convert` command will extract image contents into CernVM-FS only where
necessary. In general, some parts of the wish list will be already converted
while others will need to be converted ex-novo.

An image that has been already unpacked in CernVM-FS will be skipped. For
unconverted images, only the missing layers will be unpacked.

