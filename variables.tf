/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable region {
  description = "Region for cloud resources"
  default     = "us-central1"
}

variable name {
  description = "Name for the database instance. Must be unique and cannot be reused for up to one week."
}

variable database_version {
  description = "The version of of the database. For example, `MYSQL_5_6` or `POSTGRES_9_6`."
  default     = "MYSQL_5_6"
}

variable master_instance_name {
  description = "The name of the master instance to replicate"
  default     = ""
}

variable tier {
  description = "The machine tier (First Generation) or type (Second Generation). See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing"
  default     = "db-f1-micro"
}

variable db_name {
  description = "Name of the default database to create"
  default     = "default"
}

variable db_charset {
  description = "The charset for the default database"
  default     = ""
}

variable db_collation {
  description = "The collation for the default database. Example for MySQL databases: 'utf8_general_ci', and Postgres: 'en_US.UTF8'"
  default     = ""
}

variable user_name {
  description = "The name of the default user"
  default     = "default"
}

variable user_host {
  description = "The host for the default user"
  default     = "%"
}

variable user_password {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  default     = ""
}

variable activation_policy {
  description = "This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable authorized_gae_applications {
  description = "A list of Google App Engine (GAE) project names that are allowed to access this instance."
  type        = "list"
  default     = []
}

variable disk_autoresize {
  description = "Second Generation only. Configuration to increase storage size automatically."
  default     = true
}

variable disk_size {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  default     = 10
}

variable disk_type {
  description = "Second generation only. The type of data disk: `PD_SSD` or `PD_HDD`."
  default     = "PD_SSD"
}

variable pricing_plan {
  description = "First generation only. Pricing plan for this instance, can be one of `PER_USE` or `PACKAGE`."
  default     = "PER_USE"
}

variable replication_type {
  description = "Replication type for this instance, can be one of `ASYNCHRONOUS` or `SYNCHRONOUS`."
  default     = "SYNCHRONOUS"
}

variable database_flags {
  description = "List of Cloud SQL flags that are applied to the database server"
  default     = []
}

variable backup_configuration {
  description = "The backup_configuration settings subblock for the database setings"
  type        = "map"
  default     = {}
}

variable ip_configuration {
  description = "The ip_configuration settings subblock"
  type        = "list"
  default     = [{}]
}

variable location_preference {
  description = "The location_preference settings subblock"
  type        = "list"
  default     = []
}

variable maintenance_window {
  description = "The maintenance_window settings subblock"
  type        = "list"
  default     = []
}

variable replica_configuration {
  description = "The optional replica_configuration block for the database instance"
  type        = "list"
  default     = []
}
