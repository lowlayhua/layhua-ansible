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
