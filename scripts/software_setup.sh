#! /usr/bin/env bash
######################################
# Developed by Ron Negrov
# Purpose: A script that automatically installs all required software.
# Date: 12/2/2025
# Version: 0.0.1
source /opt/scripts/configlib.sh
 source "$CONFIG_FILE"
######################################

software_logfile="/var/log/software_setup.log"
create_log_file "$software_logfile"
echo "###- Starting software installation -###" | tee -a "$software_logfile"
for index in "${programs[@]}"; do
    check_and_install "$index" "$software_logfile"
done
