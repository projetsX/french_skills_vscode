---
name: web-interface-testing
description: "Test web page interfaces for compliance, accessibility, and performance using Chrome DevTools MPC. Use when: checking page accessibility for vision-impaired users, testing input elements and forms, verifying mobile/desktop responsiveness, analyzing page performance, fixing UI issues."
argument-hint: "[PAGE_URL_or_PATH] - URL or workspace-relative path to the page to test (e.g., '/contact', 'http://localhost:5173', 'https://monsite.loc')"
user-invocable: true
---

# Compléter la vérification d'interface web

Workflow pour tester et valider une page web d'un site (une seule page par exécution) en utilisant le MCP Google Chrome DevTools pour évaluer la conformité, l'accessibilité, l'ergonomie et les performances.

## Quand l'utiliser

- Vérifier la conformité et l'accessibilité d'une page web
- Tester les éléments interactifs (formulaires, barres de recherche, boutons, menus)
- Valider l'ergonomie sur desktop **ET** mobile (plusieurs largeurs d'écrans)
- Analyser les performances (CPU, RAM, Core Web Vitals)
- Détecter les problèmes de console DevTools
- Corriger les bugs d'interface détectés

## Prérequis

- Accès à la structure du projet workspace
- Identité du serveur:
  - **Projet Vite** : vérifier `vite.config.*` pour le port (ex: `http://localhost:5173`)
  - **Projet PHP** : utiliser le domaine `.loc` (ex: `https://monsite.loc`)
- Page web cible unique (chemin ou URL complet)
- Configuration du MCP Google Chrome installée et disponible

## Sources officielles MCP Google Chrome

À chaque invocation, télécharger la documentation complète du MCP:
- 📖 **Doc officielle**: https://raw.githubusercontent.com/ChromeDevTools/chrome-devtools-mcp/refs/heads/main/README.md

**Outils MCP disponibles** (exemples clés):
- `mcp_chromedevtool_navigate_page` — Naviguer vers une URL
- `mcp_chromedevtool_take_snapshot` — Capture du DOM/a11y
- `mcp_chromedevtool_performance_start_trace` — Démarrer un audit de perf
- `mcp_chromedevtool_list_console_messages` — Lister messages de console
- `mcp_chromedevtool_fill` — Remplir un input
- `mcp_chromedevtool_click` — Cliquer sur un élément

## Procédure étape par étape

### Phase 1: Préparation et Accès

1. **Clarifier la cible de test**
   - Demander à l'utilisateur: chemin complet ou relatif vers la page
   - Exemple: `/contact`, `/products/details`, `/admin/dashboard` 
   - Pour Vite: obtenir le **port** du serveur (vérifier `vite.config.js/ts`)
   - Pour PHP: obtenir le **domaine .loc** depuis le projet

2. **Construire l'URL complète**
   - Vite: `http://localhost:[PORT]/[PAGE_PATH]`
   - PHP: `https://[DOMAIN].loc/[PAGE_PATH]`
   - Externe: utiliser l'URL fournie directement

3. **Vérifier que le serveur est accessible**
   - Naviguer vers l'URL cible avec `mcp_chromedevtool_navigate_page`
   - Status 200 → continuer
   - Erreur réseau → proposer helpers (lancer le serveur, etc.)

### Phase 2: Vérification Console DevTools

1. **Récupérer tous les messages de console**
   ```
   mcp_chromedevtool_list_console_messages() [types: ['error', 'warn', 'log']]
   ```

2. **Analyser**
   - **Errors** 🔴 → problème-bloquant, noter détails (fichier, ligne, message)
   - **Warnings** 🟡 → problème-non-bloquant, ex: dépréciations, perfs
   - **Logs** 🟢 → informationnel (généralement OK)

3. **Décision**
   - Y a-t-il des erreurs réelles (pas 404 attendus)?
   - → **OUI**: relever et proposer correction
   - → **NON**: continuer

### Phase 3: Vérification Accessibilité

1. **Prendre un snapshot accessible** (a11y tree)
   ```
   mcp_chromedevtool_take_snapshot(verbose=true)
   ```

2. **Vérifier les critères WCAG de base**
   - Tous les `<img>` ont-ils des `alt` textes?
   - Les labels `<label>` sont-ils liés aux inputs (`for` attribute)?
   - Les boutons ont-ils du texte visible ou `aria-label`?
   - Les titres sont-ils hiérarchisés (`<h1>` → `<h2>` → `<h3>`)?
   - Les contrastes couleur texte/fond sont-ils suffisants (~4.5:1)?

3. **Décision**
   - Problème détecté? → relever avec snippet de code
   - Pas de problème? → continuer

### Phase 4: Test des Éléments Interactifs

1. **Identifier les inputs/formulaires** sur la page
   - Barre de recherche
   - Champs de formulaire (text, email, etc.)
   - Buttons, links
   - Dropdowns, checkboxes, radios

2. **Pour chaque élément interactif**
   - **Remplir** avec données valides (`mcp_chromedevtool_fill`)
   - **Cliquer** (`mcp_chromedevtool_click`)
   - **Vérifier la réaction** (snapshot après action, pas d'erreur console)
   - Cas valides: soumission, validation, changement d'état
   - Cas invalides: données vides, format incorrect → tester la gestion d'erreur

3. **Enregistrer les résultats**
   - ✅ Élément X: fonctionne
   - ❌ Élément Y: erreur Z (détails)

### Phase 5: Ergonomie Desktop & Mobile

**Desktop** (résolution standard):
1. Prendre screenshot à `1920x1080`
   ```
   mcp_chromedevtool_resize_page(1920, 1080)
   mcp_chromedevtool_take_screenshot()
   ```
2. Vérifier visuellement: pas de débordement, layout cohérent

**Mobile-S** (petit mobile):
1. Redimensionner à `375x812` (ex: iPhone SE)
   ```
   mcp_chromedevtool_resize_page(375, 812)
   ```
2. Vérifier:
   - Images adaptées (pas trop larges)
   - Texte lisible
   - Menu responsive (burger menu, etc.)
   - Boutons cliquables (taille ≥48px recommandé)

**Mobile-M/L** (tablette):
1. Redimensionner à `768x1024` (iPad)
   ```
   mcp_chromedevtool_resize_page(768, 1024)
   ```
2. Vérifier layout intermédiaire

**Décision**:
- Débordements `div`? → relever et proposer fix CSS
- Images mal dimensionnées? → relever et proposer srcset/max-width
- Texte coupé? → relever font-size ou padding
- Boutons inaccessibles? → relever et proposer zones tactiles

### Phase 6: Analyse des Performances

1. **Démarrer un audit de performance** (trace)
   ```
   mcp_chromedevtool_performance_start_trace(reload=true, autoStop=true)
   ```

2. **Analyser les résultats**
   - **Core Web Vitals** (CWV):
     - **LCP** (Largest Contentful Paint): ≤2.5s ✅, >4s ❌
     - **FID** (First Input Delay): ≤100ms ✅, >300ms ❌
     - **CLS** (Cumulative Layout Shift): <0.1 ✅, >0.25 ❌
   - **CPU/RAM**: noter pic, moyenne
   - **Ressources chargées**: JS, CSS, images (sizes, counts)

3. **Points critiques à relever**
   - ⚠️ Script bloc-rendu trop volumineux
   - ⚠️ Images non-optimisées (WebP, responsive)
   - ⚠️ Rechargement DOM répétitif (layout thrashing)
   - ⚠️ Trop de listeners événements

4. **Décision**
   - Performance acceptable (CWV ✅)? → continuer
   - Performance mauvaise? → relever et proposer optimisations

### Phase 7: Résumé & Corrections

1. **Compiler le rapport**
   ```
   ✅ PASS: éléments fonctionnants
   ❌ FAIL: éléments défaillants avec détails
   ⚠️ WARN: avertissements accessibilité/perf
   ```

2. **Si corrections proposées**
   - Pour chaque bug:
     - Fichier impacté
     - Code actuel (snippet)
     - Code corrigé (snippet)
     - Explication brève
   - Appliquer les fixes dans les fichiers source
   - Re-tester la page après correction

3. **Valider post-correction**
   - Relancer les tests Phase 2-6
   - Confirmer que le bug est résolu
   - Vérifier que pas de régression

## Points de Décision

| Situation | Action |
|-----------|--------|
| Erreur console non-bloquante (warning) | Signal ⚠️, continuer tests |
| Erreur console bloquante (erreur) | Signal 🔴, relever bug, proposer correction |
| Accessibilité WCAG échouée | Signal ❌, lister critères échoués, proposer fixes |
| Input défaillant | Vérifier le contexte (JS manquant?), relever bug |
| Mobile débordement | Cause probable: pas de `max-width`, `overflow-x`, ou media-query |
| Performance LCP> 4s | Cause probable: image non-optimisée ou JS synchrone |
| Multiple issues | Prioriser par impact (blocker > lisant > cosmétique) |

## Critères de Qualité / Checks de Complétion

✅ **Test réussi** si:
- [x] URL accessible (status 200)
- [x] Console DevTools vérifiée (0 errurs graves)
- [x] Accessibilité WCAG baseline validée (alt text, labels, hiérarchie)
- [x] Tous les inputs testés (au moins 1 test par élément interactif)
- [x] Ergonomie testée sur 3 résolutions (desktop 1920, mobile 375, tablet 768)
- [x] Performance analysée (CWV reportés)
- [x] Rapport généré avec findings

❌ **Test incomplet** si:
- Serveur inaccessible (réseau down)
- Données insuffisantes pour un test (ex: page login sans credentials)
- Interruption utilisateur

## Exemples d'Utilisation (Prompts)

- "Vérifie la page `/contact` pour l'accessibilité et les perfs"
- "Teste la page `/products` sur desktop, mobile et tablette"
- "Audit complet de `/blog/post` (console, inputs, a11y, responsive)"
- "Tester la formulaire d'inscription sur https://monsite.loc/signup"
- "Vérifier la barre de recherche sur le port 5173"

## Comment Exécuter via Script

### Utiliser le script helper (optionnel)

**Windows (PowerShell)**:
```powershell
cd c:\Users\mathi\.copilot\skills\web-interface-testing\scripts
.\launch-tests.ps1 -PagePath "/contact" -ProjectType "vite" -VitePort 5173
```

**Linux / macOS / WSL (Bash)**:
```bash
cd c:\Users\mathi\.copilot\skills\web-interface-testing\scripts
bash launch-tests.sh --page-path /contact --project-type vite --vite-port 5173
```

### Ou: Exécuter manuellement

1. Naviguer vers la page cible (`mcp_chromedevtool_navigate_page`)
2. Suivre les phases 2-6 en utilisant les outils MCP listés
3. Compiler rapport à la fin

## Notes d'Implémentation

- **Une page à la fois**: ne pas tester plusieurs pages dans un seul call
- **MCP obligatoire**: toujours utiliser les outils du MCP Chrome, pas de terminal nav
- **Vite vs PHP**: adapter l'URL de base en fonction du type de projet
- **Corrections in-situ**: modifier les fichiers source directement avec les outils d'édition
- **Re-test post-fix**: valider que les corrections n'introduisent pas de régression

## Extensions Possibles

- Ajouter screenshot diff avant/après correction
- Intégrer un générateur de rapport HTML exportable
- Ajouter scanning de pages complètes (multi-page audit)
- Intégrer Lighthouse pour audit SEO/PWA
- Créer template de bugs pour GitHub issues

---

**Maintenance**: Document toute modification du skill ici.
**Version**: 1.0 (Initial)
**Date**: 2025-03-10
