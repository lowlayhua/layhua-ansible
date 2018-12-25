#!/bin/sh
#mv /etc/sysconfig/rhn/systemid /tmp

# register with Satellite server using activation

wget http://eshop9.app.vic/pub/RHN-ORG-TRUSTED-SSL-CERT -O /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT
rhnreg_ks  --activationkey 2-18870f8c01bff1084966554f2b4c43ab --serverUrl http://eshop9.app.vic/XMLRPC

