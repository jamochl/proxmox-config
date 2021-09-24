#!/bin/bash
source libraries/cloud_img_functions.sh

IMAGE_URL="https://gitlab.archlinux.org/archlinux/arch-boxes/-/jobs/34904/artifacts/raw/output/Arch-Linux-x86_64-cloudimg-20210923.0.qcow2"
VM_NUM="$(fn_first_available_template)"
DISK_IMAGE="archlinux-20210923-amd64-kvm.img"
VM_NAME="archlinux-20210923-cloud-img"

fn_main "$IMAGE_URL" "$VM_NUM" "$DISK_IMAGE" "$VM_NAME"
