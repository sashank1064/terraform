resource "aws_instance" "roboshop" {
  count = length(var.instances)
  ami           = var.ami_id
  instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
  vpc_security_group_ids = [ aws_security_group.allow_all.id ]

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip} >> inventory"
    on_failure = continue
  }


  provisioner "local-exec" {
    command = "echo The server is destroyed"
    when = destroy
  }
   
   connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo dnf install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
    ]
  }
  provisioner "remote-exec" {
    when   = destroy
    inline = [
      "sudo systemctl stop nginx",
    ]
  }
  
  tags = {
    Name = var.instances[count.index]
  }
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

  tags = var.sg_tags
}