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
  region_1 = "us-central1"
  region_2 = "us-east1"
}

# Instance 1

module "mssql1" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 21.0"

  region = local.region_1

  name                 = "tf-mssql-public-1"
  random_instance_name = true
  project_id           = var.project_id

  database_version = "SQLSERVER_2022_ENTERPRISE"

  deletion_protection = false

  tier = "db-custom-4-15360"

  ip_configuration = {
    ipv4_enabled    = false
    private_network = google_compute_network.default.self_link
  }

  sql_server_audit_config = var.sql_server_audit_config
  enable_default_db       = false
  enable_default_user     = false

  depends_on = [
    google_service_networking_connection.vpc_connection,
  ]
}

# instance 2

module "mssql2" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 21.0"

  master_instance_name = module.mssql1.instance_name

  region = local.region_2

  name                 = "tf-mssql-public-2"
  random_instance_name = true
  project_id           = var.project_id

  database_version = "SQLSERVER_2022_ENTERPRISE"

  deletion_protection = false

  tier = "db-custom-4-15360"

  ip_configuration = {
    ipv4_enabled    = false
    private_network = google_compute_network.default.self_link
  }

  sql_server_audit_config = var.sql_server_audit_config
  enable_default_db       = false
  enable_default_user     = false

  depends_on = [
    google_service_networking_connection.vpc_connection,
  ]
}
