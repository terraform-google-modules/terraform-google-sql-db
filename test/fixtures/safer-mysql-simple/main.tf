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

provider "google-beta" {
  credentials = "${file(var.credentials_file_path)}"
}

resource "google_compute_network" "default" {
  project                 = "${var.project}"
  name                    = "test-vpc-safer-${var.safer_mysql_simple_name}"
  auto_create_subnetworks = false
}

module "private-service-access" {
  source      = "../../../modules/private_service_access"
  project_id  = "${var.project}"
  vpc_network = "${google_compute_network.default.name}"
}

module "safer-mysql-db" {
  source     = "../../../modules/safer_mysql"
  name       = "${var.safer_mysql_simple_name}"
  project_id = "${var.project}"

  database_version = "MYSQL_5_7"
  region           = "us-central1"
  zone             = "c"
  tier             = "db-n1-standard-1"

  // By default, all users will be permitted to connect only via the
  // Cloud SQL proxy.
  additional_users = [{
    name = "app"
  },
    {
      name = "readonly"
    },
  ]

  assign_public_ip = "true"
  vpc_network      = "${google_compute_network.default.self_link}"

  // Optional: used to enforce ordering in the creation of resources.
  peering_completed = "${module.private-service-access.peering_completed}"
}
