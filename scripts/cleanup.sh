cd ../terraform

# prod environment
rm -r .terraform -f
rm .terraform.lock.hcl
rm terraform.tfstate
rm terraform.tfstate.backup
terraform init -backend-config=./environments/prod.tfbackend
terraform destroy -auto-approve -var-file=./prod.tfvars 

# dev environment
rm -r .terraform -f
rm .terraform.lock.hcl
rm terraform.tfstate
rm terraform.tfstate.backup
terraform init -backend-config=./environments/dev.tfbackend
terraform destroy -auto-approve -var-file=./dev.tfvars 