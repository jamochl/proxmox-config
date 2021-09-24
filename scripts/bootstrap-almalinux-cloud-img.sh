#!/bin/bash
source libraries/cloud_img_functions.sh

IMAGE_URL="https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"
VM_NUM="$(fn.first_available_template)"
DISK_IMAGE="almalinux8-cloudimg-$(date '+%Y%m%d')-amd64-kvm.img"
VM_NAME="almalinux-8-cloud-img"

fn.main "$IMAGE_URL" "$VM_NUM" "$DISK_IMAGE" "$VM_NAME"
