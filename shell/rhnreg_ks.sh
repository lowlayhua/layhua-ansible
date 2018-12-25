#!/bin/sh
mv /etc/sysconfig/rhn/systemid /tmp

# register with Satellite server using activation

key="1-727561f349359cc6b0fcc89f4282ef58"
#key="1-rhel-6.5_2014-10-11-bcc"
wget http://gl-rhelsat.app.vic/pub/RHN-ORG-TRUSTED-SSL-CERT -O /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT
rhnreg_ks  --activationkey $key --serverUrl http://gl-rhelsat.app.vic/XMLRPC

