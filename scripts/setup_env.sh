#!/bin/bash

# This script should be SOURCED: source ./setup_env.sh
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced to update your current terminal session."
    echo "Usage: source ./setup_env.sh"
    exit 1
fi

echo "Setting up Environment..."

if [ -z "$SSH_AUTH_SOCK" ]; then
    echo "Starting SSH Agent..."
    eval $(ssh-agent -s)
fi

if ! ssh-add -l | grep -q "id_ed25519"; then
    echo "Adding SSH Key..."
    ssh-add ~/.ssh/id_ed25519
fi

PROVISIONING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
export ANSIBLE_CONFIG="$PROVISIONING_DIR/ansible/ansible.cfg"
export ANSIBLE_INVENTORY="$PROVISIONING_DIR/ansible/inventory/inventory.ini"
export KUBECONFIG="../k3s-homelab.yaml"

echo "Environment Ready!"
echo "ANSIBLE_CONFIG: $ANSIBLE_CONFIG"
echo "KUBECONFIG: $KUBECONFIG"
echo "Current Host: $(hostname)"