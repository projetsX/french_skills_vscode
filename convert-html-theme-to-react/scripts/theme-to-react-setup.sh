#!/bin/bash
# theme-to-react-setup.sh
# Quick setup script to initialize theme conversion
# Usage: bash theme-to-react-setup.sh bootstrap

THEME_NAME=${1:-bootstrap}
THEME_PATH=${2:-.}

echo "🎨 Setting up React theme conversion for: $THEME_NAME"

# Create directory structure
mkdir -p "src/assets/$THEME_NAME/css"
mkdir -p "src/assets/$THEME_NAME/js"
mkdir -p "src/assets/$THEME_NAME/images"
mkdir -p "src/components"
mkdir -p "src/hooks"

echo "✅ Created directory structure:"
echo "   src/assets/$THEME_NAME/"
echo "   ├── css/"
echo "   ├── js/"
echo "   └── images/"

echo ""
echo "📋 Next steps:"
echo "1. Copy theme CSS files to: src/assets/$THEME_NAME/css/"
echo "2. Copy theme JS files to: src/assets/$THEME_NAME/js/ (for reference)"
echo "3. Copy theme images to: src/assets/$THEME_NAME/images/"
echo ""
echo "4. Add imports to src/main.tsx:"
echo "   import './assets/$THEME_NAME/css/main.css'"
echo "   import './assets/$THEME_NAME/css/theme.css'"
echo ""
echo "5. Create React components in src/components/"
echo "6. Extract animations to src/hooks/useAnimation*.ts"
echo "7. Run 'npm run dev' and compare with original theme"
echo ""
echo "📖 Refer to the SKILL.md for detailed procedures"
