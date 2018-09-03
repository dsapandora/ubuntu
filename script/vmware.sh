#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing Open VM Tools"
    # Install open-vm-tools so we can mount shared folders
    apt-get install -y open-vm-tools
    # Install open-vm-tools-desktop so we can copy/paste, resize, etc.
    if [[ "$DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
        apt-get install -y open-vm-tools-desktop
    fi
    # Add /mnt/hgfs so the mount works automatically with Vagrant
    mkdir /mnt/hgfs
fi
