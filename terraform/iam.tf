resource "aws_iam_role" "web" {
  name = "travelmemory-web-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "travelmemory-web-ec2-role"
  }
}


resource "aws_iam_role" "database" {
  name = "travelmemory-database-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "travelmemory-database-ec2-role"
  }
}


resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy_attachment" "database_ssm" {
  role       = aws_iam_role.database.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "web" {
  name = "travelmemory-web-instance-profile"
  role = aws_iam_role.web.name
}


resource "aws_iam_instance_profile" "database" {
  name = "travelmemory-database-instance-profile"
  role = aws_iam_role.database.name
}
