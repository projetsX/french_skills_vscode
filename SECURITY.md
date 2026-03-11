# Sécurité — Scan de secrets (gitleaks)

Ce dépôt inclut une configuration Gitleaks et un workflow CI pour détecter les fuites de secrets.

- **Config**: [.gitleaks.toml](./.gitleaks.toml)
- **Workflow CI**: [.github/workflows/gitleaks.yml](.github/workflows/gitleaks.yml)
- **Script local**: `scripts/run-gitleaks.ps1`

Exemples d'exécution locale:

PowerShell (avec Docker):

```powershell
.\scripts\run-gitleaks.ps1
```

Ou si `gitleaks` est installé localement:

```powershell
gitleaks detect --source=. --config=.gitleaks.toml
```

Si le workflow CI détecte un secret, suivez la procédure standard: révoquer la clé compromise, supprimer le secret du Git (réécriture d'historique si nécessaire), puis remplacer par une nouvelle clé et vérifier l'absence de fuite.