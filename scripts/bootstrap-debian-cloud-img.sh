#!/bin/bash
source libraries/cloud_img_functions.sh

IMAGE_URL="https://cloud.debian.org/images/cloud/bullseye/daily/latest/debian-11-generic-amd64-daily.qcow2"
VM_NUM="$(fn_first_available_template)"
DISK_IMAGE="debian11-cloudimg-$(date '+%Y%m%d')-amd64-kvm.img"
VM_NAME="debian-11-cloud-img"

fn_main "$IMAGE_URL" "$VM_NUM" "$DISK_IMAGE" "$VM_NAME"
