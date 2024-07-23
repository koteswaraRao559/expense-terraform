vpc_cidr_block = "10.10.0.0/16"
env            = "dev"
tags = {
  company = "XYZ Co"
  bu_unit = "Finance"
  project_name = "expense"
}

public_subnets = ["10.10.0.0/24","10.10.1.0/24"]
web_subnets    = ["10.10.2.0/24","10.10.3.0/24"]
app_subnets    = ["10.10.4.0/24","10.10.5.0/24"]
db_subnets     = ["10.10.6.0/24","10.10.7.0/24"]
azs            =["us-east-1a","us-east-1b"]
account_id = "637423496087"
default_vpc_id = "vpc-0730c38cfa2b035db"
default_route_table_id ="rtb-05347e0a0a5281e73"
default_vpc_cidr = "172.31.0.0/16"

rds_allocated_storage = 20
rds_engine = "mysql"
rds_engine_version = "5.7.44"
rds_instance_class = "db.t3.micro"

backend ={
  app_port=8080
  instance_count = 1
  instance_type = "t3.micro"
}

frontend ={
  app_port=8080
  instance_count = 1
  instance_type = "t3.micro"
}
bastion_cidrs = ["172.31.88.70/32"]