#!/bin/bash

set -e

# Variables
# VERSION="1.9.1"
VERSION="1.11.1"
USER="node_exporter"
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/node_exporter.service"

echo "==> Installing Node Exporter v${VERSION}"

# Create user (no login)
if ! id -u $USER >/dev/null 2>&1; then
    sudo useradd --no-create-home --shell /bin/false $USER
fi

# Download
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz

# Extract
tar xvf node_exporter-${VERSION}.linux-amd64.tar.gz

# Install binary
sudo cp node_exporter-${VERSION}.linux-amd64/node_exporter $INSTALL_DIR/
sudo chown $USER:$USER $INSTALL_DIR/node_exporter
sudo chmod 755 $INSTALL_DIR/node_exporter

# Clean up
rm -rf node_exporter-${VERSION}.linux-amd64*

# Create systemd service
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=$USER
Group=$USER
Type=simple
ExecStart=$INSTALL_DIR/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# Enable & start service
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Status
echo "==> Node Exporter status:"
sudo systemctl status node_exporter --no-pager

echo "==> Done! Access metrics at: http://localhost:9100/metrics"
