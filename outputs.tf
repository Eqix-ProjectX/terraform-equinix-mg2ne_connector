output "vrf_ranges" {
  value = equinix_metal_vrf.myvrf.ip_ranges
}
output "cidr" {
  value = equinix_metal_reserved_ip_block.myrange.cidr
}
output "network_range" {
  value = equinix_metal_reserved_ip_block.myrange.network
}