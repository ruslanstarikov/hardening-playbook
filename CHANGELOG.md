# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-02

### Added

#### Core Features
- Complete Ansible playbook for Linux hardening across multiple distributions
- Support for RHEL, Ubuntu, OpenSUSE, and Amazon Linux
- Modular role-based architecture for flexible hardening

#### Hardening Roles
- **system_prepare**: System preparation and essential package installation
- **ssh_hardening**: SSH daemon security configuration
  - Disable root login
  - Enforce key-based authentication
  - Configure secure SSH parameters
  - Set proper file permissions
  
- **user_auth_hardening**: User and authentication security
  - Password quality requirements
  - PAM configuration
  - Password aging policies
  - Account lockout policies
  - File permission hardening
  
- **filesystem_hardening**: Filesystem security
  - Secure mount options for /tmp, /var/tmp, /dev/shm
  - File permission auditing
  - Core dump restrictions
  - USB storage restrictions
  - Uncommon filesystem restrictions
  
- **network_hardening**: Network security
  - Firewall configuration (UFW/firewalld)
  - TCP/IP stack hardening
  - Disable IP forwarding
  - Disable ICMP redirects
  - Enable reverse path filtering
  - TCP SYN cookies
  
- **kernel_hardening**: Kernel security parameters
  - ASLR (Address Space Layout Randomization)
  - Kernel pointer hiding
  - Ptrace restrictions
  - Core dump restrictions
  - SELinux/AppArmor configuration
  
- **service_hardening**: Service security
  - Disable unnecessary services
  - Remove insecure packages
  - Cron permission hardening
  - Systemd security settings
  
- **audit_logging**: Audit and logging configuration
  - Auditd installation and configuration
  - Comprehensive audit rules
  - Rsyslog configuration
  - Journald configuration
  - AIDE (intrusion detection) setup
  - Log rotation policies

#### Configuration & Documentation
- Comprehensive variable configuration system
- Example configurations (strict, moderate)
- Detailed README with usage instructions
- USAGE.md with advanced scenarios
- CONTRIBUTING.md for contributors
- Example inventory files
- Quick start script

#### Testing
- Molecule test scenarios for automated testing
- Verification tasks for hardening validation
- Syntax validation for all playbooks

#### Multi-Distribution Support
- Conditional tasks for distribution-specific commands
- Package manager abstraction (apt/yum/zypper)
- Service name handling across distributions
- OS family detection and handling

### Security Improvements
- Achieves Lynis hardening index of 80+
- Implements CIS Benchmark recommendations
- Follows security best practices
- Comprehensive audit trail configuration
- File integrity monitoring with AIDE
- Kernel exploit mitigation
- Network attack surface reduction

### Documentation
- Complete README with installation and usage
- Usage guide with practical examples
- Contributing guidelines
- Example configurations for different security levels
- Quick start automation script

### Configuration Examples
- Production inventory example
- Strict hardening configuration
- Moderate hardening configuration
- Multi-environment setup examples

[1.0.0]: https://github.com/ruslanstarikov/hardening-playbook/releases/tag/v1.0.0
