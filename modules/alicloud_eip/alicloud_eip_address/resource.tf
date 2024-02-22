resource "alicloud_eip_address" "default" {
  for_each          = { for i in range(var.number) : "${i}" => i }
  resource_group_id = var.resource_group_id
  isp               = "BGP"
  netmode           = "public"
  bandwidth         = "200"
  payment_type      = "PayAsYouGo"
}
