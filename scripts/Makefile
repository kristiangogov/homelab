.PHONY: help ping plan apply destroy

ANSIBLE_DIR := $(abspath $(CURDIR)/../provisioning/ansible)
TERRAFORM_DIR := $(abspath $(CURDIR)/../provisioning/terraform)

help:
	@echo "Available commands:"
	@echo "  ping       - Test connectivity to all hosts"
	@echo "  plan       - Run `terraform plan`"
	@echo "  apply      - Run `terraform apply`"
	@echo "  destroy    - Run `terraform destroy`"
	@echo "  rebuild    - Rebuild the VM fleet and ping"

ping:
	cd $(ANSIBLE_DIR) && ansible everything -i inventory/inventory.ini -m ping

plan:
	cd $(TERRAFORM_DIR) && terraform plan

apply:
	cd $(TERRAFORM_DIR) && terraform apply

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy	

rebuild: destroy apply
	@echo "Waiting 15 seconds for VMs to boot..."
	@sleep 15
	$(MAKE) ping