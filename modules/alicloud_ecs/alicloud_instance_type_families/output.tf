
output "first_instance_type_family_id" {
  value = "${data.alicloud_instance_type_families.default.families.0.id}"
}

output "instance_ids" {
  value = "${data.alicloud_instance_type_families.default.ids}"
}