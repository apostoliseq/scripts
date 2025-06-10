#!/bin/bash

# os version
echo "--- OS Version ---"
cat /etc/os-release
echo

# uptime
echo "Uptime: $(uptime)"
echo

# logged in users
echo "--- Logged In Users ---"
who
echo

#     Total CPU usage
echo "CPU Usage: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
echo

#     Total memory usage (Free vs Used including percentage)
echo "Total Memory Usage: "$(free -h| awk '$1 == "Mem:" {print "total: "$2" " "used: "$3" " "free: "$4}')""
echo "Used Memory:"$(free| awk '$1 == "Mem:" {print $3/$2 * 100 "%"}')""
echo "Free Memory:"$(free| awk '$1 == "Mem:" {print $4/$2 * 100 "%"}')""
echo

#     Total disk usage (Free vs Used including percentage)
echo "Total Storage Usage: "$(df -h| awk '$1 == "/dev/sdd" {print "total: "$2" " "avail: "$3" " "used:"$4" " "use%: "$5}')""
echo "Used Storage:"$(df| awk '$1 == "/dev/sdd" {print $4/$2 * 100 "%"}')""
echo "Free Storage:"$(df| awk '$1 == "/dev/sdd" {print $3/$2 * 100 "%"}')""
echo

#     Top 5 processes by CPU usage
echo "--- Top Processes by CPU: ---"
ps aux --sort=-%cpu | head -5
echo

#     Top 5 processes by memory usage
echo "--- Top Processes by Memory ---"
ps aux --sort=-%mem | head -5
echo

# Network information  
echo "Hostname: $(hostname -f )"
echo

echo "--- IP Configuration ---"
ip addr show
echo

echo "--- Routing Table ---"
ip route
echo