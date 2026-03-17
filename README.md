# Homelab

K3s cluster running self-hosted services.

>[!NOTE]
> You can find detailed write-ups on my blog:  
> [K3s initial setup](https://gogov.dev/blog/homelab-initial-setup)  
> [Adding Observability with Prometheus & Grafana](https://gogov.dev/blog/homelab-observability)  
> [GitOps, FluxCD Edition](https://gogov.dev/blog/homelab-gitops-fluxcd)  
> [Moving toward virtualization and other design decisions](https://gogov.dev/blog/design-decisions)  
> [Manual to Makefile - Terraform, KVM, Ansible](https://gogov.dev/blog/homelab-terraform-libvirt)  
> [The Complete Pipeline - End-to-end IaC GitOps](https://gogov.dev/blog/end-to-end-iac-gitops)  
> [Implementing SOPS - GitOps secrets management](https://gogov.dev/blog/sops-secret-management)  
> [Networking Overhaul & Production Migration](https://gogov.dev/blog/homelab-networking-overhaul)  
> [NAS Introduction and more networking issues](https://gogov.dev/blog/homelab-nas-introduction)  
> (WIP) [Kyverno implementation and policies]()  

## Quick Start 🚀

### Prerequisites:
> [!IMPORTANT]
> The following is expected:  
> **Production** host permanent IP: **192.168.0.111**  
> **Staging** host permanent IP: **192.168.0.109** (optional, if setting up dual environments)  
> **NAS** permanent IP: **192.168.0.104** (can be replicated without external provisioner, but requires tweaking)  
> If your setup differs in any way, you should adjust those values in all relevant places - deployments, persistent volume claims, setup_env script etc.
1. **Prepare Fedora 43 Host:** 
    - Install a fresh Fedora 43 (KDE tested)
    - Connected via Ethernet (required for bridge)
    - Ensure SSH is active and your key is added
    - Ensure virtualization is enabled at BIOS level
2. **GitHub PAT**: 
    - Provide your GitHub PAT in: **provisioning/ansible/roles/flux/tasks/main.yaml**   
(preferably via Ansible Vault secret as currently implemented)
3. **Terraform Variables**: 
    - Provide/create **terraform.tfvars** in   
**provisioning/terraform/production** AND **provisioning/terraform/staging**:

```sh
# Secrets
server_password = "YOUR_VM_PASSWORD"
ssh_keys = [
  "YOUR_PUBLIC_SSH_KEY(S)" 
]
# Variables
node_count    = 3                # Number of VMs
vm_memory     = "4096"           # VM RAM
vm_vcpu       = 2                # VM CPU
user_name     = "server"         # VM User (don't change)
hostname_base = "k3s-node"       # VM base hostname
env           = "production"     # or "staging" respectively
host_ip       = "192.168.X.XXX"  # Host IP; 192.168.0.111 / 192.168.0.109
```

4. **Execute Pipeline:**
```bash
source scripts/env.sh  # Sets up your shell environment

# Add ENV=production or leave blank for production
# Add ENV=staging for staging

# make provision-host           = production
# make provision-host ENV=stage = staging

make provision-host    # Configures KVM/libvirt & Tailscale
make apply             # Provisions VMs via Terraform
make provision         # Bootstraps K3s & FluxCD
```

## Architecture

>[!NOTE]
>In-progress.

## Repo Structure
```
.
├── clusters/                # GitOps via FluxCD
│   ├── production/
│   └── staging/
├── infrastructure/          # Cluster-wide setup
│   ├── base/                # Base Configuration
│       ├── kyverno/
│       ├── namespaces/
│       ├── networking/
│       └── storage/
│   ├── production/          # Production specific overlays
│   └── staging/             # Staging specific overlays
├── monitoring/              # Monitoring stack
│   ├── base/
│      ├── grafana/
│      ├── prometheus/
│      ├── kube-state-metrics/
│      ├── node-exporter/
│      └── alertmanager/
│   ├── production/
│   └── staging/       
├── policies/                # Kyverno policies
│   ├── base/
│   ├── production/
│   └── staging/        
├── provisioning/            # IaC and Configuration
│   ├── terraform/  
│      ├── modules/
│      ├── production/
│      └── staging/        
│   └── ansible/    
│      ├── inventory/
│      ├── playbook/
│      └── roles/      
├── resources/
├── scripts/
├── services/
│   ├── base/
│       ├── homepage/
│       └── jellyfin/
│   ├── production/
│   └── staging/
├── Makefile                 # Main orchestrator
    
```

## Tooling overview

### Hardware
| Logo | Device | Role |
|:-:|-----|-------------|
| ![Lenovo](https://cdn.simpleicons.org/lenovo?size=32) | Lenovo Thinkpad T14 Gen 1 | Production |
| ![Lenovo](https://cdn.simpleicons.org/lenovo?size=32) | Lenovo Thinkpad X1 Yoga | Staging (Deprecated, no Ethernet Port) |
| ![HP](https://cdn.simpleicons.org/hp?size=32) | HP EliteDesk 800 G2 SFF 2x1TB WD Red | NAS |
| ![Lenovo](https://cdn.simpleicons.org/lenovo?size=32) | Lenovo Legion 5 Slim | Workstation |

### Infrastructure
| Logo | Name | Description |
|:-:|-----|-------------|
| ![Fedora](https://cdn.simpleicons.org/fedora?size=32) | Fedora 43 | Linux Distribution used on Host, VMs and Workstation |
| ![TrueNAS](https://cdn.simpleicons.org/truenas?size=32) | TrueNAS | Open-source unified storage operating system based on OpenZFS |
| ![QEMU](https://cdn.simpleicons.org/qemu?size=32) | QEMU/KVM | Hypervisor for running virtual machines |
| ![K3s](https://cdn.simpleicons.org/k3s?size=32) | K3s | Lightweight Kubernetes engine |
| ![FluxCD](https://cdn.simpleicons.org/flux?size=32) | FluxCD | GitOps tool for managing Kubernetes declaratively |
| ![Terraform](https://cdn.simpleicons.org/terraform?size=32) | Terraform | IaC tool for provisioning infrastructure declaratively |
| ![Ansible](https://cdn.simpleicons.org/ansible/f00?size=32) | Ansible | Automation tool for post-provisioning configuration and orchestration |
| ![SOPS](https://cdn.simpleicons.org/privateinternetaccess/000?size=32) | SOPS | Secret OPerationS - tool for managing secrets |
| ![Cilium](https://cdn.simpleicons.org/cilium/size=32) | Cilium | Solution for providing, securing, and observing network connectivity |
| ![NGINX](https://cdn.simpleicons.org/nginx/size=32) | NGINX | Reverse proxy for external traffic |
| <img src="https://raw.githubusercontent.com/kyverno/artwork/5be18d691ae2b42beb898ffc1312024975749bd8/Kyverno.svg" width="32" height="32" /> | Kyverno | Unified Policy as Code solution |

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
| ![Homepage](https://cdn.simpleicons.org/homepage?size=32) | Homepage | Highly customizable dashboard |

## Up next / To do list
- More networking tuning
- Refine Kyverno policies
- Setup truenas-exporter
- Extract FluxCD bootstrap env to variable

## Goal
Learn **Kubernetes** and its ecosystem by breaking things in a controlled environment.