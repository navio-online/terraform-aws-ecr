variable "name" {
  type = string
  description = "ECR repo name"  
}

variable "image_tag_mutability" {
  type = string
  description = "Image tag mutability: IMMUTABLE|MUTABLE"
  default = "MUTABLE"
}

variable "scan_on_push" {
  type = bool
  description = "Does image scan needed?"
  default = false
}

variable "lifecycle_rules" {
  type = list(string)
  description = "Lifecycle rules list"
  default = []
}

variable "admin_arns" {
  type = list(string)
  description = "ARNs with admin access"
}

variable "readwrite_arns" {
  type = list(string)
  description = "ARNs with R/W access"
}

variable "readonly_arns" {
  type = list(string)
  description = "ARNs with R/O access"
  default = []
}

variable "tags" {
  type = map
  description = "Tags"
  default = {}
}
