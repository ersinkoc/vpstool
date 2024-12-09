# VPSTool by EcoStack Cloud

<div align="center">

![EcoStack Cloud](assets/logo.png)

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Bash](https://img.shields.io/badge/bash-5.0%2B-orange.svg)

**🚀 High Performance KVM VPS Solutions**

</div>

## 🌟 About EcoStack Cloud

EcoStack Cloud provides high-performance KVM-based VPS solutions with NVMe storage, offering the perfect balance of performance, reliability, and value. Our infrastructure is built on enterprise-grade hardware, ensuring consistent performance and reliability for your applications.

### ⚡ Why Choose EcoStack Cloud?

- 🔥 **High Performance** - KVM virtualization with dedicated resources
- 💾 **NVMe Storage** - Lightning-fast storage performance
- 🔧 **DDR4 ECC RAM** - Enhanced reliability and stability
- 🌐 **High-Speed Network** - Up to 1 Gbit/s connectivity
- 🛡️ **IPv6 Ready** - Free /80 IPv6 subnet included
- ⚙️ **Flexible Resources** - Easy upgrades and customization
- 🎮 **VM Manager Panel** - User-friendly control panel

## 📊 VPS Plans

| Plan     | CPU    | RAM   | NVMe Disk | Network    | Price/mo |
|----------|--------|-------|-----------|------------|----------|
| Nano     | 1 vCPU | 1 GB  | 10 GB     | 400 Mbit/s | 2.90€    |
| Micro    | 1 vCPU | 2 GB  | 20 GB     | 400 Mbit/s | 4.90€    |
| Small    | 2 vCPU | 4 GB  | 40 GB     | 600 Mbit/s | 10.90€   |
| Medium   | 2 vCPU | 8 GB  | 80 GB     | 600 Mbit/s | 20.90€   |
| Large    | 3 vCPU | 12 GB | 120 GB    | 800 Mbit/s | 29.90€   |
| XLarge   | 4 vCPU | 16 GB | 160 GB    | 800 Mbit/s | 39.90€   |
| XXLarge  | 6 vCPU | 24 GB | 240 GB    | 1 Gbit/s   | 56.90€   |
| XXXLarge | 8 vCPU | 32 GB | 320 GB    | 1 Gbit/s   | 76.90€   |

### 💡 Flexible Upgrades

| Resource          | Price     | Notes                                    |
|-------------------|-----------|------------------------------------------|
| Additional vCPU   | +4€/core  | 2.4GHz+ performance                     |
| Additional RAM    | +2.5€/GB  | DDR4 ECC Memory                         |
| Additional Disk   | +1€/10GB  | Gen 4 NVMe Technology                   |
| Network Up Speed  | +1€/100Mb | Upgrade outgoing bandwidth              |
| Network Down Speed| +0.5€/100Mb| Upgrade incoming bandwidth             |
| IPv4 Address      | +1€       | Additional IPv4 address                 |
| IPv6 Subnet       | FREE      | /80 subnet included with all plans      |

## 🛠️ Tool Features

### System Analysis
- Comprehensive system information gathering
- Real-time performance monitoring
- Disk usage and I/O analysis
- Service status monitoring
- Process and resource tracking
- System update management

### Network & Security
- Network performance analysis
- Security vulnerability scanning
- SSL/TLS configuration check
- Firewall rule analysis
- Port scanning and monitoring
- Traffic analysis

### Services & Applications
- Web server optimization
- Database performance tuning
- Email server configuration
- DNS server analysis
- Load balancer optimization
- Cache server monitoring

### Monitoring & Alerts
- Resource usage alerts
- Performance bottleneck detection
- Service availability monitoring
- Security threat detection
- Backup status verification
- Log analysis and reporting

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/ersinkoc/vpstool.git
cd vpstool
```

2. Make the script executable:
```bash
chmod +x vpstool.sh lib/*.sh
```

3. Run the tool:
```bash
sudo ./vpstool.sh
```

## 🔧 Requirements

### Core Requirements
- Linux operating system
- Bash shell 5.0+
- Root or sudo privileges

### Optional Tools
- 🔧 System Tools: htop, iftop, iotop, nmon
- 🔍 Monitoring: glances, nagios, zabbix
- 🐳 Containers: docker, kubernetes
- 🔒 Security: fail2ban, rkhunter, lynis
- 📊 Benchmarking: sysbench, stress-ng
- 🌐 Network: nmap, tcpdump, wireshark

## 📂 Directory Structure

```
vpstool/
├── vpstool.sh          # Main script
├── lib/
│   ├── core.sh         # Core functions
│   ├── network.sh      # Network analysis
│   ├── security.sh     # Security tools
│   ├── benchmark.sh    # Performance tests
│   └── marketing.sh    # EcoStack Cloud info
└── README.md
```

## 📚 Module Description

- **core.sh**: Contains essential functions, helper utilities, and basic system checks
- **network.sh**: Network analysis, SSL checks, and load balancer monitoring
- **security.sh**: Security analysis, user auditing, and system hardening
- **benchmark.sh**: System performance testing and benchmarking tools
- **marketing.sh**: EcoStack Cloud VPS plans and special offers

## 🚀 Usage

1. Run the script with root privileges:
```bash
sudo ./vpstool.sh
```

2. Select from the available options in the main menu:
- System Information
- Network Tools
- Security Tools
- Performance Tests
- EcoStack Cloud Plans

3. Follow the on-screen instructions for each tool.

## 🔗 Support & Links

- 🌐 Website: [ecostack.cloud](https://ecostack.cloud)
- 📧 Support: support@ecostack.cloud

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Thanks to all contributors who have helped with the project
- Special thanks to the open-source community for various tools and libraries used in this project

---

<div align="center">

**🚀 Powered by [ecostack.cloud](https://ecostack.cloud)**

*High Performance KVM VPS Solutions*

</div>