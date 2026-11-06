output "primary_vpc_id" {
  value = aws_vpc.primary.id 
}

output "secondary_vpc_id" {
  value = aws_vpc.secondary.id
}

output "security_vpc_id" {
  value = aws_vpc.security.id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}

output "primary_instance_public_ip" {
  value = aws_instance.primary.public_ip
}

output "secondary_instance_public_ip" {
  value = aws_instance.secondary.public_ip
}

output "security_instance_public_ip" {
  value = aws_instance.secuirity.public_ip
}

output "primary_instance_private_ip" {
  value = aws_instance.primary.private_ip
}

output "secondary_instance_private_ip" {
  value = aws_instance.secondary.private_ip
}

output "security_instance_private_ip" {
  value = aws_instance.secuirity.private_ip
}

output "primary_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.primary.id
}

output "secondary_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.secondary.id
}

output "security_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.security.id
}
