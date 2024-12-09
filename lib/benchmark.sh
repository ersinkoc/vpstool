#!/bin/bash

#===========================================
# Benchmark Functions
#===========================================

run_cpu_benchmark() {
    print_section "CPU Benchmark" "${YELLOW}"
    echo "----------------------------------------"
    
    # Install sysbench if not present
    if ! command -v sysbench &> /dev/null; then
        echo "Installing sysbench..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y sysbench
        elif [ -f /etc/redhat-release ]; then
            yum install -y sysbench
        fi
    fi
    
    echo -e "\nRunning CPU benchmark..."
    sysbench cpu --cpu-max-prime=20000 run
    
    echo -e "\nCPU Information:"
    lscpu
    
    echo -e "\nCPU Temperature:"
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        echo "CPU Temperature: $((temp/1000))°C"
    else
        echo "CPU temperature information not available"
    fi
}

run_memory_benchmark() {
    print_section "Memory Benchmark" "${YELLOW}"
    echo "----------------------------------------"
    
    # Install sysbench if not present
    if ! command -v sysbench &> /dev/null; then
        echo "Installing sysbench..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y sysbench
        elif [ -f /etc/redhat-release ]; then
            yum install -y sysbench
        fi
    fi
    
    echo -e "\nRunning Memory benchmark..."
    sysbench memory --memory-block-size=1K --memory-total-size=100G run
    
    echo -e "\nMemory Information:"
    free -h
    
    echo -e "\nMemory Details:"
    cat /proc/meminfo
}

run_disk_benchmark() {
    print_section "Disk Benchmark" "${YELLOW}"
    echo "----------------------------------------"
    
    # Install required tools if not present
    if ! command -v fio &> /dev/null; then
        echo "Installing fio..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y fio
        elif [ -f /etc/redhat-release ]; then
            yum install -y fio
        fi
    fi
    
    echo -e "\nRunning Sequential Read Test..."
    fio --name=seqread --rw=read --direct=1 --ioengine=libaio --bs=1M --numjobs=1 --size=1G --runtime=60 --group_reporting
    
    echo -e "\nRunning Sequential Write Test..."
    fio --name=seqwrite --rw=write --direct=1 --ioengine=libaio --bs=1M --numjobs=1 --size=1G --runtime=60 --group_reporting
    
    echo -e "\nRunning Random Read Test..."
    fio --name=randread --rw=randread --direct=1 --ioengine=libaio --bs=4K --numjobs=1 --size=1G --runtime=60 --group_reporting
    
    echo -e "\nRunning Random Write Test..."
    fio --name=randwrite --rw=randwrite --direct=1 --ioengine=libaio --bs=4K --numjobs=1 --size=1G --runtime=60 --group_reporting
    
    echo -e "\nDisk Information:"
    df -h
    
    echo -e "\nDisk I/O Statistics:"
    iostat -x 1 5
}

run_network_benchmark() {
    print_section "Network Benchmark" "${YELLOW}"
    echo "----------------------------------------"
    
    # Install required tools if not present
    if ! command -v iperf3 &> /dev/null; then
        echo "Installing iperf3..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y iperf3
        elif [ -f /etc/redhat-release ]; then
            yum install -y iperf3
        fi
    fi
    
    echo -e "\nRunning Network Speed Test..."
    # Test download speed using speedtest-cli
    if ! command -v speedtest-cli &> /dev/null; then
        echo "Installing speedtest-cli..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y speedtest-cli
        elif [ -f /etc/redhat-release ]; then
            yum install -y speedtest-cli
        fi
    fi
    speedtest-cli
    
    echo -e "\nNetwork Interface Information:"
    ip -s link
    
    echo -e "\nNetwork Statistics:"
    netstat -i
}

run_full_benchmark() {
    print_section "Full System Benchmark" "${YELLOW}"
    echo "----------------------------------------"
    
    echo -e "Starting comprehensive system benchmark..."
    
    run_cpu_benchmark
    run_memory_benchmark
    run_disk_benchmark
    run_network_benchmark
    
    echo -e "\nBenchmark Summary:"
    echo "----------------------------------------"
    echo -e "CPU Model: $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d':' -f2)"
    echo -e "Total RAM: $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "Disk Space: $(df -h / | awk 'NR==2 {print $2}')"
    echo -e "Network Interface: $(ip route get 8.8.8.8 | awk '{print $5}' | head -n1)"
}

generate_benchmark_report() {
    local report_file="benchmark_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "==================================================="
        echo "System Benchmark Report"
        echo "Generated on: $(date)"
        echo "==================================================="
        echo
        
        echo "System Information:"
        echo "-------------------"
        echo "Hostname: $(hostname)"
        echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
        echo "Kernel: $(uname -r)"
        echo "CPU: $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d':' -f2)"
        echo "RAM: $(free -h | awk '/^Mem:/ {print $2}')"
        echo "Disk: $(df -h / | awk 'NR==2 {print $2}')"
        echo
        
        run_full_benchmark
        
    } | tee "$report_file"
    
    echo -e "\nBenchmark report saved to: $report_file"
} 