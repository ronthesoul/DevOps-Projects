#! /bin/bash
###############################
# Developed by Ron Negrov
# Purpose: Mount the configuration file as a mounted disk.
# Date: 13/2/2025
# Version: 0.0.11
source "/opt/scripts/configlib.sh"
##############################

# The main function, searches for an available block device, declares it, and prepares the mount location and log file.
function main(){
    disk_name=$(lsblk -nra -o NAME,TYPE,MOUNTPOINT | grep -Ev 'sda|SWAP|disk|loop|sr0|ubuntu' | awk '{print $1}' | head -n 1)
    disk_path="/dev/$disk_name"
    mount_log_file="/var/log/configmount.log"
    new_mounted_file="/mnt/config_disk"

    create_log_file "$mount_log_file"
    check_if_diskname_exists "$disk_name" "$mount_log_file" || exit 1
    create_mount "$new_mounted_file"
    mount_disk "$disk_name" "$disk_path" "$new_mounted_file" "$mount_log_file" || exit 1
    search_config_file "$new_mounted_file" "$mount_log_file" || exit 1
}

# A function that checks if a relevant block device was found (parameters: disk name, log file name).
function check_if_diskname_exists(){
    local check_disk_name="$1"
    local check_log_file="$2"

    if [[ -z "$check_disk_name" ]]; then
        echo "No valid disk was found." | tee -a "$check_log_file"
        return 1
    else
        echo "Disk found: $check_disk_name." | tee -a "$check_log_file"
    fi
}

# A function that creates the mount directory (parameter: mount path).
function create_mount(){
    local mounted_disk="$1"
    mkdir -p "$mounted_disk"
}

# A function that mounts the disk (parameters: disk name, disk path, mount location, log file).
function mount_disk(){
    local old_disk_name="$1"
    local old_disk_path="$2"
    local new_mounted_disk="$3"
    local local_log_file="$4"

    if mount "$old_disk_path" "$new_mounted_disk"; then
        echo "The disk $old_disk_name was successfully mounted to $new_mounted_disk." | tee -a "$local_log_file"
    else
        echo "Failed to mount $old_disk_name." | tee -a "$local_log_file"
        return 1
    fi
}

# A function that searches for the config file in the mounted location (parameters: mount path, log file).
function search_config_file(){
    local search_mounted_disk="$1"
    local search_log_file="$2"

     CONFIG_NAME="$(ls $search_mounted_disk | grep -E '*config.cfg*' | head -n 1)"
	export CONFIG_FILE="$search_mounted_disk/$CONFIG_NAME"

    if [[ -n "$CONFIG_FILE" && -f "$CONFIG_FILE" ]]; then
        echo "Config file found: $CONFIG_FILE" | tee -a "$search_log_file"
        sed -i 's/\r$//' "$CONFIG_FILE"
        source "$CONFIG_FILE"
    else
        echo "No valid config file found in $search_mounted_disk" | tee -a "$search_log_file"
        return 1
    fi
}

main
bash /opt/scripts/software_setup.sh
bash /opt/scripts/confighost.sh
wait
