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

resource "libvirt_volume" "fedora_server_qcow2" {
  name   = "fedora43-server.qcow2"
  pool   = "default"
  source = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
  format = "qcow2"
}

data "cloudinit_config" "commoninit" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud_init.cfg")
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.cloudinit_config.commoninit.rendered
  pool      = "default"
}

resource "libvirt_domain" "k3s_node" {
  name   = "fedora-vm-01"
  memory = "4096"
  vcpu   = 2
  type   = "kvm"

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.fedora_server_qcow2.id
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

output "vm_ip" {
  value = libvirt_domain.k3s_node.network_interface[0].addresses[0]
}
