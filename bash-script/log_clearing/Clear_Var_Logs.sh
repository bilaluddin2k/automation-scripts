#!/bin/bash

# Function to check disk usage
check_disk_usage() {
    local threshold=85
    local usage=$(df -h /var | awk 'NR==2 {print $5}' | tr -d '%')
    if [ "$usage" -ge "$threshold" ]; then
        echo "Disk usage on /var is $usage%, which exceeds the threshold of $threshold%"
        return 0  # Return 0 to indicate threshold exceeded
    else
        echo "Threshold under control, Disk usage on /var is $usage%"
        return 1  # Return 1 to indicate threshold not exceeded
    fi
}

# Function to truncate log files
truncate_logs() {
    local log_dir="/var/log"
    if [ -d "$log_dir" ]; then
        # Find all log files recursively under /var/log and truncate them
        find "$log_dir" -type f -exec truncate -s 1000 {} +
        echo "Truncated all log files under $log_dir and its subdirectories."
    else
        echo "Log directory not found: $log_dir"
    fi
}

# Main script

echo "------------------------------------------"

echo -e "\033[0;32m $(date) \033[0m"

before_size=$(du -sh /var/log/)
echo "size before truncate ----> $before_size"

# Check disk usage threshold
if check_disk_usage; then
    # Threshold exceeded, truncate logs
    truncate_logs
else
    echo "No need to truncate logs. Threshold is under control."
fi

after_size=$(du -sh /var/log/)
echo "size after truncate ----> $after_size"
