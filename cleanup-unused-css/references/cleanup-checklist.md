# Checklist de nettoyage CSS

Utilisez cette checklist avant, pendant et après le nettoyage CSS.

## ✅ Avant le nettoyage

- [ ] **Lire le skill complet** - Comprendre les 5 phases
- [ ] **Backup Git** - Commiter tout le code avant de commencer
  ```bash
  git status              # Vérifier le statut
  git add -A              # Ajouter tous les fichiers
  git commit -m "before-css-cleanup"  # Créer un point de sauvegarde
  ```
- [ ] **Identifier les dossiers cibles**
  - [ ] Dossier des pages : `src/pages` (ou autre) ?
  - [ ] Dossier des CSS : `src/styles` (ou autre) ?
- [ ] **Vérifier les dépendances**
  - [ ] Bootstrap/Tailwind/Foundation installés ?
  - [ ] Thème personnalisé en CSS ?
  - [ ] Framework spécifique (Vue, React, Angular) ?
- [ ] **Scanner préalable**
  ```powershell
  # Repérer les fichiers minifiés
  Get-ChildItem -Path "src/styles" -Include "*.min.css" -Recurse
  ```

## ✅ Phase 1 : Analyse (Générer rapport)

- [ ] **Exécuter l'analyseur**
  ```powershell
  .\scripts\generate-css-report.ps1 `
    -PagesFolder "src/pages" `
    -CssFolder "src/styles"
  ```

- [ ] **Vérifier le rapport généré**
  - [ ] `css-analysis-report.json` exist ?
  - [ ] `css-analysis-report.md` exist ?
  - [ ] Les nombres sont plausibles (ex: pas de "0 pages scanned") ?

- [ ] **Lire le rapport**
  - [ ] Quels fichiers CSS ont été ignorés (minifiés) ?
  - [ ] Combien de classes inutilisées trouvées ?
  - [ ] Quels sélecteurs sont marqués "severity: high" ?

## ✅ Phase 2 : Validation humaine

- [ ] **Vérifier les faux positifs**
  - [ ] Classes JavaScript dynamiques détectées ?
    - Exemple : `classList.add('active')` peut ne pas être en HTML
    - Ajouter à une liste d'exceptions si nécessaire
  - [ ] Classes Bootstrap/Framework présentes ?
    - Ne pas supprimer sans vérification

- [ ] **Vérifier les cas particuliers**
  - [ ] Pseudo-classes trouvées (`:hover`, `:active`, etc.) ?
  - [ ] Media queries scannées correctement ?
  - [ ] Animations et keyframes listées ?

- [ ] **Décider pour chaque bloc**
  - [ ] Marquer "low risk" comme supprimable
  - [ ] Marquer "medium risk" pour révision supplémentaire
  - [ ] Marquer "high risk" pour documentation

## ✅ Phase 3 : Sauvegarde

- [ ] **Créer un backup**
  ```powershell
  .\scripts\backup-css.ps1 `
    -CssFolder "src/styles" `
    -BackupName "css-backup-precheck"
  ```

- [ ] **Vérifier le backup**
  - [ ] Dossier `css-backup-*` créé ?
  - [ ] Fichier `manifest.json` présent ?
  - [ ] Tous les fichiers CSS copiés (sauf minifiés) ?

- [ ] **Tester la restauration** (optionnel mais recommandé)
  ```powershell
  # Vérifier que le script de restauration existe
  Test-Path "css-backup-*/restore-backup.ps1"
  ```

## ✅ Phase 4 : Exécution en Dry-Run

- [ ] **Exécuter en mode "dry-run"**
  ```powershell
  .\scripts\cleanup-unused-css.ps1 `
    -PagesFolder "src/pages" `
    -CssFolder "src/styles" `
    -ExecuteCleanup $false `
    -Verbose
  ```

- [ ] **Vérifier la sortie**
  - [ ] Fichiers qui SERAIENT modifiés listés ?
  - [ ] Lignes qui SERAIENT supprimées affichées ?
  - [ ] Pas de fichiers minifiés inclus ?
  - [ ] Syntaxe CSS vérifiée après suppression ?

- [ ] **Analyser les logs**
  - [ ] `cleanup-dryrun.log` généré ?
  - [ ] Pas d'erreurs ou warnings ?

## ✅ Phase 5 : Nettoyage réel

- [ ] **Exécuter le nettoyage**
  ```powershell
  .\scripts\cleanup-unused-css.ps1 `
    -PagesFolder "src/pages" `
    -CssFolder "src/styles" `
    -ExecuteCleanup $true `
    -CreateBackup $true
  ```

- [ ] **Vérifier les résultats**
  - [ ] Fichier log généré (`cleanup-execution.log`) ?
  - [ ] Backup nouveau créé avant modification ?
  - [ ] Fichiers CSS modifiés ?

## ✅ Phase 6 : Vérification post-nettoyage

- [ ] **Application web**
  - [ ] Page d'accueil s'affiche correctement ?
  - [ ] Styles visuels intacts ?
  - [ ] Pas de classe CSS manquante ?
  - [ ] Animations/transitions fonctionnent ?

- [ ] **Tests manuels**
  - [ ] Vérifier pages principales
  - [ ] Tester responsivité (mobile/desktop)
  - [ ] Tester états interactifs (hover, focus, active)
  - [ ] Tester les animations

- [ ] **Tests automatisés** (si disponibles)
  ```bash
  npm test          # Ou yarn test, pytest, etc.
  npm run e2e       # Tests end-to-end si disponibles
  ```

- [ ] **Comparaison de taille**
  - [ ] Taille des fichiers CSS avant/après ?
  - [ ] Bundle size réduit ?
  - [ ] Gain de compression gzip ?

- [ ] **Code review**
  - [ ] Git diff examiné ?
  - [ ] Aucun changement inattendu ?
  - [ ] Commentaires dans les fichiers CSS valides ?

## ⚠️ En cas de problème

### Les styles ont disparu

1. **Restaurer depuis le backup**
   ```powershell
   .\css-backup-*/restore-backup.ps1
   ```

2. **Ou restaurer depuis Git**
   ```bash
   git checkout HEAD -- src/styles/
   ```

3. **Identifier le problème**
   - Quelle classe CSS était supprimée à tort ?
   - Ajouter à la liste d'exceptions
   - Relancer le nettoyage

### Le site plante

1. **Restaurer complètement**
   ```powershell
   # Utiliser le backup avant toute modification
   robocopy "css-backup-*" "src/styles" /e
   ```

2. **Redémarrer l'application**
   ```bash
   npm start    # ou la commande appropriée
   ```

3. **Documenter le problème**
   - Quelle classe/sélecteur ?
   - Pourquoi pas détecté ?

## 📊 Rapport final

- [ ] **Documenter les changements**
  ```markdown
  # CSS Cleanup Report
  
  Date: 2026-03-10
  
  ## Avant
  - Fichiers CSS : 12 fichiers, 245 KB
  - Classes inutilisées : 28
  
  ## Après
  - Fichiers CSS : 12 fichiers, 198 KB
  - Réduction : 47 KB (19%)
  
  ## Changements
  - removed .old-navbar
  - removed .deprecated-form
  - ...
  
  ## Backup
  - Location: css-backup-2026-03-10T143000Z
  - Restauration: .\css-backup-*/restore-backup.ps1
  ```

- [ ] **Commiter les changements**
  ```bash
  git add -A
  git commit -m "cleanup: remove 28 unused CSS selectors (-47KB)"
  ```

- [ ] **Archiver les rapports**
  - Conservation du backup (recommandé 30 jours)
  - Archive du rapport JSON
  - Archive du rapport Markdown
