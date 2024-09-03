#!/bin/bash

# Update System Packages
echo "Updating system packages..."
sudo apt update

# Create a System User for Prometheus
echo "Creating system user and group for Prometheus..."
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Create Directories for Prometheus
echo "Creating directories for Prometheus..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Download Prometheus and Extract Files
echo "Downloading Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz
echo "Extracting Prometheus files..."
tar vxf prometheus-2.43.0.linux-amd64.tar.gz

# Navigate to the Prometheus Directory
cd prometheus-2.43.0.linux-amd64 || { echo "Directory not found"; exit 1; }

# Move the Binary Files & Set Owner
echo "Moving binary files..."
sudo mv prometheus /usr/local/bin
sudo mv promtool /usr/local/bin
echo "Setting ownership of binary files..."
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Move the Configuration Files & Set Owner
echo "Moving configuration files..."
sudo mv consoles /etc/prometheus
sudo mv console_libraries /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
echo "Setting ownership of configuration files..."
sudo chown prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Inform user of completion
echo "Prometheus setup complete."

# Create a systemd service file
echo "Creating systemd service file..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file /etc/prometheus/prometheus.yml \\
    --storage.tsdb.path /var/lib/prometheus/ \\
    --web.console.templates=/etc/prometheus/consoles \\
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd, start and enable Prometheus service
echo "Reloading systemd and starting Prometheus service..."
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Check the status of Prometheus service
sudo systemctl status prometheus
