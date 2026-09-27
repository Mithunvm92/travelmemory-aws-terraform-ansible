data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.travelmemory.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "travelmemory-public-subnet"
    Tier = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.travelmemory.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "travelmemory-private-subnet"
    Tier = "Private"
  }
}
