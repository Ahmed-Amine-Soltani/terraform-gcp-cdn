############################# Bucket configuration #############################
# Bucket to store website
resource "google_storage_bucket" "bucket" {
  name                        = var.google_storage_bucket_name
  location                    = var.google_storage_bucket[0].location
  storage_class               = var.google_storage_bucket[0].storage_class
  force_destroy               = var.google_storage_bucket[0].force_destroy
  uniform_bucket_level_access = var.google_storage_bucket[0].uniform_bucket_level_access
  website {
    main_page_suffix = var.google_storage_bucket[0].main_page_suffix
    not_found_page   = var.google_storage_bucket[0].not_found_page
  }
}

# Make new objects public
resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Upload files to the bucket
resource "null_resource" "upload_folder_content" {
  triggers = {
    file_hashes = jsonencode({
      for fn in fileset(var.folder_path, "**") :
      fn => filesha256("${var.folder_path}/${fn}")
    })
  }

  provisioner "local-exec" {
    command = "gsutil cp -r ${var.folder_path}/* gs://${google_storage_bucket.bucket.name}/"
  }

}