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

# Fix provider version
provider "google" {
  version = "2.14"
  region  = var.region
}

# Fix provider version
provider "google-beta" {
  version = "2.20"
  region  = var.region
}

resource "random_id" "name" {
  byte_length = 2
}

module "mysql-external" {
  source             = "../../modules/mysql"
  name               = "example-external-mysql-${random_id.name.hex}"
  project_id         = var.project_id
  source_ip_address  = var.source_ip_address
  source_port        = var.source_port
  zone               = var.zone
  read_replica_size  = 1
  read_replica_tier  = "db-n1-standard-1"
  read_replica_zones = "c"
}
