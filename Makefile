.PHONY: deploy terraform_init terraform_apply terraform_plan terraform_destroy login

plan: terraform_init terraform_plan

deploy: terraform_init terraform_apply

terraform_init:
	cd deployments/terraform && \
	terraform init

terraform_destroy:
	cd deployments/terraform && \
  	terraform init  && terraform destroy -auto-approve -var-file=terraform.tfvars

terraform_plan:
	cd deployments/terraform && \
	terraform plan

terraform_apply:
	cd deployments/terraform && \
	terraform apply -auto-approve

login:
	ssh-add ~/.ssh/veselj_github.rsa
