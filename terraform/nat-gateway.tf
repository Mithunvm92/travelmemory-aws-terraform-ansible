resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "travelmemory-nat-eip"
  }
}

resource "aws_nat_gateway" "travelmemory" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.travelmemory
  ]

  tags = {
    Name = "travelmemory-nat-gateway"
  }
}
