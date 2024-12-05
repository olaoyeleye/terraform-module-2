output "nginx" {
    value =aws_instance.node1.public_dns
}
output "nginx-private" {
    value =aws_instance.node1.private_dns
}

output "python-1" {
    value =aws_instance.node2.public_dns
}
output "python-2" {
    value =aws_instance.node3.public_dns
}