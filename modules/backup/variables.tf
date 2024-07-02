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

variable "region" {
  description = "The region where to run the workflow"
  type        = string
  default     = "us-central1"
}

variable "service_account" {
  description = "The service account to use for running the workflow and triggering the workflow by Cloud Scheduler - If empty or null a service account will be created. If you have provided a service account you need to grant the Cloud SQL Admin and the Workflows Invoker role to that"
  type        = string
  default     = null
}

variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "sql_instance" {
  description = "The name of the SQL instance to backup"
  type        = string
}

variable "backup_retention_time" {
  description = "The number of days backups should be kept"
  type        = number
  default     = 30
}

variable "backup_runs_list_max_results" {
  description = "The max amount of backups to list when fetching internal backup runs for the instance. This number must be larger then the amount of backups you wish to keep. E.g. for a daily backup schedule and a backup_retention_time of 30 days, you'd need to set this to at least 31 for old backups to get deleted."
  type        = number
  default     = 31
}

variable "scheduler_timezone" {
  description = "The Timezone in which the Scheduler Jobs are triggered"
  type        = string
  default     = "Etc/GMT"
}

variable "backup_schedule" {
  description = "The cron schedule to execute the internal backup"
  type        = string
  default     = "45 2 * * *"
}

variable "export_schedule" {
  description = "The cron schedule to execute the export to GCS"
  type        = string
  default     = "15 3 * * *"
}

variable "enable_internal_backup" {
  description = "Wether to create internal backups with this module"
  type        = bool
  default     = true
}

variable "enable_export_backup" {
  description = "Weather to create exports to GCS Buckets with this module"
  type        = bool
  default     = true
}

variable "export_databases" {
  description = "The list of databases that should be exported - if is an empty set all databases will be exported"
  type        = set(string)
  default     = []
  validation {
    condition     = var.export_databases != null
    error_message = "Must not be null."
  }
}

variable "export_uri" {
  description = "The bucket and path uri for exporting to GCS"
  type        = string
  validation {
    condition     = can(regex("^gs:\\/\\/", var.export_uri))
    error_message = "Must be a full GCS URI starting with gs://."
  }
}

variable "compress_export" {
  description = "Whether or not to compress the export when storing in the bucket; Only valid for MySQL and PostgreSQL"
  type        = bool
  default     = true
}

variable "enable_connector_params" {
  description = "Whether to enable connector-specific parameters for Google Workflow SQL Export."
  type        = bool
  default     = false
}

variable "connector_params_timeout" {
  description = "The end-to-end duration the connector call is allowed to run for before throwing a timeout exception. The default value is 1800 and this should be the maximum for connector methods that are not long-running operations. Otherwise, for long-running operations, the maximum timeout for a connector call is 31536000 seconds (one year)."
  type        = number
  default     = 1800
}

variable "unique_suffix" {
  description = "Unique suffix to add to scheduler jobs and workflows names."
  type        = string
  default     = ""
}

variable "log_db_name_to_export" {
  description = "Whether or not to log database name in the export workflow"
  type        = bool
  default     = false
}

variable "use_sql_instance_replica_in_exporter" {
  description = "Whether or not to use replica instance on exporter workflow."
  type        = bool
  default     = false
}

variable "sql_instance_replica" {
  description = "The name of the SQL instance replica to export"
  type        = string
  default     = null
}

variable "use_serverless_export" {
  description = "Whether to use serverless export for DB export"
  type        = bool
  default     = false
}

variable "monitoring_email" {
  description = "Email address to send alerts"
  type        = string
  default     = null
}

variable "enable_backup_monitoring" {
  description = "Whether to monitor backup workflows or not"
  type        = bool
  default     = false
}

variable "backup_monitoring_frequency" {
  description = "Timeframe in which there should be at least one successfull backup"
  type        = string
  default     = "1d"
}

variable "enable_export_monitoring" {
  description = "Whether to monitor export workflows or not"
  type        = bool
  default     = false
}

variable "export_monitoring_frequency" {
  description = "Timeframe in which there should be at least one successfull export"
  type        = string
  default     = "1d"
}

variable "create_notification_channel" {
  description = "If set to true it will create email notification channel"
  type        = bool
  default     = false
}

variable "notification_channel_name" {
  description = "Name of the email notification channel to be created. Only needed when create_notification_channel is set to true."
  type        = string
  default     = "Email Notification"
}

variable "notification_channels" {
  description = "List of existing notification channels to send alerts to"
  type        = list(string)
  default     = []
}
