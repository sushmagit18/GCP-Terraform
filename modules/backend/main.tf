resource "google_compute_instance_template" "example_template" {
  name         = "example-template"
  machine_type = "f1-micro"
  tags         = ["apache-server"]

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    echo "Hello from $(hostname)" > /var/www/html/index.html
    sudo systemctl start apache2
  EOT
}

resource "google_compute_instance_group_manager" "example_igm" {
  name               = "example-igm"
  base_instance_name = "example"
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.example_template.self_link
  }

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }
}