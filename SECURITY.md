# Security Policy

## Overview

The Linux Hardening Playbook is designed to improve the security posture of Linux systems. This document outlines our security practices and how to report vulnerabilities.

## Supported Versions

We support the latest version of the playbook and provide security updates for:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Supported Operating Systems

This playbook is tested and supported on:

- Ubuntu 20.04 LTS (Focal Fossa)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Red Hat Enterprise Linux 7, 8, 9
- CentOS 7, 8
- Amazon Linux 2, 2023
- OpenSUSE Leap 15.x, Tumbleweed

## Security Features

### SSH Hardening
- Disables root login
- Enforces key-based authentication
- Configures secure ciphers and MACs
- Limits authentication attempts
- Sets connection timeouts

### User & Authentication
- Strong password policies (minimum length, complexity)
- Password aging and history
- PAM configuration for failed login lockout
- Proper file permissions on sensitive files
- Session timeout configuration

### Filesystem Security
- Secure mount options (noexec, nodev, nosuid)
- File integrity monitoring with AIDE
- Proper permissions on critical files
- Disabled USB storage
- Restricted uncommon filesystems

### Network Security
- Firewall configuration (UFW/firewalld)
- IP forwarding disabled
- ICMP redirects disabled
- TCP SYN cookies enabled
- Reverse path filtering
- Martian packet logging

### Kernel Hardening
- ASLR (Address Space Layout Randomization)
- Kernel pointer hiding (kptr_restrict)
- Ptrace restrictions
- Core dump restrictions
- SELinux/AppArmor enforcement

### Audit & Logging
- Comprehensive auditd rules
- System call auditing
- File access monitoring
- User activity tracking
- Log integrity protection

## Security Considerations

### Before Applying

1. **Backup Critical Systems**: Always create backups before hardening
2. **Test Environment**: Test in non-production first
3. **SSH Keys**: Ensure SSH key authentication is configured
4. **Network Access**: Verify you won't lose access due to firewall rules
5. **Application Compatibility**: Check application requirements

### After Applying

1. **Verify Access**: Ensure you can still access the system
2. **Test Applications**: Verify all applications work correctly
3. **Monitor Logs**: Check for any unexpected behavior
4. **Lynis Audit**: Run Lynis to verify hardening score
5. **Document Changes**: Keep records of applied configurations

### Known Limitations

1. **Service Disruption**: Some hardening may affect running services
2. **Application Compatibility**: Strict settings may break some applications
3. **Performance**: Some security features may impact performance
4. **Maintenance**: Hardened systems require more careful maintenance

## Reporting a Vulnerability

If you discover a security vulnerability in this playbook, please help us by reporting it responsibly.

### How to Report

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead:

1. **Email**: Send details to the repository maintainers
2. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)
   - Your contact information

### What to Expect

1. **Acknowledgment**: We'll acknowledge receipt within 48 hours
2. **Assessment**: We'll assess the vulnerability and determine severity
3. **Fix**: We'll work on a fix if the vulnerability is confirmed
4. **Disclosure**: We'll coordinate disclosure timing with you
5. **Credit**: We'll credit you in the security advisory (if desired)

### Security Advisory Process

1. Vulnerability reported
2. Severity assessment (Critical, High, Medium, Low)
3. Fix developed and tested
4. Security advisory published
5. Fix released
6. Public disclosure after fix is available

## Security Best Practices

### Deployment

1. **Review Configuration**: Review all variables before applying
2. **Staged Rollout**: Apply hardening in stages
3. **Tag-Based Execution**: Use tags to apply specific hardening
4. **Version Control**: Keep inventory and configs in version control
5. **Change Management**: Follow change management procedures

### Maintenance

1. **Regular Audits**: Run Lynis audits regularly
2. **Keep Updated**: Update playbook to latest version
3. **Monitor Logs**: Regularly review audit and system logs
4. **Security Patches**: Keep systems patched
5. **Review Settings**: Periodically review hardening settings

### Compliance

This playbook helps achieve compliance with:

- CIS Benchmarks
- NIST Cybersecurity Framework
- PCI DSS requirements
- HIPAA security requirements
- SOC 2 security controls
- ISO 27001 standards

Note: This playbook is a tool to help achieve compliance but doesn't guarantee it. Always verify requirements with compliance auditors.

## Security Testing

### Automated Testing

- Syntax validation
- Ansible-lint checks
- Molecule tests
- CI/CD pipeline validation

### Manual Testing

- Lynis security audit
- OpenSCAP security scans
- Manual configuration review
- Penetration testing (recommended)

### Recommended Tools

- **Lynis**: System auditing and hardening
- **OpenSCAP**: Security compliance
- **Nessus**: Vulnerability scanning
- **OSSEC**: Host-based intrusion detection
- **Tripwire**: File integrity monitoring

## Security Resources

### Documentation
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [NIST Security Guide](https://www.nist.gov/cybersecurity)
- [Lynis Documentation](https://cisofy.com/lynis/)
- [Red Hat Security Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/)
- [Ubuntu Security](https://ubuntu.com/security)

### Security Advisories
- [Red Hat Security Advisories](https://access.redhat.com/security/security-updates/)
- [Ubuntu Security Notices](https://ubuntu.com/security/notices)
- [Debian Security Advisories](https://www.debian.org/security/)

### Community
- GitHub Discussions
- Security mailing lists
- DevSecOps communities

## Disclaimer

This playbook provides security hardening configurations but:

- Does not guarantee complete security
- Should be part of a comprehensive security strategy
- Requires regular maintenance and updates
- May need customization for specific environments
- Should be tested before production deployment

Security is an ongoing process, not a one-time configuration.

## License

This security policy is released under the Unlicense, same as the project.

## Contact

For security concerns, please reach out through:
- GitHub repository issues (for non-sensitive topics)
- Direct contact with maintainers (for vulnerabilities)

Thank you for helping keep this project and its users secure!
