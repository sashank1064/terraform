variable "ami_id" {
  type        = string
  description = "joindevops default AMI ID RHEL9"
  default     = "ami-09c813fb71547fc4f"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ec2_tags" {
  type = map(string)  
  default = {
    Name = "Roboshop"
    Purpose = "variables-demo"
  }

}

variable "sg_name" {
   default = "vars-file-allow-all"
}

variable "sg_description" {
    default = "allowing all ports from internet"
}

variable "from_port" {
    default = 0
}

variable "to_port" {
    type = number
    default = 0
}

variable "cidr_blocks" {
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "sg_tags" {
    default = {
        Name = "allow-all"
    }
}

variable "environment" {
    default = "dev"
  
}

variable "instances" {
    default = ["mongodb","redis","mysql","rabbitmq"]
    #{
    #     mongodb = "t3.micro"
    #     mysql = "t2.small"
    #     rabbitmq = "t3.micro"
    #     redis = "t3.micro"
    
   # }
  
}

variable "zone_id" {
    default = "Z05717891IWFXUBM74UFS"
  
}

variable "domain_name" {
    default = "daws84s.pro"
  
}