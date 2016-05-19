# Packer templates for Ubuntu

### Overview

This repository contains [Packer](https://packer.io/) templates for creating Ubuntu Vagrant and vSphere boxes.

Building of boxes is driven from the supplied `Makefile`. The build supports customisation via environment
variables. By default the boxes built will contain the latest version of [Puppet](https://puppet.com).

### Building Boxes

To build everything simply execute `make`. This will build all boxes with default configuration. Some aspects of the boxes can be
configured at make time with environment variables.

The supported variables are:

- `cm` Configuration management software to install
- `cm_version` Configuration management software version
- `headless` if the boxes should be built showing the hypervisor gui
- `version` The version number to label this box with
- `vsphere_username` The username to use when uploading a vsphere box
- `vsphere_password` The password to use when uploading a vsphere box
- `BOXES` the list of boxes to build e.g. "ubuntu1404 ubuntu1604"
- `ATLAS_TOKEN` the atlas key for the nercceh account to use to register the boxes using atlas
- `PACKER_ARGS` Any additional arguments which should be passed to packer. This can be useful if only one box type is required:

        PACKER_ARGS="-only=vmware_iso" make build

The `all` target will `clean` and build all box types. If only one box type is required (e.g. vagrant boxes) then you 
can call `make clean build-vagrant`.

### Publishing Boxes

The task `make publish` will copy over any built boxes to the http://dist.nerc-lancaster.ac.uk. If the metadata for the box
has been defined in the **atlas.json** file then the boxes will be registered on the atlas cloud. In order to do this, the
`ATLAS_TOKEN` is required to be supplied to make as an environment variable:

    ATLAS_TOKEN=my_At7a5_Ap1_k3y make clean build publish

**N.B the box will be registered in an unreleased state. You will have to log in to atlas cloud in order to release**

Putting this all together, if you want to build a specific box then you can be doing something like:

    BOXES=ubuntu1604 cm=puppet make clean build-vagrant

### Acknowledgments

- [Boxcutter Ubuntu](https://github.com/boxcutter/ubuntu) The project which this one is heavily based upon.