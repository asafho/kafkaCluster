
resource "google_compute_instance" "kafka-node" {
  count        = var.node_count
  name         = "kafka-${var.cluster_name}-node${count.index}"
  machine_type = var.kafka_machine_type
  zone         = "${var.region}-${var.gcp_zones[count.index]}"
  project = var.project_id
  allow_stopping_for_update = true
  deletion_protection = true
  tags = [
    "kafka",
    "kafka-cluster",
    var.cluster_name
  ]

  labels = {
    name="kafka",
    cluster=var.cluster_name
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size = var.disk_size_gb
    }
  }

  // Local SSD disk
  #scratch_disk {
  #  interface = "SCSI"
#  }

  metadata = {
    status-config-url = "https://runtimeconfig.googleapis.com/v1beta1/projects/${var.project_id}/configs/kafka-${var.cluster_name}-config"
    status-variable-path = "status"
    status-uptime-deadline = 300
    google-logging-enable = 0
    google-monitoring-enable = 0
  }

  network_interface {
    network = var.vpc_network.self_link
    subnetwork = var.vpc_subnetwork.self_link
  }
}

resource "null_resource" "deploy_kafka1" {
  triggers = {
      md5 = "${filemd5("${path.module}/main.tf")}"
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../ansible-kafka-cluster"
    environment = {
      host_path = "kafka_terrafom_${var.cluster_name}_host_file"
      node0 = google_compute_instance.kafka-node.0.network_interface.0.network_ip
      node1 = google_compute_instance.kafka-node.1.network_interface.0.network_ip
      node2 = google_compute_instance.kafka-node.2.network_interface.0.network_ip
    }
    command = <<EOT
    gcloud compute ssh kafka-${var.cluster_name}-node0 --project ${var.project_id} --internal-ip --force-key-file-overwrite -- 'ls'
    echo "[kafka_nodes]" > $host_path
    echo "$node0" >> $host_path
    echo "$node1" >> $host_path
    echo "$node2" >> $host_path
    ansible-playbook -i $host_path master.yml
  EOT
  }
}
