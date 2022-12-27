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

variable "unique_suffix" {
  description = "Unique suffix to add to scheduler jobs and workflows names."
  type        = string
  default     = ""
}
