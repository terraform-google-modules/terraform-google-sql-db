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
  region = var.region
}

provider "google-beta" {
  region = var.region
}

resource "random_id" "instance_name_suffix" {
  byte_length = 5
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/sqlserver/delete-instance for details.
  */
  instance_name = "${var.ha_name}-${random_id.instance_name_suffix.hex}"
}

module "mssql" {
  source     = "../../../modules/mssql"
  name       = local.instance_name
  project_id = var.project_id
  db_name    = var.ha_name

  deletion_protection = false

  // Master configurations
  tier                            = "db-custom-2-13312"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [
    {
      name  = "default trace enabled"
      value = false
    },
  ]

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
        value = var.ha_external_ip_range
      },
    ]
  }

  additional_databases = [
    {
      name      = "${var.ha_name}-additional"
      charset   = ""
      collation = ""
      instance  = local.instance_name
      project   = var.project_id
    },
  ]

  user_name     = "tftest"
  user_password = "foobar"

  additional_users = [
    {
      project  = var.project_id
      name     = "tftest2"
      password = "abcdefg"
      host     = "localhost"
      instance = local.instance_name
    },
    {
      project  = var.project_id
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
      instance = local.instance_name
    },
  ]
}
