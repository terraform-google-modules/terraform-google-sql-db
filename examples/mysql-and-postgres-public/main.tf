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
  version = "~> 2.13"
}

provider "google-beta" {
  version = "~> 2.13"
}

resource "random_id" "name" {
  byte_length = 2
}

module "mysql-db" {
  source           = "../../modules/mysql"
  name             = "example-mysql-${random_id.name.hex}"
  database_version = var.mysql_version
  project_id       = var.project_id
  zone             = "c"
  region           = var.region

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    authorized_networks = var.authorized_networks
  }


  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    },
  ]
}

module "postgresql-db" {
  source           = "../../modules/postgresql"
  name             = "example-postgresql-${random_id.name.hex}"
  database_version = var.postgresql_version
  project_id       = var.project_id
  zone             = "c"
  region           = var.region

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    authorized_networks = var.authorized_networks
  }
}

