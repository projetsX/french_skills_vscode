# Verify PayPal PHP Implementation - Skill Guide

## Overview

Cette compétence est conçue pour **auditer et vérifier** les implémentations PayPal en PHP, en s'assurant qu'elles sont :

✅ **Correctes** — Pas de bugs, utilisation correcte du SDK  
✅ **Sécurisées** — Gestion sécurisée des credentials, validation des données  
✅ **À jour** — SDK à jour, version PHP compatible  
✅ **Conformes** — Respect des bonnes pratiques PayPal  

## Quand l'utiliser ?

Utilisez cette compétence dans ces situations :

- 🔍 **Audit de sécurité** — Vérification avant déploiement en production
- 🚀 **Déploiement** — Vérification finale avant lancement
- 🐛 **Débogage** — Identification des problèmes dans une intégration existante
- ⬆️ **Migration** — Mise à jour vers une nouvelle version du SDK
- 📋 **Code Review** — Récapitulatif structuré pour l'équipe

## Comment l'invoquer ?

### Option 1 : Slash Command (Recommandé)

```
/verify-paypal-php src/PaymentHandler.php
/verify-paypal-php /app/payments/
```

### Option 2 : Texte normal

```
Vérifier mon implémentation PayPal dans le fichier src/PaymentHandler.php
```

## Informations requises

Préparez :

- **Chemin du code** — Fichier unique ou répertoire complet
- **Version PHP** — Version en production (ex: 8.2)
- **Version SDK** — Version PayPal installée (ex: 1.2.0)

## Résultat attendu

Vous recevrez un **rapport markdown** structuré par domainés :

```
📋 RAPPORT DE VÉRIFICATION

🚨 Issues Critiques (Bloquantes)
   - Credentials en dur dans le code
   - HTTPS non forcé
   - Validation de signature manquante

⚠️  High Priority (À corriger avant lancement)
   - Gestion d'erreurs incomplète
   - Extensions PHP manquantes

📋 Medium Priority (Améliorations)
   - Logging à améliorer
   - Tests à ajouter

✅ Points validés
   - Authentification correcte
   - Version SDK compatible
```

## Domaines vérifiés

| Domaine | Vérifie | Rapport |
|---|---|---|
| **Sécurité** | Credentials, HTTPS, validation, sanitization | [security-checklist.md](./references/security-checklist.md) |
| **Auth & API** | OAuth 2.0, tokens, endpoints | [best-practices.md](./references/best-practices.md) |
| **Gestion erreurs** | Try-catch, logging, messages génériques | [best-practices.md](./references/best-practices.md) |
| **Validation données** | Entrées, réponses, logique métier | [security-checklist.md](./references/security-checklist.md) |
| **PHP & SDK** | Compatibilité, extensions, versions | [php-compatibility.md](./references/php-compatibility.md) |
| **Webhooks** | HTTPS, signature, déduplication, codes HTTP | [webhook-checklist.md](./references/webhook-checklist.md) |

## Sources de documentation

Le skill consulte la documentation officielle PayPal par ordre de priorité :

1. **MCP Context7** — Accès direct à la documentation SDK (le plus rapide)
2. **Context7 URL** — `https://context7.com/paypal/paypal-php-server-sdk/`
3. **GitHub README** — `https://raw.githubusercontent.com/paypal/PayPal-PHP-Server-SDK/main/README.md`

## Fichiers de références inclus

| Fichier | Contenu |
|---|---|
| [security-checklist.md](./references/security-checklist.md) | ✓ Credentials, authentification, HTTPS, validation, erreurs, logging |
| [webhook-checklist.md](./references/webhook-checklist.md) | ✓ Configuration webhooks, signature, déduplication, sécurité |
| [php-compatibility.md](./references/php-compatibility.md) | ✓ Versions PHP, extensions, SDK requirements |
| [best-practices.md](./references/best-practices.md) | ✓ Patterns corrects, error handling, rate limiting, testing |
| [verification-checklist.md](./references/verification-checklist.md) | ✓ Liste complète de vérification pré/post audit |

## Scripts utilitaires

| Script | Fonction |
|---|---|
| [generate-audit-report.ps1](./scripts/generate-audit-report.ps1) | Génère un template de rapport vierge à remplir |

### Utilisation du script

```powershell
.\scripts\generate-audit-report.ps1 `
    -OutputPath ".\paypal-audit-report.md" `
    -AnalyzedPath ".\src\" `
    -PHPVersion "8.2" `
    -SDKVersion "1.2.0"
```

## Exemple de workflow complet

### 1️⃣ Préparation
```
Récupérez :
- Chemin du code PayPal
- Version PHP en production
- Version SDK installée
```

### 2️⃣ Invoquer le skill
```
/verify-paypal-php src/payments/PayPalManager.php
```

### 3️⃣ Examiner le rapport
```
Lisez les issues triées par sévérité
Notez les checklists validées
Identifiez les actions prioritaires
```

### 4️⃣ Corriger les issues
```
Adressez d'abord les critiques
Puis les high priority
Enfin les medium priority
```

### 5️⃣ Re-vérifier
```
/verify-paypal-php src/payments/PayPalManager.php
(après corrections)
```

## Cas d'usage typiques

### Cas 1 : Audit avant production 🚀

```
Situation: Prêt à déployer une intégration PayPal

1. /verify-paypal-php app/payments/
2. Lisez le rapport (section "Critical Issues")
3. Si critiques = 0 → Go live
4. Si critiques > 0 → Corrigez d'abord
```

### Cas 2 : Code Review 👥

```
Situation: Review du code d'un collègue

1. /verify-paypal-php src/payments/ (son code)
2. Envoyez le rapport à l'équipe
3. Discutez des high/medium priority
4. Créez des tickets pour les améliorations
```

### Cas 3 : Débogage 🐛

```
Situation: Erreurs en production

1. /verify-paypal-php app/paypal/
2. Consultez section "Error Handling"
3. Vérifiez les logs recommandés
4. Corrigez les logging gaps
```

## FAQ

**Q: Combien de temps ça prend ?**
R: 5-15 minutes selon la taille du code. Le rapport est dans VS Code immédiatement.

**Q: Ça analyse vraiment le code ?**
R: Oui, le rapport inclut des références spécifiques à vos fichiers et numéros de ligne.

**Q: Besoin d'accès externe ?**
R: Oui, pour la documentation officielle PayPal. Sinon, utilise un fallback.

**Q: Ça fix automatiquement ?**
R: Non, ça génère un rapport. Vous appliquez les corrections.

## Support & Questions

Si le skill ne trouve pas un problème :
- Vérifiez que le chemin du code est accessible
- Consultez les checklists manuellement
- Ouvrez une issue sur le repo

## Prochaines étapes

Après avoir utilisé ce skill, considérez :

1. **Automatiser les tests** — Ajouter des tests unitaires PayPal
2. **Monitorer** — Configurer des alertes sur les erreurs PayPal
3. **Documenter** — Créer un guide interne pour l'équipe
4. **Former** — Montrer le rapport à l'équipe pour discuter best practices

---

**Version**: 1.0  
**Dernière mise à jour**: 2026-03-11  
**Licence**: MIT
