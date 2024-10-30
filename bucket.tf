resource "aws_s3_bucket" "live_bucket" {
  bucket = "tf-pro-cert-s9v7iba9fp"
}

moved {
  from = aws_s3_bucket.imported_bucket
  to   = aws_s3_bucket.live_bucket
}

# resource "aws_s3_bucket_object" "imported_bucket_object" {
#   bucket = aws_s3_bucket.imported_bucket.bucket
#   key    = "folder1/test_image.png"
#
#   lifecycle {
#     ignore_changes = [
#       acl
#     ]
#   }
# }

# import {
#   to = aws_s3_bucket_object.imported_bucket_object
#   id = "s3://tf-pro-cert-s9v7iba9fp/folder1/test_image.png"
# }