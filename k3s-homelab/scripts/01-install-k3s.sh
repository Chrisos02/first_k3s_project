#!/bin/bash
# ============================================================
# 01-install-k3s.sh
# Installs k3s (lightweight Kubernetes) on Ubuntu Server 22.04
# ============================================================

set -e

echo "[1/3] Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "[2/3] Installing k3s..."
curl -sfL https://get.k3s.io | sh -

echo "[3/3] Verifying installation..."
sleep 5
sudo kubectl get nodes

echo ""
echo "k3s installed successfully!"
echo "Your node should show STATUS: Ready"
