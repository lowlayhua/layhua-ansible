cat << 'EOF' >> /etc/ssh/sshd_config
# Added by layhua
# Recommended by http://benchmarks.cisecurity.org
Protocol 2
LogLevel INFO
MaxAuthTries 6
IgnoreRhosts yes
HostbasedAuthentication no
PermitRootLogin no
PermitEmptyPasswords no
PermitUserEnvironment no
ClientAliveInterval 300
ClientAliveCountMax 0
EOF

cat << 'EOF' >> /etc/hosts.allow
ALL:    127.0.0.1
sshd:   10.54., 10.44.
# SRN LAN, VPN, Comcentre LAN
sshd:   10.128., 10.130., 10.141., 10.12.
EOF

cat << 'EOF' >> /etc/hosts.deny
ALL:    ALL
EOF
