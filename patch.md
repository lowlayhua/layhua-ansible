# centos 8 / Rhel 8
- To list security updates
`dnf updateinfo list --security --available`
- To install only security update
`dnf upgrade --security`


```
- name: Get packages that can be patched with security fixes
  become: yes
  ansible.builtin.dnf:
    security: yes
    list: updates
    state: latest
    update_cache: yes
  register: reg_dnf_output_secu
  when: ev_security_only == "yes"
  
  - name: List packages that can be patched with security fixes
  ansible.builtin.debug: 
    msg: "{{ reg_dnf_output_secu.results | map(attribute='name') | list }}"
  when: ev_security_only == "yes"
  - name: Request user confirmation
  ansible.builtin.pause:
    prompt: | 
 
      The packages listed above will be upgraded. Do you want to continue ? 
      -> Press RETURN to continue.
      -> Press Ctrl+c and then "a" to abort.
  when: reg_dnf_output_all is defined or reg_dnf_output_secu is defined
  
  - name: Patch packages
  become: yes
  ansible.builtin.dnf:
    name: '*'
    security: yes
    state: latest
    update_cache: yes
    update_only: no
  register: reg_upgrade_ok
  when: ev_security_only == "yes" and reg_dnf_output_secu is defined
 
 
- name: Print errors if upgrade failed
  ansible.builtin.debug:
    msg: "Packages upgrade failed"
  when: reg_upgrade_ok is not defined
```
