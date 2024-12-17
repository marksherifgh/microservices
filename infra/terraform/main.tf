provider "aws" {
  region = "eu-west-1"
}
terraform {
  backend "s3" {
    bucket         = "microservice-tf-state"
    key            = "eks/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "eks_sg" {
  name        = "eks_sg"
  description = "EKS Security Group"
  vpc_id      = aws_vpc.main.id
}

resource "aws_eks_cluster" "eks" {
  name     = "microservice-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy_attachment]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}