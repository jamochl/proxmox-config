# Common functions for use in setting up cloud images

# From 9000
fn_first_available_template() {
    local num=9000

    set -e

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

fn_download_image() (
    local IMAGE_URL="$1"
    local DISK_IMAGE="$2"

    set -e 

    wget --tries=30 --no-clobber "${IMAGE_URL}" --output-document "${DISK_IMAGE}"
)

fn_create_vm() (
    local VM_NUM="$1"
    local DISK_IMAGE="$2"
    local VM_NAME="$3"

    set -e

    # create a new vm
    qm create "${VM_NUM}" --memory 2048 --net0 virtio,bridge=vmbr0 -name "${VM_NAME}"

    # import the downloaded disk to local-lvm storage
    qm importdisk "${VM_NUM}" "${DISK_IMAGE}" local-lvm

    # Attach new disk to VM as scsi
    qm set "${VM_NUM}" --scsihw virtio-scsi-pci --scsi0 "local-lvm:vm-${VM_NUM}-disk-0"

    # Set boot drive and display
    qm set "${VM_NUM}" --boot c --bootdisk scsi0 --serial0 socket --vga serial0
)

fn_delete_vm() (
    local VM_NUM="$1"

    qm destroy ${VM_NUM} --purge true
)

fn_main() {
    local IMAGE_URL="$1"
    local VM_NUM="$2"
    local DISK_IMAGE="$3"
    local VM_NAME="$4"

    fn_download_image "$IMAGE_URL" "$DISK_IMAGE"
    fn_create_vm "$VM_NUM" "$DISK_IMAGE" "$VM_NAME"
    if [[ $? -eq 0 ]]; then
        echo "Cloud Image setup successful"
    else
        echo "Something went wrong, Deleting VM $VM_NUM"
        fn_delete_vm "$VM_NUM"
    fi
}

