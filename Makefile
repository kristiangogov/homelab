ENV ?= production

ifeq ($(ENV), staging)
  HOST_IP  := 192.168.0.109
else
  HOST_IP  := 192.168.0.111
endif

ANSIBLE_DIR   := $(abspath $(CURDIR)/provisioning/ansible)
TERRAFORM_DIR := $(abspath $(CURDIR)/provisioning/terraform/$(ENV))
INVENTORY     := inventory/inventory.$(ENV).ini
ANSIBLE_OPTS  := -i $(INVENTORY)

.PHONY: help ping init plan apply destroy get-ips rebuild auto-rebuild provision provision-host edit-vault

help:
	@echo "Available commands:"
	@echo "  ping       - Test connectivity to all hosts"
	@echo "  init       - Run terraform init"
	@echo "  plan       - Run terraform plan"
	@echo "  apply      - Run terraform apply"
	@echo "  destroy    - Run terraform destroy"
	@echo "  rebuild    - Rebuild the VM fleet and ping"
	@echo "  provision  - Run the Ansible playbooks"
	@echo "  edit-vault - Open the Ansible Vault using a password file"
	@echo ""
	@echo "  Usage: make <target> [ENV=staging|production]"
	@echo "  ENV defaults to production ($(HOST_IP))"

ping:
	cd $(ANSIBLE_DIR) && ansible everything $(ANSIBLE_OPTS) -m ping

init:
	cd $(TERRAFORM_DIR) && terraform init

plan:
	cd $(TERRAFORM_DIR) && terraform plan

apply:
	cd $(TERRAFORM_DIR) && terraform apply

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

get-ips:
	cd $(TERRAFORM_DIR) && terraform output vm_ips

rebuild: destroy apply
	@echo "Waiting 15 seconds for VMs to boot..."
	@sleep 15
	$(MAKE) ping ENV=$(ENV)

auto-rebuild:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
	cd $(TERRAFORM_DIR) && terraform apply  -auto-approve
# 	Sleep and re-apply needed to give time for qemu-agent ot populate VM IPs
	@sleep 15
	cd $(TERRAFORM_DIR) && terraform apply  -auto-approve
	$(MAKE) provision ENV=$(ENV)
	$(MAKE) get-ips   ENV=$(ENV)

provision:
	cd $(ANSIBLE_DIR) && ansible-playbook $(ANSIBLE_OPTS) playbooks/vms.yaml --ask-become-pass

provision-host:
	cd $(ANSIBLE_DIR) && ansible-playbook $(ANSIBLE_OPTS) playbooks/host.yaml --ask-become-pass

edit-vault:
	ansible-vault edit $(ANSIBLE_DIR)/inventory/group_vars/all/secrets.yml --vault-password-file $(ANSIBLE_DIR)/.vault_pass