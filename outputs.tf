output "lifecycle_policy" {
  value = data.template_file.lifecycle_policy.rendered
}

output "ecr_iam_policy" {
  value = data.aws_iam_policy_document.this.json
}