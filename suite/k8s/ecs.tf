module "alicloud_security_group" {
  source            = "../../modules/alicloud_ecs/alicloud_security_group"
  region            = var.region
  vpc_id            = alicloud_vpc.k8s_vpc.id
  resource_group_id = var.resource_group_id
}

module "alicloud_security_group_rule" {
  source            = "../../modules/alicloud_ecs/alicloud_security_group_rule"
  region            = var.region
  security_group_id = module.alicloud_security_group.id
  visitor_ip_list   = concat(var.visitor_ip_list, [local.my_network])
}

module "alicloud_instance" {
  source                     = "../../modules/alicloud_ecs/alicloud_instance"
  region                     = var.region
  resource_group_id          = var.resource_group_id
  instances                  = { for node in local.node_list : node.instance_name => node }
  key_pair_name              = module.alicloud_ecs_key_pair.key_pair_name
  vpc_id                     = alicloud_vpc.k8s_vpc.id
  security_groups            = [module.alicloud_security_group.id]
  internet_max_bandwidth_out = 100
  data_disks                 = local.default_data_disks
}

module "alicloud_ecs_key_pair" {
  source            = "../../modules/alicloud_ecs/alicloud_ecs_key_pair"
  region            = var.region
  public_key        = file(var.public_key_file)
  resource_group_id = var.resource_group_id
  name              = "${var.prefix}${var.manager_name}-${var.region}"
}

module "alicloud_ecs_key_pair_attachment" {
  source        = "../../modules/alicloud_ecs/alicloud_ecs_key_pair_attachment"
  region        = var.region
  key_pair_name = module.alicloud_ecs_key_pair.key_pair_name
  instance_ids  = module.alicloud_instance.instance_ids
}
