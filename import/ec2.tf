resource "aws_instance" "linux" {   #Process to import manually created resources to .tf &  state files
                                    # linux is the name of the ec2 instance created manually in AWS
                                    # this resource has to be written empty with no arguments to import into the state file 
ami = "ami-000000000"
instance_type = "t3.micro"
vpc_security_group_ids = ["sg-000000000"]
user_data_replace_on_change = null
tags = {
  Name ="linux"                    # write arguments after doing terraform import, by seeing the state file & do terraform plan & apply
  }                              # Then we can use like normal terraform usage as the resource is created from terraform
}