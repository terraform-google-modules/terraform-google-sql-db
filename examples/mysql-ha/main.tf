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
    ipv4_enabled    = true
    require_ssl     = false
    private_network = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.mysql_ha_external_ip_range
      },
    ]
  }

}


module "mysql" {
  source               = "../../modules/mysql"
  name                 = var.mysql_ha_name
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "MYSQL_5_7"
  region               = "us-central1"

  deletion_protection = false

  // Master configurations
  tier                            = "db-n1-standard-1"
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
    ipv4_enabled    = true
    require_ssl     = true
    private_network = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.mysql_ha_external_ip_range
      },
    ]
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
  read_replica_name_suffix = "-test"
  read_replicas = [
    {
      name                = "0"
      zone                = "us-central1-a"
      tier                = "db-n1-standard-1"
      ip_configuration    = local.read_replica_ip_configuration
      database_flags      = [{ name = "long_query_time", value = 1 }]
      disk_autoresize     = null
      disk_size           = null
      disk_type           = "PD_HDD"
      user_labels         = { bar = "baz" }
      encryption_key_name = null
    },
    {
      name                = "1"
      zone                = "us-central1-b"
      tier                = "db-n1-standard-1"
      ip_configuration    = local.read_replica_ip_configuration
      database_flags      = [{ name = "long_query_time", value = 1 }]
      disk_autoresize     = null
      disk_size           = null
      disk_type           = "PD_HDD"
      user_labels         = { bar = "baz" }
      encryption_key_name = null
    },
    {
      name                = "2"
      zone                = "us-central1-c"
      tier                = "db-n1-standard-1"
      ip_configuration    = local.read_replica_ip_configuration
      database_flags      = [{ name = "long_query_time", value = 1 }]
      disk_autoresize     = null
      disk_size           = null
      disk_type           = "PD_HDD"
      user_labels         = { bar = "baz" }
      encryption_key_name = null
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
  user_password = "foobar"

  additional_users = [
    {
      name     = "tftest2"
      password = "abcdefg"
      host     = "localhost"
      type     = "BUILT_IN"
    },
    {
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
      type     = "BUILT_IN"
    },
  ]
}
