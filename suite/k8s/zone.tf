data "alicloud_zones" "k8s_node_zone" {
  enable_details          = true
  available_instance_type = var.node_instance_type
}

data "alicloud_zones" "k8s_control_zone" {
  enable_details          = true
  available_instance_type = var.control_instance_type
}

data "alicloud_zones" "k8s_vpc_zone" {
  enable_details              = true
  available_resource_creation = "Instance"
}
