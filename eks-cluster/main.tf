locals {
  cluster_name = "dev-eks-test"
  CA_CERTIFICATE_DIRECTORY="/etc/kubernetes/pki"
  CA_CERTIFICATE_FILE_PATH="${local.CA_CERTIFICATE_DIRECTORY}/ca.crt"
 
}
resource "aws_security_group" "eks-sg" {
    name        = "${var.environment} eks cluster"
    description = "Allow traffic"
    vpc_id      = var.vpc_id

    ingress {
      description      = "World"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags = merge({
      Name = "EKS ${var.environment}",
      "kubernetes.io/cluster/${local.cluster_name}": "owned"
    })
  }

  provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  #cluster_ca_certificate = base64decode(local.CA_CERTIFICATE_FILE_PATH)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    vpc_security_group_ids = [aws_security_group.eks-sg.id]
    disk_size              = 50

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

# module "lb_role" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name = "${var.environment}_eks_lb"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(local.CA_CERTIFICATE_FILE_PATH)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
      command     = "aws"
    }
  }
}

# resource "kubernetes_service_account" "service-account" {
#   metadata {
#     name = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     labels = {
#         "app.kubernetes.io/name"= "aws-load-balancer-controller"
#         "app.kubernetes.io/component"= "controller"
#     }
#     annotations = {
#       "eks.amazonaws.com/role-arn" = module.lb_role.iam_role_arn
#       "eks.amazonaws.com/sts-regional-endpoints" = "true"
#     }
#   }
# }

# resource "helm_release" "lb" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   depends_on = [
#     kubernetes_service_account.service-account
#   ]

#   set {
#     name  = "region"
#     value = "ap-southeast-1"
#   }

#   set {
#     name  = "vpcId"
#     value = var.vpc_id
#   }

#   set {
#     name  = "image.repository"
#     value = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com"
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "clusterName"
#     value = var.eks_name
#   }
# }


# resource "aws_ecr_repository" "vasuki-dev-test" {
#   name = "vasuki-dev-test"
# }