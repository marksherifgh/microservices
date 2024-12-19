module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = var.vpc_tag_name
  cidr = var.vpc_cidr_block

  azs             = var.az
  private_subnets = [var.private_subnet_cidr_block_1, var.private_subnet_cidr_block_2]
  public_subnets  = [var.public_subnet_cidr_block_1, var.public_subnet_cidr_block_2]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = 1
  }
  tags = {
    "Name" = var.vpc_tag_name
  }
}

