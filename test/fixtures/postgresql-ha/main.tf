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

provider "google" {
  credentials = "${file(var.credentials_file_path)}"
}

module "pg" {
  source           = "../../../modules/postgresql"
  name             = "${var.pg_ha_name}"
  project_id       = "${var.project}"
  database_version = "POSTGRES_9_6"
  region           = "us-central1"
  charset          = "utf8"
  collation        = "en_US.UTF8"

  // IP Configuration is used in all instances
  ip_configuration {
    ipv4_enabled = true
    require_ssl  = true

    authorized_networks = [{
      name  = "${var.project}-cidr"
      value = "${var.pg_ha_external_ip_range}"
    }]
  }

  backup_configuration {
    enabled    = true
    start_time = "20:55"
  }

  // Master configurations
  master = {
    tier                            = "db-custom-2-13312"
    zone                            = "c"
    availability_type               = "REGIONAL"
    maintenance_window_day          = 7
    maintenance_window_hour         = 12
    maintenance_window_update_track = "stable"
  }

  master_database_flags = [
    {
      name  = "autovacuum"
      value = false
    },
  ]

  master_labels = {
    foo = "bar"
  }

  // replica_configuration block is used in all replicas.
  replica_configuration {
    dump_file_path         = "gs://${var.project}.appspot.com/tmp"
    connect_retry_interval = 5
  }

  // Read replica configurations
  read_replica = {
    length                          = 3
    tier                            = "db-custom-2-13312"
    zones                           = "a,b,c"
    activation_policy               = "ALWAYS"
    crash_safe_replication          = true
    disk_autoresize                 = true
    disk_type                       = "PD_HDD"
    replication_type                = "SYNCHRONOUS"
    maintenance_window_day          = 1
    maintenance_window_hour         = 22
    maintenance_window_update_track = "stable"
  }

  read_replica_labels = {
    bar = "baz"
  }

  read_replica_database_flags = [
    {
      name  = "autovacuum"
      value = false
    },
  ]

  // Users
  users = [
    {
      name     = "tftest"
      password = "foobar"
    },
  ]
}
