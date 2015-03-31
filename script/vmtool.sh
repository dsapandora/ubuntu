#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing VMware Tools"
    # Assuming the following packages are installed
    # apt-get install -y linux-headers-$(uname -r) build-essential perl

    cd /tmp

    # Get VMware Tools patches to fix any kernel incompatabilities
    apt-get install -y unzip

    NEXT_WAIT_TIME=0
    echo "==> Cloning VMware Tools patch repository from GitHub"
    until git clone https://github.com/rasa/vmware-tools-patches.git || [ $NEXT_WAIT_TIME -eq 5 ]; do
        echo "==> Git clone of vmware-tools-patches failed, retrying..."
        sleep $(( NEXT_WAIT_TIME++ ))
    done

    if [ -d "vmware-tools-patches" ]; then
        echo "==> Patching VMware Tools before compilation"
        cd vmware-tools-patches
        #TODO: Abstract out tools version number
        ./download-tools.sh 7.1.1
        ./untar-and-patch.sh
        ./compile.sh
        cd /tmp
        rm -rf /tmp/vmware-tools-patches
    fi
fi

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "==> Installing VirtualBox guest additions"
    # Assuming the following packages are installed
    # apt-get install -y linux-headers-$(uname -r) build-essential perl
    # apt-get install -y dkms

    VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
    mount -o loop /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/${SSH_USER}/.vbox_version

    if [[ $VBOX_VERSION = "4.3.10" ]]; then
        ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    fi
fi

if [[ $PACKER_BUILDER_TYPE =~ parallels ]]; then
    echo "==> Installing Parallels tools"

    mount -o loop /home/${SSH_USER}/prl-tools-lin.iso /mnt
    /mnt/install --install-unattended-with-deps
    umount /mnt
    rm -rf /home/${SSH_USER}/prl-tools-lin.iso
    rm -f /home/${SSH_USER}/.prlctl_version
fi
