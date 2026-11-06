# Primary Subnet
resource "aws_subnet" "primary" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Primary-Public-Subnet"
  }
}

# Secondary Subnet
resource "aws_subnet" "secondary" {
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Secondary-Public-Subnet"
  }
}

resource "aws_subnet" "security" {
  vpc_id = aws_vpc.security.id
  cidr_block = "10.2.1.0/24"
  availability_zone = "${var.aws_region}c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Security-Private-Subnet"
  }
}

# Primary Internet Gateway
resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "Primary-IGW"
  }
}

# Secondary Internet Gateway
resource "aws_internet_gateway" "secondary" {
  vpc_id = aws_vpc.secondary.id

  tags = {
    Name = "Secondary-IGW"
  }
}

# Primary Route Table
resource "aws_route_table" "primary" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }

  tags = {
    Name = "Primary-Route-Table"
  }
}

# Secondary Route Table
resource "aws_route_table" "secondary" {
  vpc_id = aws_vpc.secondary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary.id
  }

  tags = {
    Name = "Secondary-Route-Table"
  }
}

# Secondary Route Table
resource "aws_route_table" "security" {
  vpc_id = aws_vpc.security.id

  tags = {
    Name = "security-Route-Table"
  }
}

# Primary Subnet Association
resource "aws_route_table_association" "primary" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.primary.id
}

# Secondary Subnet Association
resource "aws_route_table_association" "secondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.secondary.id
}

# Security Subnet Association
resource "aws_route_table_association" "security" {
  subnet_id      = aws_subnet.security.id
  route_table_id = aws_route_table.security.id
}

# Primary VPC -> Secondary and Security VPC
resource "aws_route" "primary_to_secondary" {
  route_table_id = aws_route_table.primary.id
  destination_cidr_block = "10.1.0.0/16"
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "primary_to_security" {
  route_table_id         = aws_route_table.primary.id
  destination_cidr_block = "10.2.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}

# Secondary VPC -> Primary and Security VPC
resource "aws_route" "secondary_to_primary" {
  route_table_id         = aws_route_table.secondary.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "secondary_to_security" {
  route_table_id         = aws_route_table.secondary.id
  destination_cidr_block = "10.2.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}

# Security VPC -> Primary and Secondary VPC
resource "aws_route" "security_to_primary" {
  route_table_id         = aws_route_table.security.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "security_to_secondary" {
  route_table_id         = aws_route_table.security.id
  destination_cidr_block = "10.1.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}






