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

variable "region" {
  default = "us-central1"
  type    = string
}

variable "network" {
  default = "default"
  type    = string
}

variable "zone" {
  default = "us-central1-b"
  type    = string
}

variable "mysql_version" {
  default = "MYSQL_5_6"
  type    = string
}

variable "postgresql_version" {
  default = "POSTGRES_9_6"
  type    = string
}

variable "network_name" {
  default = "mysql-psql-example"
  type    = string
}

variable "project_id" {
  type = string
}
