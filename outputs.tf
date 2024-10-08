output "vrf_ranges" {
  value = equinix_metal_vrf.myvrf_pri.ip_ranges
}
output "vrf_ranges_sec" {
  value = equinix_metal_vrf.myvrf_sec.ip_ranges
}
output "cidr" {
  value = equinix_metal_reserved_ip_block.myrange_pri.cidr
}
output "network_range_pri" {
  value = equinix_metal_reserved_ip_block.myrange_pri.network
}
output "network_range_sec" {
  value = equinix_metal_reserved_ip_block.myrange_sec.network
}
output "vrf_pri" {
  value = equinix_metal_vrf.myvrf_pri.id
}
output "vrf_sec" {
  value = equinix_metal_vrf.myvrf_sec.id
}
output "vrf_asn" {
  value = equinix_metal_vrf.myvrf_pri.local_asn
}
output "vlan" {
  value = equinix_metal_vlan.myvlan_pri.vxlan
}
output "vlan_sec" {
  value = equinix_metal_vlan.myvlan_sec.vxlan
}