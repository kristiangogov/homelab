variable "node_count" {
  type        = number
  description = "Number of VMs to deploy"
  default     = 3
}

variable "vm_memory" {
  type    = string
  default = "4096"
}

variable "vm_vcpu" {
  type    = number
  default = 2
}

variable "user_name" {
  type    = string
  default = "server"
}

variable "hostname_base" {
  type    = string
  default = "k3s-node"
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of public SSH keys to inject into the VM"
}

variable "server_password" {
  type        = string
  description = "The default password for the server user"
  sensitive   = true
}

variable "host_ip" {
  type        = string
  default     = "192.168.0.111"
}