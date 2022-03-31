## About this project
   In order to simplify the api development I created this generic boilerplate to improve the first steps of building a containerized api.
   In this boilerplate you'll find:
   - Github Actions to create the CI/CD pipeline;
   - Terraform, Infrastructure as Code to create the aws environment
   - Docker to create api image
   
## Infrastructure
   - 1 VPC, 2 Public Subnets, 2 Private Subnets, 2 Database Subnets, 1 IGW, 1 NAT;
   - 1 ECS Cluster, 1 Task Definition, 1 Service with 2 Desired Tasks;
   - 1 ECR;
   - 1 ALB, 1 Target Group;
   - 1 S3 bucket;
   - 2 DynamoDB Tables;

## Features
- [X] IaC -> 1 VPC, 2 Public Subnets, 2 Private Subnets, 2 Database Subnets, 1 IGW, 1 NAT
- [X] IaC -> 1 ECS Cluster, 1 Task Definition, 1 Service with 2 Desired Tasks
- [X] IaC -> 1 ECR
- [X] IaC -> 1 ALB, 1 Target Group pointing to service
- [X] CI/CD -> Update the whole infrastructure when new commit to branch main/dev 
- [X] CI/CD -> Separate dev & prod environment
- [X] CI/CD -> Update ECR image, Task Definition and Service
- [X] Network diagram


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

 **2 - Create 2 DynamoDB Table**
    **- Name**: prod-boilerplate-tfstate
    **- Partition key**: LockID
    Leave everything default
    **- Create Table**
    ---
    **- Name**: dev-boilerplate-tfstate
    **- Partition key**: LockID
    Leave everything default
    **- Create Table**

 **2- Setup Github Repository Secrets**
    - AWS_ACCESS_KEY_ID -> aws user access key
    - AWS_SECRET_ACCESS_KEY -> aws user secret key
    - TF_API_TOKEN -> terraform account api token

 **3- Now you just need to create a new commit on branch main or dev :)**

## Clean up
```
   cd scripts
   chmod +x ./*.sh
   ./cleanup.sh
```

## Next Steps
- [ ] Auto release tags
