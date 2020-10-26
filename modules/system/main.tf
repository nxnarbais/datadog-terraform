/**
 * CPU
 */

# All hosts from prod without exception
module "high_user_cpu" {
  source = "../system.cpu.idle"
  selected_tags = "${var.selected_tags},!exception_cpu_utilization:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

# Some specific hosts from prod
module "high_cpu_utilization_critical" {
  source = "../system.cpu.idle"
  selected_tags = "${var.selected_tags},critical:true,exception_cpu_utilization:true"
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
  thresholds = {
    "alert" = 10,
    "warn" = 15
  }
}

module "high_cpu_load_norm_5" {
  source = "../system.cpu.load.norm.5"
  selected_tags = "${var.selected_tags},!exception_cpu_load_norm_5:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

/**
 * MEM
 */

module "low_mem_usable" {
  source = "../system.mem.pct_usable"
  selected_tags = "${var.selected_tags},!exception_mem_pct_usable:true"
  notifications = {
    alert = var.notifications.slack
    warn = var.notifications.slack
    recovery = ""
    default = var.notifications.slack
  }
  # thresholds = {
  #   "alert" = 15,
  #   "warn" = 10
  # }
}

/**
 * DISK
 */

module "high_disk_utilization" {
  source = "../system.disk.in_use"
  selected_tags = "${var.selected_tags},!exception_disk_in_use:true"
  notifications = {
    alert = var.notifications.slack
    warn = var.notifications.slack
    recovery = ""
    default = var.notifications.slack
  }
  # thresholds = {
  #   "alert" = 0.9,
  #   "warn" = 0.8
  # }
}

/**
 * FS
 */

module "high_inodes_utilization" {
  source = "../system.fs.inodes.in_use"
  selected_tags = "${var.selected_tags},!exception_disk_in_use:true"
  notifications = {
    alert = var.notifications.slack
    warn = var.notifications.slack
    recovery = ""
    default = var.notifications.slack
  }
  # thresholds = {
  #   "alert" = 0.9,
  #   "warn" = 0.8
  # }
}