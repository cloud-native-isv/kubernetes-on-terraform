data "alicloud_security_groups" "k8s_security_groups" {
  vpc_id   = var.vpc_id
}
