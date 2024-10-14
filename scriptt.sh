#!/bin/bash

set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Installing prerequisites..."
sudo apt-get install -y apt-transport-https software-properties-common wget

echo "Setting up Grafana GPG key and repository..."
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

echo "Adding Grafana stable repository..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

echo "Adding Grafana beta repository..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

echo "Updating APT package list..."
sudo apt-get update

echo "Installing Grafana..."
sudo apt-get install grafana

echo "Reloading system daemon..."
sudo systemctl daemon-reload

echo "Starting Grafana server..."
sudo systemctl start grafana-server

echo "Checking Grafana server status..."
sudo systemctl status grafana-server | grep "Active"

echo "Enabling Grafana server to start on boot..."
sudo systemctl enable grafana-server.service

echo "Grafana installation and setup complete!"

