resource "alicloud_vswitch" "k8s_vswitches" {
  for_each     = local.vswitches_map
  vswitch_name = each.key
  cidr_block   = cidrsubnet(alicloud_vpc.k8s_vpc.cidr_block, 8, each.value.index)
  vpc_id       = alicloud_vpc.k8s_vpc.id
  zone_id      = each.value.zone.id
}
