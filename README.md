# k3s Homelab — Mitt første Kubernetes-oppsett

Mitt første Kubernetes-prosjekt. Jeg satte opp et single-node k3s cluster på en Ubuntu Server VM og deployet en nginx webserver.

## Miljø

- **Host-maskin:** Windows med VMware Workstation
- **VM:** Ubuntu Server 22.04 LTS (kalt `k3s`)
- **Kubernetes-distribusjon:** k3s

## Hva jeg gjorde

### 1. Oppdaterte serveren

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Installerte k3s

```bash
curl -sfL https://get.k3s.io | sh -
```

### 3. Verifiserte at clusteret kjørte

```bash
sudo kubectl get nodes
```

Output:
```
NAME   STATUS   ROLES           AGE   VERSION
k3s    Ready    control-plane   2m    v1.35.5+k3s1
```

### 4. Deployet nginx

```bash
sudo kubectl create deployment nginx --image=nginx
```

### 5. Eksponerte nginx så jeg kunne nå den fra nettleseren

```bash
sudo kubectl expose deployment nginx --port=80 --type=NodePort
```

### 6. Fant porten og åpnet siden

```bash
sudo kubectl get service nginx
```

Åpnet `http://192.168.75.135:31686` i nettleseren på Windows-maskinen og fikk opp **"Welcome to nginx!"**.

## Arkitektur

```
Windows (nettleser)
       |
       | http://192.168.75.135:31686
       |
Ubuntu Server VM (VMware)
       |
       | NodePort Service (:31686)
       |
nginx Pod (container :80)
```
