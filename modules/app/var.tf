variable "env" {}
variable "tags" {}
variable "component" {}
variable "instance_type" {}
variable "instance_count" {}
variable "subnets" {}
variable "vpc_id" {}
variable "app_port" {}
variable "sg_cidrs" {}

backend ={
    app_port=8080
    instance_count = 1
    instance_type = "t3.micro"
}