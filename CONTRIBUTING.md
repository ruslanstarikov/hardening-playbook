# Contributing to Linux Hardening Playbook

Thank you for considering contributing to the Linux Hardening Playbook! This document provides guidelines for contributing.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the [Issues](https://github.com/ruslanstarikov/hardening-playbook/issues) section
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - OS and version information
   - Ansible version

### Contributing Code

1. **Fork the Repository**
   ```bash
   git clone https://github.com/ruslanstarikov/hardening-playbook.git
   cd hardening-playbook
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bugfix-name
   ```

3. **Make Your Changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Update documentation if needed

4. **Test Your Changes**
   ```bash
   # Syntax check
   ansible-playbook hardening.yml --syntax-check

   # Lint with ansible-lint (if available)
   ansible-lint hardening.yml

   # Test with molecule (if available)
   molecule test
   ```

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

   Commit message format:
   - `feat: Add new feature`
   - `fix: Fix bug in SSH hardening`
   - `docs: Update README`
   - `test: Add molecule tests`
   - `refactor: Improve code structure`

6. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a Pull Request on GitHub.

## Development Guidelines

### Code Style

- Use 2 spaces for indentation in YAML files
- Follow Ansible best practices
- Use meaningful variable names
- Add comments for complex tasks
- Keep tasks idempotent

### Role Structure

```
roles/role_name/
├── tasks/
│   └── main.yml          # Main task file
├── handlers/
│   └── main.yml          # Handlers
├── templates/
│   └── config.j2         # Jinja2 templates
├── defaults/
│   └── main.yml          # Default variables
├── vars/
│   └── main.yml          # Role variables
└── meta/
    └── main.yml          # Role metadata
```

### Variables

- Prefix all variables with `hardening_`
- Use descriptive names
- Document variables in README
- Provide sensible defaults

Example:
```yaml
hardening_ssh_port: 22
hardening_ssh_permit_root_login: "no"
```

### Tasks

- One task per file when possible
- Use descriptive task names
- Add tags for selective execution
- Use `changed_when` and `failed_when` appropriately

Example:
```yaml
- name: Configure SSH daemon port
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#?Port'
    line: 'Port {{ hardening_ssh_port }}'
    validate: '/usr/sbin/sshd -t -f %s'
  notify: restart sshd
  tags: ['ssh', 'network']
```

### Testing

#### Manual Testing

1. Create a test VM or container
2. Run the playbook
3. Verify changes
4. Check Lynis score

```bash
# Run playbook
ansible-playbook -i inventory/hosts hardening.yml

# Verify with Lynis
sudo lynis audit system --quick
```

#### Molecule Testing

If molecule is installed:

```bash
# Test all scenarios
molecule test

# Test specific scenario
molecule test -s default

# Debug with converge
molecule converge
molecule verify
```

### Documentation

Update documentation when:
- Adding new roles or features
- Changing default behavior
- Adding new variables
- Modifying configuration options

Files to update:
- `README.md` - Main documentation
- `USAGE.md` - Usage examples
- Role `README.md` files
- Variable documentation

### Multi-Distribution Support

When adding features, ensure they work on all supported platforms:

- Ubuntu 20.04, 22.04
- RHEL 7, 8, 9
- CentOS 7, 8
- Amazon Linux 2, 2023
- OpenSUSE Leap 15.x

Use conditional tasks:
```yaml
- name: Install package (Debian/Ubuntu)
  apt:
    name: package-name
    state: present
  when: ansible_os_family == "Debian"

- name: Install package (RedHat/CentOS)
  yum:
    name: package-name
    state: present
  when: ansible_os_family == "RedHat"
```

## Pull Request Process

1. **PR Description**
   - Describe what changes you made
   - Explain why the changes are needed
   - Reference related issues

2. **Checklist**
   - [ ] Code follows style guidelines
   - [ ] All tests pass
   - [ ] Documentation updated
   - [ ] Tested on multiple distributions
   - [ ] Commit messages are clear

3. **Review Process**
   - Maintainers will review your PR
   - Address any feedback
   - Once approved, PR will be merged

## Security Issues

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email the maintainers directly
3. Provide detailed information
4. Wait for acknowledgment before public disclosure

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the community

## Questions?

If you have questions:
- Open a discussion on GitHub
- Check existing issues and documentation
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the Unlicense.

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

Thank you for contributing to making Linux systems more secure!
