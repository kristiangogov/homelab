module "libvirt" {
  source = "../modules/libvirt"

  env             = var.env
  host_ip         = var.host_ip
  ssh_keys        = var.ssh_keys
  server_password = var.server_password
  node_count      = var.node_count
  vm_memory       = var.vm_memory
  vm_vcpu         = var.vm_vcpu
  user_name       = var.user_name
  hostname_base   = var.hostname_base
}

output "vm_ips" {
  value = module.libvirt.vm_ips
}