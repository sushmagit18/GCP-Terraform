resource "google_compute_http_health_check" "example_health_check" {
  name                = "example-health-check"
  request_path        = "/"
  port                = var.health_check_port
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

resource "google_compute_backend_service" "example_backend_service" {
  name     = "example-backend-service"
  protocol = "HTTP"

  backend {
    group = var.instance_group
  }

  health_checks = [google_compute_http_health_check.example_health_check.self_link]
}

resource "google_compute_url_map" "example_url_map" {
  name            = "example-url-map"
  default_service = google_compute_backend_service.example_backend_service.self_link
}

resource "google_compute_target_http_proxy" "example_http_proxy" {
  name    = "example-http-proxy"
  url_map = google_compute_url_map.example_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "example_forwarding_rule" {
  name        = "example-forwarding-rule"
  target      = google_compute_target_http_proxy.example_http_proxy.self_link
  port_range  = "80"
  ip_address  = var.global_ip
  ip_protocol = "TCP"
}