# Upload the public key to your EC2 region:
```
ec2-user:~/environment $ aws ec2 import-key-pair --key-name "eksworkshop" --public-key-material file://~/.ssh/id_rsa.pub
{
    "KeyName": "eksworkshop", 
    "KeyFingerprint": "08:38:45:cc:4f:48:d1:f0:de:4b:ad:3e:c1:09:8b:2b"
}
```

# Create an EKS cluster
```
eksctl create cluster --name=eksworkshop-eksctl --nodes=3 --managed --alb-ingress-access --region=${AWS_REGION}
```
