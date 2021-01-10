# Configure /etc/haproxy/haproxy.cfg
```
# FrontEnd Configuration

frontend main
    bind *:80
    option http-server-close
    option forwardfor
    default_backend app-main
 
# BackEnd roundrobin as balance algorithm

backend app-main
    balance roundrobin                                     #Balance algorithm
    option httpchk HEAD / HTTP/1.1\r\nHost:\ localhost    #Check the server application is up and healty - 200 status code
    server nginx1 192.168.1.104:80 check                 #Nginx1 
    server nginx2 192.168.1.105:80 check                 #Nginx2
    
 ```
 # start and enable haproxy
```
systemctl start haproxy
systemctl enable haproxy
```
