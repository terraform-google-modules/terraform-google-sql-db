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

################################
#                              #
#   Service Account and IAM    #
#                              #
################################
resource "google_service_account" "sql_backup_serviceaccount" {
  count        = local.create-service-account ? 1 : 0
  account_id   = substr("backup-${var.sql-instance}", 0, 28)
  display_name = "Managed by Terraform - Service account for backup of SQL Instance ${var.sql-instance}"
  project      = var.project-id
}

resource "google_project_iam_member" "sql_backup_serviceaccount_sql_admin" {
  count   = local.create-service-account ? 1 : 0
  member  = "serviceAccount:${google_service_account.sql_backup_serviceaccount[0].email}"
  role    = "roles/cloudsql.admin"
  project = var.project-id
}

resource "google_project_iam_member" "sql_backup_serviceaccount_workflow_invoker" {
  count   = local.create-service-account ? 1 : 0
  member  = "serviceAccount:${google_service_account.sql_backup_serviceaccount[0].email}"
  role    = "roles/workflows.invoker"
  project = var.project-id
}

data "google_sql_database_instance" "backup_instance" {
  name    = var.sql-instance
  project = var.project-id
}

################################
#                              #
#       Internal Backups       #
#                              #
################################
#TODO: allow multiple backups
resource "google_workflows_workflow" "sql_backup" {
  count           = var.backup ? 1 : 0
  name            = "sql-backup-${var.sql-instance}"
  region          = var.region
  description     = "Workflow for backing up the CloudSQL Instance "
  project         = var.project-id
  service_account = local.service-account
  source_contents = templatefile("${path.module}/templates/backup.yaml.tftpl", {
    project             = var.project-id
    instanceName        = var.sql-instance
    backupRetentionTime = var.backup-retention-time
  })
}

resource "google_cloud_scheduler_job" "sql_backup" {
  count       = var.backup ? 1 : 0
  name        = "sql-backup-${var.sql-instance}"
  project     = var.project-id
  region      = var.region
  description = "Managed by Terraform - Triggers a SQL Backup via Workflows"
  schedule    = var.backup-schedule
  time_zone   = var.scheduler-timezone

  http_target {
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.sql_backup[0].id}/executions"
    http_method = "POST"
    oauth_token {
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
      service_account_email = local.service-account
    }
  }
}

################################
#                              #
#       External Backups       #
#                              #
################################
resource "google_workflows_workflow" "sql_export" {
  count           = var.export ? 1 : 0
  name            = "sql-export-${var.sql-instance}"
  region          = var.region
  description     = "Workflow for backing up the CloudSQL Instance "
  project         = var.project-id
  service_account = local.service-account
  source_contents = templatefile("${path.module}/templates/export.yaml.tftpl", {
    project             = var.project-id
    instanceName        = var.sql-instance
    backupRetentionTime = var.backup-retention-time
    databases           = jsonencode(var.export-databases)
    gcsBucket           = var.export-uri
    dbType              = split("_", data.google_sql_database_instance.backup_instance.database_version)[0]
  })
}

resource "google_cloud_scheduler_job" "sql_export" {
  count       = var.export ? 1 : 0
  name        = "sql-export-${var.sql-instance}"
  project     = var.project-id
  region      = var.region
  description = "Managed by Terraform - Triggers a SQL Export via Workflows"
  schedule    = var.export-schedule
  time_zone   = var.scheduler-timezone

  http_target {
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.sql_export[0].id}/executions"
    http_method = "POST"
    oauth_token {
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
      service_account_email = local.service-account
    }
  }
}

resource "google_storage_bucket_iam_member" "sql_instance_account" {
  count  = var.export ? 1 : 0
  bucket = split("/", var.export-uri)[2] #Get the name of the bucket out of the URI
  member = "serviceAccount:${data.google_sql_database_instance.backup_instance.service_account_email_address}"
  role   = "roles/storage.objectCreator"
}
