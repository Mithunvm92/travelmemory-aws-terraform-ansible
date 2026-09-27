resource "aws_internet_gateway" "travelmemory" {
  vpc_id = aws_vpc.travelmemory.id

  tags = {
    Name = "travelmemory-igw"
  }
}
