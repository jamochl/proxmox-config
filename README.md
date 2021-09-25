# Proxmox Config

Configuration and Script files used to automate the install and
configuration of Proxmox

* System Setup (TODO)
* User Setup (TODO)
* Cloud image Initialisation (Working)

# Requirements

```bash
apt install jq
```

# Instructions

```
cd scripts/
./bootstrap-{{ distro }}-cloud-img.sh
```

# How it works

* Downloads the latest cloud image
* Checks for existing cloud image templates (vmid >= 9000)
* Installs cloud image in the first available vmid >= 9000
* If fails
    * delete broken image
* Else
    * Remove old templates of the same name (Done for Terraform)
