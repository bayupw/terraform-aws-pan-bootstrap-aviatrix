output "aws_s3_bucket" {
  description = "Created S3 bucket object"
  value       = aws_s3_bucket.this
}

output "aws_iam_role" {
  description = "Created IAM role"
  value       = aws_iam_role.this
}

output "aws_iam_instance_profile" {
  description = "Created IAM instance profile"
  value       = aws_iam_instance_profile.this
}

output "api_user" {
  description = "admin api user details"
  value       = "${var.admin_api_user}/${var.admin_api_password}"
}