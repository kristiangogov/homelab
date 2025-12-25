# Homelab

K3s cluster running self-hosted services for personal use.

> [!NOTE] 
> You can find detailed write-ups on my blog:  
> [Homelab: K3s initial setup](https://gogov.dev/blog/homelab-initial-setup)

## Structure

```
.
└── service-name/                # Service name
    ├── configuration-file.yml   # Kubernetes manifests
```

## Setup

**Hardware**: Lenovo ThinkPad T14 Gen 1 I had laying around collecting dust.
**OS**: Fedora 43 KDE Edition
**Engine**: K3s
**Observability**: k9s
**Services**: Jellyfin

## Goal

Learn **Kubernetes** by breaking things in a controlled environment. Some services are pretty useful too!