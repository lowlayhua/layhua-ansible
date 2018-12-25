cat << 'EOF' >> /etc/bashrc
HISTTIMEFORMAT="%F %T "
export HISTTIMEFORMAT
umask 027
EOF
. /etc/bashrc
history

