#!/bin/bash
echo "### Running system setup scripts ###"

sudo -v

# Run the scripts from /opt/scripts as sudo
[[ -x /opt/scripts/configmount.sh ]] && sudo bash /opt/scripts/configmount.sh
sudo umount /mnt/config_disk
echo "### System setup completed successfully ###"

