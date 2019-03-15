/**
 * Copyright 2018 Google LLC
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
  description = "The project ID to manage the Cloud SQL resources"
}

variable "name" {
  description = "The name of the Cloud SQL resources"
}

// required
variable "database_version" {
  description = "The database version to use"
}

// required
variable "region" {
  description = "The region of the Cloud SQL resources"
  default     = "us-central1"
}

variable "tier" {
  description = "The tier for the master instance."
  default     = "db-f1-micro"
}

variable "zone" {
  description = "The zone for the master instance, it should be something like: `a`, `c`."
}

variable "activation_policy" {
  description = "The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable "availability_type" {
  description = "The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`."
  default     = "ZONAL"
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size."
  default     = true
}

variable "disk_size" {
  description = "The disk size for the master instance."
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the master instance."
  default     = "PD_SSD"
}

variable "pricing_plan" {
  description = "The pricing plan for the master instance."
  default     = "PER_USE"
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`."
  default     = "canary"
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  default     = []
}

variable "user_labels" {
  description = "The key/value labels for the master instances."
  default     = {}
}

variable "backup_configuration" {
  default = {}

  description = <<EOF
The backup configuration block of the Cloud SQL resources
This argument will be passed through the master instance directrly.

See [more details](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html).
EOF
}

variable "authorized_gae_applications" {
  description = "The authorized gae applications for the Cloud SQL instances"
  default     = []
}

variable "ip_configuration" {
  description = "The ip configuration for the master instances."
  default     = {}
}

variable "read_replica_size" {
  description = "The size of read replicas"
  default     = 0
}

variable "read_replica_tier" {
  description = "The tier for the read replica instances."
  default     = ""
}

variable "read_replica_zones" {
  description = "The zones for the read replica instancess, it should be something like: `a,b,c`. Given zones are used rotationally for creating read replicas."
  default     = ""
}

variable "read_replica_activation_policy" {
  description = "The activation policy for the read replica instances.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable "read_replica_availability_type" {
  description = "The availability type for the read replica instances.This is only used to set up high availability for the PostgreSQL instances. Can be either `ZONAL` or `REGIONAL`."
  default     = "ZONAL"
}

variable "read_replica_crash_safe_replication" {
  description = "The crash safe replication is to indicates when crash-safe replication flags are enabled."
  default     = true
}

variable "read_replica_disk_autoresize" {
  description = "Configuration to increase storage size."
  default     = true
}

variable "read_replica_disk_size" {
  description = "The disk size for the read replica instances."
  default     = 10
}

variable "read_replica_disk_type" {
  description = "The disk type for the read replica instances."
  default     = "PD_SSD"
}

variable "read_replica_pricing_plan" {
  description = "The pricing plan for the read replica instances."
  default     = "PER_USE"
}

variable "read_replica_maintenance_window_day" {
  description = "The day of week (1-7) for the read replica instances maintenance."
  default     = 1
}

variable "read_replica_maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the read replica instances maintenance."
  default     = 23
}

variable "read_replica_maintenance_window_update_track" {
  description = "The update track of maintenance window for the read replica instances maintenance.Can be either `canary` or `stable`."
  default     = "canary"
}

variable "read_replica_database_flags" {
  description = "The database flags for the read replica instances. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  default     = []
}

variable "read_replica_configuration" {
  default     = {}
  description = "The replica configuration for use in read replica"
}

variable "read_replica_user_labels" {
  default     = {}
  description = "The key/value labels for the read replica instances."
}

variable "read_replica_replication_type" {
  description = "The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS."
  default     = "SYNCHRONOUS"
}

variable "read_replica_ip_configuration" {
  description = "The ip configuration for the read instances."
  default     = {}
}

variable "db_name" {
  description = "The name of the default database to create"
  default     = "default"
}

variable "db_charset" {
  description = "The charset for the default database"
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'en_US.UTF8'"
  default     = ""
}

variable "additional_databases" {
  description = "A list of databases to be created in your cluster"
  default     = []
}

variable "user_name" {
  description = "The name of the default user"
  default     = "default"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  default     = ""
}

variable "additional_users" {
  description = "A list of users to be created in your cluster"
  default     = []
}
