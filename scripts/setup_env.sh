#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced."
    echo "Usage: source ./setup_env.sh"
    exit 1
fi

echo "Setting up Environment..."

# SSH Agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    echo "Starting SSH Agent..."
    eval $(ssh-agent -s)
fi

if ! ssh-add -l | grep -q "id_ed25519"; then
    echo "Adding SSH Key..."
    ssh-add ~/.ssh/id_ed25519
fi

# Absolute paths
REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
KUBECONFIG_FILE="$REPO_ROOT/k3s-homelab.yaml"

export ANSIBLE_CONFIG="$REPO_ROOT/ansible/ansible.cfg"
export ANSIBLE_INVENTORY="$REPO_ROOT/ansible/inventory/inventory.ini"

# Tunnel
K3S_IP=$(grep 'server:' "$KUBECONFIG_FILE" | grep -oP '(?<=https://)[^:]+')

pkill -f "L 6443" 2>/dev/null
sleep 1

if ! ss -tlnp | grep -q ':6443'; then
    echo "Opening k3s tunnel via thinkpad → ${K3S_IP}..."
    ssh -f -N -L 6443:${K3S_IP}:6443 thinkpad
fi


TUNNEL_KUBECONFIG="/tmp/k3s-tunnel.yaml"
sed "s|https://${K3S_IP}:6443|https://127.0.0.1:6443|g" "$KUBECONFIG_FILE" \
    | sed "s|certificate-authority-data:.*|insecure-skip-tls-verify: true|g" \
    > "$TUNNEL_KUBECONFIG"
export KUBECONFIG="$TUNNEL_KUBECONFIG"

echo "REPO_ROOT:      $REPO_ROOT"
echo "KUBECONFIG:     $KUBECONFIG"
echo "ANSIBLE_CONFIG: $ANSIBLE_CONFIG"
echo "K3S_IP:         $K3S_IP"
echo "Environment Ready!"