# Enable the UFW based firewall
```
sudo ufw enable
```
# Check the status of my rules?
```
sudo ufw status
sudo ufw status verbose
```
# Allow SSH, 80/tcp and 443/tcp connections
```
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

# Deny all connections from an IP
```
sudo ufw deny from 123.45.67.89/24
```

# Reset ufw rules to their factory default settings and in an inactive mode
```
sudo ufw reset
 ```
