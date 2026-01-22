# Secret Management in Kubernetes met HashiCorp Vault

Dit project demonstreert twee methoden om secrets veilig te beheren in Kubernetes met HashiCorp Vault:

1. **Vault Agent Sidecar Injectie**
2. **Vault Secrets Operator**

Beide methoden halen secrets op uit Vault en maken ze beschikbaar voor applicaties in Kubernetes, elk met hun eigen voordelen en toepassingsgebieden.

---

## 📁 Repository structuur

.
├── sidecar/          # Configuratie voor Vault Agent Sidecar injectie
│   ├── deployment.yaml
│   ├── configmap-template.hcl
│   └── serviceaccount.yaml
│
├── operator/         # Configuratie voor Vault Secrets Operator
│   ├── vaultconnection.yaml
│   ├── vaultauth.yaml
│   ├── vaultstaticsecret.yaml
│   └── deployment.yaml
│
├── vault/            # Vault configuratie (policies, roles, KV data)
│   ├── policy.hcl
│   ├── role.sh
│   └── kv-setup.sh
│
└── REPORT.pdf                # Eindverslag met screenshots



## 🔐 Vault Configuratie

Vault is geconfigureerd met:

- Een **KV v2 engine** op `secret/`
- Policies die toegang geven tot `secret/data/app-config`
- De **Kubernetes Auth Method**
- Roles voor zowel de sidecar als de operator

Alle configuratiebestanden staan in de map `vault/`.


Methode 1: Vault Agent Sidecar Injectie

De Vault Agent sidecar:

- Authenticeert via een Kubernetes ServiceAccount  
- Haalt secrets op uit Vault  
- Rendert een template naar `/vault/secrets/app-config.env`  
- De applicatie leest dit `.env`‑bestand in

### Testen

kubectl exec -it <sidecar-pod> -n apps -c vault-agent -- cat /vault/secrets/app-config.env

Methode 2: Vault Secrets Operator
De operator:

Verbindt met Vault via VaultConnection

Authenticeert via VaultAuth

Synchroniseert secrets via VaultStaticSecret

Maakt automatisch een Kubernetes Secret aan (app-config-secret)

### Testen
kubectl exec -it <operator-pod> -n apps -- env
Je ziet variabelen zoals:

username=demo-user
password=supersecret
_raw=...

🧪 Testresultaten

Beide methoden zijn succesvol getest:

De sidecar leest secrets correct uit /vault/secrets/app-config.env

De operator maakt app-config-secret aan en injecteert environment variables in de testpod



Bekijk het verslag voor visuele uitleg

📄 Licentie
Dit project is gemaakt voor educatieve doeleinden


```bash
kubectl exec -it <sidecar-pod> -n apps -c vault-agent -- cat /vault/secrets/app-config.env
