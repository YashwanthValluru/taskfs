#!/bin/bash
set -eux

# Update and install required tools
yum update -y
yum install -y wget curl

# Install Docker (to use Helm)
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add Prometheus community Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create directories for Prometheus data
mkdir -p /prometheus/data

# Create Thanos object storage YAML config
cat <<EOF > /prometheus/objstore.yml
type: s3
config:
  bucket: "${s3_bucket_name}"
  region: "${s3_bucket_region}"
  insecure: false
EOF

# Deploy Node Exporter via Helm
helm upgrade --install node-exporter prometheus-community/prometheus-node-exporter --namespace default --create-namespace

# Deploy Prometheus with Helm depending on role
if [ "${prometheus_role}" == "slave" ]; then
  helm upgrade --install prometheus prometheus-community/prometheus \
    --set server.persistentVolume.enabled=false \
    --set server.global.externalLabels.cluster="slave-cluster" \
    --set server.scrapeInterval="15s" \
    --set server.scrapeTimeout="10s" \
    --set server.remoteWrite.enabled=false \
    --set server.federationScrape.enabled=false
elif [ "${prometheus_role}" == "master" ]; then
  # Configure federation for slaves in prometheus config (this is example, adjust accordingly)
  cat <<FEDERATE > /tmp/federation.yml
global:
  scrape_interval: 15s

scrape_configs:
- job_name: 'slave1'
  honor_labels: true
  metrics_path: /federate
  scrape_interval: 15s
  static_configs:
  - targets:
    - ${master_ip}:9090

- job_name: 'slave2'
  honor_labels: true
  metrics_path: /federate
  scrape_interval: 15s
  static_configs:
  - targets:
    - ${master_ip}:9090
FEDERATE

  helm upgrade --install prometheus prometheus-community/prometheus \
    --set server.persistentVolume.enabled=false \
    --set serverFiles.prometheus.yml=/tmp/federation.yml \
    --set server.global.externalLabels.cluster="master-cluster"

fi

# Deploy Thanos Sidecar using Helm
helm upgrade --install thanos prometheus-community/thanos \
  --set sidecar.enabled=true \
  --set objstoreConfig=/prometheus/objstore.yml \
  --set sidecar.prometheus.url=http://localhost:9090 \
  --namespace default

# Enable and start Docker container services if applicable
systemctl enable docker
systemctl start docker
