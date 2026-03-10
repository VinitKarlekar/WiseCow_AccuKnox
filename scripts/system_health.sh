#!/bin/bash

# Configuration
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/system_health.log"

log_warning() {
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] WARNING: $message" | tee -a "$LOG_FILE"
}

# 1. Check CPU Usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
cpu_usage_int=${cpu_usage%.*}

if [ "$cpu_usage_int" -ge "$CPU_THRESHOLD" ]; then
    log_warning "CPU usage is high: ${cpu_usage_int}%"
fi

# 2. Check Memory Usage
memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
memory_usage_int=${memory_usage%.*}

if [ "$memory_usage_int" -ge "$MEMORY_THRESHOLD" ]; then
    log_warning "Memory usage is high: ${memory_usage_int}%"
fi

# 3. Check Disk Space
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$disk_usage" -ge "$DISK_THRESHOLD" ]; then
    log_warning "Disk usage is high: ${disk_usage}% on root partition"
fi

# 4. Running Processes
process_count=$(ps -e | wc -l)
# Arbitrary number for demonstration. Real threshold depends on the server.
PROCESS_THRESHOLD=1000 

if [ "$process_count" -ge "$PROCESS_THRESHOLD" ]; then
    log_warning "Number of running processes is high: $process_count"
fi