resource "aws_wafv2_rule_group" "TF-web-rule-group" {
  name     = "TF-web-rule-group"
  scope    = "CLOUDFRONT"
  capacity = 10

  rule {
    name     = "block-suspicious-requests"
    priority = 1

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = ["CN", "RU"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block-suspicious-requests"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "rate-limit-rule"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-rule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "TF-web-rule-group"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl" "WAF-ACL-tf" {
  name  = "waf-tf-web-acl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-tf-web-acl"
    sampled_requests_enabled   = true
  }

  lifecycle {
    ignore_changes = [rule]
  }
}

resource "aws_wafv2_web_acl_rule_group_association" "Cloudfront_tf_rule_group" {
  rule_name   = "Cloudfront_tf_rule_group"
  priority    = 100
  web_acl_arn = aws_wafv2_web_acl.WAF-ACL-tf.arn

  rule_group_reference {
    arn = aws_wafv2_rule_group.TF-web-rule-group.arn
  }
}