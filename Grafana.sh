#!/bin/bash

# Update and upgrade system packages
echo "Updating and upgrading system packages..."
sudo apt update -y && sudo apt upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt install -y apt-transport-https software-properties-common wget

# Add the Grafana GPG key
echo "Adding Grafana GPG key..."
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add Grafana APT repository
echo "Adding Grafana APT repository..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt update

# Install Grafana
echo "Installing Grafana..."
sudo apt install -y grafana

# Start and enable Grafana service
echo "Starting and enabling Grafana service..."
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Verify that the Grafana service is running
echo "Verifying Grafana service status..."
sudo systemctl status grafana-server

# Print Grafana server version
echo "Grafana server version:"
sudo grafana-server -v
