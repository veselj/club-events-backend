.PHONY: deploy terraform_init terraform_apply terraform_destroy

deploy: terraform_init terraform_apply

terraform_init:
	cd deployments/terraform && \
	terraform init

terraform_destroy:
	cd deployments/terraform && \
  	terraform init  && terraform destroy -auto-approve -var-file=terraform.tfvars

terraform_apply:
	cd deployments/terraform && \
	terraform apply -auto-approve