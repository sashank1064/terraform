resource "aws_instance" "roboshop" {
  #for_each = var.instances
  for_each = toset(var.instances)
  ami      = var.ami_id
  #instance_type = each.value
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = each.key
  }
}

resource "aws_security_group" "allow_all" {
  name        = var.sg_name
  description = var.sg_description

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = "-1"
      cidr_blocks = var.cidr_blocks
    }
  }

  egress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }

  tags = var.sg_tags
}