# Khai báo xác thực, provider
# https://registry.terraform.io/providers/hashicorp/aws/latest
terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "4.20.1"

	}
	}
}



provider "aws" {
	region = "ap-southeast-1" # Singapore region
}

# tạo vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
	cidr_block = "10.9.0.0/16"
	tags = {
		Name = "devops-techmaster-05-vpc-ngocnct"
	}
}

#tạo public subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "public_a" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.9.1.0/24"
	availability_zone = "ap-southeast-1a"
	map_public_ip_on_launch  = true
	tags = {
		Name = "public-subnet-a"
	}
}

# tạo internet gateway cho public subnet

resource "aws_internet_gateway" "ig" { 
	vpc_id = aws_vpc.main.id
	tags = {
		Name = "devops-techmaster-05-igw"
	}
}

# tạo public routing table cho public subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}

# tạo default route trỏ tới internet gateway cho public routing table

resource "aws_route"  "public_internet_gateway" {
	route_table_id = aws_route_table.public.id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.ig.id
}

# gán public subnet vào public routing table

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}