# Quick Reference Guide

## Installation

```bash
git clone https://github.com/ruslanstarikov/hardening-playbook.git
cd hardening-playbook
ansible-galaxy collection install -r requirements.yml
```

## Basic Commands

### Check Connectivity
```bash
ansible -i inventory/hosts all -m ping
```

### Syntax Check
```bash
ansible-playbook hardening.yml --syntax-check
```

### Dry Run
```bash
ansible-playbook -i inventory/hosts hardening.yml --check --diff
```

### Apply Hardening
```bash
ansible-playbook -i inventory/hosts hardening.yml
```

## Tag-Based Execution

| Tag | Description |
|-----|-------------|
| `system` | System preparation |
| `ssh` | SSH hardening |
| `users` | User hardening |
| `auth` | Authentication config |
| `filesystem` | Filesystem hardening |
| `network` | Network hardening |
| `kernel` | Kernel hardening |
| `services` | Service hardening |
| `audit` | Audit configuration |
| `logging` | Logging configuration |

### Examples
```bash
# SSH only
ansible-playbook -i inventory/hosts hardening.yml --tags ssh

# Multiple tags
ansible-playbook -i inventory/hosts hardening.yml --tags "ssh,network"

# Skip tags
ansible-playbook -i inventory/hosts hardening.yml --skip-tags audit
```

## Common Variables

### SSH Configuration
```yaml
hardening_ssh_port: 22
hardening_ssh_permit_root_login: "no"
hardening_ssh_password_authentication: "no"
hardening_ssh_max_auth_tries: 3
```

### Password Policies
```yaml
hardening_password_max_days: 90
hardening_password_min_length: 14
hardening_password_remember: 5
```

### Network Settings
```yaml
hardening_disable_ipv6: false
hardening_disable_uncommon_protocols: true
```

## Limiting Execution

### By Host
```bash
ansible-playbook -i inventory/hosts hardening.yml --limit webserver1
```

### By Pattern
```bash
ansible-playbook -i inventory/hosts hardening.yml --limit "web*"
```

### By Group
```bash
ansible-playbook -i inventory/hosts hardening.yml --limit webservers
```

## Verification Commands

### Check SSH Config
```bash
ansible -i inventory/hosts all -b -m shell -a "sshd -T | grep permitrootlogin"
```

### Check Kernel Parameters
```bash
ansible -i inventory/hosts all -b -m shell -a "sysctl net.ipv4.ip_forward"
```

### Check Firewall
```bash
# Ubuntu
ansible -i inventory/hosts ubuntu_servers -b -m shell -a "ufw status"

# RHEL/CentOS
ansible -i inventory/hosts rhel_servers -b -m shell -a "firewall-cmd --list-all"
```

### Run Lynis Audit
```bash
ansible -i inventory/hosts all -b -m shell -a "lynis audit system --quick"
```

## Makefile Shortcuts

```bash
make help          # Show all targets
make install       # Install collections
make check         # Check connectivity
make syntax        # Syntax check
make dry-run       # Check mode
make apply         # Apply hardening
make apply-ssh     # SSH only
make verify        # Run Lynis
make reboot        # Reboot all hosts
```

## Troubleshooting

### Verbose Output
```bash
ansible-playbook -i inventory/hosts hardening.yml -vvv
```

### Step-by-Step
```bash
ansible-playbook -i inventory/hosts hardening.yml --step
```

### Start at Task
```bash
ansible-playbook -i inventory/hosts hardening.yml --start-at-task="task name"
```

### Check Variable
```bash
ansible -i inventory/hosts all -m debug -a "var=hardening_ssh_port"
```

## File Locations

| File | Purpose |
|------|---------|
| `hardening.yml` | Main playbook |
| `inventory/hosts` | Inventory file |
| `inventory/group_vars/all.yml` | Global variables |
| `roles/*/tasks/main.yml` | Role tasks |
| `requirements.yml` | Ansible collections |

## Emergency Procedures

### Lost SSH Access

1. Use console access (cloud console, IPMI)
2. Check SSH status: `systemctl status sshd`
3. Review SSH config: `/etc/ssh/sshd_config`
4. Restore backup: `cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config`
5. Restart SSH: `systemctl restart sshd`

### Rollback SSH Changes
```bash
ansible -i inventory/hosts all -b -m shell -a "cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config && systemctl restart sshd"
```

### Disable Firewall (Emergency)
```bash
# Ubuntu
ansible -i inventory/hosts ubuntu_servers -b -m shell -a "ufw disable"

# RHEL/CentOS
ansible -i inventory/hosts rhel_servers -b -m shell -a "systemctl stop firewalld"
```

## Security Levels

### Strict (High Security)
```bash
ansible-playbook -i inventory/hosts hardening.yml -e @examples/strict-hardening.yml
```

### Moderate (Balanced)
```bash
ansible-playbook -i inventory/hosts hardening.yml -e @examples/moderate-hardening.yml
```

## Post-Hardening Checklist

- [ ] Verify SSH access works
- [ ] Check application functionality
- [ ] Review system logs
- [ ] Run Lynis audit (target: 80+)
- [ ] Test firewall rules
- [ ] Verify backups
- [ ] Document changes
- [ ] Update runbooks
- [ ] Schedule reboot if needed
- [ ] Monitor for issues

## Useful One-Liners

### Gather Facts
```bash
ansible -i inventory/hosts all -m setup | grep ansible_distribution
```

### Check Uptime
```bash
ansible -i inventory/hosts all -m shell -a "uptime"
```

### List Users
```bash
ansible -i inventory/hosts all -b -m shell -a "cat /etc/passwd"
```

### Check Disk Usage
```bash
ansible -i inventory/hosts all -m shell -a "df -h"
```

### List Open Ports
```bash
ansible -i inventory/hosts all -b -m shell -a "ss -tulpn"
```

### Check SELinux Status
```bash
ansible -i inventory/hosts all -b -m shell -a "getenforce"
```

## Configuration Examples

### Override SSH Port
```bash
ansible-playbook -i inventory/hosts hardening.yml -e "hardening_ssh_port=2222"
```

### Disable IPv6
```bash
ansible-playbook -i inventory/hosts hardening.yml -e "hardening_disable_ipv6=true"
```

### Enable Auditd
```bash
ansible-playbook -i inventory/hosts hardening.yml -e "hardening_enable_auditd=true"
```

## Resources

- 📖 [Full Documentation](README.md)
- 📘 [Usage Guide](USAGE.md)
- 🔒 [Security Policy](SECURITY.md)
- 🤝 [Contributing](CONTRIBUTING.md)
- 📋 [Changelog](CHANGELOG.md)

## Support

- GitHub Issues: Report bugs and request features
- Discussions: Ask questions and share experiences
- Documentation: Comprehensive guides and examples

---

**Remember**: Always test in non-production environments first!
