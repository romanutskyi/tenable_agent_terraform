resource "aws_vpc" "tenable_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "first"
  }
}

resource "aws_subnet" "cia" {
  vpc_id                  = aws_vpc.tenable_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

/*resource "aws_subnet" "fbr" {
  vpc_id            = aws_vpc.tenable_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "kgb" {
  vpc_id            = aws_vpc.tenable_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
}*/

resource "aws_internet_gateway" "tenable_igw" {
  vpc_id = aws_vpc.tenable_vpc.id

  tags = {
    Name = "tenable-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.tenable_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tenable_igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.cia.id
  route_table_id = aws_route_table.public_route_table.id
}

