#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced."
    echo "Usage: source ./setup_env.sh"
    exit 1
fi

ENV="${ENV:-production}"

if [[ "$ENV" == "staging" ]]; then
    HOST_IP="192.168.0.109"
    HOST_NAME="yoga"
else
    HOST_IP="192.168.0.111"
    HOST_NAME="thinkpad"
fi

echo "------------------------------"
echo "> Setting up Environment..."

if [ -z "$SSH_AUTH_SOCK" ]; then
    echo "> Starting SSH Agent..."
    eval $(ssh-agent -s)
fi

if ! ssh-add -l | grep -q "id_ed25519"; then
    echo "> Adding SSH Key..."
    echo "--------------------"
    ssh-add ~/.ssh/id_ed25519
fi

# Absolute paths
REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
KUBECONFIG_FILE="$REPO_ROOT/${ENV}_kubeconfig.yaml"

export ANSIBLE_CONFIG="$REPO_ROOT/ansible/ansible.cfg"
export ANSIBLE_INVENTORY="$REPO_ROOT/ansible/inventory/inventory.ini"
export KUBECONFIG="$KUBECONFIG_FILE"

K3S_IP=$(grep 'server:' "$KUBECONFIG_FILE" | grep -oP '(?<=https://)[^:]+')

echo "------------------------------"
echo "REPO_ROOT:      $REPO_ROOT"
echo "KUBECONFIG:     $KUBECONFIG"
echo "ANSIBLE_CONFIG: $ANSIBLE_CONFIG"
echo "MASTER_K3S_IP:  $K3S_IP"
echo "------------------------------"
echo "> ${ENV} env ready!"
echo "------------------------------"