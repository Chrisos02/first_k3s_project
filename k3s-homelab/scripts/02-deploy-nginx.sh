#!/bin/bash
# ============================================================
# 02-deploy-nginx.sh
# Deploys an nginx web server and exposes it via NodePort
# ============================================================

set -e

echo "[1/3] Creating nginx deployment..."
sudo kubectl create deployment nginx --image=nginx

echo "[2/3] Waiting for pod to be ready..."
sudo kubectl wait --for=condition=ready pod -l app=nginx --timeout=60s

echo "[3/3] Exposing nginx via NodePort..."
sudo kubectl expose deployment nginx --port=80 --type=NodePort

echo ""
echo "Deployment complete!"
echo ""
echo "Finding your NodePort..."
NODE_PORT=$(sudo kubectl get service nginx -o jsonpath='{.spec.ports[0].nodePort}')
VM_IP=$(hostname -I | awk '{print $1}')

echo "Access nginx at: http://$VM_IP:$NODE_PORT"
