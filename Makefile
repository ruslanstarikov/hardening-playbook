.PHONY: help install check syntax lint test dry-run apply verify clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install required Ansible collections
	ansible-galaxy collection install -r requirements.yml

check: ## Check connectivity to all hosts
	ansible -i inventory/hosts all -m ping

syntax: ## Check playbook syntax
	ansible-playbook hardening.yml --syntax-check

lint: ## Lint playbook with ansible-lint (requires ansible-lint)
	@which ansible-lint > /dev/null || (echo "ansible-lint not found. Install with: pip install ansible-lint" && exit 1)
	ansible-lint hardening.yml

test: ## Run molecule tests (requires molecule)
	@which molecule > /dev/null || (echo "molecule not found. Install with: pip install molecule molecule-docker" && exit 1)
	molecule test

dry-run: ## Run playbook in check mode (dry run)
	ansible-playbook -i inventory/hosts hardening.yml --check --diff

apply: ## Apply hardening to all hosts
	ansible-playbook -i inventory/hosts hardening.yml

apply-ssh: ## Apply only SSH hardening
	ansible-playbook -i inventory/hosts hardening.yml --tags ssh

apply-network: ## Apply only network hardening
	ansible-playbook -i inventory/hosts hardening.yml --tags network

apply-kernel: ## Apply only kernel hardening
	ansible-playbook -i inventory/hosts hardening.yml --tags kernel

verify: ## Verify hardening with Lynis (requires Lynis on target hosts)
	ansible -i inventory/hosts all -b -m shell -a "lynis audit system --quick"

facts: ## Gather and display hardening facts
	ansible -i inventory/hosts all -m setup -a "filter=ansible_local"

reboot: ## Reboot all hosts
	ansible -i inventory/hosts all -b -m reboot

clean: ## Clean temporary files
	find . -type f -name '*.retry' -delete
	find . -type d -name '__pycache__' -exec rm -rf {} +
	find . -type d -name '.pytest_cache' -exec rm -rf {} +
	rm -rf .molecule/
	rm -rf .cache/
