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

By default, the `make publish` task will upload boxes to *dist.nerc-lancaster.ac.uk* using the **automaton** user. The automaton
user does not have a password, as such an `DIST_RSA` file can be specified to enable public/private key authentication. The `DIST_USER`
can also be adjusted to enable rsyncing as a different user.

Putting this all together, if you want to build a specific box then you can be doing something like:

    BOXES=ubuntu1604 cm=puppet make clean build-vagrant

The `CHANGELOG.md` is used for describing a version of a box. So keep this up to date with the main features/improvements/bugfixes
for the current release.

### Release Management

The `VERSION` file contains the version number which is currently being worked on. You can use the `bin/bump.sh` script to
sign off on a version and start work on a new major/minor/patch version. You can also use this script to tag the repository
with the completed version number.

You can execute the `make release` task. This will:

1. Perform an atlas release for all of the boxes which have been built at the current version
2. Tag the current branch with the latest number
3. Increase the working version number by one patch point
4. Create an entry in the CHANGELOG.md for the new version

### Acknowledgments

- [Boxcutter Ubuntu](https://github.com/boxcutter/ubuntu) The project which this one is heavily based upon.
