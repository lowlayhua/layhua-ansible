# TO remember
```
file:
  setype: httpd_sys_content_t

ansible-vault create vault.yaml --vault-password-file=secret.txt

```

# vimrc
`autocmd FileType yaml setlocal ai ts=2 sw=2 et`

# Check Syntax
`ansible-playbook --syntax-check site.yaml`


# ansible.cfg
- copy from /etc/ansible.cfg 
- `ansible-config list`
- `ansible-config view`
- `ansible-doc -l | grep line`

# adhoc.sh
```
#!/bin/bash
ansible localhost -m yum_repository -a 'name="epel"
description="EPEL YUM repo"
baseurl="https://download.fedoraproject.org/pub/epel/$releasever/$basearch/
gpgkey=no
enabled=no"' -b

```
# requirements.yml
```
---
- src: http:///xxx
  name: xxx
```
- `ansible-galaxy install -r requirements.yml -p ~/ansible/roles`

# create role
- `ansible-galaxy init apache`
- `ansible-galaxy install linux-system-roles.timesync`



### hosts.j2
```
{% for host in groups['all'] %}
{{ hostvars[host]['ansible_facts']['default_ipv4']['address'] }} {{ hostvars[host]['ansible_facts']['fqdn'] }} {{ hostvars[host]['ansible_facts']['hostname'] }}
{% endfor %}
```
### hosts.yaml
```
---
- name: generate hosts
  hosts: all
  tasks:

    - template:
        src: hosts.j2
        dest: /tmp/myhosts
      when: inventory_hostname in groups['dev']
      
```

# 5. apache
```
cat roles/apache/templates/template.j2
My host is {{ ansible_hostname }} on {{ ansible_default_ipv4.address }}
```
```
---
# tasks file for apache
- name: install apache
  yum:
    name: httpd
    state: latest

- name: start httpd
  service:
    name: httpd
    state: started
    enabled: yes

- name: index.html
  template:
    src: template.j2
    dest: /var/www/html/index.html
    
```
```
more Q5.yaml
---
- name: dev
  hosts: dev
  become: yes
  roles:
    - apache
```

# 7. rhel-system-roles

- `sudo yum install rhel-system-roles`
- read /usr/share/ansible/roles/rhel-system-roles.selinux

### SELINUX
```
---
- name: configure selinux
  hosts: localhost
  become: yes
  vars:
    - selinux_state: enforcing
  roles:
    - rhel-system-roles.selinux
    
```

### chrony
- read /usr/share/ansible/roles/rhel-system-roles.timesync
```
---
- name: site
  hosts: localhost
  become: yes
  vars:
    timesync_ntp_servers:
      - hostname: ntp2.singnet.com.sg
        iburst: true
  roles:
    - rhel-system-roles.timesync
```

# 8. packages.yaml
# 9. webcontent
```
---
- name: webcontent
  hosts: dev
  tasks:
    - name: create dir
      file:
        path: /devweb
        state: directory
        group: root
        mode: '2775'
        setype: httpd_sys_content_t

    - name: create a file
      file:
        path: /devweb/index.html
        state: touch

    - name: create index.html
      copy:
        content: "Development\n"
        dest: /var/www/html/index.html


    - name: link the directory
      file:
        src: /devweb
        dest: /var/www/html/devweb
        state: link
 ```
# 10. hwreport.yaml
```
---
- name: copy
  copy:
    dest: /tmp/hwreport2.txt
    content: |
      #hwreport
      HOSTNAME={{ ansible_hostname }}
      MEMORY={{ ansible_memtotal_mb }}
      BIOS={{ ansible_bios_version }}
      CPU={{ ansible_processor[2] }}
      DISK0={{ ansible_devices.xvda.size }}
#      DISK1={{ ansible_devices['nvme1n1']['size'] }}
#      DISK1={{ ansible_devices.nvme1n1.size }}
```
