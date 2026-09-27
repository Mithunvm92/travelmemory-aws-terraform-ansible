output "web_server_public_ip" {
  description = "Public IP address of the TravelMemory web server"
  value       = aws_instance.web.public_ip
}

output "web_server_public_dns" {
  description = "Public DNS name of the TravelMemory web server"
  value       = aws_instance.web.public_dns
}

output "web_server_private_ip" {
  description = "Private IP address of the TravelMemory web server"
  value       = aws_instance.web.private_ip
}

output "database_private_ip" {
  description = "Private IP address of the MongoDB server"
  value       = aws_instance.database.private_ip
}

output "web_instance_id" {
  description = "Web EC2 instance ID"
  value       = aws_instance.web.id
}

output "database_instance_id" {
  description = "Database EC2 instance ID"
  value       = aws_instance.database.id
}
