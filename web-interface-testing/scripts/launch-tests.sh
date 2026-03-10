#!/bin/bash
# Script Bash - Aide au test d'interface web
# Usage: bash launch-tests.sh --page-path /contact --project-type vite --vite-port 5173

# Variables par défaut
PAGE_PATH="/"
PROJECT_TYPE="vite"
VITE_PORT=5173
PHP_DOMAIN=""

# Parser arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --page-path)
            PAGE_PATH="$2"
            shift 2
            ;;
        --project-type)
            PROJECT_TYPE="$2"
            shift 2
            ;;
        --vite-port)
            VITE_PORT="$2"
            shift 2
            ;;
        --php-domain)
            PHP_DOMAIN="$2"
            shift 2
            ;;
        *)
            echo "❌ Unknown option: $1"
            exit 1
            ;;
    esac
done

echo ""
echo "==========================================="
echo "Web Interface Testing - Helper Script"
echo "==========================================="
echo ""

# Valider inputs
if [ -z "$PAGE_PATH" ]; then
    echo "❌ ERROR: PagePath requis"
    echo "Usage: bash launch-tests.sh --page-path /contact --project-type vite --vite-port 5173"
    exit 1
fi

if [[ ! "$PROJECT_TYPE" =~ ^(vite|php)$ ]]; then
    echo "❌ ERROR: ProjectType doit être 'vite' ou 'php'"
    exit 1
fi

# Construire URL
FULL_URL=""

if [ "$PROJECT_TYPE" = "vite" ]; then
    FULL_URL="http://localhost:$VITE_PORT$PAGE_PATH"
    echo "✅ Type de projet: Vite (port $VITE_PORT)"
elif [ "$PROJECT_TYPE" = "php" ]; then
    if [ -z "$PHP_DOMAIN" ]; then
        echo "❌ ERROR: PhpDomain requis pour PHP projects"
        echo "Usage: bash launch-tests.sh --page-path /signup --project-type php --php-domain monsite"
        exit 1
    fi
    FULL_URL="https://$PHP_DOMAIN.loc$PAGE_PATH"
    echo "✅ Type de projet: PHP (domaine $PHP_DOMAIN.loc)"
fi

echo ""
echo "📄 Page cible: $PAGE_PATH"
echo "🔗 URL complète: $FULL_URL"
echo ""

# Afficher checklist de test
echo "Phases de test à exécuter:"
echo "  1. ✅ Vérifier accès (status 200)"
echo "  2. 🔴 Console DevTools (erreurs, warnings)"
echo "  3. ♿ Accessibilité WCAG (alt text, labels, hierarchy)"
echo "  4. 🎮 Inputs interactifs (forms, buttons, search)"
echo "  5. 📱 Ergonomie Desktop + Mobile (1920x1080, 375x812, 768x1024)"
echo "  6. ⚡ Performances (CWV, CPU, RAM)"
echo "  7. 📊 Résumé & Corrections"
echo ""

echo "💡 Instructions:"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "  1. Utiliser tools MCP Chrome DevTools (mcp_chromedevtool_*)"
echo "  2. Référence: $SCRIPT_DIR/../references/mcp-chrome-reference.md"
echo "  3. Checklist: $SCRIPT_DIR/../references/test-checklist.md"
echo ""

echo "🚀 Prêt à démarrer les tests!"
echo "   Appuyez sur [Enter] pour continuer..."
read

echo ""
echo "Aller à: $FULL_URL"
echo "Utiliser les tools MCP pour tester les phases 1-7"
echo ""
