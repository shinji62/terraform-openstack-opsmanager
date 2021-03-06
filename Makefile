.PHONY: all plan apply destroy
SHELL := $(SHELL) -e

all: plan apply

plan:
	terraform get -update
	terraform plan -var-file terraform.tfvars -out terraform.tfplan

apply:
	terraform apply -var-file terraform.tfvars

destroy:
	terraform plan -destroy -var-file terraform.tfvars -out terraform.tfplan
	terraform apply terraform.tfplan

apply-jumpbox:
	terraform apply -var-file terraform.tfvars jumpbox/

clean:
	rm -f terraform.tfplan
	rm -f terraform.tfstate
