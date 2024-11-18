resource "aws_security_group" "node_sg" {
  name        = "week9_node_security"
  vpc_id      = "vpc-0dec0ac0d693b26e7"

  tags = {
    Name = "week9_node_security"
  }
  ingress {
    from_port = 22
    to_port = 22
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

resource "aws_instance" "node1" {
    ami  = "ami-0b4c7755cdf0d9219"
    instance_type = "t2.micro"
    key_name ="hello123"

    security_groups =  [aws_security_group.node_sg.name]

    tags = {
        Name  = var.node1
    }
  
}

resource "aws_instance" "node2" {
    ami  = "ami-0b4c7755cdf0d9219"
    instance_type = "t2.micro"
    key_name ="hello123"

    tags = {
        Name  = var.node2
    }
 
}
variable "node1" {}
variable "node2" {}
