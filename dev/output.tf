output "nginx" {
    value =aws_instance.node1.public_dns
}

output "python" {
    value =aws_instance.node2.public_dns
}