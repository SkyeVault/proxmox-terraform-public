provider "proxmox" {
  endpoint = "https://YOUR_PVE_HOST:8006/api2/json"
  api_token = var.proxmox_api_token
  insecure  = true
}
