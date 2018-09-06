#!/usr/env bash
cat << EOF > test.yml
---
- hosts: all
  tasks:
    - copy:
        content: ''
        dest: "~/dist_info.txt"
      delegate_to: 127.0.0.1
    - lineinfile:
        dest: "~/dist_info.txt"
        line: |
          Hostname: \t\t{{ inventory_hostname }}
          Distribution: \t\t{{ ansible_distribution }}
          Dist Major Version: \t{{ ansible_distribution_major_version }}
          Ansible Dist Version: \t{{ ansible_distribution_version }}
          Ansible Dist Release: \t{{ ansible_distribution_release }}
      delegate_to: 127.0.0.1
EOF
ansible-playbook test.yml -c local -i "localhost," &> /dev/null
cat dist_info.txt
rm dist_info.txt
rm test.yml
