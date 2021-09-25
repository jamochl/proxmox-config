#!/bin/bash -e
source libraries/cimgsetup.sh

IMAGE_URL="https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"
VM_NUM="$(cimgsetup::first_available_template)"
DISK_IMAGE="almalinux8-cloudimg-$(date '+%Y%m%d')-amd64-kvm.img"
VM_NAME="almalinux-8-cloud-img"

cimgsetup::run "$IMAGE_URL" "$VM_NUM" "$DISK_IMAGE" "$VM_NAME"
