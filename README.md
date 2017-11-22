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
- 'UPLOAD_DIR' the default directory where newly created vagrant boxes should be uploaded to
- `BOXES` the list of boxes to build e.g. "ubuntu1404 ubuntu1604"
- `VAGRANT_CLOUD_TOKEN` the vagrant cloud key for the nercceh account to use to register the boxes using atlas (see keepass)
- `PACKER_ARGS` Any additional arguments which should be passed to packer. This can be useful if only one box type is required:

        PACKER_ARGS="-only=vmware_iso" make build

The `all` target will `clean` and build all box types. If only one box type is required (e.g. vagrant boxes) then you
can call `make clean build-vagrant`.

### Building Amazon Machine Images(AMIs)

This is done using the amazon-ebs builder. The builder launches an ec2 instance from a source AMI and creates a new AMI from that machine. This is all done on the AWS account. The resulting artifact is stored on the AWS account.

# An example command to build an Amazon AMI
access_key=xxxxxxxx secret_key=xxxxxxxxx BOXES=ubuntu1604 PACKER_ARGS="-only=amazon-ebs" cm=ansible make clean build-ami


### Publishing Boxes

The task `make publish` will copy over any built boxes to http://dist.nerc-lancaster.ac.uk (via a san mount `UPLOAD_DIR`). The boxes
will be registered on the vagrant cloud, but not released. In order to do this, the `VAGRANT_CLOUD_TOKEN` is required to be supplied
to make as an environment variable:

    VAGRANT_TOKEN_CLOUD=my_At7a5_Ap1_k3y make clean build publish

To release the boxes, use the release target:

    VAGRANT_TOKEN_CLOUD=my_At7a5_Ap1_k3y make release

Putting this all together, if you want to build a specific box then you can be doing something like:

    BOXES=ubuntu1604 cm=puppet make clean build-vagrant

Or to build a new template on vsphere cluster:

    vsphere_username=adminla_xxx@vsphere.local vsphere_password=xxxxxxx BOXES=ubuntu1604 cm=puppet make build-vsphere

**Once the template is uploaded, currently, it's not automatically flagged as a template, so you should manually connect to the
vsphere console and mark it as such so it's not inadvertently powered up.**

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
