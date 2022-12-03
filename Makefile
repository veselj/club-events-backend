.PHONY: deploy terraform_init terraform_apply terraform_plan terraform_destroy login build

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

# terraform state list
# terraform state rm aws_apigatewayv2_api.club-events-api
terraform_destroy_api:
	cd deployments/terraform && \
  	terraform destroy -target aws_apigatewayv2_api.club-events-api

login:
	ssh-add ~/.ssh/veselj_github.rsa

build:
	mkdir -p deployments/bin/
	CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o deployments/bin/lambda-linux lambda/main.go
	upx deployments/bin/lambda-linux
	cd deployments/bin && rm lambda.zip && zip -mv9 lambda.zip lambda-linux
