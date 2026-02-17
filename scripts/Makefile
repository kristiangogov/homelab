.PHONY: help ping plan apply destroy get-ips rebuild auto-rebuild provision provision-host check-route

ANSIBLE_DIR := $(abspath $(CURDIR)/../provisioning/ansible)
TERRAFORM_DIR := $(abspath $(CURDIR)/../provisioning/terraform)

help:
	@echo "Available commands:"
	@echo "  ping       - Test connectivity to all hosts"
	@echo "  plan       - Run `terraform plan`"
	@echo "  apply      - Run `terraform apply`"
	@echo "  destroy    - Run `terraform destroy`"
	@echo "  rebuild    - Rebuild the VM fleet and ping"
	@echo "  provision  - Run the Ansible playbooks"

ping:
	cd $(ANSIBLE_DIR) && ansible everything -i inventory/inventory.ini -m ping

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
	$(MAKE) ping

auto-rebuild:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve
	$(MAKE) provision
	$(MAKE) get-ips

provision:
	@echo "Running Ansible Playbooks..."
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory/inventory.ini playbooks/vms.yaml

provision-host:
	@echo "Running Ansible Playbooks..."
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory/inventory.ini playbooks/host.yaml --ask-become-pass

check-route:
	@ip route get 192.168.122.0/24 > /dev/null 2>&1 || \
	(echo "Route missing! Run: sudo ip route add 192.168.122.0/24 via 192.168.0.109" && exit 1)
	@echo "Route to VMs is active."