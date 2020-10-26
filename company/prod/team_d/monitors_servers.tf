# All hosts from prod without exception

module "cpu_high_utilization" {
  source = "../../../modules/system.cpu.idle"
  selected_tags = "${var.main_tags},env:prod,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

module "cpu_high_load" {
  source = "../../../modules/system.cpu.load.norm.5"
  selected_tags = "${var.main_tags},env:prod,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

module "mem_high_utilization" {
  source = "../../../modules/system.mem.pct_usable"
  selected_tags = "${var.main_tags},env:prod,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

module "high_disk_utilization" {
  source = "../../../modules/system.disk.in_use"
  selected_tags = "${var.main_tags},env:prod,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

module "high_inodes_utilization" {
  source = "../../../modules/system.fs.inodes.in_use"
  selected_tags = "${var.main_tags},env:prod,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}