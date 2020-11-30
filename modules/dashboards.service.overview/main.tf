resource "datadog_dashboard" "service_overview_dashboard" {
  title         = "[Sandbox][KB][TF] ${var.service["name"]} Service Overview"
  description   = var.description
  layout_type   = "free"
  is_read_only  = true
  # notify_list = var.notify_list
  template_variable {
    name   = "env"
    prefix = "env"
    default = var.env
  }
  template_variable {
    name   = "service"
    prefix = "service"
    default = var.service["name"]
  }

  widget {
    note_definition {
      content = <<EOF
# $service.value - Overview

- $env

[Terraform Repo](https://github.com/nxnarbais/terraform-datadog)
EOF
    }
    layout = {
      height = 24
      width = 56
      x = 1
      y = 1
    }
  }

  widget {
    note_definition {
      content = <<EOF
## SLOs

*Agreed with XX*

Note: does not change with template variables
EOF
      background_color = "gray"
      show_tick = true
      tick_edge = "right"
      tick_pos = "50%"
    }
    layout = {
      height = 24
      width = 16
      x = 58
      y = 1
    }
  }

  widget {
    service_level_objective_definition {
      title = "${var.service["name"]} SLOs"
      view_type = "detail"
      slo_id = var.service_slo
      show_error_budget = true
      view_mode = "overall"
      time_windows = ["7d","previous_week","30d"]
    }
    layout = {
      height = 26
      width = 57
      x = 75
      y = 1
    }
  }

  widget {
    servicemap_definition {
      service = "$service"
      filters = ["$env"]
      title = "$service.value"
    }
    layout = {
      height = 22
      width = 56
      x = 1
      y = 26
    }
  }

  widget {
    note_definition {
      content = <<EOF
## Key SLIs
EOF
      background_color = "gray"
      show_tick = true
      tick_edge = "bottom"
      tick_pos = "50%"
    }
    layout = {
      height = 6
      width = 74
      x = 58
      y = 26
    }
  }

  widget {
    query_value_definition {
      request {
        q = "sum:trace.${var.service["operation_name"]}.hits{$env,$service}.as_rate()"
        aggregator = "avg"
        conditional_formats {
          comparator = ">"
          value = "${var.service_thresholds["hit-rate-max"]}"
          palette = "white_on_red"
        }
        conditional_formats {
          comparator = "<"
          value = "${var.service_thresholds["hit-rate-min"]}"
          palette = "white_on_red"
        }
        conditional_formats {
          comparator = ">"
          value = "0"
          palette = "white_on_green"
        }
      }
      autoscale = true
      # text_align = "right"
      title = "Hit rate (past day)"
      time = {
        live_span = "1d"
      }
    }
    layout = {
      height = 15
      width = 24
      x = 58
      y = 33
    }
  }

  widget {
    query_value_definition {
      request {
        q = "100*sum:trace.${var.service["operation_name"]}.errors{$env,$service}.as_count() / sum:trace.${var.service["operation_name"]}.hits{$env,$service}.as_count()"
        aggregator = "avg"
        conditional_formats {
          comparator = ">"
          value = "${var.service_thresholds["error-rate"]}"
          palette = "white_on_red"
        }
        conditional_formats {
          comparator = ">"
          value = "-99"
          palette = "white_on_green"
        }
      }
      autoscale = true
      title = "Error rate (past day)"
      time = {
        live_span = "1d"
      }
    }
    layout = {
      height = 15
      width = 24
      x = 83
      y = 33
    }
  }

  widget {
    query_value_definition {
      request {
        q = "avg:trace.${var.service["operation_name"]}.duration.by.service.95p{$env,$service}"
        aggregator = "avg"
        conditional_formats {
          comparator = ">"
          value = "${var.service_thresholds["latency-95p"]}"
          palette = "white_on_red"
        }
        conditional_formats {
          comparator = ">"
          value = "0"
          palette = "white_on_green"
        }
      }
      autoscale = true
      title = "Latency p95 (past day)"
      time = {
        live_span = "1d"
      }
    }
    layout = {
      height = 15
      width = 24
      x = 108
      y = 33
    }
  }

  widget {
    note_definition {
      content = <<EOF
## Contacts

Slack:

- @rantanplan
- @snoopy
- @bits

Email: 

- john.doe@ddog.com

## Troubleshooting

- [Dependency Dashboard](/dashboard/${var.dependency_dashboard_id}?tpl_var_env=$env.value&tpl_var_service=$service.value) - *Make sure to set the cluster name once there*
- [Monitors](/monitors/manage?q=service:$service.value env:$env.value)
- [Service List](/apm/services?env=$env.value&search=$service.value)
- [Traces](/apm/traces?query=service:$service.value%20env:$env.value)

EOF
      background_color = "white"
      show_tick = false
    }
    layout = {
      height = 32
      width = 56
      x = 1
      y = 49
    }
  }

  widget {
    manage_status_definition {
      summary_type = "monitors"
      query = "tag:($env AND $service)"

      display_format = "countsAndList"
      sort = "status,asc"
      color_preference = "background"
      hide_zero_counts = true
      show_last_triggered = false

      title = "Monitor State"
      title_size = 16
      title_align = "left"
    }
    layout = {
      height = 33
      width = 56
      x = 1
      y = 82
    }
  }

  widget {
    note_definition {
      content = <<EOF
## Details
EOF
      background_color = "gray"
      show_tick = true
      tick_edge = "bottom"
      tick_pos = "50%"
    }
    layout = {
      height = 6
      width = 74
      x = 58
      y = 49
    }
  }

  widget {
    timeseries_definition {
      title = "Hits"
      request {
        q= "anomalies(sum:trace.${var.service["operation_name"]}.hits{$env,$service}.as_count(), 'agile', 5)"
        display_type = "line"
      }
    }
    layout = {
      height = 19
      width = 74
      x = 58
      y = 56
    }
  }

  widget {
    timeseries_definition {
      title = "Error Rate"
      request {
        q= "100*sum:trace.${var.service["operation_name"]}.errors{$env,$service}.as_count().rollup(sum, 60) / sum:trace.${var.service["operation_name"]}.hits{$env,$service}.as_count().rollup(sum, 60)"
        display_type = "line"
      }
      marker {
        display_type = "error solid"
        value = "y > ${var.service_thresholds["error-rate"]}"
        label = "> ${var.service_thresholds["error-rate"]}%"
      }
    }
    layout = {
      height = 19
      width = 74
      x = 58
      y = 76
    }
  }

  widget {
    timeseries_definition {
      title = "Latency - p95 and p90"
      request {
        q= "avg:trace.${var.service["operation_name"]}.duration.by.service.95p{$env,$service}"
        display_type = "line"
      }
      request {
        q= "sum:trace.${var.service["operation_name"]}.duration.by.service.90p{$env,$service}"
        display_type = "line"
      }
      marker {
        display_type = "error solid"
        value = "y > ${var.service_thresholds["latency-95p"]}"
        label = "> ${var.service_thresholds["latency-95p"]}s"
      }
    }
    layout = {
      height = 19
      width = 74
      x = 58
      y = 96
    }
  }
}
