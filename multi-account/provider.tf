terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws" #if any other provider configure it here like azure
      version = "6.24.0"
    }
  }  # if wanted we can store the state file in S3 bucket, even though the resorces are in different accounts
  
}

provider "aws" {   #if azure dev or aws dev or gcp
  # Configuration options
  alias = "prod"
  profile = "prod"
}

provider "aws" { # If aws prod or azure prod or gcp
  alias = "dev"
  profile = "dev"
  
}