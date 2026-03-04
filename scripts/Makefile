ENV ?= prod

ifeq ($(ENV), staging)
  HOST_IP  := 192.168.0.109
  SSH_ARGS := -o ProxyCommand="ssh -W %h:%p -q server@yoga"
else
  HOST_IP  := 192.168.0.111
  SSH_ARGS := -o ProxyCommand="ssh -W %h:%p -q server@thinkpad"
endif

ANSIBLE_DIR   := $(abspath $(CURDIR)/../provisioning/ansible)
TERRAFORM_DIR := $(abspath $(CURDIR)/../provisioning/terraform/$(ENV))
INVENTORY     := inventory/inventory.$(ENV).ini
ANSIBLE_OPTS  := -i $(INVENTORY) --ssh-extra-args='$(SSH_ARGS)'

.PHONY: help health-check ping init plan apply destroy get-ips rebuild auto-rebuild provision provision-host

help:
	@echo "Available commands:"
	@echo "  ping       - Test connectivity to all hosts"
	@echo "  init       - Run `terraform init`"
	@echo "  plan       - Run `terraform plan`"
	@echo "  apply      - Run `terraform apply`"
	@echo "  destroy    - Run `terraform destroy`"
	@echo "  rebuild    - Rebuild the VM fleet and ping"
	@echo "  provision  - Run the Ansible playbooks"
	@echo "	 Usage: make <target> [ENV=staging|prod]"
	@echo "  ENV defaults to prod ($(HOST_IP))"

health-check:
	$(MAKE) ping ENV=staging
	$(MAKE) ping ENV=prod

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
	$(MAKE) provision ENV=$(ENV)
	$(MAKE) get-ips   ENV=$(ENV)

provision:
	cd $(ANSIBLE_DIR) && ansible-playbook $(ANSIBLE_OPTS) playbooks/vms.yaml --ask-become-pass

provision-host:
	cd $(ANSIBLE_DIR) && ansible-playbook $(ANSIBLE_OPTS) playbooks/host.yaml --ask-become-pass