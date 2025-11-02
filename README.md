# Linux Hardening Playbook

[![License](https://img.shields.io/badge/license-Unlicense-blue.svg)](LICENSE)
[![Ansible](https://img.shields.io/badge/ansible-2.9%2B-green.svg)](https://www.ansible.com/)

A portable Ansible playbook to harden Linux servers (RHEL, Ubuntu, OpenSUSE, Amazon Linux) to achieve a **Lynis hardening index of 80 and above**.

## Overview

This playbook implements comprehensive security hardening for Linux systems based on industry best practices and security benchmarks. It automates the configuration of:

- **SSH hardening** - Secure SSH daemon configuration
- **User and authentication** - Password policies, PAM configuration, account security
- **Filesystem hardening** - Mount options, permissions, and file integrity
- **Network hardening** - Firewall configuration, network stack tuning
- **Kernel hardening** - Sysctl parameters, ASLR, kernel modules
- **Service hardening** - Disable unnecessary services, configure secure defaults
- **Audit and logging** - Auditd rules, system logging, intrusion detection

## Supported Operating Systems

- **Ubuntu** 20.04 (Focal), 22.04 (Jammy), and newer
- **Red Hat Enterprise Linux** 7, 8, 9
- **CentOS** 7, 8
- **Amazon Linux** 2, 2023
- **OpenSUSE** Leap 15.x, Tumbleweed

## Requirements

- Ansible 2.9 or higher
- Python 3.6 or higher on control machine
- Target systems must have Python 3 installed
- Root or sudo access on target systems
- SSH access to target systems

## Quick Start

### 1. Install Ansible

```bash
# On Ubuntu/Debian
sudo apt update && sudo apt install ansible

# On RHEL/CentOS/Amazon Linux
sudo yum install ansible

# Or using pip
pip3 install ansible
```

### 2. Clone the Repository

```bash
git clone https://github.com/ruslanstarikov/hardening-playbook.git
cd hardening-playbook
```

### 3. Install Required Collections

```bash
ansible-galaxy collection install -r requirements.yml
```

### 4. Configure Your Inventory

Edit `inventory/hosts` to add your servers:

```ini
[linux_servers]
webserver1 ansible_host=192.168.1.10
dbserver1 ansible_host=192.168.1.11

[ubuntu_servers]
webserver1

[rhel_servers]
dbserver1
```

### 5. Customize Hardening Settings

Review and modify settings in `inventory/group_vars/all.yml` to match your requirements:

```yaml
# SSH hardening
hardening_ssh_port: 22
hardening_ssh_permit_root_login: "no"
hardening_ssh_password_authentication: "no"

# Password policies
hardening_password_max_days: 90
hardening_password_min_length: 14

# Network settings
hardening_disable_ipv6: false
```

### 6. Run the Playbook

```bash
# Test with check mode (dry run)
ansible-playbook -i inventory/hosts hardening.yml --check

# Apply hardening
ansible-playbook -i inventory/hosts hardening.yml

# Apply specific roles with tags
ansible-playbook -i inventory/hosts hardening.yml --tags "ssh,network"
```

## Available Tags

Run specific hardening tasks using tags:

- `system` - System preparation
- `ssh` - SSH hardening
- `users` - User and authentication hardening
- `auth` - Authentication configuration
- `filesystem` - Filesystem hardening
- `network` - Network hardening
- `kernel` - Kernel hardening
- `services` - Service hardening
- `audit` - Audit configuration
- `logging` - Logging configuration

Example:
```bash
ansible-playbook -i inventory/hosts hardening.yml --tags "ssh,kernel"
```

## Configuration Options

### SSH Hardening

| Variable | Default | Description |
|----------|---------|-------------|
| `hardening_ssh_port` | `22` | SSH port number |
| `hardening_ssh_permit_root_login` | `no` | Allow root login via SSH |
| `hardening_ssh_password_authentication` | `no` | Enable password authentication |
| `hardening_ssh_max_auth_tries` | `3` | Maximum authentication attempts |
| `hardening_ssh_allowed_users` | `[]` | List of allowed SSH users |

### Password Policies

| Variable | Default | Description |
|----------|---------|-------------|
| `hardening_password_max_days` | `90` | Maximum password age |
| `hardening_password_min_days` | `1` | Minimum password age |
| `hardening_password_min_length` | `14` | Minimum password length |
| `hardening_password_remember` | `5` | Remember last N passwords |

### Network Hardening

| Variable | Default | Description |
|----------|---------|-------------|
| `hardening_disable_ipv6` | `false` | Disable IPv6 |
| `hardening_disable_wireless` | `false` | Disable wireless interfaces |
| `hardening_disable_uncommon_protocols` | `true` | Disable DCCP, SCTP, RDS, TIPC |

### Service Hardening

| Variable | Default | Description |
|----------|---------|-------------|
| `hardening_disable_services` | `[avahi-daemon, cups, ...]` | Services to disable |
| `hardening_enable_auditd` | `true` | Enable audit daemon |

See `inventory/group_vars/all.yml` for all configuration options.

## Roles

### system_prepare
Prepares the system for hardening by updating package caches and installing essential tools.

### ssh_hardening
Configures SSH daemon with secure settings, disabling weak ciphers and protocols.

### user_auth_hardening
Implements password policies, account lockout, and PAM configuration.

### filesystem_hardening
Secures mount options, file permissions, and disables unnecessary filesystems.

### network_hardening
Configures firewall, network stack parameters, and disables IP forwarding.

### kernel_hardening
Applies kernel security parameters, enables ASLR, and configures SELinux/AppArmor.

### service_hardening
Disables unnecessary services and configures secure service defaults.

### audit_logging
Configures auditd, rsyslog, journald, and AIDE for system monitoring.

## Testing with Molecule

This playbook includes Molecule tests for validation:

```bash
# Install molecule
pip3 install molecule molecule-docker

# Run tests
cd roles/ssh_hardening
molecule test

# Test all roles
for role in roles/*/; do
    cd "$role" && molecule test && cd ../..
done
```

## Verification

After applying the hardening playbook, verify the security posture:

### Install Lynis

```bash
# Ubuntu/Debian
sudo apt install lynis

# RHEL/CentOS/Amazon Linux
sudo yum install lynis

# Or download directly
git clone https://github.com/CISOfy/lynis
cd lynis && sudo ./lynis audit system
```

### Run Lynis Audit

```bash
sudo lynis audit system --quick
```

Expected result: **Hardening index of 80 or higher**

## Security Considerations

⚠️ **Important Notes:**

1. **Test First**: Always test in a non-production environment before applying to production systems
2. **Backup**: Create backups of critical systems before hardening
3. **SSH Keys**: Ensure SSH key-based authentication is configured before disabling password authentication
4. **Firewall**: Configure firewall rules carefully to avoid losing access
5. **Reboot Required**: Some changes require a system reboot to take full effect
6. **Application Impact**: Hardening may affect application compatibility - test thoroughly

## Troubleshooting

### Lost SSH Access

If you lose SSH access after hardening:

1. Use console access (cloud provider console, IPMI, etc.)
2. Check SSH service status: `systemctl status sshd`
3. Review SSH logs: `journalctl -u sshd -n 50`
4. Verify firewall rules allow SSH: `ufw status` or `firewall-cmd --list-all`

### Playbook Failures

```bash
# Run with verbose output
ansible-playbook -i inventory/hosts hardening.yml -vvv

# Check specific role
ansible-playbook -i inventory/hosts hardening.yml --tags ssh -vvv
```

### Rollback Changes

Some changes include backups:
- SSH config: `/etc/ssh/sshd_config.backup`

To revert:
```bash
sudo cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config
sudo systemctl restart sshd
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes with Molecule
4. Submit a pull request

## License

This project is released into the public domain under the [Unlicense](LICENSE).

## References

- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [NIST Security Guide](https://www.nist.gov/cybersecurity)
- [Lynis Documentation](https://cisofy.com/lynis/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Linux Security Hardening](https://www.kernel.org/doc/html/latest/admin-guide/security-bugs.html)

## Support

For issues and questions:
- Open an issue on GitHub
- Review existing issues and documentation

## Acknowledgments

Built with Ansible and tested with Molecule for reliable Linux system hardening.
