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
}

variable "master" {
  default = {}

  description = <<EOF
The master settings of the Cloud SQL resources.
Following arguments are available:

tier - (Required) The tier for the master instance.

zone - (Required) The zone for the master instance, it should be something like: `a`, `c`.

activation_policy - (Optional) The activation policy for the master instance. Defaults to `ALWAYS`. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.

availability_type - (Optional) The availability type for the master instance. Defaults to `ZONAL`. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.

authorized_gae_applications - (Optional) The list of authorized App Engine project names

disk_autoresize - (Optional) Configuration to increase storage size. Defaults to `true`.

disk_size - (Optional) The disk size for the master instance. Defaults to `10`.

disk_type - (Opitional) The disk type for the master instance. Defaults to `PD_SSD`.

pricing_plan - (Optional) The pricing plan for the master instance. Defaults to `PER_USE`.

database_flags - (Optional) The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)

maintenance_window_day - (Optional) The day of week (1-7) for the master instance maintenance.

maintenance_window_hour - (Optional) The hour of day (0-23) maintenance window for the master instance maintenance.

maintenance_window_update_track - (Optional) The update track of maintenance window for the master instance maintenance. Defaults to `canary`. Can be either `canary` or `stable`.
EOF
}

variable "master_database_flags" {
  default     = []
  description = "The database flasgs to set on the master instance"
}

variable "master_labels" {
  default     = {}
  description = "The key/value labels for the master instances."
}

variable "read_replica" {
  default = {}

  description = <<EOF
The read replica settings of the Cloud SQL resources
Following arguments are available:

tier - (Required) The tier for the read replica instances.

zones - (Required) The zones for the read replica instancess, it should be something like: `a,b,c`. Given zones are used rotationally for creating read replicas.

activation_policy - (Optional) The activation policy for the read replica instances. Defaults to `ALWAYS`. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.

availability_type - (Optional) The availability type for the read replica instances. Defaults to `ZONAL`. This is only used to set up high availability for the PostgreSQL instances. Can be either `ZONAL` or `REGIONAL`.

authorized_gae_applications - (Optional) The list of authorized App Engine project names

crash_safe_replication (Optional) The crash safe replication is to indicates when crash-safe replication flags are enabled. Defaults to `true`.

disk_autoresize - (Optional) Configuration to increase storage size. Defaults to `true`.

disk_size - (Optional) The disk size for the read replica instances. Defaults to `10`.

disk_type - (Opitional) The disk type for the read replica instances. Defaults to `PD_SSD`.

pricing_plan - (Optional) The pricing plan for the read replica instances. Defaults to `PER_USE`.

database_flags - (Optional) The database flags for the read replica instances. See [more details](https://cloud.google.com/sql/docs/mysql/flags)

maintenance_window_day - (Optional) The day of week (1-7) for the read replica instances maintenance.

maintenance_window_hour - (Optional) The hour of day (0-23) maintenance window for the read replica instances maintenance.

maintenance_window_update_track - (Optional) The update track of maintenance window for the read replica instances maintenance. Defaults to `canary`. Can be either `canary` or `stable`.
EOF
}

variable "read_replica_database_flags" {
  default     = []
  description = "The database flasgs to set on the read replica instances"
}

variable "replica_configuration" {
  default = {}

  description = <<EOF
The replica configuration for use in read replica
EOF
}

variable "read_replica_labels" {
  default     = {}
  description = "The key/value labels for the read replica instances."
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
  default     = []
  description = "The authorized gae applications for the Cloud SQL instances"
}

variable "ip_configuration" {
  default = {}

  description = <<EOF
The ip configuration for the Cloud SQL instances.
This argument will be passed through all instances as the settings.ip_configuration block.
EOF
}

// for google_sql_database
variable "databases" {
  default     = []
  description = "The list of databases for the instacne"
}

// for google_sql_user
variable "users" {
  default     = []
  description = "The list of users on the database"
}
