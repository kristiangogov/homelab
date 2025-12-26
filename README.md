# Homelab

K3s cluster running self-hosted services for personal use.

> [!NOTE] 
> You can find detailed write-ups on my blog:  
> [Homelab: K3s initial setup](https://gogov.dev/blog/homelab-initial-setup)

## Structure

```
.
└── service-name/        # Service name
    ├── namespace.yml    # k8s Namespace
    ├── deployment.yml   # k8s Deployment
    ├── configmap.yml    # k8s Config Map
    ├── service.yml      # k8s Service
    ├── etc.
```

## Setup

**Quick Overview:**

![k9s cli preview](https://i.imgur.com/7pZ9Sv0.png)


**Hardware**: Lenovo ThinkPad T14 Gen 1   
**OS**: Fedora 43 KDE Edition  
**Engine**: K3s  
**Observability Stack**: k9s (cli), Prometheus, Grafana, AlertManager, node-exporter, kube-statemetrics  
**Services**: Jellyfin Media Streaming

**Up next:** [HomePage](https://gethomepage.dev/), Configure AlertManager

## Goal

Learn **Kubernetes** by breaking things in a controlled environment. Some services are pretty useful too!