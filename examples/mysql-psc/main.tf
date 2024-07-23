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

locals {
  read_replica_ip_configuration = {
    ipv4_enabled                  = false
    require_ssl                   = false
    psc_enabled                   = true
    psc_allowed_consumer_projects = [var.project_id]
  }

}


module "mysql" {
  source  = "terraform-google-modules/sql-db/google//modules/mysql"
  version = "~> 21.0"

  name                 = var.mysql_ha_name
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "MYSQL_8_0"
  region               = "us-central1"

  deletion_protection = false

  // Master configurations
  tier                            = "db-custom-2-7680"
  zone                            = "us-central1-c"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [{ name = "long_query_time", value = 1 }]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled                  = false
    psc_enabled                   = true
    psc_allowed_consumer_projects = [var.project_id]
  }

  password_validation_policy_config = {
    enable_password_policy      = true
    complexity                  = "COMPLEXITY_DEFAULT"
    disallow_username_substring = true
    min_length                  = 8
  }

  backup_configuration = {
    enabled                        = true
    binary_log_enabled             = true
    start_time                     = "20:55"
    location                       = null
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  // Read replica configurations
  read_replica_name_suffix = "-test-psc"
  replica_database_version = "MYSQL_8_0"
  read_replicas = [
    {
      name              = "0"
      zone              = "us-central1-a"
      availability_type = "REGIONAL"
      tier              = "db-custom-2-7680"
      ip_configuration  = local.read_replica_ip_configuration
      database_flags    = [{ name = "long_query_time", value = 1 }]
      disk_type         = "PD_SSD"
      user_labels       = { bar = "baz" }
    },
  ]

  db_name      = var.mysql_ha_name
  db_charset   = "utf8mb4"
  db_collation = "utf8mb4_general_ci"

  additional_databases = [
    {
      name      = "${var.mysql_ha_name}-additional"
      charset   = "utf8mb4"
      collation = "utf8mb4_general_ci"
    },
  ]

  user_name     = "tftest"
  user_password = "Example!12345"
  root_password = ".5nHITPioEJk^k}="

  additional_users = [
    {
      name            = "tftest2"
      password        = "Example!12345"
      host            = "localhost"
      type            = "BUILT_IN"
      random_password = false
    },
    {
      name            = "tftest3"
      password        = "Example!12345"
      host            = "localhost"
      type            = "BUILT_IN"
      random_password = false
    },
  ]
}
