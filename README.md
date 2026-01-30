# Homelab
![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform&style=flat-square)
![Ansible](https://img.shields.io/badge/Ansible-2.15+-EE0000?logo=ansible&style=flat-square)
![Kubernetes](https://img.shields.io/badge/K3s-v1.28+-326CE5?logo=kubernetes&style=flat-square)
![GitOps](https://img.shields.io/badge/GitOps-FluxCD-00ADD8?logo=flux&style=flat-square)

K3s cluster running self-hosted services with a focus on **Total Reproducibility** and **Environment Isolation**.

> [!NOTE] 
> You can find detailed write-ups on my blog:  
> [K3s initial setup](https://gogov.dev/blog/homelab-initial-setup)  
> [Adding Observability with Prometheus & Grafana](https://gogov.dev/blog/homelab-observability)  
> [GitOps, FluxCD Edition](https://gogov.dev/blog/homelab-gitops-fluxcd)  
> [Moving toward virtualization and other design decisions](https://gogov.dev/blog/design-decisions)  
> [Manual to Makefile - Terraform, KVM, Ansible](https://gogov.dev/blog/homelab-terraform-libvirt)  
> [The Complete Pipeline - End-to-end IaC GitOps](https://gogov.dev/blog/end-to-end-iac-gitops)  

## Quick Start 🚀

To reproduce this entire environment on a fresh Fedora host:

### Prerequisites:
1. **Prepare Fedora 43 Host:** Ensure SSH is active and your key is added.
2. **GitHub PAT**: Provide your GitHub PAT in: provisioning/ansible/roles/flux/tasks/main.yaml 
(preferably via Ansible Vault secret as currently implemented)
3. **Terraform Variables**: Provide the following file in provisioning/terraform/terraform.tfvars:
```sh
# Secrets
server_password = "YOUR_VM_PASSWORD"
ssh_keys = [
  "YOUR_SSH_KEY" 
]
# Variables
node_count    = 2
vm_memory     = "2048"
vm_vcpu       = 2
user_name     = "server"
hostname_base = "k3s-node"
```
4. **Execute Pipeline:**
```bash
cd scripts/
source ./setup_env.sh  # Sets up your shell environment
make provision-host    # Configures KVM/libvirt & Tailscale
make apply             # Provisions VMs via Terraform
make provision         # Bootstraps K3s & FluxCD
```

## Architecture

![High-level overview.](resources/full.png)
- [High-level overview](resources/high-level.png)
- [Bare-metal configuration](resources/bare-metal.png)
- [Infrastructure creation (VMs)](resources/bare-metal.png)
- [Infrastructure configuration](resources/bare-metal.png)

## Repo Structure
```
.
├── flux-system/            # GitOps
├── infrastructure/         # Cluster-wide setup
│   └── namespaces/
├── monitoring/             # Monitoring stack
│   ├── grafana/
│   ├── prometheus/
│   ├── kube-state-metrics/
│   ├── node-exporter/
│   └── alertmanager/
├── provisioning/           # IaC and Configuration
│   ├── terraform/          
│   └── ansible/        
├── services/               # Running services
│   ├── homepage/
│   └── jellyfin/
└── scripts/                # Makefile and environment setup
```

## Tooling overview

### Hardware
| Logo | Device | Role |
|:-:|-----|-------------|
| ![Lenovo](https://cdn.simpleicons.org/lenovo?size=32) | Lenovo Thinkpad T14 Gen 1 | Production (bare-metal) |
| ![Lenovo](https://cdn.simpleicons.org/lenovo?size=32) | Lenovo Thinkpad X1 Yoga | Staging (VM Migration) |
| ![Lenovo](https://cdn.simpleicons.org/lenovo?size=32) | Lenovo Legion 5 Slim | Workstation |

### Infrastructure
| Logo | Name | Description |
|:-:|-----|-------------|
| ![Fedora](https://cdn.simpleicons.org/fedora?size=32) | Fedora 43 | Linux Distribution used on Host, VMs and Workstation |
| ![QEMU](https://cdn.simpleicons.org/qemu?size=32) | QEMU/KVM | Hypervisor for running virtual machines |
| ![K3s](https://cdn.simpleicons.org/k3s?size=32) | K3s | Lightweight Kubernetes engine |
| ![FluxCD](https://cdn.simpleicons.org/flux?size=32) | FluxCD | GitOps tool for managing Kubernetes declaratively |
| ![Terraform](https://cdn.simpleicons.org/terraform?size=32) | Terraform | IaC tool for provisioning infrastructure declaratively |
| ![Ansible](https://cdn.simpleicons.org/ansible/000?size=32) | Ansible | Automation tool for post-provisioning configuration and orchestration |

### Monitoring
| Logo | Name | Description |
|:-:|-----|-------------|
| ![Prometheus](https://cdn.simpleicons.org/prometheus?size=32) | Prometheus | Scrapes infrastructure metrics for visualization in Grafana |
| ![AlertManager](https://cdn.simpleicons.org/prometheus/f51d1d?size=32) | AlertManager | Sends notifications and alerts based on Prometheus metrics |
| ![Grafana](https://cdn.simpleicons.org/grafana?size=32) | Grafana | Dashboard and visualization for metrics collected by Prometheus |
| ![kube-state-metrics](https://cdn.simpleicons.org/cncf/5EC5EB?size=32) | kube-state-metrics | Exposes Kubernetes cluster-level metrics for Prometheus |
| ![node-exporter](https://cdn.simpleicons.org/prometheus?size=32) | node-exporter | Collects host-level metrics for Prometheus |
| ![K9s](https://cdn.simpleicons.org/kubernetes?size=32) | k9s | CLI tool to interactively view Kubernetes resources |

### Services
| Logo | Name | Description |
|:-:|-----|-------------|
| ![Jellyfin](https://cdn.simpleicons.org/jellyfin?size=32) | Jellyfin | Media streaming service | 
| ![Homepage](https://cdn.simpleicons.org/homepage?size=32) | Homepage | Highly customizable Dashboard |

## Up next / To do list
- Advanced Network Policy implementation (Network Overhaul)
- Evaluate permissions (RBAC)
- Implement Secret Management - SOPS
- Configure AlertManager alerts
- Set up local DNS, e.g., jellyfin.home.lab
- Some bright new idea I haven't thought of yet

## Goal

Learn **Kubernetes** by breaking things in a controlled environment. Some services are pretty useful too!