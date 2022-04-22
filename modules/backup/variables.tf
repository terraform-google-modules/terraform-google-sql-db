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
}

variable "service-account" {
  description = "The service account to use for running the workflow - If empty or null a service account will be created. If you have provided a service account you need to grant the Cloud SQL Admin and the Workflows Invoker role to that"
  type        = string
  default     = null
}

variable "project-id" {
  description = "The project ID"
  type        = string
}

variable "sql-instance" {
  description = "The name of the SQL instance to backup"
  type        = string
}

variable "backup-retention-time" {
  description = "The number of Days Backups should be kept"
  type        = number
  default     = 30
}

variable "scheduler-timezone" {
  description = "The Timezone in which the Scheduler Jobs are triggered"
  default     = "Etc/GMT"
}

variable "backup-schedule" {
  description = "The cron schedule to execute the internal backup"
  default     = "45 2 * * *"
}

variable "export-schedule" {
  description = "The cron schedule to execute the export to GCS"
  default     = "15 3 * * *"
}

variable "backup" {
  description = "Weather to create internal backups with this module"
  type        = bool
  default     = true
}

variable "export" {
  description = "Weather to create exports to GCS Buckets with this module"
  type        = bool
  default     = true
}

variable "export-databases" {
  description = "The list of databases that should be exported - if is an empty set all databases will be exported"
  type        = set(string)
  default     = []
  validation {
    condition     = var.export-databases != null
    error_message = "Must not be null."
  }
}

variable "export-uri" {
  description = "The bucket and path uri for exporting to GCS"
  type        = string
  validation {
    condition     = can(regex("^gs:\\/\\/", var.export-uri))
    error_message = "Must be a full GCS URI starting with gs://." #TODO: test
  }
}
