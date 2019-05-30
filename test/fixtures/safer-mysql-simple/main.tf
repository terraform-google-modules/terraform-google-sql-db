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
  name                    = "default-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  project                  = "${var.project}"
  name                     = "default-vpc"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "us-central1"
  private_ip_google_access = true
}

# We define a VPC peering subnet that will be peered with the
# Cloud SQL instance network. The Cloud SQL instance will
# have a private IP within the provided range.
resource "google_compute_global_address" "google-managed-services-default" {
  provider      = "google-beta"
  project       = "${var.project}"
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.default.self_link}"
}

# Creates the peering with the producer network.
resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = "google-beta"
  network                 = "${google_compute_network.default.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.google-managed-services-default.name}"]
}

module "safer-mysql-db" {
  source     = "../../../modules/safer_mysql"
  name       = "${var.safer_mysql_simple_name}"
  project_id = "${var.project}"

  database_version = "MYSQL_5_7"
  region           = "us-central1"
  zone             = "c"
  tier             = "db-n1-standard-1"

  # By default, all users will be permitted to connect only via the
  # Cloud SQL proxy.
  additional_users = [{
    name = "app"
    },
    {
      name = "readonly"
    },
  ]

  assign_public_ip = "true"
  vpc_network      = "${google_compute_network.default.self_link}"

  # Optional, but used to enforce ordering in the creation of resources.
  vpc_peering = "${google_service_networking_connection.private_vpc_connection.self_link}"
}
