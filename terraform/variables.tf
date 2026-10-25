variable "server_type" {
  description = "Hetzner Cloud server type; keep at least 2 GB RAM for installation."
  type        = string
  default     = "cpx12"
}

variable "location" {
  description = "Hetzner location shared by the server and its primary IPs."
  type        = string
  default     = "nbg1"
}

variable "ssh_source_ips" {
  description = "Source CIDRs allowed to connect over SSH."
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}
