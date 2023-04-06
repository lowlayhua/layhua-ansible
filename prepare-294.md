# vimrc

`autocmd FileType yaml setlocal ai ts=2 sw=2 et`

# Check Syntax
`ansible-playbook --syntax-check site.yaml`


# ansible.cfg
- copy from /etc/ansible.cfg 
- `ansible-config list`
- `ansible-config view`
- `ansible-doc -l | grep line`

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


# sudo yum install rhel-system-roles
- read /var/share/doc/rhel-system-roles/

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
