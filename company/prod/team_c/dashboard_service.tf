module "service_dashboard_dependencies" {
  source = "../../../modules/dashboards.service.dependencies"
  env = var.env
  cluster_name = var.cluster_name
  service = var.service
  service_thresholds = var.service_thresholds
  service_dependencies = var.service_dependencies
  jvm_enabled = var.jvm_enabled
  network_enabled = var.network_enabled
}

module "service_dashboard_overview" {
  source = "../../../modules/dashboards.service.overview"
  env = var.env
  service = var.service
  service_slo = var.service_slo
  service_thresholds = var.service_thresholds
  dependency_dashboard_id = module.service_dashboard_dependencies.service_overview_dashboard_output
}
