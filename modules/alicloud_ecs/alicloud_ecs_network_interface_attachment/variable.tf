variable "region" {
  type = string
}

variable "k8s_ecs_interface_mapping" {
  type = map(object({
    interface_id = string
    node_id      = string
  }))
}
