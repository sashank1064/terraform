resource "aws_instance" "roboshop" {
  count = 4
  ami           = var.ami_id
  instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
  vpc_security_group_ids = [ aws_security_group.allow_all.id ]

  tags = merge(
    var.common_tags,
    { 
      component = var.instances[count.index] 
      name    = var.instances[count.index]
      }
  )   
  
}

resource "aws_security_group" "allow_all" {
  name        = var.sg_name
  description = var.sg_description

  ingress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }

  tags = merge(
    var.common_tags,
    {
      Name = "allow-all"
    }
  )
}