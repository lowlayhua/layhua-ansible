# Example action to start service httpd, if not running
- systemd: state=started name=httpd
- systemd: state=started name=firewalld
# Example action to stop service cron on debian, if running
- systemd: name=cups state=stopped enabled=no
- systemd: name=avahi-daemon state=stopped
- systemd: name=NetworkManager.service state=stopped

systemctl disable cups
systemctl stop avahi-daemon
systemctl disable avahi-daemon
systemctl stop postfix
systemctl disable postfix
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service
#To review active services,
service --status-all
systemctl list-units-files
systemctl list-units | grep service
# Change hostname
vi /etc/hostname
yum install NetworkManager-tui
