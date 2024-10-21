# AWS CloudFront Terraform module

Terraform module which creates AWS CloudFront resources with all (or almost all) features provided by Terraform AWS provider.

## Usage

### CloudFront distribution with versioning enabled

```hcl
module "cdn" {
  source = "nishuri/cloudfront"

  aliases = ["cdn.example.com" , "anothercdn.example.com"]

  comment             = "My cloudfrount project"
  enabled             = true
  is_ipv6_enabled     = false
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  web_acl_id          = aws_wafv2_web_acl.example.arn


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

  default_cache_behavior = {
    target_origin_id       = "something"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = 3600
    max_ttl         = 86400
    min_ttl         = 0
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "216a2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:135367859851:certificate/1032b155-22da-4ae0-9f69-e206f825458b"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Environment = "Production"
    Project     = "MyProject"
    Owner       = "YourName"
  }
}
```
## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_monitoring_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_monitoring_subscription) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Any comments you want to include about the distribution. | `string` | `null` | no |
| <a name="input_create_distribution"></a> [create\_distribution](#input\_create\_distribution) | Controls if CloudFront distribution should be created | `bool` | `true` | no |
| <a name="input_create_monitoring_subscription"></a> [create\_monitoring\_subscription](#input\_create\_monitoring\_subscription) | If enabled, the resource for monitoring subscription will created. | `bool` | `false` | no |
| <a name="input_create_origin_access_identity"></a> [create\_origin\_access\_identity](#input\_create\_origin\_access\_identity) | Controls if CloudFront origin access identity should be created | `bool` | `false` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | One or more custom error response elements | `any` | `{}` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | The default cache behavior for this distribution | `any` | `null` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |
| <a name="input_geo_restriction"></a> [geo\_restriction](#input\_geo\_restriction) | The restriction configuration for this distribution (geo\_restrictions) | `any` | `{}` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2. | `string` | `"http2"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Whether the IPv6 is enabled for the distribution. | `bool` | `null` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | The logging configuration that controls how logs are written to your distribution (maximum one). | `any` | `{}` | no |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0. | `any` | `[]` | no |
| <a name="input_origin"></a> [origin](#input\_origin) | One or more origins for this distribution (multiples allowed). | `any` | `null` | no |
| <a name="input_origin_access_identities"></a> [origin\_access\_identities](#input\_origin\_access\_identities) | Map of CloudFront origin access identities (value as a comment) | `map(string)` | `{}` | no |
| <a name="input_origin_group"></a> [origin\_group](#input\_origin\_group) | One or more origin\_group for this distribution (multiples allowed). | `any` | `{}` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100 | `string` | `null` | no |
| <a name="input_realtime_metrics_subscription_status"></a> [realtime\_metrics\_subscription\_status](#input\_realtime\_metrics\_subscription\_status) | A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled`. | `string` | `"Enabled"` | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution | `any` | <pre>{<br>  "cloudfront_default_certificate": true,<br>  "minimum_protocol_version": "TLSv1"<br>}</pre> | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. | `bool` | `true` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL. | `string` | `null` | no |

