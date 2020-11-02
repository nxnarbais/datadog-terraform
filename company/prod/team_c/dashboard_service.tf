module "service_dashboard_dependencies" {
  source = "../../../modules/service_dashboard"
  env = var.env
  cluster_name = var.cluster_name
  service = var.service
  service_thresholds = var.service_thresholds
  service_dependencies = var.service_dependencies
  jvm_enabled = var.jvm_enabled
  network_enabled = var.network_enabled
}
