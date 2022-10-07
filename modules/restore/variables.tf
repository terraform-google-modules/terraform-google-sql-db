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
  description = "The region to run the workflow"
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

variable "import_databases" {
  description = "The list of databases that should be imported - if is an empty set all databases will be imported"
  type        = set(string)
  default     = []
  validation {
    condition     = var.import_databases != null
    error_message = "Must not be null."
  }
}

variable "import_uri" {
  description = "The bucket and path uri of GCS backup file for importing"
  type        = string
  validation {
    condition     = can(regex("^gs:\\/\\/", var.import_uri))
    error_message = "Must be a full GCS URI starting with gs://." #TODO: test
  }
}
