# install tenable agent

```
#!/usr/bin/env ansible-playbook
---
- hosts: test-centos8-cis
  gather_facts: false
  remote_user: centos
  become: yes


  tasks:
    - copy:
        src: /Users/lowlh/Downloads/NessusAgent-8.2.3-es7.x86_64.rpm
        dest: /tmp/NessusAgent-8.2.3-es7.x86_64.rpm

    - yum:
        name: /tmp/NessusAgent-8.2.3-es7.x86_64.rpm
        state: present

    - name: link agent
      ansible.builtin.shell: rm /etc/tenable
      ansible.builtin.shell: /opt/nessus_agent/sbin/nessuscli agent link --key=d17b85446b397bbaa0f8510e6e519929e8a130e9c642dd44da4ae650c334398c --host=cloud.tenable.com --port=443 --groups="Enterprise_Image_Validation_CENTOS8"
      ```
