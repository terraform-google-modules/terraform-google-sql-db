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
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "region" {
  type        = string
  description = "The region of the Cloud SQL resources"
  default     = "us-central1"
}

variable "name" {
  type        = string
  description = "The name of the Cloud SQL instance"
}

variable "edition" {
  description = "The edition of the Cloud SQL instance, can be ENTERPRISE or ENTERPRISE_PLUS."
  type        = string
  default     = null
}

// required
variable "database_version" {
  description = "The database version to use. Can be 9_6, 14, 15, 16, 17."
  type        = string

  validation {
    condition     = (length(var.database_version) >= 9 && ((upper(substr(var.database_version, 0, 9)) == "POSTGRES_") && can(regex("^\\d+(?:_?\\d)*$", substr(var.database_version, 9, -1))))) || can(regex("^\\d+(?:_?\\d)*$", var.database_version))
    error_message = "The specified database version is not a valid representation of database version. Valid database versions should be like the following patterns:- \"9_6\", \"postgres_9_6\", \"14\", \"POSTGRES_14\", \"15\", \"POSTGRES_15\", \"16\", \"POSTGRES_16\" or \"17\", \"POSTGRES_17\""
  }
}

variable "maintenance_version" {
  description = "The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored"
  type        = string
  default     = null
}

variable "availability_type" {
  description = "The availability type for the Cloud SQL instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = "ZONAL"
}

variable "enable_default_db" {
  description = "Enable or disable the creation of the default database"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "The name of the default database to create. This should be unique per Cloud SQL instance."
  type        = string
  default     = "default"
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

variable "root_password" {
  description = "Initial root password during creation"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "database_flags" {
  description = "The database flags for the Cloud SQL instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "database_deletion_policy" {
  description = "The deletion policy for the database. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be deleted from the API if there are users other than cloudsqlsuperuser with access. Possible values are: \"ABANDON\"."
  type        = string
  default     = null
}

variable "user_deletion_policy" {
  description = "The deletion policy for the user. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: \"ABANDON\"."
  type        = string
  default     = null
}

variable "data_cache_enabled" {
  description = "Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE_PLUS tier and supported database_versions"
  type        = bool
  default     = false
}

variable "additional_users" {
  description = "A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set."
  type = list(object({
    name            = string
    password        = string
    random_password = bool
  }))
  default = []
  validation {
    condition     = length([for user in var.additional_users : false if(user.random_password == false && (user.password == null || user.password == "")) || (user.random_password == true && (user.password != null && user.password != ""))]) == 0
    error_message = "Password is a requird field for built_in Postgres users and you cannot set both password and random_password, choose one of them."
  }
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

variable "master_instance_name" {
  type        = string
  description = "Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover failover replica instance as master instance"
  default     = null
}

variable "failover_dr_replica_name" {
  type        = string
  description = "If the instance is a primary instance, then this field identifies the disaster recovery (DR) replica. The standard format of this field is \"your-project:your-instance\". You can also set this field to \"your-instance\", but cloud SQL backend will convert it to the aforementioned standard format."
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The type of the instance. The supported values are SQL_INSTANCE_TYPE_UNSPECIFIED, CLOUD_SQL_INSTANCE, ON_PREMISES_INSTANCE and READ_REPLICA_INSTANCE. Set to READ_REPLICA_INSTANCE if master_instance_name value is provided"
  default     = "CLOUD_SQL_INSTANCE"
}

variable "random_instance_name" {
  type        = bool
  description = "Sets random suffix at the end of the Cloud SQL resource name"
  default     = false
}

variable "tier" {
  description = "The tier for the Cloud SQL instance, for ADC its defualt value will be db-perf-optimized-N-8 which is tier value for edtion ENTERPRISE_PLUS, if user wants to change the edition, he should chose compatible tier."
  type        = string
  default     = "db-f1-micro"
}

variable "zone" {
  type        = string
  description = "The zone for the Cloud SQL instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = null
}

variable "secondary_zone" {
  type        = string
  description = "The preferred zone for the replica instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = null
}

variable "follow_gae_application" {
  type        = string
  description = "A Google App Engine application whose zone to remain in. Must be in the same region as this instance."
  default     = null
}

variable "activation_policy" {
  description = "The activation policy for the Cloud SQL instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "deletion_protection_enabled" {
  description = "Enables protection of an Cloud SQL instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "read_replica_deletion_protection_enabled" {
  description = "Enables protection of replica instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size."
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased."
  type        = number
  default     = 0
}

variable "disk_size" {
  description = "The disk size (in GB) for the Cloud SQL instance."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the Cloud SQL instance."
  type        = string
  default     = "PD_SSD"
}

variable "pricing_plan" {
  description = "The pricing plan for the Cloud SQL instance."
  type        = string
  default     = "PER_USE"
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the Cloud SQL instance maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the Cloud SQL instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the Cloud SQL instance maintenance.Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "user_labels" {
  description = "The key/value labels for the Cloud SQL instances."
  type        = map(string)
  default     = {}
}

variable "deny_maintenance_period" {
  description = "The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/postgres/maintenance)"
  type = list(object({
    end_date   = string
    start_date = string
    time       = string
  }))
  default = []
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = optional(bool, false)
    start_time                     = optional(string)
    location                       = optional(string)
    point_in_time_recovery_enabled = optional(bool, false)
    transaction_log_retention_days = optional(string)
    retained_backups               = optional(number)
    retention_unit                 = optional(string)
  })
  default = {}
}

variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_plans_per_minute  = optional(number, 5)
    query_string_length     = optional(number, 1024)
    record_application_tags = optional(bool, false)
    record_client_address   = optional(bool, false)
  })
  default = null
}

variable "password_validation_policy_config" {
  description = "The password validation policy settings for the database instance."
  type = object({
    min_length                  = optional(number)
    complexity                  = optional(string)
    reuse_interval              = optional(number)
    disallow_username_substring = optional(bool)
    password_change_interval    = optional(string)
  })
  default = null
}

variable "ip_configuration" {
  description = "The ip configuration for the Cloud SQL instances."
  type = object({
    authorized_networks                           = optional(list(map(string)), [])
    ipv4_enabled                                  = optional(bool, true)
    private_network                               = optional(string)
    ssl_mode                                      = optional(string)
    allocated_ip_range                            = optional(string)
    enable_private_path_for_google_cloud_services = optional(bool, false)
    psc_enabled                                   = optional(bool, false)
    psc_allowed_consumer_projects                 = optional(list(string), [])
    server_ca_mode                                = optional(string)
    server_ca_pool                                = optional(string)
    custom_subject_alternative_names              = optional(list(string), [])
  })
  default = {}
}

// Read Replicas
variable "read_replicas" {
  description = "List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption_key_name = null"
  type = list(object({
    name                  = string
    name_override         = optional(string)
    tier                  = optional(string)
    edition               = optional(string)
    availability_type     = optional(string)
    zone                  = optional(string)
    disk_type             = optional(string)
    disk_autoresize       = optional(bool)
    disk_autoresize_limit = optional(number)
    disk_size             = optional(string)
    user_labels           = map(string)
    database_flags = optional(list(object({
      name  = string
      value = string
    })), [])
    insights_config = optional(object({
      query_plans_per_minute  = optional(number, 5)
      query_string_length     = optional(number, 1024)
      record_application_tags = optional(bool, false)
      record_client_address   = optional(bool, false)
    }), null)
    ip_configuration = object({
      authorized_networks                           = optional(list(map(string)), [])
      ipv4_enabled                                  = optional(bool)
      private_network                               = optional(string)
      ssl_mode                                      = optional(string)
      allocated_ip_range                            = optional(string)
      enable_private_path_for_google_cloud_services = optional(bool, false)
      psc_enabled                                   = optional(bool, false)
      psc_allowed_consumer_projects                 = optional(list(string), [])
    })
    encryption_key_name = optional(string)
    data_cache_enabled  = optional(bool)
  }))
  default = []
}

variable "read_replica_name_suffix" {
  description = "The optional suffix to add to the read instance name"
  type        = string
  default     = ""
}

variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'en_US.UTF8'"
  type        = string
  default     = ""
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

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "read_replica_deletion_protection" {
  description = "Used to block Terraform from deleting replica SQL Instances."
  type        = bool
  default     = false
}

variable "enable_random_password_special" {
  description = "Enable special characters in generated random passwords."
  type        = bool
  default     = false
}

variable "connector_enforcement" {
  description = "Enforce that clients use the connector library"
  type        = bool
  default     = false
}

variable "enable_google_ml_integration" {
  description = "Enable database ML integration"
  type        = bool
  default     = false
}

variable "enable_dataplex_integration" {
  description = "Enable database Dataplex integration"
  type        = bool
  default     = false
}

variable "database_integration_roles" {
  description = "The roles required by default database instance service account for integration with GCP services"
  type        = list(string)
  default     = []
}

variable "use_autokey" {
  description = "Enable the use of autokeys from Google Cloud KMS for CMEK. This requires autokey already configured in the project"
  type        = bool
  default     = false
}

variable "create_kms_key_handle" {
  description = "KeyHandles cannot be deleted from Google Cloud Platform. Destroying a Terraform-managed KeyHandle will remove it from state but will not delete the resource from the project. Set this to false if key handle already exists"
  type        = bool
  default     = true
}

variable "kms_key_handle_name" {
  description = "key handle name. If not provided module will use instance name as key handle name"
  type        = string
  default     = null
}

variable "retain_backups_on_delete" {
  description = "When this parameter is set to true, Cloud SQL retains backups of the instance even after the instance is deleted. The ON_DEMAND backup will be retained until customer deletes the backup or the project. The AUTOMATED backup will be retained based on the backups retention setting."
  type        = bool
  default     = false
}
