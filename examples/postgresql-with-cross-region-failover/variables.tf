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

variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "pg_name_1" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-pg-x-1"
}

variable "pg_name_2" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-pg-x-2"
}

variable "pg_ha_external_ip_range" {
  type        = string
  description = "The ip range to allow connecting from/to Cloud SQL"
  default     = "192.10.10.10/32"
}

variable "network_name" {
  description = "The ID of the network in which to provision resources."
  type        = string
  default     = "test-postgres-failover"
}
