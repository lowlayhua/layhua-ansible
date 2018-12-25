# Postfix
echo "relayhost = [imhq05b.omni]" >> /etc/postfix/main.cf

service postfix start
chkconfig postfix on

HOST=`hostname`

ip a | mail -s "$HOST: test postfix" -r layhua@singtel.com layhua@singtel.com


