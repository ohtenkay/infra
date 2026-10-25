output "ipv4_address" {
  value = hcloud_primary_ip.ipv4.ip_address
}

output "ipv6_address" {
  value = cidrhost(hcloud_primary_ip.ipv6.ip_network, 1)
}

output "server_id" {
  value = hcloud_server.servnix.id
}

output "ssh_command" {
  value = "ssh ondrej@${hcloud_primary_ip.ipv4.ip_address}"
}
