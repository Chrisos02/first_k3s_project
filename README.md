# k3s Homelab — First Kubernetes Setup

My first Kubernetes project. I set up a single-node k3s cluster on a Ubuntu Server VM and deployed an nginx web server.

## Environment

- **Host machine:** Windows with VMware Workstation
- **VM:** Ubuntu Server 22.04 LTS (named `k3s`)
- **Kubernetes distribution:** k3s

## What I did

### 1. Updated the server

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Installed k3s

```bash
curl -sfL https://get.k3s.io | sh -
```

### 3. Verified the cluster was running

```bash
sudo kubectl get nodes
```

Output:
```
NAME   STATUS   ROLES           AGE   VERSION
k3s    Ready    control-plane   2m    v1.35.5+k3s1
```

### 4. Deployed nginx

```bash
sudo kubectl create deployment nginx --image=nginx
```

### 5. Exposed nginx so I could reach it from my browser

```bash
sudo kubectl expose deployment nginx --port=80 --type=NodePort
```

### 6. Found the port and accessed it

```bash
sudo kubectl get service nginx
```

Then opened `http://192.168.75.135:31686` in my browser on the Windows host and got the **"Welcome to nginx!"** page.

## Architecture

```
Windows (browser)
       |
       | http://192.168.75.135:31686
       |
Ubuntu Server VM (VMware)
       |
       | NodePort Service (:31686)
       |
nginx Pod (container :80)
```
