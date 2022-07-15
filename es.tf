resource "aws_elasticsearch_domain" "es" {
  domain_name           = "newdomain"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "r4.large.elasticsearch"
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
vpc_options{
subnet_ids = [aws_subnet.private_2.id]
  }
  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = "10"
  }
  tags = {
    Domain = "NEWDOMAIN"
  }
}

# Creating the AWS Elasticsearch domain policy

resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = aws_elasticsearch_domain.es.domain_name
  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.es.arn}/*"
        }
    ]
}
POLICIES
}
