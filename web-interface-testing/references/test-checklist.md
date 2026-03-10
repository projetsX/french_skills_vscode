# Checklist de Test d'Interface Web

À utiliser en référence pendant l'exécution du skill.

## Phase 1: Préparation

### Accès au serveur
- [ ] URL cible identifiée (ex: `/contact`, `http://localhost:5173/products`)
- [ ] Serveur accessible (réponse 200)
- [ ] Page charge correctement (pas de timeout)

### Type de projet clarifié
- [ ] Vite? → Port obtenu de `vite.config.*`
- [ ] PHP? → Domaine `.loc` obtenu du projet
- [ ] Externe? → URL fournie directement

---

## Phase 2: Console DevTools

### Erreurs
- [ ] Liste complète des erreurs obtenue (`list_console_messages`)
- [ ] Erreurs réelles identifiées (excluant 404 attendus)
- [ ] Erreurs bloquantes vs warnings documentées
- [ ] Causes probables associées à chaque erreur

### Status
- [ ] ✅ **NO ERRORS**: Continuer
- [ ] ⚠️ **WARNINGS ONLY**: Documenter, continuer
- [ ] 🔴 **ERRORS**: Relever bugs, proposer fixes

---

## Phase 3: Accessibilité (WCAG Baseline)

### Images
- [ ] Tous les `<img>` ont-ils `alt=""` non-vide?
- [ ] `alt` décrit le contenu ou son intention?

### Formulaires
- [ ] Tous les `<input>` liés à `<label>`?
- [ ] `<label for="input-id">` correspond à `<input id="input-id">`?

### Titres (Headings)
- [ ] Structure hiérarchique? (`<h1>` → `<h2>` → `<h3>`)
- [ ] Pas de `<h1>` manquant?

### Boutons & Links
- [ ] Boutons ont du texte visible OU `aria-label`?
- [ ] Links discernables (couleur, underline)?

### Contraste Couleur
- [ ] Texte sur fond: ratio ≥4.5:1 recommandé (au moins visuellement)

### Status
- [ ] ✅ **WCAG PASS**: Continue
- [ ] ⚠️ **MINOR ISSUES**: Documenter, continuer
- [ ] 🔴 **MAJOR ISSUES**: Relever, proposer fixes

---

## Phase 4: Éléments Interactifs

### Inventaire
Lister tous les éléments trouvés:
- [ ] Barre de recherche
- [ ] Champs de formulaire (text, email, password, etc.)
- [ ] Boutons (submit, cancel, action)
- [ ] Menus (dropdown, hamburger)
- [ ] Checkboxes / Radios
- [ ] Links
- [ ] Autres: _______________

### Pour chaque élément

**Élément: ________________**
- [ ] Élément visible & accessible (snapshot)?
- [ ] Remplissage de données valides → pas d'erreur console?
- [ ] Clic/soumission → fonctionnement attendu?
- [ ] Cas invalide testé (si applicable)?
- [ ] État post-action visible & correct?

Répéter pour chaque élément.

### Status par élément
- [ ] ✅ PASS
- [ ] ❌ FAIL (détails: ________________)
- [ ] ⚠️ PARTIAL (détails: ________________)

---

## Phase 5: Ergonomie Responsive

### Desktop (1920x1080)
- [ ] Page redimensionnée à (1920, 1080)
- [ ] Screenshot pris
- [ ] Inspection visuelle:
  - [ ] Pas de débordement horizontal?
  - [ ] Layout cohérent?
  - [ ] Texte lisible?

### Mobile (375x812)
- [ ] Page redimensionnée à (375, 812)
- [ ] Screenshot pris
- [ ] Inspection mobile:
  - [ ] Images correctement proportionnées (max-width)?
  - [ ] Pas de débordement `div`?
  - [ ] Texte lisible (pas trop petit)?
  - [ ] Boutons cliquables (taille ≥48px)?
  - [ ] Menu responsive/burger?

### Tablet (768x1024)
- [ ] Page redimensionnée à (768, 1024)
- [ ] Screenshot pris
- [ ] Layout intermédiaire cohérent?

### Issues Détectées
- [ ] Débordement → Fichier & classe CSS impactée: ___________
- [ ] Image mal dimensionnée → Fichier & balise: ___________
- [ ] Texte coupé → Fichier & élément: ___________
- [ ] Autres → Détails: ___________

---

## Phase 6: Performance

### Audit Lancé
- [ ] `performance_start_trace()` exécutée
- [ ] Page rechargée
- [ ] Audit complété sans erreur

### Core Web Vitals
- [ ] **LCP** (Largest Contentful Paint): ______ ms
  - ✅ ≤2.5s / ⚠️ 2.5-4s / 🔴 >4s
- [ ] **FID** (First Input Delay): ______ ms
  - ✅ ≤100ms / ⚠️ 100-300ms / 🔴 >300ms
- [ ] **CLS** (Cumulative Layout Shift): ______ 
  - ✅ <0.1 / ⚠️ 0.1-0.25 / 🔴 >0.25

### Ressources
- [ ] Nombre de requêtes JS: ______
- [ ] Nombre de requêtes CSS: ______
- [ ] Nombre & size des images: ______
- [ ] Total page weight: ______ KB

### Red Flags
- [ ] Script bloc-rendu volumineux?
- [ ] Images non-optimisées (PNG vs WebP)?
- [ ] Trop de requêtes réseau?
- [ ] DOM thrashing (layout recalc répétitif)?

### Status Performance
- [ ] ✅ ACCEPTABLE (CWV OK)
- [ ] ⚠️ NEEDS IMPROVEMENT (CWV borderline)
- [ ] 🔴 POOR (CWV mauvais)

---

## Phase 7: Résumé & Corrections

### Findings Compilés

**Console Errors**: __________ bugs
- [ ] Listés avec fichier/ligne/message

**Accessibility**: __________ issues
- [ ] Listés WCAG failure reason

**Interactivity**: __________ bugs
- [ ] Listés input/element concerns

**Responsiveness**: __________ bugs
- [ ] Listés breakpoint/CSS concerns

**Performance**: __________ red flags
- [ ] Listés perf concern

### Corrections Proposées
- [ ] Bug #1 File: __________ Fix: __________
- [ ] Bug #2 File: __________ Fix: __________
- [ ] Bug #3 File: __________ Fix: __________
- [ ] (continuer...)

### Fixes Appliqués
- [ ] Correction #1 ✅ DONE
- [ ] Correction #2 ✅ DONE
- [ ] Correction #3 ✅ DONE

### Re-test Post-Fix
- [ ] Phases 2-6 re-exécutées
- [ ] Bugs précédents resolus?
- [ ] Pas de régression?

---

## Rapport Final

**Page Testée**: ____________________________
**Date**: ____________________________
**Tester**: ____________________________

### Overall Status
- [ ] ✅ PASS (tous critères OK)
- [ ] ⚠️ PASS WITH WARNINGS (besoin améliorations)
- [ ] 🔴 FAIL (issues bloquantes)

### Recommandations
- Priority 1 (Blocker): ____________________________
- Priority 2 (High): ____________________________
- Priority 3 (Low): ____________________________

### Follow-up
- [ ] Owner assigné pour fixes
- [ ] Deadline établie
- [ ] Retest planifié

---

**Archiver cette checklist** avec les screenshots et rapport.
