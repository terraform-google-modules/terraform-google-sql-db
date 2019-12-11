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

resource "random_id" "suffix" {
  byte_length = 5
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.
  */
  instance_name = "${var.db_name}-${random_id.suffix.hex}"
  network_name  = "${var.network_name}-safer-${random_id.suffix.hex}"
}

module "network-safer-mysql-simple" {
  source  = "terraform-google-modules/network/google"
  version = "~> 1.4"

  project_id   = var.project_id
  network_name = local.network_name

  subnets = []
}

module "private-service-access" {
  source      = "../../modules/private_service_access"
  project_id  = var.project_id
  vpc_network = module.network-safer-mysql-simple.network_name
}

module "safer-mysql-db" {
  source     = "../../modules/safer_mysql"
  name       = local.instance_name
  project_id = var.project_id

  database_version = "MYSQL_5_6"
  region           = "us-central1"
  zone             = "c"
  tier             = "db-n1-standard-1"

  // By default, all users will be permitted to connect only via the
  // Cloud SQL proxy.
  additional_users = [
    {
      project  = var.project_id
      name     = "app"
      password = "PaSsWoRd"
      host     = "localhost"
      instance = local.instance_name
    },
    {
      project  = var.project_id
      name     = "readonly"
      password = "PaSsWoRd"
      host     = "localhost"
      instance = local.instance_name
    },
  ]

  assign_public_ip = "true"
  vpc_network      = module.network-safer-mysql-simple.network_self_link

  // Optional: used to enforce ordering in the creation of resources.
  module_depends_on = [module.private-service-access.peering_completed]
}
