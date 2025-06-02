module "ec2" {
  for_each = var.db_instances
  source = "./modules/ec2"
  ami_id = each.value["ami_id"]
  env = var.env
  instance_type = each.value["instance_type"]
  name = each.key
  vpc_security_group_ids = var.vpc_security_group_ids
  zone_id = var.zone_id
  vault_token = var.vault_token
  ansible_role = lookup(each.value, "ansible_role", each.key)
  root_volume_size = each.value["root_volume_size"]
  subnet_ids = module.vpc["main"].subnets["db"]
  vpc_id =  module.vpc["main"].vpc["id"]
}


module "eks" {
  for_each = var.eks
  source = "./modules/eks"
  env = var.env
  eks_version = each.value["eks_version"]
  subnets = each.value["subnets"]
  node_groups = each.value["node_groups"]
  addons      = each.value["addons"]
  access      = each.value["access"]
}

module "vpc" {
  for_each = var.vpc
  source = "./modules/vpc"
  vpc_cidr = each.value["cidr"]
  name     = each.key
  env      = var.env
  subnets  = each.value["subnets"]
  default_vpc = var.default_vpc

}

output "vpc" {
  value = module.vpc
}