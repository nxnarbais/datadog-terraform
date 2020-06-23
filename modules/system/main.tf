/**
 * CPU
 */

# All hosts from prod without exception
module "prod_high_user_cpu" {
  source = "../system.cpu.user"
  selected_tags = "${var.selected_tags},env:prod,!exception_user_cpu:true"
  notifications = {
    alert = var.notifications.email
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
}

# Some specific hosts from prod
module "prod_high_user_cpu_critical" {
  source = "../system.cpu.user"
  selected_tags = "${var.selected_tags},env:prod,critical:true,exception_user_cpu:true"
  notifications = {
    alert = "${var.notifications.email} ${var.notifications.slack}"
    warn = var.notifications.slack
    recovery = ""
    default = ""
  }
  thresholds = {
    "alert" = 20,
    "warn" = 15
  }
}

/**
 * MEM
 */

# All hosts from dev without exception
module "prod_low_mem_usable" {
  source = "../system.mem.pct_usable"
  selected_tags = "${var.selected_tags},env:prod,!exception_mem_pct_usable:true"
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