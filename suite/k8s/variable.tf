variable "prefix" {
  type = string

  default = "k8s-"
}

variable "vpc_prefix" {
  type = string

  default = "k8s-vpc"
}

variable "vswitch_prefix" {
  type = string

  default = "k8s-vswitch"
}

variable "region" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "visitor_ip_list" {
  type = list(string)

  default = []
}

variable "manager_name" {
  type = string

  default = "admin"
}

variable "public_key_file" {
  type = string
}

variable "image_id" {
  type = string

  // "Alibaba Cloud Linux 3.2104 LTS 64 bit"
  default = "aliyun_3_x64_20G_alibase_20230727.vhd"
}

variable "node_instance_type" {
  type = string

  default = "ecs.ebmg6.26xlarge"
}

variable "node_number" {
  type = number

  default = 0
}

variable "control_instance_type" {
  type = string

  default = "ecs.c7.8xlarge"
}

variable "working_dir" {
  type = string
}
