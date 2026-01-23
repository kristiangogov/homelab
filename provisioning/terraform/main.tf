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
  uri = "qemu+ssh://server@yoga/system"
}

resource "libvirt_volume" "fedora_base" {
  name   = "fedora-base"
  pool   = "default"
  source = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "fedora_volume" {
  count          = var.node_count
  name           = "fedora-node-${count.index}.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.fedora_base.id
  size           = 21474836480 # 20GB in bytes
  format         = "qcow2"
}

data "cloudinit_config" "commoninit" {
  count         = var.node_count
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud_init.cfg", {
      hostname        = "${var.hostname_base}-${count.index}"
      user_name       = var.user_name
      ssh_keys        = jsonencode(var.ssh_keys) 
      server_password = var.server_password
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

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory/inventory.ini"
  content  = <<EOT
[physical]
yoga ansible_host=yoga ansible_user=server
thinkpad ansible_host=thinkpad ansible_user=b1ur

[k3s_server]
${libvirt_domain.k3s_node[0].name} ansible_host=${libvirt_domain.k3s_node[0].network_interface[0].addresses[0]} ansible_user=server

[k3s_agents]
%{ for i in range(1, length(libvirt_domain.k3s_node)) ~}
${libvirt_domain.k3s_node[i].name} ansible_host=${libvirt_domain.k3s_node[i].network_interface[0].addresses[0]} ansible_user=server
%{ endfor ~}

[vms:children]
k3s_server
k3s_agents

[everything:children]
physical
vms
EOT
}