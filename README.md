# Homelab

K3s cluster running self-hosted services for personal use.

> [!NOTE] 
> You can find detailed write-ups on my blog:  
> [K3s initial setup](https://gogov.dev/blog/homelab-initial-setup)  
> [Adding Observability with Prometheus & Grafana](https://gogov.dev/blog/homelab-observability)  
> [GitOps, FluxCD Edition](https://gogov.dev/blog/homelab-gitops-fluxcd)  
> [Moving toward virtualization and other design decisions](https://gogov.dev/blog/design-decisions)  

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
├── provisioning/           # VM Setup (work-in-progress)
│   ├── terraform/          
│   └── ansible/        
├── services/               # Running services
│   ├── homepage/
│   └── jellyfin/
└── scripts/                # Placeholder
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
- (In Progress) Fully automated virtualized setup on the Staging Env
- Evaluate permissions (RBAC)
- Implement Secret Management - SOPS
- Configure AlertManager alerts
- Set up local DNS, e.g., jellyfin.home.lab
- Some bright new idea I haven't thought of yet

## Goal

Learn **Kubernetes** by breaking things in a controlled environment. Some services are pretty useful too!