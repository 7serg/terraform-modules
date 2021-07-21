


# VPC Network
#----------------------------------------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-VPC"
  }

}

# Internet gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.env} - igw"
  }
}
#-------------------------------------------------------------------
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet ${var.env} ${count.index + 1}"
  }

}


resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id

  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }

  depends_on = [aws_internet_gateway.main]


}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
