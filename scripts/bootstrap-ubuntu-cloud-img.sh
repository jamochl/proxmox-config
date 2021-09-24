#!/bin/bash
source libraries/cimgsetup.sh

IMAGE_URL="https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
VM_NUM="$(cimgsetup::first_available_template)"
DISK_IMAGE="ubuntu2004-cloudimg-$(date '+%Y%m%d')-amd64-kvm.img"
VM_NAME="ubuntu-2004-cloud-img"

cimgsetup::run "$IMAGE_URL" "$VM_NUM" "$DISK_IMAGE" "$VM_NAME"
