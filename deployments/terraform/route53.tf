data "aws_route53_zone" "janmancc" {
  name = "janman.cc"
  private_zone = false
}

resource "aws_route53_record" "dsc-events" {
  zone_id = data.aws_route53_zone.janmancc.zone_id
  name    = "dsc-events.janman.cc"
  records = ["blog.janman.cc"]
  type    = "CNAME"
  ttl     = 300
}