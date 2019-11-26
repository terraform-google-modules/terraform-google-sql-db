/**
 * Copyright 2019 Google LLC
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
  default     = "us-central1"
  description = "The region to host the instance."
  type        = string
}

variable "mysql_version" {
  default     = "MYSQL_5_6"
  description = "The MySQL version to use."
  type        = string
}

variable "postgresql_version" {
  default     = "POSTGRES_9_6"
  description = "The PostgreSQL version to use."
  type        = string
}

variable "project_id" {
  default     = null
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}
