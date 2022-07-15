output "vpc_id"{
value=aws_vpc.vpc_demo
}
output "private_subnet_1"{
value=aws_subnet.private_1
}
output "private_subnet_2"{
value=aws_subnet.private_2
}
output "public_subnet_1"{
value=aws_subnet.public_1
}
output "public_subnet_2"{
value=aws_subnet.public_2
}
output "public_subnets"{
value=["aws_subnet.public_1", "aws_subnet.public-2"]
}
output "private_subnets"{
value=["aws_subnet.private_1","aws_subnet.private_2"]
}

output "db_instance"{
value=aws_db_instance.default
sensitive=true
}
output "arn" {
    value = aws_elasticsearch_domain.es.arn
} 
output "domain_id" {
    value = aws_elasticsearch_domain.es.domain_id
} 
output "domain_name" {
    value = aws_elasticsearch_domain.es.domain_name
} 
output "endpoint" {
    value = aws_elasticsearch_domain.es.endpoint
} 
output "kibana_endpoint" {
    value = aws_elasticsearch_domain.es.kibana_endpoint
}
