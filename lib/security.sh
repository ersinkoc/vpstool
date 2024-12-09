#!/bin/bash

#===========================================
# Security Functions
#===========================================

check_security() {
    print_section "Security Analysis" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Failed Login Attempts:"
    grep "Failed password" /var/log/auth.log 2>/dev/null || grep "Failed password" /var/log/secure 2>/dev/null
    echo -e "\nSuccessful Logins:"
    grep "session opened" /var/log/auth.log 2>/dev/null || grep "session opened" /var/log/secure 2>/dev/null
    echo -e "\nLast Logins:"
    last | head -n 10
    echo -e "\nCurrently Logged In Users:"
    who
    echo -e "\nUser Login History:"
    for user in $(cut -d: -f1 /etc/passwd); do
        echo -e "\n$user:"
        last "$user" | head -n 3
    done
}

check_users() {
    print_section "User Analysis" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "Users with Login Shell:"
    grep -v '/nologin\|/false' /etc/passwd
    echo -e "\nSudo Users:"
    grep -v '^#' /etc/sudoers 2>/dev/null | grep -v '^$'
    for file in /etc/sudoers.d/*; do
        if [ -f "$file" ]; then
            echo -e "\nSudo config from $file:"
            grep -v '^#' "$file" 2>/dev/null | grep -v '^$'
        fi
    done
    echo -e "\nUsers in sudo group:"
    getent group sudo 2>/dev/null
    echo -e "\nUsers in wheel group:"
    getent group wheel 2>/dev/null
}

check_ssh_security() {
    print_section "SSH Security Analysis" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "SSH Configuration:"
    grep -v '^#' /etc/ssh/sshd_config | grep -v '^$'
    echo -e "\nSSH Keys:"
    for user in $(cut -d: -f1 /etc/passwd); do
        if [ -d "/home/$user/.ssh" ]; then
            echo -e "\nSSH Keys for $user:"
            ls -l "/home/$user/.ssh"
        fi
    done
    echo -e "\nSSH Failed Login Attempts:"
    grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 10
    echo -e "\nSSH Successful Logins:"
    grep "Accepted" /var/log/auth.log 2>/dev/null | tail -n 10
}

check_firewall() {
    print_section "Firewall Analysis" "${YELLOW}"
    echo "----------------------------------------"
    if command -v ufw &> /dev/null; then
        echo -e "UFW Status:"
        ufw status verbose
    elif command -v firewall-cmd &> /dev/null; then
        echo -e "FirewallD Status:"
        firewall-cmd --state
        echo -e "\nFirewallD Rules:"
        firewall-cmd --list-all
    else
        echo -e "IPTables Rules:"
        iptables -L -n
    fi
}

check_rootkits() {
    print_section "Rootkit Check" "${YELLOW}"
    echo "----------------------------------------"
    if command -v rkhunter &> /dev/null; then
        echo -e "Running RKHunter check..."
        rkhunter --check --skip-keypress
    else
        echo -e "RKHunter not installed. Installing..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y rkhunter
        elif [ -f /etc/redhat-release ]; then
            yum install -y rkhunter
        fi
        echo -e "\nRunning initial RKHunter check..."
        rkhunter --check --skip-keypress
    fi
}

check_malware() {
    print_section "Malware Check" "${YELLOW}"
    echo "----------------------------------------"
    if command -v clamav &> /dev/null; then
        echo -e "Running ClamAV scan..."
        clamscan -r --bell -i /
    else
        echo -e "ClamAV not installed. Installing..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y clamav
        elif [ -f /etc/redhat-release ]; then
            yum install -y clamav
        fi
        echo -e "\nUpdating virus definitions..."
        freshclam
        echo -e "\nRunning initial ClamAV scan..."
        clamscan -r --bell -i /
    fi
}

check_file_permissions() {
    print_section "File Permissions Analysis" "${YELLOW}"
    echo "----------------------------------------"
    echo -e "SUID Files:"
    find / -type f -perm -4000 2>/dev/null
    echo -e "\nSGID Files:"
    find / -type f -perm -2000 2>/dev/null
    echo -e "\nWorld-Writable Files:"
    find / -type f -perm -2 ! -type l -ls 2>/dev/null
    echo -e "\nWorld-Writable Directories:"
    find / -type d -perm -2 ! -type l -ls 2>/dev/null
    echo -e "\nFiles with no owner:"
    find / -nouser -o -nogroup 2>/dev/null
}

check_audit_logs() {
    print_section "Audit Log Analysis" "${YELLOW}"
    echo "----------------------------------------"
    if command -v ausearch &> /dev/null; then
        echo -e "Authentication Events:"
        ausearch -m USER_AUTH -ts today 2>/dev/null
        echo -e "\nSystem Call Events:"
        ausearch -m SYSCALL -ts today 2>/dev/null
        echo -e "\nFile Access Events:"
        ausearch -m PATH -ts today 2>/dev/null
    else
        echo -e "Auditd not installed. Installing..."
        if [ -f /etc/debian_version ]; then
            apt-get update && apt-get install -y auditd
        elif [ -f /etc/redhat-release ]; then
            yum install -y audit
        fi
        systemctl start auditd
        echo -e "\nAudit system enabled. Please wait for events to be collected."
    fi
} 