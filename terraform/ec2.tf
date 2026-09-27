resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  key_name = "travelmemory-key.pem"

  iam_instance_profile = aws_iam_instance_profile.web.name

  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "travelmemory-web-server"
    Role = "WebServer"
  }
}


resource "aws_instance" "database" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.database.id]

  key_name = "travelmemory-key.pem"

  iam_instance_profile = aws_iam_instance_profile.database.name

  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "travelmemory-database-server"
    Role = "DatabaseServer"
  }
}

