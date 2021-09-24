# Common functions for use in setting up cloud images

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
    local IMAGE_URL="$1"
    local DISK_IMAGE="$2"
    wget --tries=30 --no-clobber "${IMAGE_URL}" --output-document "${DISK_IMAGE}"
}

fn_create_vm() {
    local VM_NUM="$1"
    local DISK_IMAGE="$2"
    local VM_NAME="$3"

    # create a new vm
    qm create "${VM_NUM}" --memory 2048 --net0 virtio,bridge=vmbr0 -name "${VM_NAME}"

    # import the downloaded disk to local-lvm storage
    qm importdisk "${VM_NUM}" "${DISK_IMAGE}" local-lvm

    # Attach new disk to VM as scsi
    qm set "${VM_NUM}" --scsihw virtio-scsi-pci --scsi0 "local-lvm:vm-${VM_NUM}-disk-0"

    # Set boot drive and display
    qm set "${VM_NUM}" --boot c --bootdisk scsi0 --serial0 socket --vga serial0
}