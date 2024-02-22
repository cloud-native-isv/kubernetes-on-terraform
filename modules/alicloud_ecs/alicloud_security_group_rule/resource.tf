resource "alicloud_security_group_rule" "visitor" {
  for_each          = toset(var.visitor_ip_list)
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 2
  security_group_id = var.security_group_id
  cidr_ip           = each.value
  description       = "visitor ${each.value}"
}
