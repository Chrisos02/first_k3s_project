# Arkitektur

## Oversikt

Dette prosjektet kjører et single-node k3s Kubernetes-cluster inne i en VMware VM på en Windows-maskin.

## Trafikkflyt

Når du åpner `http://192.168.75.135:31686` i nettleseren skjer dette:

```
1. Nettleseren sender en HTTP-forespørsel til 192.168.75.135:31686
2. VMwares virtuelle nettverk videresender forespørselen til Ubuntu VM-en
3. k3s NodePort Service mottar forespørselen på port 31686
4. Service videresender den til nginx Pod på port 80
5. nginx svarer med "Welcome to nginx!"-siden
6. Svaret går samme vei tilbake til nettleseren
```

## Komponenter

**VMware (Hypervisor)**
Kjører Ubuntu Server VM-en på Windows-maskinen. Bruker NAT-nettverk, som betyr at VM-en får sin egen IP på et virtuelt nettverk som VMware administrerer.

**Ubuntu Server 22.04**
Operativsystemet som kjører inne i VM-en. Fungerer som host for k3s-clusteret.

**k3s**
En lettvekts Kubernetes-distribusjon. Kjører som en systemd-tjeneste på Ubuntu, noe som betyr at den starter automatisk ved oppstart. I et single-node oppsett fungerer samme node som både control-plane og worker.

**Deployment**
Et Kubernetes-objekt som definerer ønsket tilstand — "jeg vil ha 1 instans av nginx kjørende til enhver tid." Hvis poden krasjer, starter Deployment den automatisk på nytt.

**Pod**
Den faktiske kjørende containeren. Inneholder nginx og serverer HTTP-trafikk på port 80.

**NodePort Service**
Eksponerer poden til omverdenen ved å åpne en port (31686) på VM-ens nettverksgrensesnitt. Uten denne ville poden kun være nåbar fra innsiden av clusteret.

## Nettverksoversikt

| Lag | Adresse |
|-----|---------|
| Windows Host (nettleser) | når VM via 192.168.75.135 |
| VMware NAT-nettverk | bro mellom host og VM |
| Ubuntu VM | 192.168.75.135 |
| NodePort | 31686 |
| Cluster-IP (kun intern) | 10.43.x.x |
