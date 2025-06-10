#!/bin/bash

read -p "Which directory should the logs be stored to ? " new_dir
sudo mkdir -p "$new_dir"
sudo tar -czf "$new_dir/logs_archive_$(date +'%Y%m%d_%H%M%S').tar.gz" $1