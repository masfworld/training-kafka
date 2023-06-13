resource "google_monitoring_alert_policy" "cpu_limit_all_containers" {
  display_name = "GKE Container - High CPU Limit Utilization (all containers)"
  combiner     = "OR"

  conditions {
    display_name = "GKE Container has high CPU limit utilization"

    condition_threshold {
      filter          = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/cpu/limit_utilization\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.9
      duration        = "0s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  documentation {
    content = "- Containers that exceed CPU utilization limit are CPU throttled. To avoid application slowdown and unresponsiveness, keep CPU usage below the CPU utilization limit [View Documentation](https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-resource-requests-and-limits).\n- If alerts tend to be false positive or noisy, consider visiting the alert policy page and changing the threshold, the rolling (alignment) window, and the retest (duration) window. [View Documentation](https://cloud.google.com/monitoring/alerts/concepts-indepth)"
    mime_type = "text/markdown"
  }

  alert_strategy {
    auto_close = "604800s"
  }

  enabled = true
  notification_channels = [
    "projects/training-386613/notificationChannels/14502328610942170622"
  ]
}

resource "google_monitoring_alert_policy" "memory_limit_all_containers" {
  display_name = "GKE Container - High Memory Limit Utilization (all containers)"
  combiner     = "OR"

  conditions {
    display_name = "GKE Container has high memory limit utilization"

    condition_threshold {
      filter          = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/memory/limit_utilization\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.9
      duration        = "0s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  documentation {
    content = "- Containers that exceed Memory utilization limit are terminated. To avoid Out of Memory (OOM) failures, keep memory usage below the memory utilization limit [View Documentation](https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-resource-requests-and-limits).\n- If alerts tend to be false positive or noisy, consider visiting the alert policy page and changing the threshold, the rolling (alignment) window, and the retest (duration) window. [View Documentation](https://cloud.google.com/monitoring/alerts/concepts-indepth)"
    mime_type = "text/markdown"
  }

  alert_strategy {
    auto_close = "604800s"
  }

  enabled = true
  notification_channels = [
    "projects/training-386613/notificationChannels/14502328610942170622"
  ]
}

resource "google_monitoring_alert_policy" "restart_containers" {
  display_name = "GKE Container - Restarts (all containers)"
  combiner     = "OR"

  conditions {
    display_name = "GKE container has restarted"

    condition_threshold {
      filter          = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/restart_count\""
      comparison      = "COMPARISON_GT"
      threshold_value = 1.0
      duration        = "0s"

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }

  documentation {
    content = "- Container restarts are commonly caused by memory/cpu usage issues and application failures.\n- By default, this alert notifies an incident when there is more than 1 container restart in a 5 minute window. If alerts tend to be false positive or noisy, consider visiting the alert policy page and changing the threshold, the rolling (alignment) window, and the retest (duration) window. [View Documentation](https://cloud.google.com/monitoring/alerts/concepts-indepth)."
    mime_type = "text/markdown"
  }

  alert_strategy {
    auto_close = "604800s"
  }

  enabled = true
  notification_channels = [
    "projects/training-386613/notificationChannels/14502328610942170622"
  ]
}
