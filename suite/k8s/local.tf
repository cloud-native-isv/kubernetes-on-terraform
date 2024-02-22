locals {
  # nodes
  default_data_disks = [
    {
      name                 = "data"
      size                 = 500
      category             = "cloud_essd"
      encrypted            = false
      delete_with_instance = true
      description          = "data disk"
    }
  ]

  node_zones    = sort(data.alicloud_zones.k8s_node_zone.ids)
  control_zones = sort(data.alicloud_zones.k8s_control_zone.ids)
  node_number   = var.node_number > 0 ? var.node_number : length(local.node_zones)
  server_number = 1

  vswitch_map = {
    for k, v in alicloud_vswitch.k8s_vswitches : v.zone_id => v.id
  }

  k8s_control = {
    for i in range(local.server_number) : "${var.prefix}control" => {
      instance_type = var.control_instance_type
      instance_name = "${var.prefix}control"
      image_id      = var.image_id
      zone_id       = local.control_zones[0]
      vswitch_id    = local.vswitch_map[local.control_zones[0]]
      index         = 0
      init_scripts = [
        file("${path.module}/script/00-setup-os.sh"),
        file("${path.module}/script/01-install-k8s.sh"),
        file("${path.module}/script/02-prepare-k8s.sh"),
        "echo ${local.containerd_config}|base64 -d > /etc/containerd/config.toml",
        file("${path.module}/script/03-setup-k8s-control.sh"),
        "wait",
        "reboot"
      ]
  } }
  k8s_nodes = {
    for i in range(local.node_number) : "${var.prefix}node-${i}" => {
      instance_type = var.node_instance_type
      instance_name = "${var.prefix}node-${i}"
      image_id      = var.image_id
      zone_id       = local.node_zones[i]
      vswitch_id    = local.vswitch_map[local.node_zones[i]]
      index         = i + 1
      init_scripts = [
        file("${path.module}/script/00-setup-os.sh"),
        file("${path.module}/script/01-install-k8s.sh"),
        file("${path.module}/script/02-prepare-k8s.sh"),
        "echo ${local.containerd_config}|base64 -d > /etc/containerd/config.toml",
        file("${path.module}/script/03-setup-k8s-node.sh"),
        "wait",
        "reboot"
      ]
    }
  }
  node_list = flatten([values(local.k8s_control), values(local.k8s_nodes)])

  containerd_config = base64encode(file("${path.module}/config/containerd.toml"))
}

locals {
  # network
  vswitches_list = [
    for zone in data.alicloud_zones.k8s_vpc_zone.zones :
    {
      name = "${var.vswitch_prefix}-${zone.id}"
      zone = zone
    }
  ]

  vswitches_map = {
    for i in range(length(local.vswitches_list)) : "${local.vswitches_list[i].name}" => merge(
      local.vswitches_list[i], {
        index = i
      }
    )
  }
}

locals {
  # log
  log_project_name = "${var.prefix}kubernetes-telemetry-${var.region}"

  common_log_files = fileset("${path.module}/logs/common", "*.yaml")
  common_log_map   = { for f in local.common_log_files : trimsuffix(f, ".yaml") => yamldecode(file("${path.module}/logs/common/${f}")) }

  json_log_files = fileset("${path.module}/logs/json", "*.yaml")
  json_log_map   = { for f in local.json_log_files : trimsuffix(f, ".yaml") => yamldecode(file("${path.module}/logs/json/${f}")) }

  metrics_log_files = fileset("${path.module}/logs/metrics", "*.yaml")
  metrics_log_map   = { for f in local.metrics_log_files : trimsuffix(f, ".yaml") => yamldecode(file("${path.module}/logs/metrics/${f}")) }

  identify_list = ["${local.log_project_name}"]
}
