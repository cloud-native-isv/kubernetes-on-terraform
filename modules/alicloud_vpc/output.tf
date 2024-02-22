output "k8s_vpc_id" {
  value = resource.alicloud_vpc.ack_vpc.id
}

output "k8s_vpc_route_table_id" {
  value = resource.alicloud_vpc.ack_vpc.route_table_id
}

output "k8s_vpc_router_id" {
  value = resource.alicloud_vpc.ack_vpc.router_id
}
