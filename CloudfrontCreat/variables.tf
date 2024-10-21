variable "aliases" {
  description = "List of aliases for the CloudFront distribution."
  type        = list(string)
}

variable "comment" {
  description = "Comment for the CloudFront distribution."
  type        = string
}

variable "enabled" {
  description = "Whether the CloudFront distribution is enabled."
  type        = bool
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled for the CloudFront distribution."
  type        = bool
}

variable "price_class" {
  description = "Price class for the CloudFront distribution."
  type        = string
}

variable "retain_on_delete" {
  description = "Whether to retain the CloudFront distribution on delete."
  type        = bool
}

variable "wait_for_deployment" {
  description = "Whether to wait for the CloudFront distribution deployment."
  type        = bool
}

variable "web_acl_id" {
  description = "The ID of the AWS WAF Web ACL to associate with the CloudFront distribution."
  type        = string
}

variable "logging_config" {
  description = "Logging configuration for the CloudFront distribution."
  type        = map(string)
}

variable "origin" {
  description = "Origin configuration for the CloudFront distribution."
  type        = map(any)
}

variable "default_cache_behavior" {
  description = "Default cache behavior configuration for the CloudFront distribution."
  type        = map(any)
}

variable "viewer_certificate" {
  description = "Viewer certificate configuration for the CloudFront distribution."
  type        = map(string)
}

variable "tags" {
  description = "Tags to assign to the CloudFront distribution."
  type        = map(string)
}
