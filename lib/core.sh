#!/bin/bash

#===========================================
# Core Functions
#===========================================

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Helper functions
print_header() {
    local title="$1"
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║${title}║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    local title="$1"
    local color="$2"
    echo -e "\n${color}╔═ ${title} ═${NC}"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}Error: Please run as root or with sudo${NC}"
        exit 1
    fi
}

check_dependencies() {
    local deps=("curl" "wget" "netstat" "ss" "lsof" "ps")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${YELLOW}Missing dependencies: ${missing[*]}${NC}"
        echo -e "Installing missing packages..."
        if [ -f /etc/debian_version ]; then
            apt-get update
            apt-get install -y "${missing[@]}"
        elif [ -f /etc/redhat-release ]; then
            yum install -y "${missing[@]}"
        fi
    fi
}

# System information functions
check_system_info() {
    print_section "System Information" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Hostname: $(hostname)"
    echo -e "Kernel: $(uname -r)"
    echo -e "Operating System: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo -e "CPU Model: $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d':' -f2)"
    echo -e "CPU Cores: $(nproc)"
    echo -e "Total RAM: $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "Used RAM: $(free -h | awk '/^Mem:/ {print $3}')"
    echo -e "System Uptime: $(uptime -p)"
    echo -e "Last System Boot: $(who -b | awk '{print $3,$4}')"
    echo -e "\nProcessor Load:"
    uptime
    echo -e "\nMemory Info Details:"
    free -h
    echo -e "\nSystem Architecture: $(uname -m)"
}

check_disk_usage() {
    print_section "Disk Usage" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Partition Usage:"
    df -h | grep -v "tmpfs"
    echo -e "\nTop 10 largest directories:"
    du -h / 2>/dev/null | sort -rh | head -n 10
    echo -e "\nDisk I/O Statistics:"
    iostat 2>/dev/null || echo "iostat not installed (sysstat package required)"
    echo -e "\nInode Usage:"
    df -i | grep -v "tmpfs"
    echo -e "\nMounted Filesystems:"
    mount | column -t
}

check_performance() {
    print_section "Performance Metrics" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Top 10 CPU-Consuming Processes:"
    ps aux --sort=-%cpu | head -n 11
    echo -e "\nTop 10 Memory-Consuming Processes:"
    ps aux --sort=-%mem | head -n 11
    echo -e "\nSystem Load Average:"
    cat /proc/loadavg
    echo -e "\nVirtual Memory Statistics:"
    vmstat 1 5
    echo -e "\nProcessor Information:"
    lscpu
    echo -e "\nCache Memory Information:"
    cat /proc/meminfo | grep -i cache
}

check_services() {
    print_section "Service Status" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Running Services:"
    systemctl list-units --type=service --state=running
    echo -e "\nFailed Services:"
    systemctl --failed
    echo -e "\nEnabled Services (starts at boot):"
    systemctl list-unit-files | grep enabled
    echo -e "\nTimers (Systemd):"
    systemctl list-timers --all
    echo -e "\nSystem Startup Services:"
    systemctl list-dependencies multi-user.target
}

check_updates() {
    print_section "System Updates" "${YELLOW}"
    echo "----------------------------------------"
    if [ -f /etc/debian_version ]; then
        echo -e "\nDebian/Ubuntu Updates:"
        apt update 2>/dev/null
        echo -e "\nAvailable Updates:"
        apt list --upgradable 2>/dev/null
        echo -e "\nSecurity Updates:"
        apt list --upgradable 2>/dev/null | grep -i security
    elif [ -f /etc/redhat-release ]; then
        echo -e "\nCentOS/RHEL Updates:"
        yum check-update 2>/dev/null
        echo -e "\nSecurity Updates:"
        yum updateinfo list security 2>/dev/null
    fi
    echo -e "\nLast Update Time:"
    ls -l /var/log/apt/history.log 2>/dev/null || ls -l /var/log/yum.log 2>/dev/null
}

check_cron_jobs() {
    print_section "Cron Jobs" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "System-wide cron jobs (/etc/crontab):"
    cat /etc/crontab
    echo -e "\nSystem-wide cron directories:"
    for dir in /etc/cron.{daily,weekly,monthly,d}; do
        echo -e "\nContents of $dir:"
        ls -l "$dir"
    done
    echo -e "\nUser Cron Jobs:"
    for user in $(cut -d: -f1 /etc/passwd); do
        crontab -l -u "$user" 2>/dev/null | grep -v '^#' || continue
    done
} 