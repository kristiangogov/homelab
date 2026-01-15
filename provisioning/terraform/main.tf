terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.2"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "fedora_volume" {
  count  = var.node_count
  name   = "fedora-node-${count.index}.qcow2"
  pool   = "default"
  source = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
  format = "qcow2"
}

data "cloudinit_config" "commoninit" {
  count         = var.node_count
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud_init.cfg", {
      hostname  = "${var.hostname_base}-${count.index}"
      user_name = var.user_name
    })
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count     = var.node_count
  name      = "commoninit-${count.index}.iso"
  user_data = data.cloudinit_config.commoninit[count.index].rendered
  pool      = "default"
}

resource "libvirt_domain" "k3s_node" {
  count  = var.node_count
  name   = "k3s-node-${count.index}"
  memory = var.vm_memory
  vcpu   = var.vm_vcpu
  type   = "kvm"

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.fedora_volume[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
  }
}

output "vm_ips" {
  value = {
    for vm in libvirt_domain.k3s_node :
    vm.name => vm.network_interface[0].addresses[0]
  }
}