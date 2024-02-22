variable "region" {
  type = string
}

variable "interface_mapping" {
  type = map(object({ # interface_name => {}
    node_id            = string
    zone_id            = string
    security_group_ids = list(string)
  }))
}

variable "vswitches_mapping" {
  type = map(object({ 
    id         = string
    vpc_id     = string
    zone_id    = string
    cidr_block = string
  }))
}

