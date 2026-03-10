
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"
  name = "hive-vpc"
  cidr = "10.0.0.0/16"
  azs  = var.azs
  public_subnets = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs
  enable_nat_gateway = true
  single_nat_gateway = true
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
resource "aws_ecr_repository" "hive_resource" {
  name                 = "hive_repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"
  name = var.cluster_name
  kubernetes_version = "1.30"
  vpc_id = module.vpc.vpc_id  
  subnet_ids = module.vpc.private_subnets
  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  eks_managed_node_groups = {
    hive_nodes = {
      desired_size = 1
      max_size   = 2
      min_size   = 1
      instance_types   = ["t3.medium"]
      disk_size = 20
    }
  }
}
