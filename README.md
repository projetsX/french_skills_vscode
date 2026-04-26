# French Skills VSCode

Collection de skills et scripts pour l'intégration avec Claude Desktop, GitHub Copilot / VS Code ou autre IDE. 
Ce dépôt contient des outils, guides et modèles pour aider au refactoring CSS, à la conversion de thèmes HTML vers React, aux tests d'interface web, et autres tâches connexes.

## Structure

- `cleanup-unused-css/` : outils et scripts pour identifier et nettoyer le CSS inutilisé d'un site.
- `convert-html-theme-to-react/` : guides et templates pour migrer un thème HTML/CSS vers des composants React.
- `react-component-refactoring/` : bonnes pratiques et templates pour découper et refactorer des composants React.
- `refactor-css-mdn/` : recommandations basées sur MDN pour moderniser et améliorer des feuilles de style.
- `upgrade-htmx-2-to-4/` : ressources pour migrer de HTMX v2 à v4.
- `web-interface-testing/` : checklist et scripts pour tester l'accessibilité et les performances UI.
- `beer-css-director/` : Utilisation de la librairie BeerCSS.

## Utilisation

POUR VSCODE :

1. Sous windows, copier le dossier des skills dans votre dossier de profil user de VSCODE. EX : C:\Users\nom_utilisateur\AppData\Roaming\Code\User\copilot\skills
2. VS Code chargera automatiquement les skills quand vous les appellerez (ex : /refactor-css-mdn)

POUR CLAUDE DESKTOP :

1. Aller dans le menu "Compétences"
2. Choisir Aller dans > Créer une compétence > Téléverser une compétence
3. Choisir la compétence du sous dossier "/zip" du repo contenant les skills au format ZIP que vous souhaitez importer

IMPORTANT : 
- Certains skills nécessitent le serveur MCP context7, voir ici pour l'installation : https://github.com/upstash/context7#installation mais aussi le serveur MCP de Chrome, 
voici ici l'installation : https://developer.chrome.com/blog/chrome-devtools-mcp?hl=fr
- Le skill `creer-utilisateurs-test-php` nécessite la librairie PHP 'DelightPHP' ([text](https://github.com/delight-im/php-auth))

## Contribuer

Les contributions sont bienvenues : ouvrez une issue pour discuter d'un changement, ou créez une pull request décrivant la modification et le dossier impacté.

## Contact

Pour toute question, ouvrez une issue dans le dépôt.
