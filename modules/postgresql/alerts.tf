/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  alert_primary_database_id  = "${var.project_id}:${google_sql_database_instance.default.name}"
  alert_replica_database_ids = [for r in google_sql_database_instance.replicas : "${var.project_id}:${r.name}"]

  # Alert on disk utilization when autoresize is off;
  # alert on bytes used when the autoresize limit is enabled.
  # Alert remains disabled if neither is the case.
  disk_alert_on_limit = var.disk_autoresize && var.disk_autoresize_limit > 0

  # Fixed parts of each built-in alert. Tunable parts (enabled, threshold,
  # duration, severity) come from var.alerts. threshold_scale converts the
  # user-facing value into the metric's unit.
  alert_definitions = {
    cpu_utilization = {
      display_name     = "CPU Utilization"
      description      = "CPU utilization has been above the threshold for the configured duration. Sustained high CPU leaves no headroom for spikes and slows queries."
      metric_filter    = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\""
      comparison       = "COMPARISON_GT"
      aligner          = "ALIGN_MEAN"
      alignment_period = "300s"
      threshold_scale  = 1
      default_enabled  = true
      missing_data     = null
      include_replicas = true
    }
    # components.usage excludes the reclaimable OS page cache, unlike
    # memory/utilization; it is reported in percent.
    memory_utilization = {
      display_name     = "Memory Usage"
      description      = "Memory used by PostgreSQL is above the threshold. If memory runs out, the instance is stopped by the OOM killer."
      metric_filter    = "metric.type=\"cloudsql.googleapis.com/database/memory/components\" AND metric.labels.component=\"Usage\""
      comparison       = "COMPARISON_GT"
      aligner          = "ALIGN_MEAN"
      alignment_period = "300s"
      threshold_scale  = 100
      default_enabled  = true
      missing_data     = "EVALUATION_MISSING_DATA_ACTIVE"
      include_replicas = true
    }
    disk_utilization = {
      display_name     = local.disk_alert_on_limit ? "Disk Usage Near Autoresize Limit" : "Disk Utilization"
      description      = local.disk_alert_on_limit ? "Disk usage is approaching disk_autoresize_limit. Storage cannot grow beyond the limit, and the instance goes offline when the disk is full." : "Disk utilization is above the threshold and automatic storage increase is disabled. The instance goes offline when the disk is full."
      metric_filter    = local.disk_alert_on_limit ? "metric.type=\"cloudsql.googleapis.com/database/disk/bytes_used\"" : "metric.type=\"cloudsql.googleapis.com/database/disk/utilization\""
      comparison       = "COMPARISON_GT"
      aligner          = "ALIGN_MEAN"
      alignment_period = "300s"
      # alert on bytes used relative to disk_autoresize_limit (defined in GB = 1024^3 bytes)
      threshold_scale  = local.disk_alert_on_limit ? var.disk_autoresize_limit * pow(1024, 3) : 1
      default_enabled  = !var.disk_autoresize || local.disk_alert_on_limit
      missing_data     = "EVALUATION_MISSING_DATA_ACTIVE"
      include_replicas = true
    }
    # ALIGN_MAX: only fires when the instance was down for the whole duration,
    # not on a single missed sample. Missing data counts as down.
    instance_down = {
      display_name     = "Instance Down"
      description      = "The instance has not reported being up for the configured duration."
      metric_filter    = "metric.type=\"cloudsql.googleapis.com/database/up\""
      comparison       = "COMPARISON_LT"
      aligner          = "ALIGN_MAX"
      alignment_period = "60s"
      threshold_scale  = 1
      default_enabled  = var.activation_policy == "ALWAYS"
      missing_data     = "EVALUATION_MISSING_DATA_ACTIVE"
      include_replicas = true
    }
    transaction_id_utilization = {
      display_name     = "Transaction ID Utilization"
      description      = "Unvacuumed transaction IDs are above the threshold. At 100% PostgreSQL stops accepting writes to prevent transaction ID wraparound; vacuum the primary."
      metric_filter    = "metric.type=\"cloudsql.googleapis.com/database/postgresql/transaction_id_utilization\""
      comparison       = "COMPARISON_GT"
      aligner          = "ALIGN_MEAN"
      alignment_period = "300s"
      threshold_scale  = 1
      default_enabled  = true
      missing_data     = "EVALUATION_MISSING_DATA_ACTIVE"
      # replicas share the primary's transaction ID state
      include_replicas = false
    }
  }

  enabled_alerts = var.alerts == null ? {} : {
    for name, definition in local.alert_definitions :
    name => merge(definition, var.alerts[name], {
      database_ids = definition.include_replicas ? concat([local.alert_primary_database_id], local.alert_replica_database_ids) : [local.alert_primary_database_id]
    }) if coalesce(var.alerts[name].enabled, definition.default_enabled)
  }
}

resource "google_monitoring_alert_policy" "default" {
  for_each = local.enabled_alerts

  project      = var.project_id
  display_name = "CloudSQL - ${each.value.display_name} - ${var.name}"
  combiner     = "OR"
  severity     = each.value.severity

  conditions {
    display_name = "CloudSQL - ${each.value.display_name} - ${var.name}"
    condition_threshold {
      comparison              = each.value.comparison
      duration                = each.value.duration
      filter                  = "resource.type=\"cloudsql_database\" AND ${each.value.metric_filter} AND resource.labels.database_id = one_of(${join(", ", [for id in each.value.database_ids : "\"${id}\""])})"
      threshold_value         = each.value.threshold * each.value.threshold_scale
      evaluation_missing_data = each.value.missing_data

      aggregations {
        alignment_period   = each.value.alignment_period
        group_by_fields    = []
        per_series_aligner = each.value.aligner
      }

      trigger {
        count   = 1
        percent = 0
      }
    }
  }

  notification_channels = var.alerts.notification_channels

  # $${...} escapes Terraform interpolation; Cloud Monitoring fills these in
  # per incident, naming the instance that fired.
  documentation {
    subject   = "CloudSQL ${each.value.display_name} on $${resource.label.database_id}"
    mime_type = "text/markdown"
    content   = <<-EOT
      ${each.value.description}

      - Affected instance: `$${resource.label.database_id}`
      - Metric `$${metric.type}` crossed threshold of ${each.value.threshold} for ${each.value.duration}.
    EOT
  }

  alert_strategy {
    notification_prompts = [
      "OPENED",
      "CLOSED",
    ]
  }

}
