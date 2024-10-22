aliases = ["cdn.example.com", "anothercdn.example.com"]

comment = "My cloudfront project"
enabled = true
is_ipv6_enabled = false
price_class = "PriceClass_100"
retain_on_delete = false
wait_for_deployment = false
web_acl_id = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/example-web-acl/12345678-1234-1234-1234-123456789012"

logging_config = {
  bucket = "logs-my-cdn.s3.amazonaws.com"
}

origin = {
  something = {
    domain_name = "something.example.com"
    custom_origin_config = {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
}

default_cache_behavior = {
  target_origin_id       = "something"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  compress               = true
  default_ttl            = 3600
  max_ttl                = 86400
  min_ttl                = 0
  cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  origin_request_policy_id = "216a2d-6df8-44a3-9df3-4b5a84be39ad"
}

viewer_certificate = {
  acm_certificate_arn      = "arn:aws:acm:us-east-1:135367859851:certificate/1032b155-22da-4ae0-9f69-e206f825458b"
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
}

tags = {
  Environment = "Production"
  Project     = "MyProject"
  Owner       = "YourName"
}
