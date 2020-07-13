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

resource "random_id" "instance_name_suffix" {
  byte_length = 5
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/postgres/delete-instance for details.
  */
  instance_name = "${var.pg_ha_name}-${random_id.instance_name_suffix.hex}"
}

module "example" {
  source                  = "../../../examples/postgresql-ha"
  project_id              = var.project_id
  pg_ha_name              = var.pg_ha_name
  pg_ha_external_ip_range = var.pg_ha_external_ip_range
}



