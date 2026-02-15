resource "proxmox_virtual_environment_container" "customer" {
  node_name   = var.node_name
  vm_id       = var.vmid
  description = "Terraform-managed customer LXC"
  tags        = ["terraform", "customer", "lan-only"]

  # Put it in your pool if you want (optional)
  pool_id = var.pool_id

  # Clone from your template CT
  clone {
    datastore_id = var.clone_datastore_id
    vm_id        = var.template_vmid
  }

  # LAN only
  network_interface {
    name     = "eth0"
    bridge   = var.lan_bridge      # vmbr1
    firewall = true
    enabled  = true
  }

  # Give the clone a UNIQUE network config at creation
  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipv4_cidr
        gateway = var.ipv4_gateway
      }
    }

    # optional but nice
    dns {
      servers = var.dns_servers
    }
  }

  started = false # safest: create it powered-off first
}
