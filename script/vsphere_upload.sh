#!/bin/bash
###
# N.B There is a long standing issue with the vSphere post-processor of packer
# (https://github.com/mitchellh/packer/pull/3321) which means that variables are 
# ""double quoted"", resulting in paths which can not be uploaded to.
#
# This script implements the desired functionality. This script can be replaced with
# native packer functionality once mitchellh/packer#3321 has been merged and released
###

# A url encoding function which takes a string and returns a url encoded
# representation. See http://stackoverflow.com/a/10660730
e() {
  local string="$@"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo ${encoded}    # You can either set a return variable (FASTER) 
}

# Check if the extension of the passed in filename is vmx. If so, lets upload to vSphere
if [ "${1##*.}" == 'vmx' ]; then
  echo '==> Located vmx file. Uploading to vSphere'
  ovftool                    \
    --overwrite              \
    --noSSLVerify=true       \
    --acceptAllEulas         \
    --name="$vm_name"        \
    --network="$vm_network"  \
    --datastore="$datastore" \
    --vmFolder="$vm_folder"  \
    $1 "vi://`e $vsphere_username`:`e $vsphere_password`@`e $host`/`e $datacenter`/host/`e $cluster`"
fi
