variable "region" {
  type = string
}

variable "resource_group_id" {
  type = string
}

// instance
variable "new_ecs_template" {
  type = object({
    system_disk_category = string
    system_disk_size     = number
  })

  default = {
    system_disk_category = "cloud_essd"
    system_disk_size     = 80
  }
}

variable "key_pair_name" {
  type = string
}

// network
variable "vpc_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "internet_max_bandwidth_out" {
  type = number
}

// storage
variable "data_disks" {
  type = list(object({
    name                 = string
    size                 = number
    category             = string
    encrypted            = bool
    delete_with_instance = bool
    description          = string
  }))
}

variable "instances" {
  type = map(object({
    instance_type = string
    instance_name = string
    image_id      = string
    vswitch_id    = string
    init_scripts  = list(string)
  }))
}
