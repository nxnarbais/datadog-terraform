terraform {
  required_providers {
    datadog = {
      source = "datadog/datadog"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
