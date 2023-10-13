#!/bin/bash

#System Information
SYSTEM_HOSTNAME=$(hostname)
SYSTEM_OS=$(lsb_release -d | awk -F"\t" '{print $2}')
SYSTEM_UPTIME=$(uptime -p)

#Hardware Information
HARDWARE_CPU=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F": " '{print $2}')
HARDWARE_CPU_SPEED=$(lscpu | grep "MHz" | awk '{print $3}')
HARDWARE_RAM=$(free -h | awk '/Mem/ {print $2}')
HARDWARE_DISK=$(df -h | awk '$NF=="/"{printf "Disk: %d/%dGB (%s)\n", $3,$2,$5}')
HARDWARE_VIDEO_CARD=$(lspci | grep -i "VGA" | awk -F": " '{print $2}')

#Network Information
NETWORK_FQDN=$(hostname -f)
NETWORK_HOST_ADDRESS=$(hostname -I | awk '{print $1}')
NETWORK_GATEWAY=$(ip route | awk '/default/ {print $3}')
NETWORK_DNS=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
NETWORK_INTERFACES=$(ip -o link show | awk -F': ' '{print $2}')
NETWORK_MAKE_MODEL=$(lspci | grep -i "network" | awk -F": " '{print $2}')
NETWORK_IP_CIDR=$(ip -o -4 addr show $NETWORK_INTERFACE | awk '/inet / {print $4}')

#System Status
SYSTEM_USERS=$(who | awk '{print $1}' | sort | uniq | tr '\n' ',' | sed 's/,$//')
SYSTEM_DISK_SPACE=$(df -h | awk '/^\/dev/ {print $6" "$4}')
SYSTEM_PROCESS_COUNT=$(ps aux | wc -l)
SYSTEM_LOAD_AVERAGES=$(uptime | awk -F'average: ' '{ print $2 }')
SYSTEM_MEMORY_ALLOCATION=$(free -m)
LISTENING_PORTS=$(ss -tuln | awk '{print $5}' | cut -d ':' -f2 | grep -E "^[0-9]" | sort -n | uniq | tr '\n' ', ' | sed 's/,$//')
UFW_RULES=$(sudo ufw status numbered | awk '{print $1" "$2" "$3}')

# Generating Report
echo ""
echo "System Report generated by $(whoami), $(date)"
echo ""
echo "System Information"
echo "------------------"
echo "Hostname: $SYSTEM_HOSTNAME"
echo "OS: $SYSTEM_OS"
echo "Uptime: $SYSTEM_UPTIME"
echo ""
echo "Hardware Information"
echo "--------------------"
echo "CPU: $HARDWARE_CPU"
echo "Speed: $HARDWARE_CPU_SPEED MHz"
echo "RAM: $HARDWARE_RAM"
echo "$HARDWARE_DISK"
echo "Video: $HARDWARE_VIDEO_CARD"
echo ""
echo "Network Information"
echo "-------------------"
echo "FQDN: $NETWORK_FQDN"
echo "Host Address: $NETWORK_HOST_ADDRESS"
echo "Gateway IP: $NETWORK_GATEWAY"
echo "DNS Server: $NETWORK_DNS"
echo ""
echo "Interfaces Names"
echo "$NETWORK_INTERFACES"
echo ""
echo "Network Card: $NETWORK_MAKE_MODEL"
echo "IP Address: $NETWORK_IP_CIDR"
echo ""
echo "System Status"
echo "-------------"
echo "Users Logged In: ${SYSTEM_USERS%,}"
echo "Disk Space: $SYSTEM_DISK_SPACE"
echo "Process Count: $SYSTEM_PROCESS_COUNT"
echo "Load Averages: $SYSTEM_LOAD_AVERAGES"
echo "Memory Allocation:"
echo "$SYSTEM_MEMORY_ALLOCATION"
echo "Listening Network Ports: $LISTENING_PORTS"
echo "UFW Rules: $UFW_RULES"
echo ""

# End of Report
