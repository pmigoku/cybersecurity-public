#!/bin/bash
# This script is intented to be used in a Linux DE panel/taskbar to show the current IP addresses

# Get internal IP address
hostIP="$(hostname -I)"
lanIP="$(echo "${hostIP}" | awk '{print $1}')"

# Get external IP address
wanIP="$(curl ifconfig.me 2>/dev/null)"

# Create text output
textOuts="LAN: ${lanIP} | WAN: ${wanIP}"

# Get TUN device info
tunDev=$(ip a show tun0 2>&1)

# Test if device exists
if [[ ${tunDev} != *"not exist"* ]]; then
	# Get TUN IP address
	tunIP=$(echo "$tunDev" | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)

	# Append text output
	textOuts+=" | VPN: ${tunIP}"	
fi

# Print final plain text output
echo "${textOuts}"
