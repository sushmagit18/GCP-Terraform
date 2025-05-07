resource "google_sql_database_instance" "db" {
  name             = var.db_instance_name
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "db_user" {
  instance = google_sql_database_instance.db.name
  name     = var.db_user
  password = var.db_password
}