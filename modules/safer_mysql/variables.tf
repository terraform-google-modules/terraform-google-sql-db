/**
 * Copyright 2024 Google LLC
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

variable "random_instance_name" {
  type        = bool
  description = "Sets random suffix at the end of the Cloud SQL resource name"
  default     = false
}

// required
variable "database_version" {
  description = "The database version to use"
  type        = string
}

variable "maintenance_version" {
  description = "The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored"
  type        = string
  default     = null
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

variable "allocated_ip_range" {
  description = "Existing allocated IP range name for the Private IP CloudSQL instance. The networks needs to be configured with https://cloud.google.com/vpc/docs/configure-private-services-access."
  type        = string
  default     = null
}

// Master
variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-n1-standard-1"
}

variable "edition" {
  description = "The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS."
  type        = string
  default     = null
}

variable "zone" {
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
  type        = string
  default     = null
}

variable "secondary_zone" {
  type        = string
  description = "The preferred zone for the secondary/failover instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = null
}

// optional
variable "master_instance_name" {
  description = "The name of the existing instance that will act as the master in the replication setup."
  type        = string
  default     = null
}

//optional
variable "failover_dr_replica_name" {
  type        = string
  description = "If the instance is a primary instance, then this field identifies the disaster recovery (DR) replica. The standard format of this field is \"your-project:your-instance\". You can also set this field to \"your-instance\", but cloud SQL backend will convert it to the aforementioned standard format."
  default     = null
}

// optional
variable "instance_type" {
  description = "Users can upgrade a read replica instance to a stand-alone Cloud SQL instance with the help of instance_type. To promote, users have to set the instance_type property as CLOUD_SQL_INSTANCE and remove/unset master_instance_name and replica_configuration from instance configuration. This operation might cause your instance to restart."
  type        = string
  default     = null
}

variable "follow_gae_application" {
  type        = string
  description = "A Google App Engine application whose zone to remain in. Must be in the same region as this instance."
  default     = null
}

variable "activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "availability_type" {
  description = "The availability type for the master instance. Can be either `REGIONAL` or `null`."
  type        = string
  default     = "REGIONAL"
}

variable "deletion_protection_enabled" {
  description = "Enables protection of an instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "read_replica_deletion_protection_enabled" {
  description = "Enables protection of a read replica from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased."
  type        = number
  default     = 0
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

variable "data_cache_enabled" {
  description = "Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE_PLUS tier and supported database_versions"
  type        = bool
  default     = false
}

variable "deny_maintenance_period" {
  description = "The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/mysql/maintenance)"
  type = list(object({
    end_date   = string
    start_date = string
    time       = string
  }))
  default = []
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
  description = "The backup_configuration settings subblock for the database settings"
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    start_time                     = string
    location                       = string
    transaction_log_retention_days = string
    retained_backups               = number
    retention_unit                 = string
  })
  default = {
    binary_log_enabled             = false
    enabled                        = false
    start_time                     = null
    location                       = null
    transaction_log_retention_days = null
    retained_backups               = null
    retention_unit                 = null
  }
}

variable "retain_backups_on_delete" {
  description = "When this parameter is set to true, Cloud SQL retains backups of the instance even after the instance is deleted. The ON_DEMAND backup will be retained until customer deletes the backup or the project. The AUTOMATED backup will be retained based on the backups retention setting."
  type        = bool
  default     = true
}

variable "assign_public_ip" {
  description = "Set to true if the master instance should also have a public IP (less secure)."
  type        = bool
  default     = false
}

// Read Replicas
variable "read_replica_name_suffix" {
  description = "The optional suffix to add to the read instance name"
  type        = string
  default     = ""
}

variable "read_replicas" {
  description = "List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption_key_name = null"
  type = list(object({
    name                  = string
    name_override         = optional(string)
    tier                  = string
    edition               = string
    availability_type     = string
    zone                  = string
    disk_type             = string
    disk_autoresize       = bool
    disk_autoresize_limit = number
    disk_size             = string
    user_labels           = map(string)
    database_flags = list(object({
      name  = string
      value = string
    }))
    insights_config = optional(object({
      query_plans_per_minute  = number
      query_string_length     = number
      record_application_tags = bool
      record_client_address   = bool
    }))
    ip_configuration = object({
      authorized_networks = list(map(string))
      ipv4_enabled        = bool
      private_network     = string
      allocated_ip_range  = string
    })
    encryption_key_name = string
  }))
  default = []
}

variable "enable_default_db" {
  description = "Enable or disable the creation of the default database"
  type        = bool
  default     = true
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
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable "enable_default_user" {
  description = "Enable or disable the creation of the default user"
  type        = bool
  default     = true
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
  description = "A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set."
  type = list(object({
    name            = string
    password        = string
    host            = string
    type            = string
    random_password = bool
  }))
  default = []
}

variable "iam_users" {
  description = "A list of IAM users to be created in your CloudSQL instance. iam.users.type can be CLOUD_IAM_USER, CLOUD_IAM_SERVICE_ACCOUNT, CLOUD_IAM_GROUP and is required for type CLOUD_IAM_GROUP (IAM groups)"
  type = list(object({
    id    = string,
    email = string,
    type  = optional(string)
  }))
  default = []
}

variable "create_timeout" {
  description = "The optional timout that is applied to limit long database creates."
  type        = string
  default     = "30m"
}

variable "update_timeout" {
  description = "The optional timout that is applied to limit long database updates."
  type        = string
  default     = "30m"
}

variable "delete_timeout" {
  description = "The optional timout that is applied to limit long database deletes."
  type        = string
  default     = "30m"
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "read_replica_deletion_protection" {
  description = "Used to block Terraform from deleting replica SQL Instances."
  type        = bool
  default     = false
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_plans_per_minute  = number
    query_string_length     = number
    record_application_tags = bool
    record_client_address   = bool
  })
  default = null
}
