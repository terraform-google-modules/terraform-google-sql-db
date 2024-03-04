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


# Create Network with a subnetwork and private service access for both netapp.servicenetworking.goog and servicenetworking.googleapis.com

locals {
  region_1 = "us-central1"
  region_2 = "us-east1"
}
resource "google_compute_network" "default" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "test network"
}

resource "google_compute_subnetwork" "subnetwork1" {
  name                     = "subnet-${local.region_1}-pg"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = local.region_1
  project                  = var.project_id
  network                  = google_compute_network.default.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnetwork_2" {
  name                     = "subnet-${local.region_2}-pg"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = local.region_2
  project                  = var.project_id
  network                  = google_compute_network.default.self_link
  private_ip_google_access = true
}


resource "google_compute_global_address" "private_ip_alloc" {
  project       = var.project_id
  name          = "psa-pg"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  address       = "10.10.0.0"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network = google_compute_network.default.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_ip_alloc.name,
  ]
  deletion_policy = "ABANDON"

  depends_on = [
    google_compute_subnetwork.subnetwork1,
    google_compute_subnetwork.subnetwork_2
  ]
}
