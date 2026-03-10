# CSS Naming Conventions

## Why Naming Matters

- **Maintainability**: Clear names make code easier to understand
- **Scalability**: Consistent patterns prevent chaos as CSS grows
- **Collaboration**: Team members know what each class does
- **Documentation**: Names serve as inline documentation

## Popular Naming Conventions

### 1. BEM (Block Element Modifier) - RECOMMENDED

**Pattern:** `.block__element--modifier`

**Structure:**
- **Block**: Standalone component (`.card`)
- **Element**: Part of a block (`.card__header`)
- **Modifier**: A variation (`.card--featured`)

**Example:**
```css
/* Block */
.button { }

/* Elements */
.button__icon { }
.button__text { }

/* Modifiers */
.button--primary { }
.button--large { }
.button--disabled { }

/* Combined */
.button--primary.button--large { }
```

**Benefits:**
- Clear hierarchy
- Prevents specificity issues
- Easy to maintain
- Self-documenting

**Drawbacks:**
- Longer class names
- Can look cluttered in HTML

**MDN Reference:** [Organizing CSS](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Organizing_your_CSS)

---

### 2. SMACSS (Scalable and Modular Architecture for CSS)

**Categories:**
- **Base**: HTML elements (no classes)
- **Layout**: Major components (`.l-sidebar`)
- **Module**: Reusable components (`.button`, `.card`)
- **State**: Conditions (`.is-active`, `.is-disabled`)
- **Theme**: Visual variations (`.theme-dark`)

**Example:**
```css
/* Base */
html, body { }

/* Layout */
.l-container { }
.l-sidebar { }

/* Modules */
.button { }
.card { }

/* State */
.is-active { }
.is-disabled { }

/* Theme */
.theme-dark .button { }
```

**Benefits:**
- Scalable structure
- Clear categorization
- Prevents style conflicts

**Reference:** [SMACSS](http://smacss.com/)

---

### 3. OOCSS (Object-Oriented CSS)

**Principle:** Separate structure from skin

**Pattern:**
```css
/* Structure (repeated classes) */
.box {
  padding: 10px;
  margin: 10px;
  border: 1px solid #ddd;
}

/* Skin (styling variations) */
.box--primary {
  background-color: #007bff;
  color: white;
}

.box--success {
  background-color: #28a745;
  color: white;
}
```

**Benefits:**
- Reduces code duplication
- Promotes reusability
- Smaller CSS files

**Drawbacks:**
- Can lead to many small classes
- Markup can become cluttered

---

### 4. Utility-First (Tailwind-Inspired)

**Pattern:** Small, single-purpose classes

**Example:**
```css
.mt-4 { margin-top: 1rem; }
.p-2 { padding: 0.5rem; }
.bg-blue { background-color: #007bff; }
.text-white { color: white; }
```

**Usage:**
```html
<div class="mt-4 p-2 bg-blue text-white">Content</div>
```

**Benefits:**
- Fast development
- Consistent spacing/sizing
- Small CSS bundle if using PurgeCSS

**Drawbacks:**
- Markup can become verbose
- Requires build tool setup

---

## General Naming Best Practices

### ✅ DO

```css
/* Descriptive, semantic names */
.nav-primary { }
.button-submit { }
.error-message { }

/* Hyphenated for readability */
.main-navigation { }
.primary-button { }

/* Avoid adjectives alone */
.alert-danger { } /* Better than .red or .alert1 */

/* Grouping related classes */
.card { }
.card__header { }
.card__body { }
.card__footer { }
```

### ❌ DON'T

```css
/* Avoid presentation-based names */
.red { }           /* Use .error or .alert-danger */
.big { }           /* Use .large or specific purpose */
.margin-10 { }     /* Don't hardcode values in names */

/* Avoid cryptic abbreviations */
.btn-xs-prim { }   /* Use .button--small--primary */

/* Avoid IDs for styling */
#header { }        /* Use classes instead */

/* Avoid numbers without context */
.box1, .box2 { }   /* Use .box--primary, .box--secondary */

/* Avoid multiple hyphens without structure */
.main-nav-ul-li { } /* Use .nav-link or simpler names */
```

---

## Organizing by Functionality

**Group related classes together:**

```css
/* Typography */
.heading-1 { }
.heading-2 { }
.body-text { }

/* Buttons */
.button { }
.button--primary { }
.button--secondary { }

/* Forms */
.form-group { }
.input-field { }
.checkbox { }

/* Layout */
.container { }
.row { }
.column { }

/* Cards/Modules */
.card { }
.card__title { }
.card__content { }

/* Navigation */
.nav-main { }
.nav-link { }
.nav-link--active { }

/* Utilities */
.text-center { }
.mb-4 { }
.hidden { }
```

---

## State Classes

Always prefix state classes with `.is-` or `.has-`:

```css
.is-active { }
.is-disabled { }
.is-visible { }
.is-hidden { }
.has-error { }
.has-success { }
```

---

## Responsive Modifiers

Make screen-size variants clear:

```css
/* Mobile-first approach */
.button { }

/* Tablet and up */
@media (min-width: 768px) {
  .button--tablet { }
}

/* Desktop and up */
@media (min-width: 1024px) {
  .button--desktop { }
}

/* Or use suffix convention */
.button--sm { }  /* small */
.button--md { }  /* medium */
.button--lg { }  /* large */
```

---

## CSS Custom Properties (Variables) Naming

```css
:root {
  /* Colors */
  --color-primary: #007bff;
  --color-success: #28a745;
  --color-error: #dc3545;

  /* Spacing */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 32px;

  /* Typography */
  --font-size-base: 16px;
  --font-size-sm: 14px;
  --font-size-lg: 20px;
  --font-weight-normal: 400;
  --font-weight-bold: 700;

  /* Border radius */
  --border-radius-sm: 4px;
  --border-radius-md: 8px;
  --border-radius-lg: 12px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
}
```

---

## Recommended Approach

**For most projects, combine:**
- **BEM** for component naming (clear, predictable)
- **Utility classes** for common patterns (spacing, text utilities)
- **State classes** with `.is-` prefix
- **CSS variables** for theming and constants

**Example:**
```css
.card {
  dark-background: var(--bg-dark);
  padding: var(--spacing-md);
}

.card--featured {
  border-left: 4px solid var(--color-primary);
}

.card.is-disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Utility */
.mt-4 {
  margin-top: var(--spacing-lg);
}
```

See MDN: [Organizing CSS](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Organizing_your_CSS)
