output "dev_vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "staging_vpc_id" {
  value = module.staging_vpc.vpc_id
}

output "dev_subnets" {
  value = module.dev_vpc.public_subnet_ids
}

output "staging_subnets" {
  value = module.staging_vpc.public_subnet_ids
}