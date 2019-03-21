.. _cpt_ducc:

===================================
Working with DUCC and docker images
===================================

DUCC (Daemon for Unpacking Containers in CernVM-FS) helps in ingesting container
images into CernVM-FS.

Requirements
============

* DUCC is distributed as a simple binary. It publish images into CernVM-FS,
  hence is necessary to execute it in a machine that can publish files into a
  Stratum-0.

Vocabulary
==========

There are several concepts to keep track of in the process of ingesting
containers images into CernVM-FS. and none of those concepts are common. Hence
we believe is usefull to agree on a shared vocabulary.

**Registry** does refer to the docker image registry, with protocol extensions,
common examples are:

* https://registry.hub.docker.com 
* https://gitlab-registry.cern.ch

**Repository** This specifies a class of images, each image will be indexed,
then by tag or digest. Common examples are:
* library/redis 
* library/ubuntu

**Tag** is a way to identify an image inside a repository, tags are mutable and
may change in a feature. Common examples are:
* 4 
* 3-alpine

**Digest** is another way to identify images inside a repository, digests are
**immutable**, since they are the result of a hash function to the content of
the image. Thanks to this technique the images are content addressable.  Common
examples are:
* sha256:2aa24e8248d5c6483c99b6ce5e905040474c424965ec866f7decd87cb316b541 
* sha256:d582aa10c3355604d4133d6ff3530a35571bd95f97aadc5623355e66d92b6d2c


An **image** belongs to a repository -- which in turns belongs to a registry --
and it is identified by a tag, or a digest or both, if you can choose is always
better to identify the image using at least the digest.

To unique identify an image so we need to provide all those information:
1. registry 
2. repository 
3. tag or digest or tag + digest

We will use slash (`/`) to separate the `registry` from the `repository` and the
colon (`/`) to separate the `repository` from the `tag` and the at (`@`) to
separate the `digest` from the tag or from the `repository`.

The final syntax will be:

    REGISTRY/REPOSITORY[:TAG][@DIGEST]

Examples of images are: 
* https://registry.hub.docker.com/library/redis:4 
* https://registry.hub.docker.com/minio/minio@sha256:b1e5dd4a7be831107822243a0675ceb5eabe124356a9815f2519fe02beb3f167
* https://registry.hub.docker.com/wurstmeister/kafka:1.1.0@sha256:3a63b48894bce633fb2f0d2579e162163367113d79ea12ca296120e90952b463


Concepts
========

DUCC follows a declarative approach. The user specify what is the end goal, and
DUCC tries to reach it.

The main component of this approach is the **wish** which is a triplet
composed by the input image, the output image and in which cvmfs repository you
want to store the data.

    wish => (input_image, output_image, cvmfs_repository)

The input image in your wish should be as more specific as possible,
ideally specifying both the tag and the digest.

Recipes
=======

Recipes are a way to describe the wishes that we want to convert.

Recipe Syntax v1
****************

An example of recipe is show below.

``` yaml
version: 1
user: smosciat
cvmfs_repo: unpacked.cern.ch
output_format: '$(scheme)://registry.gitlab.cern.ch/thin/$(image)'
input:
        - 'https://registry.hub.docker.com/econtal/numpy-mkl:latest'
        - 'https://registry.hub.docker.com/agladstein/simprily:version1'
        - 'https://registry.hub.docker.com/library/fedora:latest'
        - 'https://registry.hub.docker.com/library/debian:stable'
```

**version**: indicate what version of recipe we are using, at the moment only
`1` is supported.  

**user**: the user that will push the thin docker images into
the registry, the password must be stored in the
`DOCKER2CVMFS_DOCKER_REGISTRY_PASS` environment variable.  

**cvmfs_repo**: in
which CVMFS repository store the layers and the singularity images.


**output_format**: how to name the thin images. It accepts few "variables" that
reference to the input image.

* $(scheme), the very first part of the image url, most likely `http` or `https`

* $(registry), in which registry the image is locate, in the case of the example
  it would be `registry.hub.docker.com`

* $(repository), the repository of the input image, so something like
  `library/ubuntu` or `atlas/athena`

* $(tag), the tag of the image examples could be `latest` or `stable` or
  `v0.1.4`

* $(image), the $(repository) plus the $(tag)

**input**: list of docker images to convert

This recipe format allow to specify only some wish, specifically all the images
need to be stored in the same CVMFS repository and have the same format.

Commands
========

DUCC supports several commands.

convert
*******

The syntax of the `convert` command is the following

```
ducc convert recipe.yaml
```

where `recipe.yaml` is the path of a recipe file.

This command will try to ingest all the images into CernVM-FS.

The process consist in downloading the manifest of the image, then it downloads
and ingests the layers that compose each image, then we create the flat root
file system necessary to work with Singularity and finally we write metadata
inside the repository itself.

loop
****

The syntax of the `loop` command is the following

```
ducc loop recipe.yaml
```

The `loop` comman will simply execute the `convert` command in a loop. For each
iteration, the recipe file is read again, so changes are picked up.


Convert workflow
================

The goal of convert is to actually create the thin images starting from the
regular one.

In order to convert we iterate for every wish in the recipe.

In general, some wish will be already converted while others will need to be
converted ex-novo.

The first step is then to check if the wish is already been converted.  In order
to do this check, we download the input image manifest and check in the
repository if the specific image is been already converted, if it is we safely
skip such conversion.

Then, every image is made of different layers, some of them could already be on
the repository.  In order to avoid expensive CVMFS transaction, before to
download and ingest the layer we check if it is already in the repository, if it
is we do not download nor ingest the layer.

The conversion simply ingest every layer in an image, create a thin image and
finally push the thin image to the registry.

Such images can be used by docker with the  thin image plugins.

The daemon also transform the images into singularity images and store them into
the repository.

The layers are stored into the `.layer` subdirectory, while the singularity
images are stored in the `.singularity` subdirectory.

