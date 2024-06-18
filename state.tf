terraform {
  backend "s3" {
    bucket = "d76-terraform-state"
    key    = "expense//terraform.tfstate"
    region = "us-east-1"
  }
}
