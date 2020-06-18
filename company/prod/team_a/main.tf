# Providers

# Datadog
provider "datadog" {
  version = "2.8.0"
  api_url = var.datadog_api_url
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
