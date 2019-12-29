## Install bitnami/nginx
```
ec2-user:~/environment $ helm search bitnami/nginx
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                           
bitnami/nginx                           5.1.1           1.16.1          Chart for the nginx server            
bitnami/nginx-ingress-controller        5.2.2           0.26.2          Chart for the nginx Ingress controller
ec2-user:~/environment $ helm install --name mywebserver bitnami/nginx
NAME:   mywebserver
LAST DEPLOYED: Sun Dec 29 13:10:06 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME               AGE
mywebserver-nginx  0s

==> v1/Pod(related)
NAME                              AGE
mywebserver-nginx-8f744875-xs75f  0s

==> v1/Service
NAME               AGE
mywebserver-nginx  0s


NOTES:
Get the NGINX URL:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w mywebserver-nginx'

  export SERVICE_IP=$(kubectl get svc --namespace default mywebserver-nginx --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo "NGINX URL: http://$SERVICE_IP/"
```
## Inspect this Deployment object in more detail
ec2-user:~/environment $ 
ec2-user:~/environment $ kubectl describe deployment mywebserver
Name:                   mywebserver-nginx
Namespace:              default
CreationTimestamp:      Sun, 29 Dec 2019 13:10:06 +0000
Labels:                 app.kubernetes.io/instance=mywebserver
                        app.kubernetes.io/managed-by=Tiller
                        app.kubernetes.io/name=nginx
                        helm.sh/chart=nginx-5.1.1
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app.kubernetes.io/instance=mywebserver,app.kubernetes.io/name=nginx
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app.kubernetes.io/instance=mywebserver
           app.kubernetes.io/managed-by=Tiller
           app.kubernetes.io/name=nginx
           helm.sh/chart=nginx-5.1.1
  Containers:
   nginx:
    Image:        docker.io/bitnami/nginx:1.16.1-debian-9-r105
    Port:         8080/TCP
    Host Port:    0/TCP
    Liveness:     http-get http://:http/ delay=30s timeout=5s period=10s #success=1 #failure=6
    Readiness:    http-get http://:http/ delay=5s timeout=3s period=5s #success=1 #failure=3
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   mywebserver-nginx-8f744875 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  113s  deployment-controller  Scaled up replica set mywebserver-nginx-8f744875 to 1

```
## Verify the Pod object was successfully deployed
```
ec2-user:~/environment $ kubectl get pods -l app.kubernetes.io/name=nginx
NAME                               READY   STATUS    RESTARTS   AGE
mywebserver-nginx-8f744875-xs75f   1/1     Running   0          3m39s
```
