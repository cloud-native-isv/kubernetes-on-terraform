output "k8s_ecs_interface_mapping" {
  value = {
    for interface in alicloud_ecs_network_interface.k8s_ecs_network_interface :
    interface.network_interface_name => {
      interface_id = interface.id
      mac          = interface.mac
      ipv4         = interface.primary_ip_address
      vswitch_id   = interface.vswitch_id
      cidr_block = var.vswitches_mapping[
        var.interface_mapping[interface.network_interface_name].zone_id
      ].cidr_block
    }
  }
}
