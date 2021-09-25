# Common functions for use in setting up cloud images

# From 9000
cimgsetup::first_available_template() {
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

cimgsetup::download_image() (
    local image_url="$1"
    local disk_path="$2"

    set -e 

    mkdir --parents "$(dirname $2)"
    wget --tries=30 --no-clobber "${image_url}" --output-document "${disk_path}"
)

cimgsetup::create_vm() (
    local vm_num="$1"
    local disk_path="$2"
    local vm_name="$3"

    set -e

    # create a new vm
    qm create "${vm_num}" --memory 2048 --net0 virtio,bridge=vmbr0 -name "${vm_name}"

    # import the downloaded disk to local-lvm storage
    qm importdisk "${vm_num}" "${disk_path}" local-lvm

    # Attach new disk to VM as scsi
    qm set "${vm_num}" --scsihw virtio-scsi-pci --scsi0 "local-lvm:vm-${vm_num}-disk-0"

    # Set boot drive and display
    qm set "${vm_num}" --boot c --bootdisk scsi0 --serial0 socket --vga serial0
)

cimgsetup::delete_vm() (
    local vm_num="$1"

    qm destroy ${vm_num} --purge true
)

cimgsetup::check_existing_vm() (
    local cloud_vm_name=$1
    local current_node="$(pvesh get /nodes --output-format json | jq --raw-output '.[0].node')"
    pvesh get "/nodes/${current_node}/qemu" --output-format json | jq --raw-output ".[] | select(.vmid >= 9000) | select(.name == '${cloud_vm_name}').vmid"
)

cimgsetup::run() {
    local IMAGE_URL="$1"
    local VM_NUM="$2"
    local DISK_IMAGE="$3"
    local DISK_PATH="/root/cloud_images/$DISK_IMAGE"
    local VM_NAME="$4"
    local EXISTING_VM="$(cimgsetup::check_existing_vm $VM_NAME)"

    cimgsetup::download_image "$IMAGE_URL" "$DISK_PATH"
    if cimgsetup::create_vm "$VM_NUM" "$DISK_PATH" "$VM_NAME"; then
        echo "Cloud Image setup successful"
        if [[ -n EXISTING_VM ]]; then
            cimgsetup::delete_vm "$EXISTING_VM"
            echo "Deleted existing VM $EXISTING_VM"
        fi
    else
        echo "Something went wrong, Deleting VM $VM_NUM"
        cimgsetup::delete_vm "$VM_NUM"
    fi
}
