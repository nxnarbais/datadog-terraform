resource "datadog_dashboard" "service_dependencies_dashboard" {
  title         = "[Sandbox][KB][TF] ${var.service["service_name"]} Service Dependencies"
  description   = var.description
  layout_type   = "ordered"
  is_read_only  = false # true: lock in edit by owner and admins
  # notify_list = var.notify_list # TODO:
  template_variable {
    name   = "env"
    prefix = "env"
    default = var.env
  }
  dynamic "template_variable" {
    for_each = var.secondary_primary_tag["key"] != "NA" ? [1] : []
    content {
      name   = var.secondary_primary_tag["key"]
      prefix = var.secondary_primary_tag["key"]
      default = var.secondary_primary_tag["value"]
    }
  }
  template_variable {
    name   = "service"
    prefix = "service"
    default = var.service["service_name"]
  }
  dynamic "template_variable" {
    for_each = var.cluster_name == "cluster_name" ? [] : [1]
    content {
      name   = "cluster_name"
      prefix = "cluster_name"
      default = var.cluster_name
    }
  }

  widget {
    note_definition {
      content = <<EOF
# Troubleshooting: $service.value - $env.value

*Note: This dashboard is aimed to be seen with 2 columns.*

[Terraform Repo](https://github.com/nxnarbais/terraform-datadog)
EOF
    }
  }

  widget {
    note_definition {
      content = <<EOF
For additional troubleshooting ideas:

- [Watchdog](/watchdog) to identify some unknown unknowns (aka blind spots)
- [Correlation](https://docs.datadoghq.com/dashboards/correlations/#overview) to highlight some potential correlation. (Correlation does not mean causation!!)

EOF
    }
  }

  #######################################
  # GOLDEN APM METRICS
  #######################################

  widget {
    group_definition {
      layout_type = "ordered"
      title = "Golden APM Metrics"

      widget {
        note_definition {
          content = <<EOF
## Golden APM Metrics

- [Service List](/apm/services?env=$env.value&search=$service.value&hostGroup=${"$"}${var.secondary_primary_tag["key"]}.value)
- [Traces](/apm/traces?query=service:$service.value%20env:$env.value%20${var.secondary_primary_tag["key"]}:${"$"}${var.secondary_primary_tag["key"]}.value)
- [Monitors](/monitors/manage?q=service:$service.value env:$env.value tag:${var.secondary_primary_tag["key"]}:${"$"}${var.secondary_primary_tag["key"]}.value)
EOF
# FIXME: [Service Overview](/apm/service/$service.value/${var.service_operation_name}?env=$env.value)
        }
      }

      widget {
        # TODO: Overlay on top events indicating a change on the service (e.g. Jenkins events)
        timeseries_definition {
          title = "hits by version"
          request {
            q= "sum:${var.service["service_metric_root"]}.hits{$env,${"$"}${var.secondary_primary_tag["key"]},$service} by {version}.as_count()"
            display_type = "bars"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "hits"
          request {
            q= "anomalies(sum:${var.service["service_metric_root"]}.hits{$env,${"$"}${var.secondary_primary_tag["key"]},$service}.as_count(), 'agile', 5)"
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Error Rate"
          request {
            q= "100*sum:${var.service["service_metric_root"]}.errors{$env,${"$"}${var.secondary_primary_tag["key"]},$service}.as_count().rollup(sum, 60) / sum:${var.service["service_metric_root"]}.hits{$env,${"$"}${var.secondary_primary_tag["key"]},$service}.as_count().rollup(sum, 60)"
            display_type = "line"
          }
          marker {
            display_type = "error solid"
            value = "y > ${var.service_thresholds["error-rate"]}"
            label = "> ${var.service_thresholds["error-rate"]}%"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Latency - p95 and p90"
          request {
            q = "avg:${var.service["service_metric_root"]}.duration.by.${var.secondary_primary_tag["key"]}_service.95p{$env,${"$"}${var.secondary_primary_tag["key"]},$service}"
            # q= "avg:${var.service["service_metric_root"]}.duration.by.service.95p{$env,$service}"
            display_type = "line"
          }
          request {
            q = "avg:${var.service["service_metric_root"]}.duration.by.${var.secondary_primary_tag["key"]}_service.90p{$env,${"$"}${var.secondary_primary_tag["key"]},$service}"
            # q= "sum:${var.service["service_metric_root"]}.duration.by.service.90p{$env,$service}"
            display_type = "line"
          }
          marker {
            display_type = "error solid"
            value = "y > ${var.service_thresholds["latency-95p"]}"
            label = "> ${var.service_thresholds["latency-95p"]}s"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Latency - p50"
          request {
            q = "avg:${var.service["service_metric_root"]}.duration.by.${var.secondary_primary_tag["key"]}_service.50p{$env,${"$"}${var.secondary_primary_tag["key"]},$service}"
            # q= "avg:${var.service["service_metric_root"]}.duration.by.service.50p{$env,$service}"
            display_type = "line"
          }
          marker {
            display_type = "error solid"
            value = "y > ${var.service_thresholds["latency-50p"]}"
            label = "> ${var.service_thresholds["latency-50p"]}"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Time Spent / Service"
          request {
            q = "sum:${var.service["service_metric_root"]}.duration.by_service{$env,${"$"}${var.secondary_primary_tag["key"]},$service} by {sublayer_service}.rollup(sum).fill(zero) / sum:${var.service["service_metric_root"]}.duration.by_service{$env,${"$"}${var.secondary_primary_tag["key"]},$service}.rollup(sum).fill(zero) "
            display_type = "area"
          }
        }
      }

    }
  }

  #######################################
  # INFRA - HOSTS
  #######################################

  widget {
    group_definition {
      layout_type = "ordered"
      title = "Infra - Hosts"

      widget {
        note_definition {
          content = <<EOF
## Host Metrics"

- [System - Metrics](/dash/integration/1/system---metrics?tpl_var_scope=$env)
- [System - Disk I/O](/dash/integration/2/system---disk-io?tpl_var_scope=$env)
- [System - Networking](/dash/integration/3/system---networking?tpl_var_scope=$env)
EOF
        }
      }

      widget {
        timeseries_definition {
          title = "Agent Running"
          request {
            q= "anomalies(sum:datadog.agent.running{$env,${"$"}${var.secondary_primary_tag["key"]}}, 'agile', 4)"
            display_type = "bars"
          }
          event {
            q= "sources:datadog tags:$env agent started"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "CPU Idle"
          request {
            q= "avg:system.cpu.idle{$env,${"$"}${var.secondary_primary_tag["key"]}} by {host}"
            display_type = "line"
          }
          marker {
            display_type = "orange solid"
            value = "y < 10"
            label = "< 10%"
          }
          marker {
            display_type = "error solid"
            value = "y < 5"
            label = "< 5%"
          }
          yaxis {
            scale = "log"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "CPU Idle - Load Balancing Check"
          request {
            q= "outliers(avg:system.cpu.idle{$env,${"$"}${var.secondary_primary_tag["key"]}} by {host}, 'DBSCAN', 3)"
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Mem Free"
          request {
            q= "avg:system.mem.pct_usable{$env,${"$"}${var.secondary_primary_tag["key"]}} by {host} * 100"
            display_type = "line"
          }
          marker {
            display_type = "orange solid"
            value = "y < 10"
            label = "< 10%"
          }
          marker {
            display_type = "error solid"
            value = "y < 5"
            label = "< 5%"
          }
          yaxis {
            scale = "log"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Mem Free - Load Balancing Check"
          request {
            q= "outliers(avg:system.mem.pct_usable{$env,${"$"}${var.secondary_primary_tag["key"]}} by {host} * 100, 'DBSCAN', 3)"
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Disk Free"
          request {
            q= "sum:system.disk.free{$env,${"$"}${var.secondary_primary_tag["key"]}} by {host}"
            display_type = "line"
          }
          marker {
            display_type = "orange solid"
            value = "y < 500000000"
            label = "< 500MiB"
          }
          marker {
            display_type = "error solid"
            value = "y < 100000000"
            label = "< 100MiB"
          }
          yaxis {
            scale = "log"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Inode usage"
          request {
            q= "avg:system.fs.inodes.in_use{$env,${"$"}${var.secondary_primary_tag["key"]},!device:/dev/loop0,!device:/dev/loop1,!device:/dev/loop2,!device:/dev/loop4,!device:/dev/loop3} by {host,device} * 100"
            display_type = "line"
          }
          marker {
            display_type = "error solid"
            value = "y > 90"
            label = "> 90%"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "CPU Load 5 /core"
          request {
            q= "avg:system.load.norm.5{$env,${"$"}${var.secondary_primary_tag["key"]}} by {host}"
            display_type = "line"
          }
          marker {
            display_type = "orange solid"
            value = "y > 1"
            label = "> 1"
          }
          marker {
            display_type = "error solid"
            value = "y > 2"
            label = "> 2"
          }
        }
      }

    }
  }

  #######################################
  # GOLDEN APM METRICS for SERVICE DEPENDENCIES
  #######################################

  dynamic "widget" {
    for_each = var.service_dependencies
    content {

      group_definition {
        layout_type = "ordered"
        title = "Dependency: ${widget.value["service_name"]} - Golden APM Metrics"

        widget {
          note_definition {
            content = <<EOF
## Golden APM Metrics - service:${widget.value["service_name"]}, $env

- [Service Overview](/apm/service/${widget.value["service_name"]}/${widget.value["service_operation_name"]}?env=$env.value&hostGroup=${"$"}${var.secondary_primary_tag["key"]}.value)
- [Service List](/apm/services?env=$env.value&search=${widget.value["service_name"]}&hostGroup=${"$"}${var.secondary_primary_tag["key"]}.value)
- [Traces](/apm/traces?query=service:${widget.value["service_name"]}%20env:$env.value%20${var.secondary_primary_tag["key"]}:${"$"}${var.secondary_primary_tag["key"]}.value)
- [Monitors](/monitors/manage?q=service:${widget.value["service_name"]} env:$env.value tag:${var.secondary_primary_tag["key"]}:${"$"}${var.secondary_primary_tag["key"]}.value)
EOF
          }
        }

        widget {
          timeseries_definition {
            title = "hits"
            request {
              q= "sum:${widget.value["service_metric_root"]}.hits{$env,${"$"}${var.secondary_primary_tag["key"]},service:${widget.value["service_name"]}} by {version}.as_count()"
              display_type = "bars"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "hits"
            request {
              q= "anomalies(sum:${widget.value["service_metric_root"]}.hits{$env,${"$"}${var.secondary_primary_tag["key"]},service:${widget.value["service_name"]}}.as_count(), 'agile', 5)"
              display_type = "line"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Error Rate"
            request {
              q= "100*sum:${widget.value["service_metric_root"]}.errors{$env,${"$"}${var.secondary_primary_tag["key"]},service:${widget.value["service_name"]}}.as_count().rollup(sum, 60) / sum:${widget.value["service_metric_root"]}.hits{$env,${"$"}${var.secondary_primary_tag["key"]},service:${widget.value["service_name"]}}.as_count().rollup(sum, 60)"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > ${widget.value["thresholds"]["error-rate"]}"
              label = "> ${widget.value["thresholds"]["error-rate"]}%"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Latency - p95 and p90"
            request {
              q= "sum:${widget.value["service_metric_root"]}.duration.by.${var.secondary_primary_tag["key"]}_service.95p{$env,service:${widget.value["service_name"]}}"
              display_type = "line"
            }
            request {
              q= "sum:${widget.value["service_metric_root"]}.duration.by.${var.secondary_primary_tag["key"]}_service.90p{$env,service:${widget.value["service_name"]}}"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > ${widget.value["thresholds"]["latency-95p"]}"
              label = "> ${widget.value["thresholds"]["latency-95p"]}s"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Latency - p50"
            request {
              q= "sum:${widget.value["service_metric_root"]}.duration.by.${var.secondary_primary_tag["key"]}_service.50p{$env,service:${widget.value["service_name"]}}"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > ${widget.value["thresholds"]["latency-50p"]}"
              label = "> ${widget.value["thresholds"]["latency-50p"]}s"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Time Spent / Service"
            request {
              q= "sum:${widget.value["service_metric_root"]}.duration.by_service{$env,${"$"}${var.secondary_primary_tag["key"]},service:${widget.value["service_name"]}} by {sublayer_service}.rollup(sum).fill(zero) / sum:${widget.value["service_metric_root"]}.duration.by_service{$env,${"$"}${var.secondary_primary_tag["key"]},service:${widget.value["service_name"]}}.rollup(sum).fill(zero) "
              display_type = "area"
            }
          }
        }

      }
      
    }
  }

  #######################################
  # KUBERNETES
  #######################################

  dynamic "widget" {
    for_each = var.cluster_name == "cluster_name" ? [] : [1]
    content {

      group_definition {
        layout_type = "ordered"
        title = "Kubernetes"

        widget {
          note_definition {
            content = <<EOF
## Kubernetes

- [Kubernetes Orchestration](/orchestration/overview?tags=cluster_name:$cluster_name.value)
- [Kubernetes Overview](/screen/integration/86/kubernetes---overview?tpl_var_cluster=$cluster_name.value&tpl_var_service=$service.value)
- [Kubernetes Deployment Overview](/screen/integration/30341/kubernetes-deployments-overview?tpl_var_cluster=$cluster_name.value)
EOF
# TODO: Check links and add more
          }
        }

        widget {
          timeseries_definition {
            title = "Replica Pod Down"
            request {
              q= "avg:kubernetes_state.deployment.replicas_desired{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {deployment}.rollup(avg, 900) - avg:kubernetes_state.deployment.replicas_ready{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {deployment}.rollup(avg, 900)"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > 2"
              label = "> 2"
            }
            yaxis {
              scale = "log"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "ImagePullBackOff"
            request {
              q= "max:kubernetes_state.container.waiting{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name,reason:imagepullbackoff} by {kube_namespace,pod_name}.rollup(max, 600)"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > 1"
              label = "> 1"
            }
            yaxis {
              scale = "log"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Pod Restarting"
            request {
              q= "exclude_null(avg:kubernetes.containers.restarts{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name}.rollup(avg, 300))-hour_before(exclude_null(avg:kubernetes.containers.restarts{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name}.rollup(avg, 300)))"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > 5"
              label = "> 5"
            }
            yaxis {
              scale = "log"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Stateful Replicas Down"
            request {
              q= "sum:kubernetes_state.statefulset.replicas_desired{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {statefulset} - sum:kubernetes_state.statefulset.replicas_ready{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {statefulset}.rollup(max,900)"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > 2"
              label = "> 2"
            }
            yaxis {
              scale = "log"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "CrashLoopBackOff"
            request {
              q= "max:kubernetes_state.container.waiting{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name,reason:crashloopbackoff} by {kube_namespace,${"$"}${var.secondary_primary_tag["key"]},pod_name}.rollup(max, 600)"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > 1"
              label = "> 1"
            }
            yaxis {
              scale = "log"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Failed Pods in Namespace"
            request {
              q= "sum:kubernetes_state.pod.status_phase{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name,phase:failed} by {kubernetes_cluster,kube_namespace} - hour_before(sum:kubernetes_state.pod.status_phase{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name,phase:failed} by {kubernetes_cluster,kube_namespace})"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y > 10"
              label = "> 10"
            }
            yaxis {
              scale = "log"
            }
          }
        }

         widget {
          timeseries_definition {
            title = "Nodes Unavailable"
            request {
              q= "sum:kubernetes_state.node.status{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name,status:schedulable} by {kubernetes_cluster}.rollup(max,900) * 100 / sum:kubernetes_state.node.status{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {kubernetes_cluster}.rollup(max,900)"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y < 80"
              label = "< 80"
            }
            yaxis {
              scale = "pow"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "CPU Free vs Limits"
            request {
              q= "(avg:kubernetes.cpu.limits{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name}-avg:kubernetes.cpu.usage.total{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name}/1000000000)/avg:kubernetes.cpu.limits{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name}"
              display_type = "line"
            }
            marker {
              display_type = "error solid"
              value = "y < 0.1"
              label = "< 0.1"
            }
            yaxis {
              scale = "log"
            }
          }
        }

        widget {
          timeseries_definition {
            title = "Mem Free vs Limits"
            request {
              q= "(avg:kubernetes.memory.limits{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name}-avg:kubernetes.memory.usage{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name})/avg:kubernetes.memory.limits{$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name} by {pod_name}"
              display_type = "line"
            }
            event {
              q= "sources:kubernetes,docker tags:$env,${"$"}${var.secondary_primary_tag["key"]},$cluster_name priority:all OOM"
            }
            marker {
              display_type = "error solid"
              value = "y < 0.1"
              label = "< 0.1"
            }
            yaxis {
              scale = "log"
            }
          }
        }
        
      }
      
    }
  }

  #######################################
  # LOGS
  #######################################

  widget {
    group_definition {
      layout_type = "ordered"
      title = "Logs"

      widget {
        note_definition {
          content = <<EOF
## Logs
EOF
        }
      }

      widget {
        toplist_definition {
          title = "Logs per service in environment"
          request {
            log_query {
              index = "*"
              compute = {
                aggregation = "count"
              }
              search = {
                query = "$env ${"$"}${var.secondary_primary_tag["key"]}"
              }
              group_by {
                facet = "service"
                limit = 100
              }
            }
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Logs for service"
          request {
            log_query {
              index = "*"
              compute = {
                aggregation = "count"
              }
              search = {
                query = "$env ${"$"}${var.secondary_primary_tag["key"]} $service"
              }
              group_by {
                facet = "service"
                limit = 100
              }
            }
            display_type = "bars"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Error logs for service"
          request {
            log_query {
              index = "*"
              compute = {
                aggregation = "count"
              }
              search = {
                query = "$env ${"$"}${var.secondary_primary_tag["key"]} $service status:error"
              }
              group_by {
                facet = "service"
                limit = 100
              }
            }
            display_type = "bars"
          }
        }
      }

    }
  }

  #######################################
  # JVM
  #######################################

  dynamic "widget" {
    for_each = var.jvm_enabled == "true" ? [1] : []
    content {

      group_definition {
        layout_type = "ordered"
        title = "JVM"

        widget {
          note_definition {
            content = <<EOF
## JVM

- [JVM Metrics](/dash/integration/256/jvm-metrics?tpl_var_env=$env.value&tpl_var_service=$service.value)

TODO: Add more relevant widget to this group
EOF
          }
        }
      }
    }
  }

  #######################################
  # APM - Trace Analytics
  #######################################

  dynamic "widget" {
    for_each = var.jvm_enabled == "true" ? [1] : []
    content {

      group_definition {
        layout_type = "ordered"
        title = "Trace Analytics"

        widget {
          note_definition {
            content = <<EOF
## Trace Analytics

- [Traces](/apm/traces?query=service:$service.value%20env:$env.value%20${var.secondary_primary_tag["key"]}:${"$"}${var.secondary_primary_tag["key"]}.value)
- [Traces Analytics](/apm/analytics?query=service:$service.value%20env:$env.value%20${var.secondary_primary_tag["key"]}:${"$"}${var.secondary_primary_tag["key"]}.value)
- Trace Outlier - Check on Trace Analytics for some outliers

TODO: Add more relevant widget to this group based on the context the applicatino handle: latency per user tier, latency per cart value, errors per feature flag, errors per user tier, etc.
EOF
          }
        }
      }
    }
  }

  #######################################
  # NETWORK
  #######################################

  dynamic "widget" {
    for_each = var.network_enabled == "true" ? [1] : []
    content {

      group_definition {
        layout_type = "ordered"
        title = "Network"

        widget {
          note_definition {
            content = <<EOF
## Network

TODO: Add more relevant widget and links to this group
EOF
          }
        }
      }
    }
  }

}
