#!/bin/bash
# ============================================================
# 03-verify.sh
# Verifies the cluster and nginx deployment are healthy
# ============================================================

echo "=== Cluster Nodes ==="
sudo kubectl get nodes

echo ""
echo "=== Running Pods ==="
sudo kubectl get pods

echo ""
echo "=== Services ==="
sudo kubectl get services

echo ""
echo "=== Nginx Access Info ==="
NODE_PORT=$(sudo kubectl get service nginx -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
VM_IP=$(hostname -I | awk '{print $1}')

if [ -n "$NODE_PORT" ]; then
  echo "URL: http://$VM_IP:$NODE_PORT"
else
  echo "nginx service not found — has it been deployed?"
fi
