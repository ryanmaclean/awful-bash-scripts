#!/usr/bin/env bash
cat << EOF > test.yml
---
- hosts: all
  vars:
    dest: ~/dist_info.txt
  tasks:
    - copy:
        content: ''
        dest: "{{ dest }}"
      run_once: yes
      delegate_to: 127.0.0.1
    - lineinfile:
        dest: "{{ dest }}"
        line: 'Hostname: \t\t{{ inventory_hostname }}\nDistribution: \t\t{{ ansible_distribution }}\nDist Major Version: \t{{ ansible_distribution_major_version }}\nAnsible Dist Version: \t{{ ansible_distribution_version }}\nAnsible Dist Release: \t{{ ansible_distribution_release }}'
      delegate_to: 127.0.0.1
EOF
sudo ansible-playbook test.yml -c local -i "localhost,"
cat dist_info.txt
