variable "region" {
  type = string
}

variable "eip_ids" {
  type = list(string) // instance_id => eip_id
}

variable "ecs_ids" {
  type = list(string)
}