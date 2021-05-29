# async
Run a or multiple process and check on it 6 mins later and poll every 
```
hosts: xxx
tasks:
  - command: /opt/monitor_webapp.py
    async: 360
    poll: 0
    register: webapp_result
  - name: check status
    async_status: jid={{ webapp_result.ansible_job_id }}
    register: job_result
    until: job_result.finished
    retries: 30
``` 
# Strategy
- 1st 3 servers
`serial: 3` 
# Forks
- default is 5

 # Task Failure
 failure immediately
 `any_errors_fatal: true`
 
 # ignore Errors
 `ignore_errors: yes`
 

# Lookup
- csv
```
- name: Test Connectivity
  hosts: web_server
  vars:
    ansible_ssh_pass: "{{ lookup('csvfile', 'web_server file=credentials.csv delimiter=,') }}"
  tasks:
  - name: Ping target host
    ping:
           data: "Test"
 ```
- ini
```
 name: Test Connectivity
  hosts: web_server
  vars:
    ansible_ssh_pass: "{{ lookup('ini', 'password section=web_server file=credentials.ini') }}"

  tasks:
  - name: Ping target host
    ping:
           data: "Test"
 ```
