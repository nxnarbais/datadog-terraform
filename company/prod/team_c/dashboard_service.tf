# All hosts from prod without exception
module "prod_high_user_cpu" {
  source = "../../../modules/service_dashboard"
  env = var.env
  cluster_name = var.cluster_name
  service = var.service
  service_thresholds = var.service_thresholds
  service_dependencies = var.service_dependencies
}