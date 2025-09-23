output "web_acl_arn" {
    value = aws_wafv2_web_acl.WAF-ACL-tf.arn
}

output "waf_acl_name" {
  value = aws_wafv2_web_acl.WAF-ACL-tf.name
}

output "waf_acl_id" {
  value = aws_wafv2_web_acl.WAF-ACL-tf.id
}
