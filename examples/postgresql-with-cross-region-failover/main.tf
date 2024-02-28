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
  read_replica_ip_configuration = {
    ipv4_enabled       = false
    require_ssl        = false
    ssl_mode           = "ENCRYPTED_ONLY"
    private_network    = google_compute_network.default.self_link
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }
  edition            = "ENTERPRISE_PLUS"
  tier               = local.edition == "ENTERPRISE_PLUS" ? "db-perf-optimized-N-8" : "db-custom-8-30720"
  data_cache_enabled = local.edition == "ENTERPRISE_PLUS" ? true : false
}

data "google_compute_zones" "available_region1" {
  project = var.project_id
  region  = local.region_1
}

data "google_compute_zones" "available_region2" {
  project = var.project_id
  region  = local.region_2
}
