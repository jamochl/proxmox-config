#!/bin/bash
source libraries/cloud_img_functions.sh

fn_main() {
    IMAGE_URL="https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
    VM_NUM="$(fn_first_available_template)"
    DISK_IMAGE="ubuntu2004-cloudimg-$(date '+%Y%m%d')-amd64-kvm.img"
    VM_NAME="ubuntu-2004-cloud-img"
    fn_download_image "$IMAGE_URL" "$DISK_IMAGE"
    fn_create_vm "$VM_NUM" "$DISK_IMAGE" "$VM_NAME"
}

fn_main
