/**
 * Copyright 2022 Google LLC
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
  create_service_account = var.service_account == null || var.service_account == "" ? true : false
  service_account        = local.create_service_account ? google_service_account.sql_backup_serviceaccount[0].email : var.service_account
  backup_name            = "sql-backup-${var.sql_instance}${var.unique_suffix}"
  role_name              = var.enable_export_backup ? "roles/cloudsql.editor" : "roles/cloudsql.viewer"
  export_name            = var.use_sql_instance_replica_in_exporter ? "sql-export-${var.sql_instance_replica}${var.unique_suffix}" : "sql-export-${var.sql_instance}${var.unique_suffix}"
  notification_channels  = var.create_notification_channel ? concat(var.notification_channels, [google_monitoring_notification_channel.email[0].id]) : var.notification_channels
}


################################
#                              #
#   Service Account and IAM    #
#                              #
################################
resource "google_service_account" "sql_backup_serviceaccount" {
  count        = local.create_service_account ? 1 : 0
  account_id   = trimsuffix(substr("backup-${var.sql_instance}", 0, 28), "-")
  display_name = "Managed by Terraform - Service account for backup of SQL Instance ${var.sql_instance}"
  project      = var.project_id
}

resource "google_project_iam_member" "sql_backup_serviceaccount_sql_admin" {
  count   = local.create_service_account ? 1 : 0
  member  = "serviceAccount:${google_service_account.sql_backup_serviceaccount[0].email}"
  role    = local.role_name
  project = var.project_id
  condition {
    title      = "Limit access to instance ${var.sql_instance}"
    expression = <<-EOT
      (resource.type == "sqladmin.googleapis.com/Instance" &&
       resource.name == "projects/${var.project_id}/instances/${var.sql_instance}")
    EOT
  }
}

resource "google_project_iam_member" "sql_backup_serviceaccount_workflow_invoker" {
  count   = local.create_service_account ? 1 : 0
  member  = "serviceAccount:${google_service_account.sql_backup_serviceaccount[0].email}"
  role    = "roles/workflows.invoker"
  project = var.project_id
}

data "google_sql_database_instance" "backup_instance" {
  name    = var.sql_instance
  project = var.project_id
}

resource "google_monitoring_notification_channel" "email" {
  count        = var.create_notification_channel ? 1 : 0
  display_name = var.notification_channel_name
  project      = var.project_id
  type         = "email"
  labels = {
    email_address = var.monitoring_email
  }
}

################################
#                              #
#       Internal Backups       #
#                              #
################################
resource "google_workflows_workflow" "sql_backup" {
  count           = var.enable_internal_backup ? 1 : 0
  name            = local.backup_name
  region          = var.region
  description     = "Workflow for backing up the CloudSQL Instance "
  project         = var.project_id
  service_account = local.service_account
  source_contents = templatefile("${path.module}/templates/backup.yaml.tftpl", {
    project                  = var.project_id
    instanceName             = var.sql_instance
    backupRetentionTime      = var.backup_retention_time
    backupRunsListMaxResults = var.backup_runs_list_max_results
  })
}

resource "google_cloud_scheduler_job" "sql_backup" {
  count       = var.enable_internal_backup ? 1 : 0
  name        = local.backup_name
  project     = var.project_id
  region      = var.region
  description = "Managed by Terraform - Triggers a SQL Backup via Workflows"
  schedule    = var.backup_schedule
  time_zone   = var.scheduler_timezone

  http_target {
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.sql_backup[0].id}/executions"
    http_method = "POST"
    oauth_token {
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
      service_account_email = local.service_account
    }
  }
}

# We want to get notified if there hasn't been at least one successful backup in a day
resource "google_monitoring_alert_policy" "sql_backup_workflow_success_alert" {
  count        = var.enable_internal_backup && var.enable_backup_monitoring ? 1 : 0
  display_name = "Failed workflow: ${local.backup_name}"
  combiner     = "OR"

  conditions {
    display_name = "Failed workflow: ${local.backup_name}"
    condition_monitoring_query_language {
      query    = <<-EOT
        fetch workflows.googleapis.com/Workflow
        | filter workflow_id == '${local.backup_name}'
        | metric 'workflows.googleapis.com/finished_execution_count'
          | filter metric.status == 'SUCCEEDED'
          | group_by ${var.backup_monitoring_frequency}, [value_finished_execution_count_sum: sum(value.finished_execution_count)]
          | every ${var.backup_monitoring_frequency}
          | condition val() < 1 '1'
      EOT
      duration = "3600s"
      trigger { count = 1 }
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
    }
  }
  notification_channels = local.notification_channels
}

################################
#                              #
#       External Backups       #
#                              #
################################
resource "google_workflows_workflow" "sql_export" {
  count           = var.enable_export_backup ? 1 : 0
  name            = local.export_name
  region          = var.region
  description     = "Workflow for backing up the CloudSQL Instance"
  project         = var.project_id
  service_account = local.service_account
  source_contents = templatefile("${path.module}/templates/export.yaml.tftpl", {
    project                = var.project_id
    instanceName           = var.use_sql_instance_replica_in_exporter ? var.sql_instance_replica : var.sql_instance
    backupRetentionTime    = var.backup_retention_time
    databases              = jsonencode(var.export_databases)
    gcsBucket              = var.export_uri
    dbType                 = split("_", data.google_sql_database_instance.backup_instance.database_version)[0]
    compressExport         = var.compress_export
    enableConnectorParams  = var.enable_connector_params
    connectorParamsTimeout = var.connector_params_timeout
    logDbName              = var.log_db_name_to_export
    serverlessExport       = var.use_serverless_export
  })
}

resource "google_cloud_scheduler_job" "sql_export" {
  count       = var.enable_export_backup ? 1 : 0
  name        = local.export_name
  project     = var.project_id
  region      = var.region
  description = "Managed by Terraform - Triggers a SQL Export via Workflows"
  schedule    = var.export_schedule
  time_zone   = var.scheduler_timezone

  http_target {
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.sql_export[0].id}/executions"
    http_method = "POST"
    oauth_token {
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
      service_account_email = local.service_account
    }
  }
}

resource "google_storage_bucket_iam_member" "sql_instance_account" {
  count  = var.enable_export_backup ? 1 : 0
  bucket = split("/", var.export_uri)[2] #Get the name of the bucket out of the URI
  member = "serviceAccount:${data.google_sql_database_instance.backup_instance.service_account_email_address}"
  role   = "roles/storage.objectCreator"
}

# We want to get notified if there hasn't been at least one successful backup in a day
resource "google_monitoring_alert_policy" "sql_export_workflow_success_alert" {
  count        = var.enable_export_backup && var.enable_export_monitoring ? 1 : 0
  display_name = "Failed workflow: ${local.export_name}"
  combiner     = "OR"

  conditions {
    display_name = "Failed workflow: ${local.export_name}"
    condition_monitoring_query_language {
      query    = <<-EOT
        fetch workflows.googleapis.com/Workflow
        | filter workflow_id == '${local.export_name}'
        | metric 'workflows.googleapis.com/finished_execution_count'
          | filter metric.status == 'SUCCEEDED'
          | group_by ${var.export_monitoring_frequency}, [value_finished_execution_count_sum: sum(value.finished_execution_count)]
          | every ${var.export_monitoring_frequency}
          | condition val() < 1 '1'
      EOT
      duration = "3600s"
      trigger { count = 1 }
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
    }
  }
  notification_channels = local.notification_channels
}
