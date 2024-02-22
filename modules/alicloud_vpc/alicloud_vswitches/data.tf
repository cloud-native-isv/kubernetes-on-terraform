data "alicloud_vswitches" "k8s_vswitches" {
  vpc_id = var.vpc_id
  status = "Available"
}
