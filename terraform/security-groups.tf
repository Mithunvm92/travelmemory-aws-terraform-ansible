resource "aws_security_group" "web" {
  name        = "travelmemory-web-sg"
  description = "Security group for TravelMemory web server"
  vpc_id      = aws_vpc.travelmemory.id

  ingress {
    description = "SSH from administrator IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "travelmemory-web-sg"
  }
}


resource "aws_security_group" "database" {
  name        = "travelmemory-database-sg"
  description = "Security group for TravelMemory MongoDB server"
  vpc_id      = aws_vpc.travelmemory.id

  ingress {
    description     = "SSH from web server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  ingress {
    description     = "MongoDB from web server"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "travelmemory-database-sg"
  }
}
