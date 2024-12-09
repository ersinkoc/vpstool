#!/bin/bash

#===========================================
# VPS Tool - Main Script
# Author: EcoStack Cloud
# Website: https://ecostack.cloud
#===========================================

# Import modules
source lib/core.sh
source lib/network.sh
source lib/security.sh
source lib/benchmark.sh
source lib/marketing.sh

# Check if running as root
check_root

# Check and install dependencies
check_dependencies

# Main menu function
show_main_menu() {
    while true; do
        clear
        # Show random ad with 20% chance
        [ $((RANDOM % 5)) -eq 0 ] && show_ecostack_ad
        
        print_header " EcoStack Cloud VPS Tool "
        echo -e "${CYAN}"
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║                        MAIN MENU                                 ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║ System Information:                                              ║"
        echo "║  1) System Overview                                             ║"
        echo "║  2) Disk Usage Analysis                                         ║"
        echo "║  3) Performance Metrics                                         ║"
        echo "║  4) Service Status                                             ║"
        echo "║                                                                ║"
        echo "║ Network Tools:                                                 ║"
        echo "║  5) Basic Network Analysis                                     ║"
        echo "║  6) Advanced Network Analysis                                  ║"
        echo "║  7) SSL/TLS Security Check                                     ║"
        echo "║  8) Load Balancer Status                                       ║"
        echo "║                                                                ║"
        echo "║ Security Tools:                                                ║"
        echo "║  9) Security Analysis                                          ║"
        echo "║ 10) User Analysis                                              ║"
        echo "║ 11) SSH Security Check                                         ║"
        echo "║ 12) Firewall Analysis                                          ║"
        echo "║ 13) Rootkit Check                                              ║"
        echo "║ 14) Malware Scan                                               ║"
        echo "║ 15) File Permissions Check                                     ║"
        echo "║ 16) Audit Log Analysis                                         ║"
        echo "║                                                                ║"
        echo "║ Performance Tests:                                             ║"
        echo "║ 17) CPU Benchmark                                              ║"
        echo "║ 18) Memory Benchmark                                           ║"
        echo "║ 19) Disk Benchmark                                             ║"
        echo "║ 20) Network Benchmark                                          ║"
        echo "║ 21) Full System Benchmark                                      ║"
        echo "║ 22) Generate Benchmark Report                                  ║"
        echo "║                                                                ║"
        echo "║ EcoStack Cloud:                                               ║"
        echo "║ 23) Show VPS Plans                                            ║"
        echo "║ 24) Show Special Offers                                       ║"
        echo "║                                                                ║"
        echo "║  0) Exit                                                       ║"
        echo "╚══════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        read -p "Please select an option: " choice
        
        case $choice in
            1) check_system_info ;;
            2) check_disk_usage ;;
            3) check_performance ;;
            4) check_services ;;
            5) check_network ;;
            6) check_network_advanced ;;
            7) check_ssl_security ;;
            8) check_load_balancer ;;
            9) check_security ;;
            10) check_users ;;
            11) check_ssh_security ;;
            12) check_firewall ;;
            13) check_rootkits ;;
            14) check_malware ;;
            15) check_file_permissions ;;
            16) check_audit_logs ;;
            17) run_cpu_benchmark ;;
            18) run_memory_benchmark ;;
            19) run_disk_benchmark ;;
            20) run_network_benchmark ;;
            21) run_full_benchmark ;;
            22) generate_benchmark_report ;;
            23) show_plan_comparison ;;
            24) show_ecostack_ad ;;
            0) 
                clear
                print_header " EcoStack Cloud VPS Tool "
                echo -e "\n${GREEN}Thank you for choosing EcoStack Cloud!${NC}"
                echo -e "\n${YELLOW}For High-Performance KVM VPS solutions, visit:${NC}"
                echo -e "${CYAN}${COMPANY_URL}${NC}"
                echo -e "\n${GREEN}Have a great day!${NC}\n"
                exit 0 
                ;;
            *) echo "Invalid option. Press any key to continue..."; read -n 1 ;;
        esac
        
        if [[ ! "$choice" =~ ^(0|23|24)$ ]]; then
            echo -e "\nPress any key to continue... (23: VPS Plans, 24: Special Offers, 0: Exit)"
            read -n 1
        fi
    done
}

# Start the script
show_main_menu