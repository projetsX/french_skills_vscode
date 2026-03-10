# Common CSS Improvements with MDN Best Practices

## 1. Replace Float Layouts with Flexbox

**Before (Deprecated Pattern):**
```css
.container {
  overflow: hidden;
}

.column {
  float: left;
  width: 33.333%;
  padding: 10px;
}

.column:last-child {
  float: right;
}
```

**After (Modern Approach - MDN Recommended):**
```css
.container {
  display: flex;
  gap: 10px;
}

.column {
  flex: 1;
}
```

**Why:** Flexbox is more maintainable, handles edge cases better, and improves accessibility. See MDN: [CSS Flexible Box Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout)

---

## 2. Use CSS Variables Instead of Repetition

**Before:**
```css
.button {
  border-radius: 4px;
  padding: 12px 24px;
  background-color: #007bff;
  color: white;
  font-size: 14px;
}

.button-alt {
  border-radius: 4px;
  padding: 12px 24px;
  background-color: #28a745;
  color: white;
  font-size: 14px;
}

.button-secondary {
  border-radius: 4px;
  padding: 12px 24px;
  background-color: #6c757d;
  color: white;
  font-size: 14px;
}
```

**After (MDN Recommended):**
```css
:root {
  --border-radius: 4px;
  --padding-button: 12px 24px;
  --font-size-button: 14px;
  --color-primary: #007bff;
  --color-success: #28a745;
  --color-secondary: #6c757d;
  --color-text-light: white;
}

.button {
  border-radius: var(--border-radius);
  padding: var(--padding-button);
  background-color: var(--color-primary);
  color: var(--color-text-light);
  font-size: var(--font-size-button);
}

.button-alt {
  background-color: var(--color-success);
}

.button-secondary {
  background-color: var(--color-secondary);
}
```

**Why:** CSS custom properties improve maintainability and allow dynamic theming. See MDN: [CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)

---

## 3. Remove Vendor Prefixes (Usually Not Needed)

**Before (Outdated):**
```css
.box {
  -webkit-transform: translateX(10px);
  -moz-transform: translateX(10px);
  -ms-transform: translateX(10px);
  -o-transform: translateX(10px);
  transform: translateX(10px);
  
  -webkit-border-radius: 8px;
  -moz-border-radius: 8px;
  border-radius: 8px;
}
```

**After (Modern - Vendor Prefixes No Longer Needed):**
```css
.box {
  transform: translateX(10px);
  border-radius: 8px;
}
```

**Why:** Most modern browsers support standard CSS without prefixes. Check [caniuse.com](https://caniuse.com/) for specific browser support. MDN provides browser compatibility tables.

---

## 4. Simplify and Consolidate Selectors

**Before (Complex/Repetitive):**
```css
.main-nav ul li a {
  color: #333;
  text-decoration: none;
  padding: 10px 15px;
  display: block;
}

.main-nav ul li a:hover {
  background-color: #f0f0f0;
}

.main-nav ul li a.active {
  background-color: #007bff;
  color: white;
}
```

**After (Simplified):**
```css
.nav-link {
  color: #333;
  text-decoration: none;
  padding: 10px 15px;
  display: block;
  transition: background-color 0.2s ease;
}

.nav-link:hover {
  background-color: #f0f0f0;
}

.nav-link.active {
  background-color: #007bff;
  color: white;
}
```

**Why:** Reduced specificity and clearer naming make CSS more maintainable. See MDN: [CSS Selectors](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Selectors)

---

## 5. Use CSS Grid for Complex Layouts

**Before (Floats/Positioning):**
```css
.layout {
  position: relative;
}

.sidebar {
  float: left;
  width: 25%;
}

.content {
  margin-left: 25%;
}

.footer {
  clear: both;
}
```

**After (CSS Grid):**
```css
.layout {
  display: grid;
  grid-template-columns: 1fr 3fr;
  gap: 20px;
}

.footer {
  grid-column: 1 / -1;
}
```

**Why:** CSS Grid is more powerful, flexible, and easier to maintain. See MDN: [CSS Grid Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)

---

## 6. Replace Inline Styles with Classes

**Before:**
```html
<button style="background-color: blue; color: white; padding: 10px 15px; border: none; border-radius: 4px;">
  Click me
</button>
```

**After:**
```html
<button class="btn btn-primary">Click me</button>
```

```css
.btn {
  padding: 10px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary {
  background-color: blue;
  color: white;
}
```

**Why:** Separation of concerns, easier maintenance, better reusability. See MDN: [CSS Best Practices](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks)

---

## 7. Use Shorthand Properties

**Before (Long-form):**
```css
.box {
  margin-top: 10px;
  margin-right: 15px;
  margin-bottom: 10px;
  margin-left: 15px;
  
  padding-top: 5px;
  padding-right: 10px;
  padding-bottom: 5px;
  padding-left: 10px;
  
  border-width: 1px;
  border-style: solid;
  border-color: #ddd;
}
```

**After (Shorthand):**
```css
.box {
  margin: 10px 15px;
  padding: 5px 10px;
  border: 1px solid #ddd;
}
```

**Why:** Reduces code verbosity and improves readability. See MDN: [CSS Shorthand Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Shorthand_properties)

---

## 8. Replace Clearfix with Modern Layout

**Before (Outdated Hack):**
```css
.container::after {
  content: "";
  display: table;
  clear: both;
}
```

**After (Modern - No Longer Needed):**
```css
/* Use Flexbox or Grid instead */
.container {
  display: flex;
  flex-wrap: wrap;
}
```

**Why:** Flexbox and Grid handle layout naturally without clearfix hacks. See MDN: [CSS Layout](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout)

---

## 9. Improve Class Naming (BEM Convention)

**Before (Unclear naming):**
```css
.btn { }
.btn-1 { }
.btn.big { }
.btn.big:hover { }
.btn.big.red { }
```

**After (BEM Convention):**
```css
.button { }
.button--primary { }
.button--large { }
.button--large:hover { }
.button--large--alert { }
```

**Why:** Consistent naming makes CSS easier to understand and maintain. See: [BEM Naming Convention](http://getbem.com/)

---

## 10. Remove Deprecated Properties

| Deprecated | Modern Replacement | MDN Link |
|-----------|-------------------|----------|
| `float` (for layout) | Flexbox or CSS Grid | [CSS Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_layout) |
| `position: fixed` (complete layout) | Sticky positioning or Grid | [CSS Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/position) |
| Table layouts | Flexbox or CSS Grid | [Grids](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout) |
| Filter hacks (IE) | Remove entirely | Remove IE-specific code |
| Vendor prefixes (most) | Standard properties | [Can I Use](https://caniuse.com/) |

---

## Performance Tips

1. **Reduce Specificity**: Use class selectors instead of ID selectors
2. **Avoid Universal Selectors**: `*` selector can impact performance
3. **Use Efficient Selectors**: Right-to-left matching (browsers read selectors backwards)
4. **Consolidate Media Queries**: Group related breakpoints
5. **Remove Unused CSS**: Delete dead code regularly

See MDN: [CSS Performance](https://developer.mozilla.org/en-US/docs/Learn/Performance/CSS)
