output "k8s_vswitches" {
  value = {
    for vswitch in data.alicloud_vswitches.k8s_vswitches.vswitches : vswitch.zone_id => {
      id         = vswitch.id
      vpc_id     = vswitch.vpc_id
      zone_id    = vswitch.zone_id
      cidr_block = vswitch.cidr_block
    }
  }
}
