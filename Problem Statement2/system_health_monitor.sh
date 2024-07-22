#!/bin/bash



CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=150


LOG_FILE="/var/log/system_health_monitor.log"


check_cpu_usage() {
    local cpu_usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    echo "Current CPU usage: $cpu_usage%"
    if (( ${cpu_usage%%.*} > CPU_THRESHOLD )); then
        echo "$(date): ALERT: CPU usage is above ${CPU_THRESHOLD}%. Current usage: ${cpu_usage}%" | tee -a $LOG_FILE
    fi
}

check_memory_usage() {
    local memory_usage
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Current Memory usage: $memory_usage%"
    if (( ${memory_usage%%.*} > MEMORY_THRESHOLD )); then
        echo "$(date): ALERT: Memory usage is above ${MEMORY_THRESHOLD}%. Current usage: ${memory_usage}%" | tee -a $LOG_FILE
    fi
}

check_disk_space() {
    local disk_usage
    disk_usage=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//g')
    echo "Current Disk space usage: $disk_usage%"
    if (( disk_usage > DISK_THRESHOLD )); then
        echo "$(date): ALERT: Disk space usage is above ${DISK_THRESHOLD}%. Current usage: ${disk_usage}%" | tee -a $LOG_FILE
    fi
}

check_running_processes() {
    local process_count
    process_count=$(ps aux --no-heading | wc -l)
    echo "Current Running processes: $process_count"
    if (( process_count > PROCESS_THRESHOLD )); then
        echo "$(date): ALERT: Number of running processes is above ${PROCESS_THRESHOLD}. Current count: ${process_count}" | tee -a $LOG_FILE
    fi
}

monitor_system_health() {
    echo "Starting system health check at $(date)..."
    check_cpu_usage
    check_memory_usage
    check_disk_space
    check_running_processes
    echo "System health check completed at $(date)."
}

monitor_system_health
