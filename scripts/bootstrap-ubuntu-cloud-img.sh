#!/bin/bash

# From 9000
fn_first_available_template() {
    local num=9000
    for vm_id in \
        $(qm list | awk '{print $1}' | grep --perl-regexp '9\d{3}')
    do
        if [[ $num -eq $vm_id ]]; then
            num=$(($num + 1)) 
        else
            break
        fi
    done
    unset vm_id
    echo "$num"
}

fn_download_image() {
    wget --tries=30 --no-clobber https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img --output-document ${DISK_IMAGE}
}

fn_create_vm() {
    # create a new vm
    qm create "${VM_NUM}" --memory 2048 --net0 virtio,bridge=vmbr0 -name "ubuntu-2004-cloud-img"

    # import the downloaded disk to local-lvm storage
    qm importdisk "${VM_NUM}" "${DISK_IMAGE}" local-lvm

    # Attach new disk to VM as scsi
    qm set "${VM_NUM}" --scsihw virtio-scsi-pci --scsi0 "local-lvm:vm-${VM_NUM}-disk-0"

    # Set boot drive and display
    qm set "${VM_NUM}" --boot c --bootdisk scsi0 --serial0 socket --vga serial0
}

fn_main() {
    DISK_IMAGE="ubuntu2004-cloudimg-$(date '+%Y%m%d')-amd64-kvm.img"
    VM_NUM="$(fn_first_available_template)"
    fn_download_image
    fn_create_vm
}

fn_main
