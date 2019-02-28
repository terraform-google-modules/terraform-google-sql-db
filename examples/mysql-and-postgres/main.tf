/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "region" {
  default = "us-central1"
}

variable "network" {
  default = "default"
}

variable "zone" {
  default = "us-central1-b"
}

variable "mysql_version" {
  default = "MYSQL_5_6"
}

variable "postgresql_version" {
  default = "POSTGRES_9_6"
}

provider "google" {
  region = "${var.region}"
}

variable "network_name" {
  default = "mysql-psql-example"
}

resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

data "google_client_config" "current" {}

resource "random_id" "name" {
  byte_length = 2
}

module "mysql-db" {
  source           = "../../modules/mysql"
  name             = "example-mysql-${random_id.name.hex}"
  database_version = "${var.mysql_version}"
  project_id       = "${data.google_client_config.current.project}"
  zone             = "c"

  ip_configuration = [{
    authorized_networks = [{
      name  = "${var.network_name}"
      value = "${google_compute_subnetwork.default.ip_cidr_range}"
    }]
  }]

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
  database_version = "${var.postgresql_version}"
  project_id       = "${data.google_client_config.current.project}"
  zone             = "c"

  ip_configuration = [{
    authorized_networks = [{
      name  = "${var.network_name}"
      value = "${google_compute_subnetwork.default.ip_cidr_range}"
    }]
  }]
}

output "mysql_conn" {
  value = "${data.google_client_config.current.project}:${var.region}:${module.mysql-db.instance_name}"
}

output "mysql_user_pass" {
  value = "${module.mysql-db.generated_user_password}"
}

output "psql_conn" {
  value = "${data.google_client_config.current.project}:${var.region}:${module.postgresql-db.instance_name}"
}

output "psql_user_pass" {
  value = "${module.postgresql-db.generated_user_password}"
}
