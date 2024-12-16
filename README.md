## InvestPro IaC with ECS

## Build Docker Images and Push to the ECR

1. Configure your AWS Credentials:
```sh
aws configure   
```

2. Login to the ECR:
```sh
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 657608969216.dkr.ecr.us-east-1.amazonaws.com/invest-pro-api
```

3. Build and Push the Docker Image:
```sh
export VERSION="0.0.2"
export REPOSITORY="657608969216.dkr.ecr.us-east-1.amazonaws.com/invest-pro-api"
docker build -t invest-pro-api:$VERSION .

docker tag invest-pro-api:$VERSION $REPOSITORY:$VERSION
docker tag invest-pro-api:$VERSION $REPOSITORY:latest

docker push "$REPOSITORY":"$VERSION"
docker push "$REPOSITORY":latest
```

## SSH to the EC2 Instance

```sh
cd Projects
ssh -i "gbrotas-keypair.pem" ec2-user@ec2-44-200-153-50.compute-1.amazonaws.com
```

## Obtain SSL Certificate

```sh
sudo yum install -y nginx certbot python-certbot-nginx
sudo certbot certonly --nginx -d myportfolio-api.brottas.com
```
