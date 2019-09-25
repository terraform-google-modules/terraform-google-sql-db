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

data "google_client_config" "current" {
}

resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  project                  = var.project_id
  name                     = var.network_name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
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

  ip_configuration = {
    ipv4_enabled    = true
    private_network = null
    require_ssl     = true
    authorized_networks = [
      {
        name  = var.network_name
        value = google_compute_subnetwork.default.ip_cidr_range
      },
    ]
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

  ip_configuration = {
    ipv4_enabled    = true
    private_network = null
    require_ssl     = true
    authorized_networks = [
      {
        name  = var.network_name
        value = google_compute_subnetwork.default.ip_cidr_range
      },
    ]
  }
}

// We define a connection with the VPC of the Cloud SQL instance.
module "private-service-access" {
  source      = "../../modules/private_service_access"
  project_id  = var.project_id
  vpc_network = google_compute_network.default.name
}

module "safer-mysql-db" {
  source           = "../../modules/safer_mysql"
  name             = "example-safer-mysql-${random_id.name.hex}"
  database_version = var.mysql_version
  project_id       = var.project_id
  region           = var.region
  zone             = "c"

  # By default, all users will be permitted to connect only via the
  # Cloud SQL proxy.
  additional_users = [
    {
      project  = var.project_id
      name     = "app"
      password = "PaSsWoRd"
      host     = "localhost"
      instance = module.safer-mysql-db.instance_name
    },
    {
      project  = var.project_id
      name     = "readonly"
      password = "PaSsWoRd"
      host     = "localhost"
      instance = module.safer-mysql-db.instance_name
    },
  ]

  assign_public_ip = true
  vpc_network      = google_compute_network.default.self_link

  // Used to enforce ordering in the creation of resources.
  peering_completed = module.private-service-access.peering_completed
}


