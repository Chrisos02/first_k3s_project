# Architecture Notes

## Overview

This project runs a single-node k3s Kubernetes cluster inside a VMware VM on a Windows host machine.

## Traffic Flow

When you open `http://192.168.75.135:31686` in your browser, this is what happens:

```
1. Browser sends HTTP request to 192.168.75.135:31686
2. VMware's virtual network forwards the request to the Ubuntu VM
3. k3s NodePort Service receives the request on port 31686
4. Service forwards the request to the nginx Pod on port 80
5. nginx responds with the "Welcome to nginx!" page
6. Response travels back the same path to your browser
```

## Components

### VMware (Hypervisor)
Runs the Ubuntu Server VM on your Windows machine. Uses NAT networking, which means the VM gets its own IP on a virtual network that VMware manages.

### Ubuntu Server 22.04
The operating system running inside the VM. Acts as the host for the k3s cluster.

### k3s
A lightweight Kubernetes distribution. Runs as a systemd service on Ubuntu, meaning it starts automatically on boot. In a single-node setup, the same node acts as both control-plane and worker.

### Deployment
A Kubernetes object that defines the desired state — "I want 1 replica of nginx running at all times." If the pod crashes, the Deployment automatically restarts it.

### Pod
The actual running container. Contains nginx and serves HTTP traffic on port 80.

### NodePort Service
Exposes the pod to the outside world by opening a port (31686) on the VM's network interface. Without this, the pod would only be reachable from inside the cluster.

## Networking Summary

| Layer | Address |
|-------|---------|
| Windows Host (browser) | accesses VM via 192.168.75.135 |
| VMware NAT Network | bridges host and VM |
| Ubuntu VM | 192.168.75.135 |
| NodePort | :31686 |
| Cluster-IP (internal only) | 10.43.x.x |
| Pod IP (internal only) | 10.42.x.x |
