#!/bin/bash
####################################
# Developed by Ron Negrov
# Purpose: A lib file that contains all relevant functions.
# Date: 14/2/2025
# Version: 0.0.1
####################################

# Function to create a log file
function create_log_file() {
    local log_file="$1"
    touch "$log_file" && echo "Log file $log_file was created"
}

# Function to check if a package is installed
function check_package() {
    local package="$1"
    dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"
}

# Function to install a package if it's not installed
function check_and_install() {
    local software_name="$1"
    local logfile="$2"

    if ! check_package "$software_name"; then  # If package is NOT installed
        echo "Installing $software_name..." | tee -a "$logfile"
        if apt install -y "$software_name" >> "$logfile" 2>&1; then
            echo "$software_name installed successfully [+]" | tee -a "$logfile"
        else
            echo "Failed to install $software_name [-]" | tee -a "$logfile"
        fi
    else
        echo "$software_name already exists, skipping installation [-]" | tee -a "$logfile"
    fi
}
