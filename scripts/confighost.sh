#!/usr/bin/env bash
####################################
#Developed by Ron Negrov
#Purpose: takes the configuration file for input and accordingly configures the system
#Date: 13/2/2025
#Version: 0.0.6
 source "/opt/scripts/configlib.sh"
 source "$CONFIG_FILE"
####################################

hostcfg_log_file="/var/log/confighost.log"
create_log_file "$hostcfg_log_file"

# User Configurations
useradd -m -s "$user_shell" -G "$user_groups" -c "$displayname, $department, $role, $email, $phone, $office_location" "$username" 2>&1 | tee -a "$hostcfg_log_file"
echo "$username:$user_password" | chpasswd 2>&1 | tee -a "$hostcfg_log_file"

# Host Configurations
echo "$hostname" > /etc/hostname 2>&1 | tee -a "$hostcfg_log_file"
echo "TZ=$timezone" >> /etc/environment 2>&1 | tee -a "$hostcfg_log_file"
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime 2>&1 | tee -a "$hostcfg_log_file"
sed -i "s/^# \(en_US.UTF-8\|he_IL.UTF-8\)/\1/" /etc/locale.gen && locale-gen 2>&1 | tee -a "$hostcfg_log_file"
loadkeys "$keyboard_layout" 2>&1 | tee -a "$hostcfg_log_file"
update-alternatives --set editor /usr/bin/"$default_editor" 2>&1 | tee -a "$hostcfg_log_file"

# Fix PS1 export (Escape colors properly)
echo "export PS1=\"\[\e[34m\]\u@\h:\w\$ \[\e[0m\]\"" >> /etc/profile 2>&1 | tee -a "$hostcfg_log_file"

cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml > /dev/null
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses:
        - ${static_ip}/24
      gateway4: ${gateway}
      nameservers:
        addresses:
          - ${dns_servers}
EOF

# Apply Netplan configuration only if file is successfully created
if [[ -f /etc/netplan/01-netcfg.yaml ]]; then
    netplan apply 2>&1 | tee -a "$hostcfg_log_file"
else
    echo "Error: Failed to create netplan file." | tee -a "$hostcfg_log_file"
    exit 1
fi

exec su - "$username"
