# Prepare
## .vimrc
- `autocmd FileType yaml setlocal ai ts=2 sw=2 et`

# TO remember

- `ansible-vault encrypt user_password.yaml vault-password-file=secret.txt`
- `password: "{{ Password | password_hash('sha512') }}"`


## .bash_profile
alias ap='ansible-playbook'
alias aps='ansible-playbook --syntax-check'
alias av='ansible-vault'
alias adoc='ansible-doc'

# Section 1: Adhoc commands
```
#!/bin/bash
ansible all -m yum_repository -a 'baseurl=http://hqdev1.tekneed.com/rpm/AppStream description="RHEL 8 Appstream" name=RHEL_Appstream enabled=1 gpgcheck=1 gpgkey=http://hqdev1.tekneed.com/rpm/RPM-GPG-KEY-redhat-release file=rhel'

ansible all -m yum_repository -a 'baseurl=http://hqdev1.tekneed.com/rpm/BaseOS description="RHEL 8 BaseOS" name=RHEL_BaseOS enabled=1 gpgcheck=1 gpgkey=http://hqdev1.tekneed.com/rpm/RPM-GPG-KEY-redhat-release file=rhel'
```

# ----
# Recommend to Practise
- https://github.com/mateuszstompor/rhce-ex294-exam/tree/main/questions
- https://github.com/DevSecOpsGuy/EX294-1
- https://www.lisenet.com/2019/ansible-sample-exam-for-ex294/
- https://www.redhat.com/sysadmin/ansible-create-users-csv

# Loop
```
- name: Users exist and are in the correct groups
  user:
    name: "{{ item.name }}"
    state: present
    groups: "{{ item.groups }}"
  loop:
    - name: jane
      groups: wheel
    - name: joe
      groups: root
```

# Vault
https://tekneed.com/managing-ansible-secrets-with-ansible-vault-ex294/

- `ansible-vault create vault.yaml --vault-password-file=secret.txt`
- `ansible-playbook site.yml --vault-password-file ~/.vault_pass.txt`


# ansible-doc
- stat
- debug
- parted
- lvg
- lvol
- filesystem
- file
- mount
- rpm_key
- yum_repository
- authorized_key
- uri
- blockinfile
- copy
- fetch
- file
- lineinfile
- stat
- synchronize
- sefcontext



# LVM 
https://www.redhat.com/sysadmin/automating-logical-volume-manager

```
---
- name: lvm
  hosts: jump
  gather_facts: no
  ignore_errors: yes
  tasks:

    - name: create partition
      parted:
        device: /dev/xvdb
        number: 1
        flags: [ lvm ]
        state: present

    - name: Install lvm2 dependency
      package:
        name: lvm2
        state: present

    - name: create VG
      lvg:
        vg: sample-vg
        pvs: /dev/xvdb1
     

    - name: lvm
      lvol:
        vg: sample-vg
        lv: sample-lv
        size: 100m
        force: true

    - name: Filesystem xfs
      filesystem:
        dev: /dev/sample-vg/sample-lv
        fstype: xfs

    - name: create directory
      file:
        path: /data
        state: directory
        mode: '0755'
        owner: root
        group: root

    - name: mount
      mount:
        path: /data
        src: /dev/sample-vg/sample-lv
        fstype: xfs
        state: mounted
```

# lvm-extend.yaml

```
   - name: lvm
      lvol:
        vg: sample-vg
        lv: sample-lv
        size: +100%FREE
        force: true

    - name: Filesystem xfs
      filesystem:
        dev: /dev/sample-vg/sample-lv
        fstype: xfs
        resizefs: true
        
```


# Check Syntax
`ansible-playbook --syntax-check site.yaml`


# ansible.cfg
- `cp /etc/ansible/ansible.cfg .`

```
[defaults]
remote_user = devops
inventory = ./inventory
roles_path    = ~/.ansible/roles:/usr/share/ansible/roles:./roles
host_key_checking = False
[privilege_escalation]
become_user = root
become_method = sudo
become = true
```
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

### hosts.j2
- `{{ ansible_facts['default_ipv4']['address'] }}`
```
{% for host in groups['all']  %}
{{ hostvars[host]['ansible_default_ipv4']['address'] }} {{ hostvars[host]['ansible_fqdn'] }} {{ hostvars[host]['ansible_hostname'] }}
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

- `sudo dnf install rhel-system-roles`
- read /usr/share/ansible/roles/rhel-system-roles.selinux/README.md
- /usr/share/ansible/roles/rhel-system-roles.timesync/README.md

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

### timesync

```
---
- name: timesync
  hosts: localhost
  become: yes
  vars:
    timesync_ntp_servers:
      - hostname: ntp2.singnet.com.sg
        iburst: true
    timezone: Asia/Singapore

  tasks:
    - name: Set Timezone
      timezone:
        name: "{{ timezone }}"

  roles:
    - /usr/share/ansible/roles/rhel-system-roles.timesync
```
- `ansible all -a "timedatectl"`
- chronyc sources

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

# hwreport-line.yaml
```
---
- hosts: jump
  tasks:

    - name: copy
      copy:
        src: hwreport.txt
        dest: /tmp/hwreport3.txt

    - name: change HOSTNAME
      lineinfile:
        path: /tmp/hwreport3.txt
        regex: ^HOSTNAME
        line: HOSTNAME="{{ ansible_hostname }}"

    - name: change MEMORY
      lineinfile:
        path: /tmp/hwreport3.txt
        regex: ^MEMORY
        line: MEMORY="{{ ansible_memtotal_mb }}"

    - name: change BIOS
      lineinfile:
        path: /tmp/hwreport3.txt
        regex: ^BIOS
        line: BIOS="{{ ansible_bios_version }}"

    - name: change CPU
      lineinfile:
        path: /tmp/hwreport3.txt
        regex: ^CPU
        line: CPU="{{ ansible_processor[2] }}"

    - name: change HOSTNAME
      lineinfile:
        path: /tmp/hwreport3.txt
        regex: ^DISK0
        line: DISK0="{{ ansible_devices.xvda.size }}"
```
# Sudo
```
- name: Modify sudo config to allow webadmin users sudo without a password
  copy:
    content: "%webadmin ALL=(ALL) NOPASSWD: ALL"
    dest: /etc/sudoers.d/webadmin
    mode: 0440
```

```
- name: Disable root login via SSH
  lineinfile:
    dest: /etc/ssh/sshd_config
    regexp: "^PermitRootLogin"
    line: "PermitRootLogin no"
  notify: Restart sshd

 handlers:
  - name: Restart sshd
    service:
      name: sshd
      state: restarted
      
 ```
 # when
 ```
 - name: Configure sysctl para
  hosts: jump
  vars:
    ram_mb: 512

  tasks:
    - name: Ensure that server meets memory requirements
      fail:
        msg: Server should have at least {{ ram_mb }}MB of ram
      when:  ansible_memtotal_mb  < ram_mb

    - name: configure
      become: true
      sysctl:
        name: vm.swappiness
        value: '5'
        state: present
   ```
   
# Firewalld
```
    - name: fw
      firewalld:
        service: "{{ rule }}"
        permanent: true
        state: enabled
        
```

# Dump facts
```
---
- name: Fact dump
  hosts: jump
  tasks:
    - name: Print all facts
      debug:
        var: ansible_facts
```
# Troubleshooting
https://www.redhat.com/sysadmin/troubleshoot-ansible-playbooks
- `ansible-config dump -v --only-changed`

# When
```
vars:
    my_service: httpd

 when: my_service is defined
```

```
---
- name: Demonstrate the "in" keyword
  hosts: all
  gather_facts: yes
  vars:
    supported_distros:
      - RedHat
      - Fedora
  tasks:
    - name: Install httpd using yum, where supported
      yum:
        name: http
        state: present
      when: ansible_distribution in supported_distros
```
- `when: ansible_distribution == "RedHat" or ansible_distribution == "Fedora"
`
```
when:
  - ansible_distribution_version == "7.5"
  - ansible_kernel == "3.10.0-327.el7.x86_64"
```

```
when: >
    ( ansible_distribution == "RedHat" and
      ansible_distribution_major_version == "7" )
    or
    ( ansible_distribution == "Fedora" and
    ansible_distribution_major_version == "28" )
    
```
### loop and when 
```
- name: install mariadb-server if enough space on root
  yum:
    name: mariadb-server
    state: latest
  loop: "{{ ansible_mounts }}"
  when: item.mount == "/" and item.size_available > 300000000
 ```
 
 # Ignore Task Failure
 - `ignore_errors: yes`
 - `force_handlers: yes`
 Remember that handlers are notified when a tasks reports a changed result but are not notified when it reports an ok or failed result.
 #### failed_when
 ```
 tasks:
  - name: Run user creation script
    shell: /usr/local/bin/create_users.sh
    register: command_result
    ignore_errors: yes
  - name: Report script failure
    fail:
      msg: "The password is missing in the output"
    when: "'Password missing' in command_result.stdout"
 ```
 #### changed_when
 ```
 tasks:
  - shell:
      cmd: /usr/local/bin/upgrade-database
    register: command_result
    changed_when: "'Success' in command_result.stdout"
    notify:
      - restart_database
handlers:
  - name: restart_database
     service:
       name: mariadb
       state: restarted
```
# Blocks and Error Handling
```
- name: block example
  hosts: all
  tasks:
    - name: installing and configuring Yum versionlock plugin
      block:
      - name: package needed by yum
        yum:
          name: yum-plugin-versionlock
          state: present
      - name: lock version of tzdata
        lineinfile:
          dest: /etc/yum/pluginconf.d/versionlock.list
          line: tzdata-2016j-1
          state: present
      when: ansible_distribution == "RedHat"
```
- block: Defines the main tasks to run
- rescue: Defines the tasks to run if the tasks defined in the block clause fail.
- always: Defines the tasks that will always run independently of the success or failure of tasks defined in the block and rescue clauses.

# CH6
### include_tasks

```
- name: Include the environment task file and set the variables
  include_tasks: tasks/environment.yml
  vars:
    package: httpd
    service: httpd
```
### import_tasks
```
- name: Import the firewall task file and set the variables
  import_tasks: tasks/firewall.yml
  vars:
    firewall_pkg: firewalld
    firewall_svc: firewalld
    rule:
- http - https
````
### import_playbook
```
- name: Import test play file and set the variable
  import_playbook: plays/test.yml
  vars:
    url: 'http://servera.lab.example.com
    
```

### ROLES
```
---
- hosts: remote.example.com
  roles:
    - role: role1
    - { role: role2, var1: val1, var2: val2 
```

### pre_tasks, roles, tasks, post_tasks

