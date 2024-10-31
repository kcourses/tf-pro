variable "iam_role_name" {
  description = "IAM role name"
  type        = string
  default     = "test_role"

  validation {
    condition     = var.iam_role_name == "s3_access_role"
    error_message = "Validation error: wrong S3 access role name"
  }
}

variable "vpc_id" {
  type = string
}

variable "subnet_tags" {
  type    = map(string)
  default = {}
}