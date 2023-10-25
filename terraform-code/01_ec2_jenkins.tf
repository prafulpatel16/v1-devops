provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "devops-server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  //security_groups = [ "demo-sg" ]
  vpc_security_group_ids = [aws_security_group.devops-sg.id]
  subnet_id              = aws_subnet.devops-pub-subnet-01.id
  for_each               = toset(["jenkins-master", "jenkins-slave", "ansible"])
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_security_group" "devops-sg" {
  name        = "jenkins-sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.devops-vpc.id

  ingress {
    description = "SHH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

resource "aws_vpc" "devops-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "devops-vpc"
  }

}

resource "aws_subnet" "devops-pub-subnet-01" {
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "devops-pub-subnet-01"
  }
}

resource "aws_subnet" "devops-pub-subnet-02" {
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "devops-pub-subent-02"
  }
}

resource "aws_internet_gateway" "devops-igw" {
  vpc_id = aws_vpc.devops-vpc.id
  tags = {
    Name = "dpp-igw"
  }
}

resource "aws_route_table" "devops-public-RT" {
  vpc_id = aws_vpc.devops-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-igw.id
  }
}

resource "aws_route_table_association" "devops-RT-public-subnet-01" {
  subnet_id      = aws_subnet.devops-pub-subnet-01.id
  route_table_id = aws_route_table.devops-public-RT.id
}

resource "aws_route_table_association" "devops-RT-public-subnet-02" {
  subnet_id      = aws_subnet.devops-pub-subnet-02.id
  route_table_id = aws_route_table.devops-public-RT.id
}