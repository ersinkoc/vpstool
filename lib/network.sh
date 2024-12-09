#!/bin/bash

#===========================================
# Network Functions
#===========================================

check_network() {
    print_section "Network Connections" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Network Interfaces:"
    ip a
    echo -e "\nRouting Table:"
    netstat -rn
    echo -e "\nOpen Ports (Listening):"
    netstat -tuln | grep LISTEN
    echo -e "\nActive Connections:"
    netstat -tn | grep ESTABLISHED
    echo -e "\nDNS Servers:"
    cat /etc/resolv.conf | grep nameserver
    echo -e "\nCurrent Network Connections:"
    ss -s
    echo -e "\nNetwork Interface Statistics:"
    netstat -i
}

check_network_advanced() {
    print_section "Advanced Network Analysis" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "\nNetwork Interface Details:"
    ip -s link
    echo -e "\nIP Routing Table:"
    ip route
    echo -e "\nARP Cache:"
    arp -n
    echo -e "\nNetwork Statistics:"
    netstat -s
    echo -e "\nSocket Statistics:"
    ss -s
    echo -e "\nNetwork Connections:"
    lsof -i
}

check_firewall_advanced() {
    print_section "Advanced Firewall Analysis" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "\nIPTables Rules:"
    iptables -L -n -v
    echo -e "\nIPTables NAT Rules:"
    iptables -t nat -L -n -v
    if command -v ufw &> /dev/null; then
        echo -e "\nUFW Status:"
        ufw status verbose
    fi
    if command -v firewall-cmd &> /dev/null; then
        echo -e "\nFirewallD Zones:"
        firewall-cmd --list-all-zones
        echo -e "\nFirewallD Active Rules:"
        firewall-cmd --list-all
    fi
}

check_dns_server() {
    print_section "DNS Server Analysis" "${YELLOW}"
    echo "----------------------------------------"
    if command -v named &> /dev/null; then
        echo -e "\nBIND Status:"
        systemctl status named
        echo -e "\nBIND Version:"
        named -v
        echo -e "\nDNS Zones:"
        ls -l /etc/bind/zones/ 2>/dev/null || ls -l /var/named/ 2>/dev/null
        echo -e "\nBIND Configuration:"
        cat /etc/bind/named.conf 2>/dev/null
    fi
    echo -e "\nLocal DNS Resolution:"
    cat /etc/resolv.conf
    echo -e "\nHost File Entries:"
    cat /etc/hosts
}

check_load_balancer() {
    print_section "Load Balancer Analysis" "${YELLOW}"
    echo "----------------------------------------"
    if command -v haproxy &> /dev/null; then
        echo -e "\nHAProxy Status:"
        systemctl status haproxy
        echo -e "\nHAProxy Version:"
        haproxy -v
        echo -e "\nHAProxy Configuration:"
        cat /etc/haproxy/haproxy.cfg 2>/dev/null
    fi
    if command -v nginx &> /dev/null; then
        echo -e "\nNginx Load Balancer Config:"
        grep -r "upstream" /etc/nginx/
    fi
}

check_ssl_certificates() {
    print_section "SSL Certificate Check" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Checking common SSL certificate locations..."
    cert_locations=(
        "/etc/ssl/certs"
        "/etc/letsencrypt/live"
    )
    for loc in "${cert_locations[@]}"; do
        if [ -d "$loc" ]; then
            echo -e "\nCertificates in $loc:"
            for cert in $(find "$loc" -type f -name "*.pem" -o -name "*.crt" 2>/dev/null); do
                echo -e "\nCertificate: $cert"
                openssl x509 -in "$cert" -noout -dates -subject 2>/dev/null
            done
        fi
    done
}

check_ssl_security() {
    print_section "SSL/TLS Security Analysis" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "\nChecking SSL/TLS configurations..."
    if [ -d "/etc/apache2" ] || [ -d "/etc/httpd" ]; then
        echo -e "\nApache SSL Configuration:"
        grep -r "SSLProtocol" /etc/apache2 2>/dev/null || grep -r "SSLProtocol" /etc/httpd 2>/dev/null
        grep -r "SSLCipherSuite" /etc/apache2 2>/dev/null || grep -r "SSLCipherSuite" /etc/httpd 2>/dev/null
    fi
    if [ -d "/etc/nginx" ]; then
        echo -e "\nNginx SSL Configuration:"
        grep -r "ssl_protocols" /etc/nginx
        grep -r "ssl_ciphers" /etc/nginx
    fi
    echo -e "\nChecking for SSL/TLS vulnerabilities..."
    for domain in $(grep -r "ServerName" /etc/apache2 2>/dev/null | awk '{print $2}' | grep -v "#"); do
        echo -e "\nChecking $domain:"
        openssl s_client -connect $domain:443 -tls1_2 </dev/null 2>/dev/null | grep "Protocol\|Cipher"
    done
} 