.PHONY: help ping plan apply destroy rebuild provision check-route setup-env

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

rebuild: destroy apply
	@echo "Waiting 15 seconds for VMs to boot..."
	@sleep 15
	$(MAKE) ping

provision:
	@echo "Running Ansible Playbooks..."
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory/inventory.ini playbooks/site.yaml

check-route:
	@ip route get 192.168.122.90 > /dev/null 2>&1 || \
	(echo "Route missing! Run: sudo ip route add 192.168.122.0/24 via 192.168.0.109" && exit 1)
	@echo "Route to VMs is active."

setup-env: check-route
	@source ./setup_env.sh