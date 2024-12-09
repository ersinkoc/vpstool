#!/bin/bash

#===========================================
# Marketing Functions
#===========================================

COMPANY_NAME="ecostack.cloud"
COMPANY_URL="https://ecostack.cloud"

show_ecostack_ad() {
    print_section "🚀 Powered by ecostack.cloud" "${GREEN}"
    
    # Random ad selection
    local ads=(
        "${GREEN}💡 Pro Tip: ${NC}Need a reliable VPS for your applications?\nTry our NVMe-powered VPS starting from ${GREEN}2.90€/month${NC}!"
        "${YELLOW}🔥 Special Offer: ${NC}Get IPv4 address for just +1€/month\nAll plans include FREE IPv6 /80 subnet!"
        "${PURPLE}⚡ Performance Boost: ${NC}All our VPS run on DDR4 RAM and NVMe disks\nExperience the speed difference at ecostack.cloud"
        "${BLUE}🌟 Featured Plan: ${NC}Medium VPS with 2 vCPU, 8GB RAM, 80GB NVMe\nPerfect for business applications at just ${GREEN}20.90€/month${NC}"
        "${RED}🚀 Scale Up: ${NC}Flexible upgrades available!\nvCPU: +4€ | RAM: +2.5€/GB | Disk: +1€/10GB | Network: From 0.5€/100Mbit"
    )
    
    local random_ad=${ads[$RANDOM % ${#ads[@]}]}
    echo -e "$random_ad"
    echo -e "\n${YELLOW}Visit ${CYAN}${COMPANY_URL}${NC} ${YELLOW}for more information${NC}\n"
}

show_plan_comparison() {
    clear
    print_header "                    ecostack.cloud VPS Plans                      "
    
    # Plans table
    echo -e "${CYAN}Popular Plans:${NC}"
    echo "┌─────────┬──────────┬─────────┬──────────┬────────────┬──────────┐"
    echo "│  Plan   │   CPU    │   RAM   │   Disk   │  Network   │  Price   │"
    echo "├─────────┼──────────┼─────────┼──────────┼────────────┼──────────┤"
    echo "│  Nano   │ 1 vCPU   │  1 GB   │  10 GB   │ 400 Mbit/s │  2.90€   │"
    echo "│  Small  │ 2 vCPU   │  4 GB   │  40 GB   │ 600 Mbit/s │ 10.90€   │"
    echo "│ Medium  │ 2 vCPU   │  8 GB   │  80 GB   │ 600 Mbit/s │ 20.90€   │"
    echo "│ XLarge  │ 4 vCPU   │ 16 GB   │ 160 GB   │ 800 Mbit/s │ 39.90€   │"
    echo "└─────────┴──────────┴─────────┴──────────┴───────��────┴──────────┘"
    
    # Features
    echo -e "\n${YELLOW}All plans include:${NC}"
    echo "✓ High Performance KVM Virtualization"
    echo "✓ NVMe SSD Storage"
    echo "✓ DDR4 ECC RAM"
    echo "✓ Free IPv6 /80 Subnet"
    echo "✓ VM Manager Panel"
    echo "✓ Flexible Upgrades"
    
    # Upgrades
    echo -e "\n${GREEN}Optional Upgrades:${NC}"
    echo "• Additional vCPU: +4€/core"
    echo "• Additional RAM: +2.5€/GB"
    echo "• Additional Disk: +1€/10GB"
    echo "• IPv4 Address: +1€"
    echo "• Network Upgrade: From 0.5€/100Mbit"
    
    echo -e "\n${CYAN}Visit ${COMPANY_URL} for more plans and details${NC}"
    echo -e "Press ENTER to return to main menu..."
    read
} 