.PHONY: tf-fmt
tf-fmt:
	@echo "Formatting Terraform files"
	terraform fmt -recursive ./terraform

.PHONY: tf-validate
tf-validate:
	@echo "Validating Terraform files"
	cd terraform && terraform validate

.PHONY: tf-plan
tf-plan:
	@echo "Planning Terraform changes"
	cd terraform && terraform plan 

.PHONY: tf-apply
tf-apply:
	@echo "Applying Terraform changes"
	cd terraform && terraform apply

.PHONY: tf-destroy
tf-destroy:
	@echo "Destroying Terraform resources"
	cd terraform && terraform destroy

.PHONY: tf-init
tf-init:
	@echo "Initializing Terraform"
	cd terraform && terraform init
