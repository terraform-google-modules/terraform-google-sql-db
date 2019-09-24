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
  description = "The project ID to manage the Cloud SQL resources"
  type        = string
}

variable "name" {
  description = "The name of the Cloud SQL resources"
  type        = string
}

// required
variable "database_version" {
  description = "The database version to use"
  type        = string
}

// required
variable "region" {
  description = "The region of the Cloud SQL resources"
  type        = string
}

// required
variable "vpc_network" {
  description = "Existing VPC network to which instances are connected. The networks needs to be configured with https://cloud.google.com/vpc/docs/configure-private-services-access."
  type        = string
}

variable "peering_completed" {
  description = "Optional. This is used to ensure that resources are created in the proper order when using private IPs and service network peering."
  type        = string
  default     = ""
}

// Master
variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-n1-standard-1"
}

variable "zone" {
  description = "The zone for the master instance, it should be something like: `a`, `c`."
  type        = string
}

variable "activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "authorized_gae_applications" {
  description = "The list of authorized App Engine project names"
  type        = list(string)
  default     = []
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "The disk size for the master instance"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD_SSD"
}

variable "pricing_plan" {
  description = "The pricing plan for the master instance."
  type        = string
  default     = "PER_USE"
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  type        = string
  default     = "stable"
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "user_labels" {
  description = "The key/value labels for the master instances."
  type        = map(string)
  default     = {}
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    binary_log_enabled = bool
    enabled            = bool
    start_time         = string
  })
  default = {
    binary_log_enabled = null
    enabled            = null
    start_time         = null
  }
}

variable "assign_public_ip" {
  description = "Set to true if the master instance should also have a public IP (less secure)."
  type        = string
  default     = false
}

// Read Replicas

variable "read_replica_configuration" {
  description = "The replica configuration for use in all read replica instances."
  type = object({
    connect_retry_interval    = number
    dump_file_path            = string
    ca_certificate            = string
    client_certificate        = string
    client_key                = string
    failover_target           = bool
    master_heartbeat_period   = number
    password                  = string
    ssl_cipher                = string
    username                  = string
    verify_server_certificate = bool
  })
  default = {
    connect_retry_interval    = null
    dump_file_path            = null
    ca_certificate            = null
    client_certificate        = null
    client_key                = null
    failover_target           = null
    master_heartbeat_period   = null
    password                  = null
    ssl_cipher                = null
    username                  = null
    verify_server_certificate = null
  }
}

variable "read_replica_name_suffix" {
  description = "The optional suffix to add to the read instance name"
  type        = string
  default     = ""
}

variable "read_replica_size" {
  description = "The size of read replicas"
  type        = number
  default     = 0
}

variable "read_replica_tier" {
  description = "The tier for the read replica instances."
  type        = string
  default     = ""
}

variable "read_replica_zones" {
  description = "The zones for the read replica instancess, it should be something like: `a,b,c`. Given zones are used rotationally for creating read replicas."
  type        = string
  default     = ""
}

variable "read_replica_activation_policy" {
  description = "The activation policy for the read replica instances. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "read_replica_crash_safe_replication" {
  description = "The crash safe replication is to indicates when crash-safe replication flags are enabled."
  type        = bool
  default     = true
}

variable "read_replica_disk_autoresize" {
  description = "Configuration to increase storage size."
  type        = bool
  default     = true
}

variable "read_replica_disk_size" {
  description = "The disk size for the read replica instances."
  type        = number
  default     = 10
}

variable "read_replica_disk_type" {
  description = "The disk type for the read replica instances."
  type        = string
  default     = "PD_SSD"
}

variable "read_replica_pricing_plan" {
  description = "The pricing plan for the read replica instances."
  type        = string
  default     = "PER_USE"
}

variable "read_replica_replication_type" {
  description = "The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS."
  type        = string
  default     = "SYNCHRONOUS"
}

variable "read_replica_database_flags" {
  description = "The database flags for the read replica instances. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "read_replica_maintenance_window_day" {
  description = "The day of week (1-7) for the read replica instances maintenance."
  type        = number
  default     = 1
}

variable "read_replica_maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the read replica instances maintenance."
  type        = number
  default     = 23
}

variable "read_replica_maintenance_window_update_track" {
  description = "The update track of maintenance window for the read replica instances maintenance. Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "read_replica_user_labels" {
  type        = map(string)
  default     = {}
  description = "The key/value labels for the read replica instances."
}

// Failover replica

variable "failover_replica" {
  description = "Specify true if the failover instance is required"
  type        = bool
  default     = false
}

variable "failover_replica_name_suffix" {
  description = "The optional suffix to add to the failover instance name"
  type        = string
  default     = ""
}

variable "failover_replica_configuration" {
  description = "The replica configuration for the failover replica instance. In order to create a failover instance, need to specify this argument."
  type = object({
    connect_retry_interval    = number
    dump_file_path            = string
    ca_certificate            = string
    client_certificate        = string
    client_key                = string
    failover_target           = bool
    master_heartbeat_period   = number
    password                  = string
    ssl_cipher                = string
    username                  = string
    verify_server_certificate = bool
  })
  default = {
    connect_retry_interval    = null
    dump_file_path            = null
    ca_certificate            = null
    client_certificate        = null
    client_key                = null
    failover_target           = null
    master_heartbeat_period   = null
    password                  = null
    ssl_cipher                = null
    username                  = null
    verify_server_certificate = null
  }
}

variable "failover_replica_tier" {
  description = "The tier for the failover replica instance."
  type        = string
  default     = ""
}

variable "failover_replica_zone" {
  description = "The zone for the failover replica instance, it should be something like: `a`, `c`."
  type        = string
  default     = ""
}

variable "failover_replica_activation_policy" {
  description = "The activation policy for the failover replica instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "failover_replica_crash_safe_replication" {
  description = "The crash safe replication is to indicates when crash-safe replication flags are enabled."
  type        = bool
  default     = true
}

variable "failover_replica_disk_autoresize" {
  description = "Configuration to increase storage size."
  type        = bool
  default     = true
}

variable "failover_replica_disk_size" {
  description = "The disk size for the failover replica instance."
  type        = number
  default     = 10
}

variable "failover_replica_disk_type" {
  description = "The disk type for the failover replica instance."
  type        = string
  default     = "PD_SSD"
}

variable "failover_replica_pricing_plan" {
  description = "The pricing plan for the failover replica instance."
  type        = string
  default     = "PER_USE"
}

variable "failover_replica_replication_type" {
  description = "The replication type for the failover replica instance. Can be one of ASYNCHRONOUS or SYNCHRONOUS."
  type        = string
  default     = "SYNCHRONOUS"
}

variable "failover_replica_database_flags" {
  description = "The database flags for the failover replica instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "failover_replica_maintenance_window_day" {
  description = "The day of week (1-7) for the failover replica instance maintenance."
  type        = number
  default     = 1
}

variable "failover_replica_maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the failover replica instance maintenance."
  type        = number
  default     = 23
}

variable "failover_replica_maintenance_window_update_track" {
  description = "The update track of maintenance window for the failover replica instance maintenance. Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "failover_replica_user_labels" {
  type        = map(string)
  default     = {}
  description = "The key/value labels for the failover replica instance."
}

variable "db_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "default"
}

variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'utf8_general_ci'"
  type        = string
  default     = ""
}

variable "additional_databases" {
  description = "A list of databases to be created in your cluster"
  type = list(object({
    project   = string
    name      = string
    charset   = string
    collation = string
    instance  = string
  }))
  default = []
}

variable "user_name" {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}

variable "additional_users" {
  description = "A list of users to be created in your cluster"
  type = list(object({
    project  = string
    name     = string
    password = string
    host     = string
    instance = string
  }))
  default = []
}

variable "create_timeout" {
  description = "The optional timout that is applied to limit long database creates."
  type        = string
  default     = "15m"
}

variable "update_timeout" {
  description = "The optional timout that is applied to limit long database updates."
  type        = string
  default     = "15m"
}

variable "delete_timeout" {
  description = "The optional timout that is applied to limit long database deletes."
  type        = string
  default     = "15m"
}
