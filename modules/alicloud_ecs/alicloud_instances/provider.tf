terraform {
  required_version = ">= 1.6"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.213.0"
      
    }
  }
}

provider "alicloud" {
  region = var.region
}

