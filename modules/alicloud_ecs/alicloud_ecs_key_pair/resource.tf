resource "alicloud_ecs_key_pair" "ecs_key_pair" {
  public_key        = var.public_key
  resource_group_id = var.resource_group_id
  key_pair_name     = var.name
}
