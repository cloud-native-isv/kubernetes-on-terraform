variable "region" {
  type = string
}

variable "ecs_disk_mapping" {
  type = map(object({ # disk_name => {}
    disk_name  = string
    zone_id    = string
    node_id    = string
    size_in_gb = string
  }))
}

variable "ecs_disk_category" {
  type = string 
  default = "cloud_essd"
}