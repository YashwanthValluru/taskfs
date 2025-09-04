#!/bin/bash
set -eux

# Update and install wget, curl
yum update -y
yum install -y wget curl

# Download Thanos binary latest (replace with version as needed)
THANOS_VERSION="v0.24.0"
curl -LO https://github.com/thanos-io/thanos/releases/download/${THANOS_VERSION}/thanos-${THANOS_VERSION}.linux-amd64.tar.gz
tar xvf thanos-${THANOS_VERSION}.linux-amd64.tar.gz
mv thanos-${THANOS_VERSION}.linux-amd64/thanos /usr/local/bin/
chmod +x /usr/local/bin/thanos

# Run Thanos Query as a systemd service (adjust service file as needed)

cat <<EOF > /etc/systemd/system/thanos-query.service
[Unit]
Description=Thanos Query Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/thanos query \
  --http-address=0.0.0.0:9090 \
  --grpc-address=0.0.0.0:10901 \
  %{ for addr in store_grpc_addresses }
  --store=${addr} \
  %{ endfor }
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable thanos-query
systemctl start thanos-query
