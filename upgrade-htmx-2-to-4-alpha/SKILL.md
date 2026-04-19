---
name: upgrade-htmx-2-to-4-alpha
description: 'Aide à migrer un site utilisant HTMX de la version 2 à la version 4. Vérifie les changements dans la documentation officielle et propose la mise à jour des références locales.'
argument-hint: '[OPTIONS] - Options pour la vérification et la mise à jour locale'
user-invocable: true
---

# Skill: upgrade-htmx-2-to-4

But: Aider à migrer un site utilisant HTMX de la version 2 à la version 4.

Objectif
- Fournir une procédure reproductible et des outils pour vérifier les changements officiels de documentation HTMX et guider la migration.

Sources officielles (à surveiller à chaque exécution du skill)
- https://raw.githubusercontent.com/bigskysoftware/htmx/refs/heads/four/src/skills/htmx-guidance.md
- https://raw.githubusercontent.com/bigskysoftware/htmx/refs/heads/four/src/skills/upgrade-from-htmx2.md

Comportement attendu du skill
- À chaque invocation, vérifier s'il y a eu des ajouts/modifications dans les deux fichiers distants.
- Si modifications détectées: indiquer qu'il y a des changements et proposer de mettre à jour les références locales (pas de diff détaillé par défaut).
- Fournir une checklist de migration et pointers pour les cas courants.

Fichiers fournis
- `SKILL.md` (ce fichier)
- `scripts/check_updates.sh` (Linux / macOS / WSL)
- `scripts/check_updates.ps1` (PowerShell)
- `references/htmx-guidance.md` (copie locale initiale)
- `references/upgrade-from-htmx2.md` (copie locale initiale)

Processus étape par étape (workflow que le skill formalise)
1. Récupérer les versions distantes des deux fichiers.
2. Comparer avec les copies locales dans `references/`.
3. Si différences: générer un résumé (diff), marquer les sections ajoutées/retirées.
4. Proposer des actions: mettre à jour les fichiers locaux, générer une checklist de migration adaptée.
5. Fournir des exemples de transformations de code HTML/HTMX courantes.

Points de décision
- Si la différence est uniquement de mise en forme (espaces, lignes vides) → option "Ignorer".
- Si de nouvelles sections apparaissent → option "Mise à jour locale" et "Afficher les nouveautés".

Critères de qualité / checks de complétion
- Deux fichiers distants ont été récupérés sans erreurs réseau.
- Comparaison textuelle effectuée et signalée.
- Si l'utilisateur accepte, fichiers locaux mis à jour.

Exemples d'utilisation (prompts)
- "Vérifie si la doc HTMX a changé et mets à jour les références locales si besoin."
- "Donne-moi une checklist de migration HTMX 2→4 pour un projet avec beaucoup d'attributs hx-* personnalisés."

Extensions possibles
- Ajouter un script qui scanne le code du projet pour usages `hx-` et propose un diff automatique.
- Intégrer un résumé sémantique (ex: lister nouvelles API/attributs).

Comment exécuter la vérification (exemples)

PowerShell (Windows):
```powershell
cd c:\Users\mathi\.copilot\skills\upgrade-htmx-2-to-4\scripts
.\check_updates.ps1 -UpdateLocalIfChanged:$false
```

Bash (Linux / macOS / WSL):
```bash
cd c:\Users\mathi\.copilot\skills\upgrade-htmx-2-to-4\scripts
bash check_updates.sh --no-update
```

Notes d'implémentation
- Les scripts utilisent un cache local dans `references/`.
- Comportement par défaut: proposer la mise à jour (ne pas modifier automatiquement les fichiers locaux) et ne pas afficher de diff détaillé — seul un message "Changements détectés" est affiché.
- Pour remplacer les fichiers locaux par les versions distantes, relancer avec `--update` (bash) ou `-UpdateLocalIfChanged:$true` (PowerShell).

Préférences enregistrées
- Le skill proposera la mise à jour au lieu d'appliquer automatiquement les modifications.
- Pas de diff détaillé; les fichiers distants sont récupérés tels quels et un simple indicateur de changement est affiché.

Contact / maintenance
- Documenter toute modification du skill ici.

---

