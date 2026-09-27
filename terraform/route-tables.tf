resource "aws_route_table" "public" {
  vpc_id = aws_vpc.travelmemory.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.travelmemory.id
  }

  tags = {
    Name = "travelmemory-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.travelmemory.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.travelmemory.id
  }

  tags = {
    Name = "travelmemory-private-route-table"
  }
}
