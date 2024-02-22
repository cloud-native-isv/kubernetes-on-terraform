output "ecs_interfaces" {
  value = merge(
    {
      for interface in data.alicloud_ecs_network_interfaces.by_id.interfaces : interface.id => interface
    },
    {
      for interface in data.alicloud_ecs_network_interfaces.by_name.interfaces : interface.id => interface
    }
  )
}

