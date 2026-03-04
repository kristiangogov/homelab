ENV ?= prod

ifeq ($(ENV), staging)
  HOST_IP     := 192.168.0.109
  TF_VAR_FILE := staging.tfvars
else
  HOST_IP     := 192.168.0.111
  TF_VAR_FILE := prod.tfvars
endif

ANSIBLE_DIR   := $(abspath $(CURDIR)/../provisioning/ansible)
TERRAFORM_DIR := $(abspath $(CURDIR)/../provisioning/terraform)
INVENTORY := inventory/inventory.$(ENV).ini

.PHONY: help ping plan apply destroy get-ips rebuild auto-rebuild provision provision-host

help:
	@echo "Available commands:"
	@echo "  ping       - Test connectivity to all hosts"
	@echo "  plan       - Run `terraform plan`"
	@echo "  apply      - Run `terraform apply`"
	@echo "  destroy    - Run `terraform destroy`"
	@echo "  rebuild    - Rebuild the VM fleet and ping"
	@echo "  provision  - Run the Ansible playbooks"
	@echo "	 Usage: make <target> [ENV=staging|prod]"
	@echo "  ENV defaults to prod ($(HOST_IP))"

ping:
	cd $(ANSIBLE_DIR) && ansible everything -i $(INVENTORY) -m ping

plan:
	cd $(TERRAFORM_DIR) && terraform plan -var-file=$(TF_VAR_FILE)

apply:
	cd $(TERRAFORM_DIR) && terraform apply -var-file=$(TF_VAR_FILE)

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy -var-file=$(TF_VAR_FILE)

get-ips:
	cd $(TERRAFORM_DIR) && terraform output vm_ips

rebuild: destroy apply
	@echo "Waiting 15 seconds for VMs to boot..."
	@sleep 15
	$(MAKE) ping ENV=$(ENV)

auto-rebuild:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve -var-file=$(TF_VAR_FILE)
	cd $(TERRAFORM_DIR) && terraform apply  -auto-approve -var-file=$(TF_VAR_FILE)
	$(MAKE) provision ENV=$(ENV)
	$(MAKE) get-ips   ENV=$(ENV)

provision:
	cd $(ANSIBLE_DIR) && ansible-playbook -i $(INVENTORY) playbooks/vms.yaml --ask-become-pass

provision-host:
	cd $(ANSIBLE_DIR) && ansible-playbook -i $(INVENTORY) playbooks/host.yaml --ask-become-pass