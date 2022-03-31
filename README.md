## About this project

## Infrastructure

## How to run
 1 - Create s3 Bucket
    **- Name**: api-boilerplate-terraform-state
    **- Region**: us-east-1
    **- Object Ownership**: ACLs disabled
    **- Block Public Access settings for this bucket**: Block all public access
    **- Bucket Versioning**: Enabled
    **- Create Bucket**

    - Create a "dev" folder
    - Create a "prod" folder


## Requirements
- [ ] IaC -> 1 VPC, 2 Public Subnets, 2 Private Subnets, 2 Database Subnets, 1 IGW, 1 NAT
- [X] IaC -> 1 ECS Cluster, 1 Task Definition, 1 Service with 2 Desired Tasks
- [X] IaC -> 1 ECR
- [ ] IaC -> 1 ALB, 1 Target Group pointing to service
- [ ] CI/CD -> Update the whole infrastructure when new commit to branch main/dev 
- [ ] CI/CD -> Separate dev & prod environment
- [X] CI/CD -> Update ECR image, Task Definition and Service
