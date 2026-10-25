locals {
  # Git sources exclude ignored provider downloads and local credentials from Nix.
  flake = "git+file://${abspath("${path.module}/..")}"
  labels = {
    managed-by = "terraform"
    host       = "servnix"
  }
}

resource "hcloud_ssh_key" "admin" {
  name       = "servnix-admin"
  public_key = file("${path.module}/../keys/servnix-admin.pub")
  labels     = local.labels
}

# These addresses survive a VM replacement. A full destroy removes them too.
resource "hcloud_primary_ip" "ipv4" {
  name        = "servnix-ipv4"
  type        = "ipv4"
  location    = var.location
  auto_delete = false
  labels      = local.labels
}

resource "hcloud_primary_ip" "ipv6" {
  name        = "servnix-ipv6"
  type        = "ipv6"
  location    = var.location
  auto_delete = false
  labels      = local.labels
}

resource "hcloud_firewall" "servnix" {
  name   = "servnix"
  labels = local.labels

  rule {
    description = "SSH administration"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = var.ssh_source_ips
  }

  rule {
    description = "ICMP and IPv6 network discovery"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "servnix" {
  name        = "servnix"
  server_type = var.server_type
  location    = var.location
  # Temporary bootstrap OS; nixos-anywhere replaces it with the flake below.
  image        = "ubuntu-24.04"
  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.servnix.id]
  labels       = local.labels

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
    ipv4         = hcloud_primary_ip.ipv4.id
    ipv6         = hcloud_primary_ip.ipv6.id
  }
}

module "nixos" {
  source = "git::https://github.com/nix-community/nixos-anywhere.git//terraform/all-in-one?ref=92b94751fc010eab62d07de40972cffa6937cafd"

  nixos_system_attr      = "${local.flake}#nixosConfigurations.servnix.config.system.build.toplevel"
  nixos_partitioner_attr = "${local.flake}#nixosConfigurations.servnix.config.system.build.diskoScript"
  target_host            = hcloud_primary_ip.ipv4.ip_address
  instance_id            = hcloud_server.servnix.id
  copy_host_keys         = true

  # Passed to extendModules by the build helper; no generated Nix files required.
  special_args = {
    terraform = {
      ipv6_address = cidrhost(hcloud_primary_ip.ipv6.ip_network, 1)
    }
  }

  # Authentication uses ssh-agent; private key contents never enter Terraform.
}

# Home Manager includes this address-only file; it owns the user/key settings.
resource "local_file" "ssh_address" {
  filename        = pathexpand("~/.ssh/servnix-address.conf")
  file_permission = "0600"
  content         = "Host servnix\n  HostName ${hcloud_primary_ip.ipv4.ip_address}\n"
}
