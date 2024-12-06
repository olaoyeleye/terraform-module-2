resource "aws_security_group" "week10_nginx_node_sg" {
  name        = "week10_nginx_security"
  vpc_id      = "vpc-0e26d767ace1ef817"

  tags = {
    Name = "week10_nginx_node_sg"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "week10_python_node_sg" {
  name        = "week10_python_security"
  vpc_id      = "vpc-0e26d767ace1ef817"

  tags = {
    Name = "week10_python_node_sg"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  ingress {
    from_port = 65432
    to_port = 65432
    protocol = "tcp" 
    cidr_blocks =  ["${aws_instance.node1.public_ip}/32", "${aws_instance.node1.public_ip}/32"] 
    #cidr_blocks =  ["${aws_instance.node1.private_ip}/32"]  #["0.0.0.0/0"]
  }
  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  depends_on = [aws_security_group.week10_nginx_node_sg]
}

resource "aws_instance" "node1" {
    ami  = "ami-0b4c7755cdf0d9219"
    instance_type = "t2.micro"
    key_name ="kensko-2"

    security_groups =  [aws_security_group.week10_nginx_node_sg.name]

    tags = {
        Name  = var.node1
    }
    depends_on = [aws_security_group.week10_nginx_node_sg]
}

resource "aws_instance" "node2" {
    ami  = "ami-0b4c7755cdf0d9219"
    instance_type = "t2.micro"
    key_name ="kensko-2"
    security_groups =  [aws_security_group.week10_python_node_sg.name]
    tags = {
        Name  = var.node2
    }
    depends_on = [aws_security_group.week10_nginx_node_sg]
}
resource "aws_instance" "node3" {
    ami  = "ami-0b4c7755cdf0d9219"
    instance_type = "t2.micro"
    key_name ="kensko-2"
    security_groups =  [aws_security_group.week10_python_node_sg.name]
    tags = {
        Name  = var.node3
    }
    depends_on = [aws_security_group.week10_nginx_node_sg]
}
variable "node1" {}
variable "node2" {}
variable "node3" {}