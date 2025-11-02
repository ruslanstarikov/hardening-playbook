# Usage Guide

This guide provides detailed instructions for using the Linux Hardening Playbook.

## Table of Contents

1. [Installation](#installation)
2. [Basic Usage](#basic-usage)
3. [Advanced Configuration](#advanced-configuration)
4. [Tag-Based Execution](#tag-based-execution)
5. [Multi-Environment Setup](#multi-environment-setup)
6. [Selective Hardening](#selective-hardening)
7. [Verification](#verification)

## Installation

### Prerequisites

Ensure you have the following installed:

```bash
# Check Ansible version (2.9+ required)
ansible --version

# Check Python version (3.6+ required)
python3 --version
```

### Setup

1. Clone the repository:
```bash
git clone https://github.com/ruslanstarikov/hardening-playbook.git
cd hardening-playbook
```

2. Install required Ansible collections:
```bash
ansible-galaxy collection install -r requirements.yml
```

3. Verify installation:
```bash
ansible-playbook --version
```

## Basic Usage

### Step 1: Configure Inventory

Edit `inventory/hosts` to define your servers:

```ini
[all:vars]
ansible_python_interpreter=/usr/bin/python3

[production_servers]
web01 ansible_host=192.168.1.10
web02 ansible_host=192.168.1.11
db01 ansible_host=192.168.1.20

[staging_servers]
stage01 ansible_host=192.168.2.10
```

### Step 2: Test Connectivity

```bash
ansible -i inventory/hosts all -m ping
```

### Step 3: Dry Run

Always perform a dry run first:

```bash
ansible-playbook -i inventory/hosts hardening.yml --check --diff
```

### Step 4: Apply Hardening

```bash
ansible-playbook -i inventory/hosts hardening.yml
```

### Step 5: Reboot Systems

Some changes require a reboot:

```bash
ansible -i inventory/hosts all -b -m reboot
```

## Advanced Configuration

### Custom Variables Per Host

Create host-specific variables in `inventory/host_vars/`:

```bash
# inventory/host_vars/web01.yml
hardening_ssh_port: 2222
hardening_ssh_allowed_users:
  - deploy
  - admin
```

### Group-Specific Variables

Create group-specific variables in `inventory/group_vars/`:

```bash
# inventory/group_vars/production_servers.yml
hardening_ssh_password_authentication: "no"
hardening_enable_auditd: true

# inventory/group_vars/staging_servers.yml
hardening_ssh_password_authentication: "yes"
hardening_enable_auditd: false
```

### Override Default Variables

You can override defaults using extra vars:

```bash
ansible-playbook -i inventory/hosts hardening.yml \
  -e "hardening_ssh_port=2222" \
  -e "hardening_password_max_days=60"
```

## Tag-Based Execution

Execute specific hardening tasks using tags:

### SSH Hardening Only

```bash
ansible-playbook -i inventory/hosts hardening.yml --tags ssh
```

### Multiple Tags

```bash
ansible-playbook -i inventory/hosts hardening.yml --tags "ssh,network,kernel"
```

### Skip Specific Tags

```bash
ansible-playbook -i inventory/hosts hardening.yml --skip-tags "audit,logging"
```

### List Available Tags

```bash
ansible-playbook -i inventory/hosts hardening.yml --list-tags
```

## Multi-Environment Setup

### Directory Structure

```
hardening-playbook/
├── inventory/
│   ├── production/
│   │   ├── hosts
│   │   └── group_vars/
│   │       └── all.yml
│   ├── staging/
│   │   ├── hosts
│   │   └── group_vars/
│   │       └── all.yml
│   └── development/
│       ├── hosts
│       └── group_vars/
│           └── all.yml
```

### Run Against Specific Environment

```bash
# Production
ansible-playbook -i inventory/production/hosts hardening.yml

# Staging
ansible-playbook -i inventory/staging/hosts hardening.yml

# Development
ansible-playbook -i inventory/development/hosts hardening.yml
```

## Selective Hardening

### Limit to Specific Hosts

```bash
ansible-playbook -i inventory/hosts hardening.yml --limit web01,web02
```

### Limit to Host Pattern

```bash
ansible-playbook -i inventory/hosts hardening.yml --limit "web*"
```

### Limit to Groups

```bash
ansible-playbook -i inventory/hosts hardening.yml --limit production_servers
```

## Verification

### Check Ansible Facts

```bash
ansible -i inventory/hosts all -m setup -a "filter=ansible_local"
```

### Verify SSH Configuration

```bash
ansible -i inventory/hosts all -b -m shell -a "sshd -T | grep -E 'permitrootlogin|passwordauthentication'"
```

### Verify Kernel Parameters

```bash
ansible -i inventory/hosts all -b -m shell -a "sysctl net.ipv4.ip_forward"
```

### Run Lynis Audit

```bash
ansible -i inventory/hosts all -b -m shell -a "lynis audit system --quick"
```

### Check Auditd Status

```bash
ansible -i inventory/hosts all -b -m shell -a "auditctl -l"
```

### Verify Firewall Status

```bash
# Ubuntu/Debian
ansible -i inventory/hosts ubuntu_servers -b -m shell -a "ufw status"

# RHEL/CentOS/Amazon Linux
ansible -i inventory/hosts rhel_servers -b -m shell -a "firewall-cmd --list-all"
```

## Common Scenarios

### Scenario 1: Harden New Web Servers

```bash
# 1. Add servers to inventory
# 2. Test connectivity
ansible -i inventory/hosts new_webservers -m ping

# 3. Apply hardening
ansible-playbook -i inventory/hosts hardening.yml --limit new_webservers

# 4. Reboot
ansible -i inventory/hosts new_webservers -b -m reboot

# 5. Verify with Lynis
ansible -i inventory/hosts new_webservers -b -m shell -a "lynis audit system --quick"
```

### Scenario 2: Update SSH Configuration

```bash
# 1. Update variables
# Edit inventory/group_vars/all.yml

# 2. Apply only SSH hardening
ansible-playbook -i inventory/hosts hardening.yml --tags ssh

# 3. Verify SSH service
ansible -i inventory/hosts all -b -m systemd -a "name=sshd state=restarted"
```

### Scenario 3: Incremental Hardening

```bash
# Week 1: SSH and User hardening
ansible-playbook -i inventory/hosts hardening.yml --tags "ssh,users,auth"

# Week 2: Network hardening
ansible-playbook -i inventory/hosts hardening.yml --tags network

# Week 3: Kernel and filesystem hardening
ansible-playbook -i inventory/hosts hardening.yml --tags "kernel,filesystem"

# Week 4: Services and audit
ansible-playbook -i inventory/hosts hardening.yml --tags "services,audit,logging"
```

## Troubleshooting

### Enable Verbose Output

```bash
# Level 1
ansible-playbook -i inventory/hosts hardening.yml -v

# Level 2
ansible-playbook -i inventory/hosts hardening.yml -vv

# Level 3 (very detailed)
ansible-playbook -i inventory/hosts hardening.yml -vvv
```

### Step-by-Step Execution

```bash
ansible-playbook -i inventory/hosts hardening.yml --step
```

### Start at Specific Task

```bash
ansible-playbook -i inventory/hosts hardening.yml --start-at-task="Configure SSH daemon"
```

### Debug Variable Values

```bash
ansible -i inventory/hosts all -m debug -a "var=hardening_ssh_port"
```

## Best Practices

1. **Always test in non-production first**
2. **Use version control for inventory and variables**
3. **Document custom configurations**
4. **Maintain backups before hardening**
5. **Use tags for incremental hardening**
6. **Verify changes with Lynis after each run**
7. **Keep SSH key-based access configured**
8. **Monitor system logs after hardening**
9. **Test application functionality after hardening**
10. **Schedule regular hardening audits**

## Next Steps

After successful hardening:

1. Run Lynis audit to verify hardening score
2. Document any custom configurations
3. Set up monitoring and alerting
4. Schedule regular security audits
5. Keep the playbook updated with security patches
6. Review and adjust hardening based on application requirements
