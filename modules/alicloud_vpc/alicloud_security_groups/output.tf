output "k8s_security_groups" {
  value = {
    for group in data.alicloud_security_groups.k8s_security_groups.groups : group.id => {
      id     = group.id
      name   = group.name
      vpc_id = group.vpc_id
    }
  }
}
