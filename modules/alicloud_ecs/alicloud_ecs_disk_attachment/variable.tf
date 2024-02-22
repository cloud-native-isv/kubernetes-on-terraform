variable "region" {
  type = string
}

variable "ecs_disk_mapping" {
  type = map(object({
    disk_id = string
    node_id = string
  }))
}
