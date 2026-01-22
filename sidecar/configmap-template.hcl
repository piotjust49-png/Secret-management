apiVersion: v1
kind: ConfigMap
metadata:
  name: vault-agent-config
  namespace: apps
data:
  config.hcl: |
    exit_after_auth = false
    pid_file = "/tmp/vault-agent-pid"

    auto_auth {
      method "kubernetes" {
        mount_path = "auth/kubernetes"
        config = {
          role = "app-role"
        }
      }

      sink "file" {
        config = {
          path = "/home/vault/.token"
        }
      }
    }

    template {
      source      = "/vault/config/app-config.ctmpl"
      destination = "/vault/secrets/app-config.env"
    }

  app-config.ctmpl: |
    USERNAME={{ with secret "secret/data/app-config" }}{{ .Data.data.username }}{{ end }}
    PASSWORD={{ with secret "secret/data/app-config" }}{{ .Data.data.password }}{{ end }}
