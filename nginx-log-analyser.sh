#!/bin/bash

read -p "Provide log to analyze: " log_file

analyze() {
    echo "$2"
    eval "$1" $log_file | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
    echo
}

analyze "awk '{print $1}'" "Top 5 IP addresses with the most requests:"
analyze "awk '{print $7}'" "Top 5 most requested paths:"
analyze "awk '{print $9}'" "Top 5 response status codes:"
analyze "awk -F'\"' '{print $6}'" "Top 5 user agents:"