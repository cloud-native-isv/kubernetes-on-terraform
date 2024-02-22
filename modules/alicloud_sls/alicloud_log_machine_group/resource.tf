resource "alicloud_log_machine_group" "machine_group" {
  project       = var.log_project
  name          = var.name
  topic         = ""
  identify_type = "userdefined"
  identify_list = var.identify_list
}

