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

resource "random_string" "db_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_kms_key_ring" "key_ring_region1" {
  name     = "test-${random_string.db_suffix.result}-${local.region_1}"
  location = local.region_1
  project  = var.project_id
}

resource "google_kms_crypto_key" "cloudsql_region1_key" {
  name     = "cmek-${random_string.db_suffix.result}-${local.region_1}"
  key_ring = google_kms_key_ring.key_ring_region1.id
  purpose  = "ENCRYPT_DECRYPT"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_key_ring" "key_ring_region2" {
  name     = "test-${random_string.db_suffix.result}-${local.region_2}"
  location = local.region_2
  project  = var.project_id
}


resource "google_kms_crypto_key" "cloudsql_region2_key" {
  name     = "cmek-${random_string.db_suffix.result}-${local.region_2}"
  key_ring = google_kms_key_ring.key_ring_region2.id
  purpose  = "ENCRYPT_DECRYPT"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project_service_identity" "cloudsql_sa" {
  provider = google-beta

  project = var.project_id
  service = "sqladmin.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "crypto_key_region1" {
  crypto_key_id = google_kms_crypto_key.cloudsql_region1_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.cloudsql_sa.email}"
}

resource "google_kms_crypto_key_iam_member" "crypto_key_region2" {
  crypto_key_id = google_kms_crypto_key.cloudsql_region2_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.cloudsql_sa.email}"
}

