resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags       = merge(var.tags, { Name = var.env})
}

# This subnet block need to nbe improvement in code dry concept
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  tags              = merge(var.tags, { Name = "public_subnet"})
  availability_zone = var.azs[count.index]
}

resource "aws_subnet" "web" {
  count             = length(var.web_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnets[count.index]
  tags              = merge(var.tags, { Name = "web_subnet"})
  availability_zone = var.azs[count.index]
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnets[count.index]
  tags              = merge(var.tags, { Name = "app_subnet"})
  availability_zone = var.azs[count.index]
}


resource "aws_subnet" "db" {
  count             = length(var.db_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets[count.index]
  tags              = merge(var.tags, { Name = "db_subnet"})
  availability_zone = var.azs[count.index]
}


# step 3. creating 4 route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "public"})

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "web"})

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }
}


resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "app"})

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "db" })

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  route {
    cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }
}



#step 4. Associating route tables with subnets
resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)
    subnet_id      = aws_subnet.public.*.id[count.index]
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "web" {
  count = length(aws_subnet.web)
  subnet_id      = aws_subnet.web.*.id[count.index]
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "db" {
  count = length(aws_subnet.db)
  subnet_id      = aws_subnet.db.*.id[count.index]
  route_table_id = aws_route_table.db.id
}

resource "aws_route_table_association" "app" {
  count = length(aws_subnet.app)
  subnet_id      = aws_subnet.app.*.id[count.index]
  route_table_id = aws_route_table.app.id
}

# creating internet_gate_way and attach it to public subnet
# for attaching see public route table code--->the route block
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "igw" })
}

#creating NAT gateway and attach it to public subnet
# here we need one IP to reserve, that is elastic_ip
# Associate NGW to 3 private subnet route tables--->route block in we,app,db route tables code
resource "aws_eip" "ngw" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public.*.id[0]
}

# 8. create peering connection, here peer_owner_id is our account id
# copy account id of aws and send it using variables
# provide default vpc id also using variables

resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = var.account_id
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept = true
  tags = merge(var.tags, { Name = "peer-for-${var.env}-vpc-to-default-vpc"})
}

#9. update both route tables with peering connection

# add route to default vpc
resource "aws_route" "default-vpc-peer-route" {
  route_table_id            = var.default_route_table_id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}