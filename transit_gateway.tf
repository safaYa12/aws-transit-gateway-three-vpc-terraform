resource "aws_ec2_transit_gateway" "main" {
    description = "Central Transit Gateway for three VPCs"
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"

    dns_support = "enable"
    vpn_ecmp_support = "enable"

    tags = {
    Name        = "three-vpc-transit-gateway"
    Environment = "Development"
  }
}

resource "aws_ec2_transit_gateway_route_table" "main" {
    transit_gateway_id = aws_ec2_transit_gateway.main.id

    tags = {
    Name = "Main-TGW-Route-Table"
  }
}

# VPC-A attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "primary" {
    vpc_id = aws_vpc.primary.id
    subnet_ids = [aws_subnet.primary.id]
    transit_gateway_id = aws_ec2_transit_gateway.main.id

    tags = {
      Name = "Primary-VPC-Attachment"
    }
  
}

# VPC-B attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "secondary" {
    vpc_id = aws_vpc.secondary.id
    subnet_ids = [aws_subnet.secondary.id]
    transit_gateway_id = aws_ec2_transit_gateway.main.id

    tags = {
      Name = "Secondary-VPC-Attachment"
    } 
}

# VPC-C attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "security" {
    vpc_id = aws_vpc.security.id
    subnet_ids = [aws_subnet.security.id]
    transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_ec2_transit_gateway_route_table_association" "primary" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.primary.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
resource "aws_ec2_transit_gateway_route_table_association" "secondary" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.secondary.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
resource "aws_ec2_transit_gateway_route_table_association" "security" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.secondary.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

resource "aws_ec2_transit_gateway_route" "primary" {
    destination_cidr_block = "10.0.0.0/16"
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.primary.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
resource "aws_ec2_transit_gateway_route" "secondary" {
  destination_cidr_block         = "10.1.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.secondary.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}

resource "aws_ec2_transit_gateway_route" "security" {
  destination_cidr_block         = "10.2.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main.id
}
