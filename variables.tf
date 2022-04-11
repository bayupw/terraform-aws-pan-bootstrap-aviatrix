# Boolean to determine if name will be appended with random string
variable "random_suffix" {
  description = "Set to true to append random suffix"
  type        = bool
  default     = true
}

# Length of random string to be appended to the name
variable "random_string_length" {
  description = "Random string length"
  type        = number
  default     = 3
}

# IAM Role name
variable "aws_iam_role" {
  description = "Bootstrap IAM role name"
  type        = string
  default     = "bootstrap-VM-S3-role"
}

# IAM Policy name
variable "aws_iam_policy" {
  description = "Bootstrap IAM policy"
  type        = string
  default     = "bootstrap-VM-S3-policy"
}

# S3 bucket name
variable "bootstrap_bucket" {
  type        = string
  default     = "pan-bootstrap-bucket"
  description = "Bootstrap S3 bucket name"
}

# PAN OS config version for bootstrap.xml
variable "config_version" {
  type        = string
  default     = "10.1.0"
  description = "Config version"
}

# PAN OS detail version for bootstrap.xml
variable "detail_version" {
  type        = string
  default     = "10.1.3"
  description = "Detail version"
}

# PAN OS config version for bootstrap.xml
variable "admin_user" {
  type        = string
  default     = "admin"
  description = "VM-Series admin username"
}

# admin phash for bootstrap.xml | default = Aviatrix123# 
variable "admin_password_phash" {
  type        = string
  default     = "$5$rpbkrfyo$AuahwOgZREF65jNMQpkFW.fFHX0RGbOhLLGsdY7nL/."
  description = "VM-Series admin password phash"
}

# admin public-key for bootstrap.xml
variable "admin_public_key" {
  type        = string
  default     = "c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCQVFDZzkrT293MlpUVkcxaW01RjBwbE83aFVETlZnRVNZOFNBMThEOUVxWVR1Q3ZobGs3eVIwenBjTEJMNGVmMU02dDJubDZ5SWp0VytlZFhqV0VvTFA3SjRTbHljbjF6RWNBQm93TWVVM00yMFBOTFFMUWdKTlI2QnNsSTBpc1B5U1Yrc092amVYWjlGVFZKMTZrUXhNZjdPTUkzT1ozellNOEsvd0VVcDg5SmFjZmdBMTZHZHN2SWo2dy9lUzZLaVZQbVRWWlNTZmVOendMRGluNDRVbElvcUx5ZkVqS0NQcTUzb0prcyttVSt4eVhsbk9XZVN2Y2FiZ0U1WUJtVy9oamU1QTFOc29WL2s0ellzMzlROXNiODJ0TjhXSkJYN014bWpzUitYMFNaeU8vRWNtNmk1amxpSHB0c256MTRWcDVmTmFXZDJQVUYzNmxlOFdQSStWcXQgdnBjLTBmNjYxYTYyZjgxODEzMzM5X2Z3LWluc3RhbmNlLTE="
  description = "VM-Series admin public-key"
}

# admin API username for bootstrap.xml | default = admin-api
variable "admin_api_user" {
  type        = string
  default     = "admin-api"
  description = "VM-Series admin API username"
}

# admin API profile name for bootstrap.xml
variable "admin_api_profile_name" {
  type        = string
  default     = "Aviatrix-API-Role"
  description = "VM-Series admin API profile name"
}

# admin API password for bootstrap.xml | default = Aviatrix123#
variable "admin_api_password" {
  type        = string
  default     = "Aviatrix123#"
  description = "VM-Series admin API password cleartext"
}

# admin API phash for bootstrap.xml | default = Aviatrix123#
variable "admin_api_password_phash" {
  type        = string
  default     = "$5$wvkrarwn$ySGHsUWRFrKJ6v3nw21sJ842cBkC9CU3k04adOmaY90"
  description = "VM-Series admin API password phash"
}

# If var.random_suffix = true, append with random string to avoid duplication
locals {
  bootstrap_bucket = var.random_suffix ? "${var.bootstrap_bucket}-${random_string.this[0].id}" : var.bootstrap_bucket
  aws_iam_role     = var.random_suffix ? "${var.aws_iam_role}-${random_string.this[0].id}" : var.aws_iam_role
  aws_iam_policy   = var.random_suffix ? "${var.aws_iam_policy}-${random_string.this[0].id}" : var.aws_iam_policy

  bootstrap_folders = toset([
    "config/",
    "content/",
    "license/",
    "software/"
  ])
}