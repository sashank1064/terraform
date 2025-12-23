variable "Project" {

    default = "Roboshop"
  
}

variable "component" {

    default = "Cart"
}

variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    default = {
    Project = "Roboshop"
    terraform = "true"
    }
}
  