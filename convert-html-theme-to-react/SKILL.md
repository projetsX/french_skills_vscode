---
name: convert-html-theme-to-react
description: 'Convert HTML/CSS theme templates into reusable React components. Use when: migrating theme files to React, preserving existing CSS structure, handling JavaScript animations with React hooks, decomposing large components.'
argument-hint: '[THEME_FOLDER_PATH] - Path to the HTML/CSS theme source files'
user-invocable: true
---

# Convert HTML Theme to React Components

Procedural workflow for migrating HTML/CSS themes into modular React components with preserved styling and hook-based animation logic.

## When to Use

- Importing a complete HTML/CSS theme into the React project
- Converting static HTML markup into reusable component library
- Migrating JavaScript/jQuery animations to React hooks
- Ensuring visual consistency with original theme design
- Need to decompose large component files into maintainable modules

## Prerequisites

- Source HTML/CSS theme files with complete asset directory structure
- Knowledge of original CSS class naming and theme layout
- Understanding of animations or interactions in the theme JavaScript

## Step-by-Step Procedure

### Phase 1: Asset Organization

1. **Create assets subdirectory** in `src/assets/`
   ```
   src/assets/
   ├── theme-name/
   │   ├── css/           # All CSS files from theme
   │   ├── js/            # Original JavaScript files (for reference)
   │   └── images/        # Theme demo images and icons
   ```

2. **Copy theme files** without modification
   - Copy all `.css` files → `assets/theme-name/css/`
   - Copy all `.js` files → `assets/theme-name/js/` (for reference only)
   - Copy all image assets → `assets/theme-name/images/`
   - Do NOT modify or rename CSS files at this stage

3. **Import CSS globally** in `src/main.tsx`
   ```tsx
   import './assets/theme-name/css/main.css'
   // ... other theme CSS imports
   ```

### Phase 2: HTML to React Component Conversion

1. **Analyze HTML structure** from theme files
   - Identify independent components (nav, card, modal, etc.)
   - Note CSS class dependencies
   - Document JavaScript interactions (click handlers, animations)

2. **Create component structure** respecting class names
   - Each component file in `src/components/`
   - Preserve all original CSS class names exactly
   - Use semantic HTML elements matching original theme
   - **Do NOT add custom CSS** — use existing theme classes only

3. **Component template example**
   ```tsx
   // src/components/ThemeCard/ThemeCard.tsx
   /**
    * ThemeCard - Reusable card component from theme
    * Maps to original HTML markup with theme CSS classes
    */
   
   import React from 'react'
   
   interface ThemeCardProps {
     title: string
     content: string
     className?: string
   }
   
   export const ThemeCard: React.FC<ThemeCardProps> = ({ 
     title, 
     content, 
     className = '' 
   }) => {
     return (
       <div className={`theme-card ${className}`}>
         <h3 className="theme-card__title">{title}</h3>
         <p className="theme-card__content">{content}</p>
       </div>
     )
   }
   ```

### Phase 3: JavaScript/jQuery to React Hooks Migration

1. **Identify animations and interactions** in original JS files
   - Click handlers (show/hide, toggle, expand)
   - Scroll/fade animations
   - Form submissions
   - Modal/popup interactions

2. **Create custom hooks** for reusable animation logic
   ```tsx
   // src/hooks/useThemeAnimation.ts
   /**
    * useThemeAnimation - Handle theme fade/slide animations
    * Maps original jQuery animations to React state
    */
   
   import { useState, useCallback } from 'react'

   interface UseThemeAnimationOptions {
     duration?: number
     triggerEvent?: 'click' | 'hover' | 'scroll'
   }

   export const useThemeAnimation = (
     options: UseThemeAnimationOptions = {}
   ) => {
     const { duration = 300 } = options
     const [isAnimating, setIsAnimating] = useState(false)

     const trigger = useCallback(() => {
       setIsAnimating(true)
       setTimeout(() => setIsAnimating(false), duration)
     }, [duration])

     return { isAnimating, trigger }
   }
   ```

3. **Apply hooks to components**
   ```tsx
   // Use in component:
   const { isAnimating, trigger } = useThemeAnimation({ duration: 500 })
   
   return (
     <button onClick={trigger}>
       <div className={`animated-element ${isAnimating ? 'is-active' : ''}`}>
         Content
       </div>
     </button>
   )
   ```

### Phase 4: Component Decomposition (if > 600 lines)

1. **Monitor component file size**
   - Keep individual component files under 600 lines max
   - Identify logic that can be extracted

2. **Create subdirectory for large components**
   ```
   src/components/
   ├── ComplexFeature/
   │   ├── index.tsx         # Parent container component
   │   ├── ComplexFeature.tsx # Main export
   │   ├── SubComponent1.tsx
   │   ├── SubComponent2.tsx
   │   └── useComplexLogic.ts
   ```

3. **Add header comment** to each sub-component
   ```tsx
   /**
    * SubComponent1
    * 
    * Part of ComplexFeature feature. Handles [specific responsibility].
    * Keeps parent component under 600-line limit.
    */
   ```

4. **Extract hooks** for reusable logic
   - State management logic → custom hooks
   - API calls / data fetching → service hooks
   - Animation controllers → animation hooks

### Phase 5: Quality Verification

Use the [Quality Checklist](./references/conversion-checklist.md) to verify:

- [ ] All CSS class names match original theme exactly
- [ ] No custom CSS added beyond theme files
- [ ] All animations migrated to hooks or component state
- [ ] Component file size under 600 lines (with sub-decomposition as needed)
- [ ] Each component has documentation comment
- [ ] All props properly typed with TypeScript
- [ ] No CSs collisions with other components
- [ ] Theme assets properly imported in main.tsx
- [ ] ESLint passes without warnings

## Example Output Structure

```
src/
├── assets/
│   └── bootstrap-theme/
│       ├── css/
│       │   ├── bootstrap.css
│       │   ├── theme.css
│       │   └── components.css
│       ├── js/
│       │   └── animations.js (reference only)
│       └── images/
├── components/
│   ├── Navigation/
│   │   └── Navigation.tsx
│   ├── HeroSection/
│   │   └── HeroSection.tsx
│   ├── CardGrid/
│   │   ├── index.tsx
│   │   ├── CardGrid.tsx
│   │   ├── Card.tsx
│   │   └── useCardAnimation.ts
│   └── Footer/
│       └── Footer.tsx
├── hooks/
│   ├── useThemeAnimation.ts
│   ├── useScrollAnimation.ts
│   └── useModalToggle.ts
└── main.tsx (imports all theme CSS)
```

## Common Patterns

### Handling CSS Class Toggling
```tsx
const [isActive, setIsActive] = useState(false)

return (
  <div className={`theme-element ${isActive ? 'is-active' : ''}`}>
    {/* Respects original theme's is-active CSS state */}
  </div>
)
```

### Event Handlers from JavaScript
```tsx
// Original: $('#element').on('click', function() { ... })
// React:
const handleClick = useCallback(() => {
  // animation or state change
}, [])

return <element onClick={handleClick} className="original-class" />
```

### Form Interactions
```tsx
const [formData, setFormData] = useState({})

const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  // Trigger validation or animations via CSS classes
}
```

## Tips & Best Practices

1. **Preserve naming** - Keep original CSS class names exactly as-is
2. **Immutable CSS** - Do not edit theme CSS files after import
3. **Test visuals** - Compare rendered components with original HTML theme
4. **Document animations** - Add comments explaining hook-based animation mappings
5. **Progressive enhancement** - Add React interactivity on top of stable CSS
6. **Type everything** - Use TypeScript interfaces for all props
7. **Monitor bundle** - Watch for CSS duplication from multiple theme imports

## Troubleshooting

### CSS Classes Not Applying
- Verify CSS import order in `main.tsx`
- Check class name spelling matches original exactly
- Ensure no CSS modules interfering with global styles

### Animations Not Working
- Review original JavaScript logic in reference files
- Map jQuery handlers to React hooks + setState
- Test with browser DevTools animation timeline

### Component Too Large
- Use file size breakdown to identify extractable logic
- Create hooks for state management
- Split presentation from container logic
