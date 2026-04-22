module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "10.0.0.0/16"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  public_subnet_id = module.subnet.public_subnet_id
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source            = "./modules/route_table"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.internet_gateway.igw_id
  nat_gateway_id    = module.nat_gateway.nat_gateway_id
  public_subnet_id  = module.subnet.public_subnet_id
  private_subnet_id = module.subnet.private_subnet_id
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.subnet.public_subnet_id
  security_group_id = module.security_group.security_group_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  public_key        = var.public_key
}
