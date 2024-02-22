output "eip_ids" {
  value = [for k, v in alicloud_eip_address.default : v.id]
}
