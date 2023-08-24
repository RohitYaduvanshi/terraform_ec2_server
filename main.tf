provider "aws" {
  region = "ap-southeast-2"
}
resource "aws_vpc" "op" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    name = "oop"
  }
}
resource "aws_subnet" "sb" {
  vpc_id     = aws_vpc.op.id
  cidr_block = "10.10.0.0/24"

  tags = {
    Name = "yadav"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.op.id

  tags = {
    Name = "ro"
  }
}
resource "aws_route_table" "rut" {
  vpc_id = aws_vpc.op.id


 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }

  tags = {
    Name = "route"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sb.id
  route_table_id = aws_route_table.rut.id
}
resource "aws_security_group" "ysec" {
  name        = "ysec"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.op.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ytls"
  }
}
resource "aws_key_pair" "yykey" {
  key_name   = "yykey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhTkshUzCy/Ee8qc6RNYFtfce2kixxJKb5/GQWOGRlm/yWxTBCT/ON0gdpxGm17vq9rRBipJB2ngaA4mug9WcBTdHw/VruKCGcQ9PUXYo3f5w1RFsqutMysDERfNZAna1boHfi1HjaeTp5x1zuEKFqP5cO2Wwl6L59+hwVaONoy5pP4tuSDNMlKwftPvX+mfRLV6zlxB1rhtyHAmC1y047VjBYsxZdapUy0oGE2phPY2kwuJkKqGfzgaExKbWaxIGZt1cTC5MwM03QCjD0vsmhEmVihsRtg5TAQjwbw7UG2gugM+jCgFWhgJphEaluUpZXJvSGlSUWmuhMuqWxGx1xKEVGRZkPPnHAziF9bRxs38fQcWDbR0Cfexieh/dg3ZYSSs5+stLJANuo+HQimsyIv1wWFlu06HVz2Nn6myE35G/d/2g0p47s+C6tyvuXNCaon+fsoOK4rd4ofNUSQr1KrPnBlswrgOws3HkRj49+5o1kjKPR/YobKAuCoimwBbU= rohit@rohit"
}
resource "aws_instance" "opo" {
  ami           = "ami-0310483fb2b488153"
  instance_type = "t2.micro"
  key_name = aws_key_pair.yykey.key_name
  subnet_id = aws_subnet.sb.id
 associate_public_ip_address = true
  security_groups  = aws_security_group.ysec[*].id

  tags = {
    Name = "yadav"
  }
}
