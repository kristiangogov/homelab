# Homelab

K3s cluster running self-hosted services for personal use.

> [!NOTE] 
> You can find detailed write-ups on my blog:  
> [K3s initial setup](https://gogov.dev/blog/homelab-initial-setup)  
> [Adding Observability with Prometheus & Grafana](https://gogov.dev/blog/homelab-observability)

## Structure
```
.
├── infrastructure/         # Cluster-wide setup
│   └── namespaces/
├── monitoring/             # Monitoring stack
│   ├── grafana/
│   ├── prometheus/
│   ├── kube-state-metrics/
│   ├── node-exporter/
│   └── alertmanager/
├── services/               # Running services
│   ├── homepage/
│   └── jellyfin/
└── scripts/                # Setup scripts
    └── apply.sh
```


## Setup

**Quick Overview:**

![k9s cli preview](https://i.imgur.com/7pZ9Sv0.png)


**Hardware**: Lenovo ThinkPad T14 Gen 1   
**OS**: Fedora 43 KDE Edition  
**Engine**: K3s  
**Observability Stack**: k9s (cli), Prometheus, Grafana, AlertManager, node-exporter, kube-state-metrics  
**Services**: Jellyfin Media Streaming, Homepage

**Up next**: Configure AlertManager, Harden Security

## Goal

Learn **Kubernetes** by breaking things in a controlled environment. Some services are pretty useful too!