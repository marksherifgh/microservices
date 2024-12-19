module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
  subnet_ids      = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  eks_managed_node_groups = {
    public_nodes = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_types = ["t3.medium"]

      labels = {
        role = "general"
      }

      tags = {
        "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
      }

      additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      ]
    }
  }

  tags = {
    "Name" = var.eks_cluster_name
  }
}
