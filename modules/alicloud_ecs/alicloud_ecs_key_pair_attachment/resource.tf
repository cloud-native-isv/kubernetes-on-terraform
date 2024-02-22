resource "alicloud_ecs_key_pair_attachment" "default" {
  key_pair_name = var.key_pair_name
  instance_ids  = var.instance_ids
  force         = true
}
