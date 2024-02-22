data "alicloud_instances" "ecs_instances" {
  ids    = var.ecs_ids
  vpc_id = var.vpc_id
  status = "Running"
}
