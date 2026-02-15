variable "proxmox_endpoint" {
  type        = string
  description = "https://YOUR-PVE:8006/"
}

variable "proxmox_api_token" {
  type        = string
  description = "terraform@pve!tokenid=secret"
  sensitive   = true
}

variable "node_name" {
  type    = string
  default = "r1"
}

variable "pool_id" {
  type    = string
  default = "terraform-one"
}

variable "template_vmid" {
  type    = number
  default = 1420
}

# IMPORTANT: this is the STORAGE ID, not the path.
# In your GUI dropdown you’re seeing /storage/SSD3 etc — the ID is usually "SSD3" or "local".
variable "clone_datastore_id" {
  type    = string
  default = "SSD3"
}

variable "lan_bridge" {
  type    = string
  default = "vmbr1"
}

variable "vmid" {
  type    = number
  default = 1500
}

variable "hostname" {
  type    = string
  default = "terraform-customer-lxc-1500"
}

variable "ipv4_cidr" {
  type    = string
  default = "10.0.0.50/24"
}

variable "ipv4_gateway" {
  type    = string
  default = "10.0.0.1"
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.0.0.1"]
}
