module "dns" {
  source = "./modules/dns"
}

module "sql" {
  source           = "./modules/sql"
  region           = var.region
  db_instance_name = var.db_instance_name
  db_user          = var.db_user
  db_password      = var.db_password
}





module "backend" {
  source = "./modules/backend"
  zone   = var.zone
}

module "lb" {
  source             = "./modules/lb"
  instance_group     = module.backend.instance_group
  health_check_port  = 80
}