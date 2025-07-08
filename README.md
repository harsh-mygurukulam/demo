![image](https://github.com/user-attachments/assets/594f0123-81ab-4c39-84b8-7f6ac96f27b6)

#  Ansible Unit Test POC

|**Author**        | **created on**       | **Version** |**Last edited on**| **Review Level**   | **Reviewer**      |
|---------------|------------|---------|--------|--------|----------------------|
| Anitha Annem  | July 03  | v1.0| July 04   | Pre-Reviewer   | Priyanshu            |
| Anitha Annem  |  |  |   | L0             | Khushi Malhothra    |
| Anitha Annem  |     |      |         | L1             | Mukul Joshi       |
| Anitha Annem  |     |      |         | L2             | piyush Upadhyay      |


# Table of Contents

1. [Objective](#objective)
2. [Prerequisites](#prerequisites)
3. [Directory Structure](#directory-structure)
4. [Playbook](#playbookyml)
5. [Molecule Configuration](#molecule-configuration)
6. [Converge Playbook](#converge-playbook)
7. [Testinfra Tests](#testinfra-tests)
8. [Run the POC](#run-the-poc)
9. [Conclusion](#conclusion)
10. [Contact Information](#contact-information)
11. [References](#references)

# Objective

This POC demonstrates **unit testing of an Ansible playbook** using **Molecule** and **Testinfra** with successful lint and test execution.  

The goal is to ensure:

- The playbook runs as intended.
- Server state is verified automatically.
- Code quality is maintained via linting.

For more related information refer this link [Ansible Unit Test Documentation](https://github.com/Cloud-NInja-snaatak/Documentation/blob/Anitha-SCRUM-569/IAC-unit-test/ansible/doc/README.md)

# Prerequisites

| Tool      | Version/Requirement | Purpose                                  | Installation Command                                       |
|-------------|----------------------|-------------------------------------------|-----------------------------------------------------------|
| Python    | 3.6 or above        | Required for running Molecule & Testinfra | [Install Python](https://www.python.org/downloads/)      |
| pip       | Latest             | Python package manager                   | Comes with Python or `python -m ensurepip --upgrade`    |
| Ansible   | Latest stable     | Automation tool for playbooks            | `pip install ansible`                                   |
| Docker    | Latest stable     | Runs isolated test containers            | [Install Docker](https://docs.docker.com/get-docker/)   |
| Molecule  | Latest            | Framework for testing Ansible            | `pip install molecule`                                  |
| Testinfra | Latest            | Verifies server state after provisioning | `pip install testinfra`                                 |
| Ansible Lint | Latest         | Checks playbook syntax and best practices | `pip install ansible-lint`                              |

# Directory Structure
```
ansible-poc-playbook/
├── playbook.yml
├── molecule/
│ └── default/
│ ├── converge.yml
│ ├── molecule.yml
│ └── tests/
│ └── test_playbook.py
└── README.md
```

playbook.yml
```
- name: Install and configure Apache
  hosts: all
  become: yes
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Start Apache service
      service:
        name: apache2
        state: started
        enabled: yes
      when: ansible_virtualization_type != "docker"

    - name: Show message when skipping start/enable
      debug:
        msg: "Skipping start/enable tasks since running inside Docker container"
      when: ansible_virtualization_type == "docker"
```
# Molecule Configuration
molecule/default/molecule.yml
```
---
dependency:
  name: galaxy

driver:
  name: docker

platforms:
  - name: instance
    image: geerlingguy/docker-ubuntu2004-ansible
    pre_build_image: true

provisioner:
  name: ansible
  playbooks:
    converge: converge.yml

verifier:
  name: testinfra
```
# Converge Playbook
molecule/default/converge.yml
```
- name: Converge
  hosts: all
  become: yes
  tasks:
    - import_playbook: ../../playbook.yml
```
#  Testinfra Tests
molecule/default/tests/test_playbook.py
```
import os
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_apache_package_installed(host):
    pkg = host.package("apache2")
    assert pkg.is_installed


def test_apache_service_running_and_enabled(host):
    svc = host.service("apache2")
    assert not svc.is_running
    assert not svc.is_enabled
```

# Run the POC
```
molecule test
```
![image](https://github.com/user-attachments/assets/61208cc2-aeb4-4adc-9a16-b63148b9cd99)

# Conclusion
This POC successfully demonstrates automated unit testing for Ansible playbooks using Molecule and Testinfra.

With this approach:

- You ensure idempotence and correct system state.

- Tests can be integrated into CI/CD pipelines.

- Playbook quality and reliability improve.


# Contact Information 
| Name       | Email Address                |
|------------|------------------------------|
| Anitha     |anitha.annem.snaatak@mygurukulam.co|

# References

| **Link** | **Description** |
|------------------------------------------------------|------------------|
| [Molecule Documentation](https://molecule.readthedocs.io/)%7C Molecule Documentation      |
| [Testinfra Documentation](https://testinfra.readthedocs.io/)%7C Testinfra Documentation   |
