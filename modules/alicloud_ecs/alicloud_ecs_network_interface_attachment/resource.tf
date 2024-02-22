resource "alicloud_ecs_network_interface_attachment" "k8s_ecs_network_interface_attachment" {
  for_each             = var.k8s_ecs_interface_mapping
  network_interface_id = each.value.interface_id
  instance_id          = each.value.node_id
}