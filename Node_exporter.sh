#!/bin/bash

# Update System Packages
echo "Updating system packages..."
sudo apt update -y

# Download and Extract Node Exporter
echo "Downloading Node Exporter..."
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
echo "Extracting Node Exporter files..."
sudo tar xzf node_exporter-1.7.0.linux-amd64.tar.gz

# Remove the tar file
echo "Removing Node Exporter tar file..."
sudo rm -f node_exporter-1.7.0.linux-amd64.tar.gz

# Move Node Exporter Files
echo "Moving Node Exporter files..."
sudo mv node_exporter-1.7.0.linux-amd64 /etc/node_exporter

# Create Systemd Service for Node Exporter
echo "Creating systemd service file for Node Exporter..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=always
User=node_exporter
Group=node_exporter

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd, start and enable Node Exporter service
echo "Reloading systemd and starting Node Exporter service..."
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Check the status of Node Exporter service
echo "Checking Node Exporter service status..."
sudo systemctl status node_exporter

echo "Node Exporter has been installed and configured."
echo "Please add Node Exporter to Prometheus configuration to scrape the data."
