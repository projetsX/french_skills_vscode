# MDN Web Docs Best Practices Guide

## Overview

This guide provides a curated list of MDN best practices for CSS refactoring, with direct references to the official Mozilla documentation.

## Essential MDN Topics

### 1. CSS Layout Methods

**Primary Reference:** https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/

The foundation of modern CSS. Choose the right layout method:

- **Display Property** (https://developer.mozilla.org/en-US/docs/Web/CSS/display)
  - `block`, `inline`, `inline-block`, `flex`, `grid`, `contents`
  - Avoid outdated `float` for layout purposes

- **Flexbox** (https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout)
  - Use for one-dimensional layouts (rows OR columns)
  - Superior to floats and inline-block for alignment
  - Properties: `flex-direction`, `justify-content`, `align-items`, `gap`
  - When to use: Navigation menus, button groups, card layouts

- **CSS Grid** (https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)
  - Use for two-dimensional layouts (rows AND columns)
  - More powerful than Flexbox for complex layouts
  - Properties: `grid-template-columns`, `grid-template-rows`, `gap`, `grid-auto-flow`
  - When to use: Page layouts, dashboard grids, complex component arrangements

- **Positioning** (https://developer.mozilla.org/en-US/docs/Web/CSS/position)
  - `static` (default)
  - `relative` (relative to normal flow)
  - `absolute` (removed from normal flow, positioned relative to parent)
  - `fixed` (fixed to viewport)
  - `sticky` (hybrid of relative and fixed)
  - Use with caution; prefer layout methods for structure

### 2. CSS Selectors & Performance

**Reference:** https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Selectors

- **Selector Types:**
  - Type selectors: `div`, `p` (broad, use carefully)
  - Class selectors: `.button` (preferred for styling)
  - ID selectors: `#main` (high specificity, avoid for styling)
  - Attribute selectors: `[type="checkbox"]`
  - Pseudo-classes: `:hover`, `:focus`, `:active`
  - Pseudo-elements: `::before`, `::after`

- **Performance Tips:**
  - Avoid excessive specificity
  - Keep selectors short
  - Avoid universal selector `*` in critical paths
  - Prefer class selectors over element selectors

### 3. CSS Custom Properties (Variables)

**Reference:** https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties

```css
:root {
  --primary-color: #007bff;
  --spacing-unit: 8px;
}

.button {
  background-color: var(--primary-color);
  padding: calc(var(--spacing-unit) * 2);
}
```

**Benefits:**
- Dynamic theming
- Reduced repetition
- Easier maintenance
- Cascading support (can override per scope)

### 4. Specificity & Cascade

**Reference:** https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity

**Specificity Order (lowest to highest):**
1. Type selectors (1 point)
2. Class selectors (10 points)
3. ID selectors (100 points)
4. Inline styles (1000 points)

**Best Practice:** Keep specificity low and consistent
- Use classes for styling, not IDs
- Avoid `!important` (use only as last resort)
- Prefer specific class names over high specificity

### 5. Box Model

**Reference:** https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model

- Use `box-sizing: border-box;` globally for predictable sizing
- Understand: `content` → `padding` → `border` → `margin`
- Use shorthand: `margin: 10px 15px;` (top/bottom left/right)

```css
* {
  box-sizing: border-box;
}
```

### 6. Responsive Design

**Reference:** https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design

- **Mobile-first approach**: Start with mobile styles, enhance with media queries
- **Flexible layouts**: Use relative units (`%`, `em`, `rem`) instead of fixed pixels
- **Media queries**: 
  ```css
  @media (min-width: 768px) {
    .container { width: 750px; }
  }
  ```
- **Viewport meta tag**: Required for responsive design
  ```html
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  ```

### 7. Color & Contrast

**Reference:** https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#colors

- Use named colors or hex: `#007bff` or `rgb(0, 123, 255)`
- Modern color spaces: `oklch()`, `lab()` (better color manipulation)
- Check contrast ratios for accessibility (WCAG 2.1)
- Example: `color: oklch(50% 0.2 280);`

### 8. Typography

**Reference:** https://developer.mozilla.org/en-US/docs/Learn/CSS/Styling_text

- Use system fonts or web-safe fonts
- `font-family`: Use fallback chains
  ```css
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  ```
- `font-size`: Use relative units (`rem`, `em`) for scalability
- `line-height`: Typically 1.5-1.6 for readability
- `letter-spacing`: Use sparingly
- Web fonts: Use `@font-face` or services like Google Fonts

### 9. Animations & Transitions

**Reference:** https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations

- Use CSS animations for continuous motion
- Use CSS transitions for state changes
- Avoid animating expensive properties (`width`, `height`, `position`)
- Animate `transform` and `opacity` for better performance

```css
.button {
  transition: background-color 0.3s ease, transform 0.3s ease;
}

.button:hover {
  background-color: #0056b3;
  transform: translateY(-2px);
}
```

### 10. Accessibility

**Reference:** https://developer.mozilla.org/en-US/docs/Learn/Accessibility

- Ensure sufficient color contrast (WCAG AA: 4.5:1 for text)
- Support keyboard navigation (`:focus` states)
- Don't remove focus outlines without providing alternatives
- Use semantic HTML with appropriate ARIA attributes
- Test with screen readers

```css
.button:focus {
  outline: 2px solid #007bff;
  outline-offset: 2px;
}
```

## Deprecated & Outdated Patterns to Remove

| Pattern | Why Remove | Replacement |
|---------|-----------|------------|
| `float` (layout) | Inflexible for alignment | Flexbox or CSS Grid |
| Vendor prefixes (most) | No longer necessary | Standard properties |
| `position: absolute` (layout) | Removed from flow | CSS Grid or Flexbox |
| Table layouts | Semantic/structural | CSS Grid |
| Clearfix hacks | Obsolete | Flexbox or CSS Grid |
| IE-specific hacks | IE not supported | Remove entirely |
| Inline styles | Poor maintainability | CSS classes |

## Key Reference Domains

- **Official MDN**: https://developer.mozilla.org/en-US/docs/Web/CSS
- **CSS Reference**: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference
- **Learning Guide**: https://developer.mozilla.org/en-US/docs/Learn/CSS
- **Browser Compatibility**: https://caniuse.com/

## Context7 Optimization Tips

When using Context7 to access MDN documentation:

1. **Specific queries**: Instead of "CSS best practices", query "CSS Grid layout modern pages"
2. **Problem-focused**: Query "CSS selector performance", not "CSS properties"
3. **Version-aware**: Specify browser targets if relevant
4. **Bundle size**: Request 5000-8000 tokens for comprehensive guides

Example effective queries:
- "CSS custom properties for theming"
- "Flexbox vs CSS Grid when to use each"
- "CSS selectors performance optimization"
- "Modern CSS layout techniques replacing floats"
- "Accessibility with focus states"

## Tools & Validators

- **W3C CSS Validator**: https://jigsaw.w3.org/css-validator/
- **MDN Browser Compatibility**: https://developer.mozilla.org/en-US/docs/Learn/CSS
- **CSS Linter (Stylelint)**: https://stylelint.io/
- **PostCSS**: Automated CSS transformations
- **PurgeCSS**: Remove unused CSS

## Conclusion

Modern CSS is powerful and flexible. By following MDN best practices:
- Your CSS becomes more maintainable
- Layouts are more robust and responsive
- Performance improves
- Accessibility is built-in
- Team collaboration is easier

Always refer to MDN for the authoritative standard and browser compatibility information.
