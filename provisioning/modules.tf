locals {
  service_account_id = "privacy-engineering-workshop"
  service_account_display_name = "Privacy Engineering Workshop"
  service_account_description = "Service Account used as a credential for writing to a Google Cloud Storage Bucket"
}

resource "google_storage_bucket" "data_engineering_bucket" {
  name = local.service_account_id
  location = module.dev.default_region

  force_destroy = true
}

resource "google_storage_bucket_access_control" "public" {
  bucket = google_storage_bucket.data_engineering_bucket.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_service_account" "service_account" {
  account_id = local.service_account_id
  display_name = local.service_account_display_name
  description = local.service_account_description
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}

resource "google_storage_bucket_iam_member" "bucket_sa_write_access" {
  bucket = google_storage_bucket.data_engineering_bucket.name
  role = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_storage_bucket_object" "picture" {
  name   = "privacy-engineering-workshop-gcs-bucket-write-sa.json"
  content = base64decode(google_service_account_key.service_account_key.private_key)
  bucket = google_storage_bucket.data_engineering_bucket.name
}
