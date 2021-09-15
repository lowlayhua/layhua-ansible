# Check
- `systemctl status ansible-tower`

# Config file
-`.tower_cli.cfg`

# Tower-cli

- `tower-cli user list`
- `tower-cli job template list`
- `tower-cli job_template create --help`
- `tower-cli job_template create -n API_create_users -d "xx"
--project "My project" --playbook create_user.yml --ask-variables-on-launch TRUE -i PRODUCTIOn --credential xxx
`

-`tower-cli job launch --job-template=18 --monitor`

# Backup
`./setup.sh -b`

# Restore
`./setup.sh -r`



