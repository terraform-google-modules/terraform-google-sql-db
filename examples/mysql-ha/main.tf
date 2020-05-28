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

provider "google" {
  version = "~> 3.22"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "instance_name_suffix" {
  byte_length = 5
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.
  */
  instance_name = "${var.mysql_ha_name}-${random_id.instance_name_suffix.hex}"

  database_flags = [
    {
      name  = "long_query_time"
      value = 1
    },
  ]

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
  source           = "../../modules/mysql"
  name             = local.instance_name
  project_id       = var.project_id
  database_version = "MYSQL_5_7"
  region           = "us-central1"

  // Master configurations
  tier                            = "db-n1-standard-1"
  zone                            = "c"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = local.database_flags

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
    enabled            = true
    binary_log_enabled = true
    start_time         = "20:55"
  }

  // Read replica configurations
  read_replica_name_suffix = "-test"
  read_replicas = [
    {
      name             = "0"
      zone             = "a"
      region           = null
      tier             = "db-n1-standard-1"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = local.database_flags
      disk_type        = "PD_HDD"
      user_labels      = {}
    },
    {
      name             = "1"
      zone             = "b"
      region           = null
      tier             = "db-n1-standard-1"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = local.database_flags
      disk_type        = "PD_HDD"
      user_labels      = {}
    },
    {
      name             = "2"
      zone             = "c"
      region           = null
      tier             = "db-n1-standard-1"
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = local.database_flags
      disk_type        = "PD_HDD"
      user_labels      = {}
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
    },
    {
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
    },
  ]
}
