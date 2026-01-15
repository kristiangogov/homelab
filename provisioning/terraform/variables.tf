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