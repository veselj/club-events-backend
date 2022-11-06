data "aws_route53_zone" "janmancc" {
  name = "janman.cc"
  private_zone = false
}

resource "aws_route53_record" "dsc-events" {

  zone_id = data.aws_route53_zone.janmancc.zone_id
  name    = "dsc-events.janman.cc"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.club-events-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.club-events-distribution.hosted_zone_id
  }
}