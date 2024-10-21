module "cdn" {
  source = "https://github.com/nishuri/TF-Modules/blob/main/CloudFront"

  aliases             = var.aliases
  comment             = var.comment
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id

  logging_config = var.logging_config

  origin = var.origin

  default_cache_behavior = var.default_cache_behavior

  viewer_certificate = var.viewer_certificate

  tags = var.tags
}
