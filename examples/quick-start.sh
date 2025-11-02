#!/bin/bash
# Quick start script for Linux Hardening Playbook

set -e

echo "================================"
echo "Linux Hardening Playbook Setup"
echo "================================"
echo

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Error: Ansible is not installed."
    echo "Please install Ansible first:"
    echo "  Ubuntu/Debian: sudo apt install ansible"
    echo "  RHEL/CentOS:   sudo yum install ansible"
    echo "  Or via pip:    pip3 install ansible"
    exit 1
fi

echo "✓ Ansible found: $(ansible --version | head -1)"
echo

# Install required collections
echo "Installing required Ansible collections..."
ansible-galaxy collection install -r requirements.yml
echo "✓ Collections installed"
echo

# Test inventory
echo "Testing inventory connectivity..."
if ansible -i inventory/hosts all -m ping > /dev/null 2>&1; then
    echo "✓ All hosts are reachable"
else
    echo "⚠ Warning: Some hosts may not be reachable"
    echo "  Please check your inventory configuration"
fi
echo

# Run syntax check
echo "Checking playbook syntax..."
if ansible-playbook hardening.yml --syntax-check > /dev/null 2>&1; then
    echo "✓ Playbook syntax is valid"
else
    echo "✗ Error: Playbook syntax check failed"
    exit 1
fi
echo

echo "Setup complete!"
echo
echo "Next steps:"
echo "  1. Edit inventory/hosts to add your servers"
echo "  2. Review and customize inventory/group_vars/all.yml"
echo "  3. Run a dry-run: ansible-playbook -i inventory/hosts hardening.yml --check"
echo "  4. Apply hardening: ansible-playbook -i inventory/hosts hardening.yml"
echo "  5. Verify with Lynis: sudo lynis audit system"
echo
