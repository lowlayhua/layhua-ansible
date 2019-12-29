# Upload the public key to your EC2 region:
```
ec2-user:~/environment $ aws ec2 import-key-pair --key-name "eksworkshop" --public-key-material file://~/.ssh/id_rsa.pub
{
    "KeyName": "eksworkshop", 
    "KeyFingerprint": "08:38:45:cc:4f:48:d1:f0:de:4b:ad:3e:c1:09:8b:2b"
}
```
# EKS PREREQUISITES
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

sudo mv -v /tmp/eksctl /usr/local/bin

eksctl completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion


```

# Create an EKS cluster
```
eksctl create cluster --name=eksworkshop-eksctl --nodes=3 --managed --alb-ingress-access --region=${AWS_REGION}
```
# Test & Verify
## kubectl get nodes # if we see our 3 nodes, we know we have authenticated correctly
```
kubectl get nodes
ec2-user:~/environment $ kubectl get nodes
NAME                                           STATUS   ROLES    AGE    VERSION
ip-192-168-18-52.us-west-2.compute.internal    Ready    <none>   88s    v1.14.7-eks-1861c5
ip-192-168-56-255.us-west-2.compute.internal   Ready    <none>   104s   v1.14.7-eks-1861c5
ip-192-168-93-143.us-west-2.compute.internal   Ready    <none>   106s   v1.14.7-eks-1861c5
```
## Export the Worker Role Name for use throughout the workshop:
```
STACK_NAME=$(eksctl get nodegroup --cluster eksworkshop-eksctl -o json | jq -r '.[].StackName')
ROLE_NAME=$(aws cloudformation describe-stack-resources --stack-name $STACK_NAME | jq -r '.StackResources[] | select(.ResourceType=="AWS::IAM::Role") | .PhysicalResourceId')
echo "export ROLE_NAME=${ROLE_NAME}" | tee -a ~/.bash_profile
```
## kubectl
```
kubectl get deployment
kubectl get services
```

## SCALE THE BACKEND SERVICES
```
ec2-user:~/environment $ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
ecsdemo-crystal    1/1     1            1           3h52m
ecsdemo-frontend   1/1     1            1           25m
ecsdemo-nodejs     1/1     1            1           3h52m
ec2-user:~/environment $ kubectl scale deployment ecsdemo-nodejs --replicas=3
deployment.extensions/ecsdemo-nodejs scaled
ec2-user:~/environment $ kubectl scale deployment ecsdemo-crystal --replicas=3
deployment.extensions/ecsdemo-crystal scaled
ec2-user:~/environment $ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
ecsdemo-crystal    3/3     3            3           3h52m
ecsdemo-frontend   1/1     1            1           25m
ecsdemo-nodejs     3/3     3            3           3h53m
```

## Delete the services and  deployments
```
ec2-user:~/environment/ecsdemo-nodejs (master) $ kubectl get deployments.
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
ecsdemo-crystal    3/3     3            3           3h58m
ecsdemo-frontend   3/3     3            3           31m
ecsdemo-nodejs     3/3     3            3           3h58m
ec2-user:~/environment/ecsdemo-nodejs (master) $ kubectl delete -f kubernetes/deployment.yaml 
deployment.apps "ecsdemo-nodejs" deleted
ec2-user:~/environment/ecsdemo-nodejs (master) $ kubectl delete -f kubernetes/service.yaml 
service "ecsdemo-nodejs" deleted
ec2-user:~/environment/ecsdemo-nodejs (master) $ cd ../ecsdemo-frontend/
ec2-user:~/environment/ecsdemo-frontend (master) $ kubectl delete -f kubernetes/deployment.yaml 
deployment.apps "ecsdemo-frontend" deleted
ec2-user:~/environment/ecsdemo-frontend (master) $ kubectl delete -f kubernetes/service.yaml 
service "ecsdemo-frontend" deleted
ec2-user:~/environment/ecsdemo-frontend (master) $ cd ../ecsdemo-crystal/
ec2-user:~/environment/ecsdemo-crystal (master) $ kubectl delete -f kubernetes/deployment.yaml 
deployment.apps "ecsdemo-crystal" deleted
ec2-user:~/environment/ecsdemo-crystal (master) $ kubectl delete -f kubernetes/service.yaml 
service "ecsdemo-crystal" deleted
ec2-user:~/environment/ecsdemo-crystal (master) $ kubectl get deployments
No resources found
ec2-user:~/environment/ecsdemo-crystal (master) $ kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   4h25m
```
