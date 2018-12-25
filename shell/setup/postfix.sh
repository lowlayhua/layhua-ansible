echo "relayhost = [imhq05b.omni]" >> /etc/postfix/main.cf
service postfix start
mail -s "test postfix" -r layhua@singtel.com layhua@singtel.com < /etc/hosts

