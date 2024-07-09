
data "equinix_network_device" "vd_pri" {
  name = "vd-${var.metro_code}-${var.username}-pre"
}
data "equinix_network_device" "vd_sec" {
  name = "vd-${var.sec_metro_code}-${var.username}-sec"
}
data "equinix_metal_device" "instance" {
  project_id = var.project_id
  device_id  = "metal-${var.metro}-node-1}"
}
locals {
  config = <<-EOF
  from netmiko import ConnectHandler

  pri = {
    'device_type': 'cisco_xe',
    'host'       : '${data.equinix_network_device.vd_pri.ssh_ip_address}',
    'username'   : '${var.username}',
    'password'   : '${data.equinix_network_device.vd_pri.vendor_configuration.adminPassword}'
  }

  sec = {
    'device_type': 'cisco_xe',
    'host'       : '${data.equinix_network_device.vd_sec.ssh_ip_address}',
    'username'   : '${var.username}',
    'password'   : '${data.equinix_network_device.vd_sec.vendor_configuration.adminPassword}'
  }

  ha = [pri, sec]

  for i in ha:
    net_connect = ConnectHandler(**i)
    config_commands = [
      'ip http secure-server',
      'restconf'
    ]
    output = net_connect.send_config_set(config_commands)
    print(output)
  EOF
}

resource "equinix_metal_vrf" "myvrf" {
  description = var.vrf_desc
  name        = var.vrf_name
  metro       = var.metro
  local_asn   = var.vrf_asn
  ip_ranges   = var.vrf_ranges
  project_id  = var.project_id
}

# Create Metal Gateway for a VLAN with a private IPv4 block with 8 IP addresses

resource "equinix_metal_vlan" "myvlan" {
  description = var.vlan_desc
  metro       = var.metro
  project_id  = var.project_id
}

resource "equinix_metal_reserved_ip_block" "myrange" {
  description = var.range_desc
  project_id  = var.project_id
  metro       = var.metro
  type        = "vrf"
  vrf_id      = equinix_metal_vrf.myvrf.id
  cidr        = var.cidr
  network     = var.network_range
}

resource "equinix_metal_gateway" "mygateway" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.myvlan.id
  ip_reservation_id = equinix_metal_reserved_ip_block.myrange.id
}

resource "null_resource" "cisco" {
  provisioner "remote-exec" {
    connection {
      type           = "ssh"
      user           = "root"
      private_key    = var.private_key
      host           = data.equinix_metal_device.instance.access_public_ipv4
    }
    
    inline = [
      "apt install python3-pip -y",
      "y",
      "pip install netmiko",
      "y",
      "cat << EOF > ~/restconf.py\n${local.config}\nEOF",
      "python3 restconf.py"
    ]    
  }
}

# provider "iosxe" {
#   username = var.username
#   password = module.ne.pass
#   url      = "https://${module.ne.ssh_ip_vd}"
# }

# resource "iosxe_cli" "example" {
#   cli = <<-EOT
#   interface Lo0
#   desc testing
#   EOT
# }


