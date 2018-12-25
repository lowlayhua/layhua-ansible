cat << 'EOF' > /etc/resolv.conf
search app.vic
domain singtel.com
nameserver 10.20.1.11
nameserver 10.20.1.12
EOF
