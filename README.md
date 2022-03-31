## About this project

## Infrastructure

## How to run
 **1 - Create s3 Bucket**
    **- Name**: api-boilerplate-terraform-state
    **- Region**: us-east-1
    **- Object Ownership**: ACLs disabled
    **- Block Public Access settings for this bucket**: Block all public access
    **- Bucket Versioning**: Enabled
    **- Create Bucket**
    - Create a "dev" folder
    - Create a "prod" folder

 **2- Setup Repository secrets**
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - TF_API_TOKEN

 **3- Now you just need to create a new commit :)**


## Clean up
```
    cd scripts
    chmod +x ./*.sh
    ./cleanup.sh
```

## Features
- [X] IaC -> 1 VPC, 2 Public Subnets, 2 Private Subnets, 2 Database Subnets, 1 IGW, 1 NAT
- [X] IaC -> 1 ECS Cluster, 1 Task Definition, 1 Service with 2 Desired Tasks
- [X] IaC -> 1 ECR
- [X] IaC -> 1 ALB, 1 Target Group pointing to service
- [X] CI/CD -> Update the whole infrastructure when new commit to branch main/dev 
- [X] CI/CD -> Separate dev & prod environment
- [X] CI/CD -> Update ECR image, Task Definition and Service
- [X] Network diagram

## Next Steps
- [ ] Auto release tags
