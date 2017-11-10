#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing VMware Tools"
    cd /tmp

    NEXT_WAIT_TIME=0
    echo "==> Cloning VMware Tools patch repository from GitHub"
    until git clone https://github.com/rasa/vmware-tools-patches.git || [ $NEXT_WAIT_TIME -eq 5 ]; do
        echo "==> Git clone of vmware-tools-patches failed, retrying..."
        sleep $(( NEXT_WAIT_TIME++ ))
    done

    if [ -d "vmware-tools-patches" ]; then
        echo "==> Patching VMware Tools before compilation"
        cd vmware-tools-patches
        ./download-tools.sh $VMWARE_TOOLS_VERSION
        ./untar-and-patch.sh
        ./compile.sh
        cd /tmp
        rm -rf /tmp/vmware-tools-patches
    fi

    VMWARE_TOOLBOX_CMD_VERSION=$(vmware-toolbox-cmd -v)
    echo "==> Installed VMware Tools ${VMWARE_TOOLBOX_CMD_VERSION}"

    if [[ "$VMWARE_RESTART_AFTER_INSTALL" == true ]]; then
        echo "==> Restarting to enable VMware tools"
        # Recompile when the kernel is updated
        # Make sure the kernel module is loaded at boot
        echo "answer AUTO_KMODS_ENABLED yes" >> /etc/vmware-tools/locations
        echo "vmhgfs" > /etc/modules-load.d/vmware.conf
    fi
fi
