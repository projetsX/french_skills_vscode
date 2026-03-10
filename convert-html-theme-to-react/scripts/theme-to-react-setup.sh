#!/bin/bash
# theme-to-react-setup.sh
# Script d'initialisation rapide pour démarrer la conversion de thème
# Utilisation : bash theme-to-react-setup.sh bootstrap

THEME_NAME=${1:-bootstrap}
THEME_PATH=${2:-.}

echo "🎨 Préparation de la conversion du thème React pour : $THEME_NAME"

# Create directory structure
mkdir -p "src/assets/$THEME_NAME/css"
mkdir -p "src/assets/$THEME_NAME/js"
mkdir -p "src/assets/$THEME_NAME/images"
mkdir -p "src/components"
mkdir -p "src/hooks"

echo "✅ Structure de répertoires créée :"
echo "   src/assets/$THEME_NAME/"
echo "   ├── css/"
echo "   ├── js/"
echo "   └── images/"

echo ""
echo "📋 Étapes suivantes :"
echo "1. Copier les fichiers CSS du thème vers : src/assets/$THEME_NAME/css/"
echo "2. Copier les fichiers JS du thème vers : src/assets/$THEME_NAME/js/ (à titre de référence)"
echo "3. Copier les images du thème vers : src/assets/$THEME_NAME/images/"
echo ""
echo "4. Ajouter les imports dans src/main.tsx :"
echo "   import './assets/$THEME_NAME/css/main.css'"
echo "   import './assets/$THEME_NAME/css/theme.css'"
echo ""
echo "5. Créer les composants React dans src/components/"
echo "6. Extraire les animations dans src/hooks/useAnimation*.ts"
echo "7. Lancer 'npm run dev' et comparer avec le thème original"
echo ""
echo "📖 Se référer à SKILL.md pour la procédure détaillée"
