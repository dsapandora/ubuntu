# Packer templates for Ubuntu

### Overview

This repository contains [Packer](https://packer.io/) templates for creating Ubuntu Vagrant and ESXi boxes.

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
- `BOXES` the list of boxes to build e.g. "ubuntu1404 ubuntu1604"

The `all` target will `clean` and build all box types. If only one box type is required (e.g. vagrant boxes) then you 
can call `make clean build-vagrant`.

Putting this all together, if you want to build a specific box then you can be doing something like:

    BOXES=ubuntu1604 cm=puppet make clean build-vagrant

### Acknowledgments

- [Boxcutter Ubuntu](https://github.com/boxcutter/ubuntu) The project which this one is heavily based upon.