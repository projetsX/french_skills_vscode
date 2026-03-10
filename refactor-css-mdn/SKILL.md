---
name: refactor-css-mdn
description: 'Refactor CSS files using MDN Web Docs best practices. Use when: improving CSS code quality, modernizing styles, removing deprecated patterns, simplifying class names, eliminating repetition, following Mozilla standards.'
argument-hint: 'Path to the CSS file to refactor'
user-invocable: true
disable-model-invocation: false
---

# Refactor CSS with MDN Best Practices

Analyze and refactor CSS files following Mozilla MDN standards, automatically creating backups and leveraging MCP context7.

## When to Use

- Improve CSS code quality and readability
- Modernize and simplify selectors
- Remove deprecated or outdated patterns
- Eliminate repetitive and redundant rules
- Standardize naming conventions
- Optimize for performance
- Align with current best practices

## Procedure

### 1. Prepare the CSS File

- Provide the path to the CSS file to refactor
- Confirm the file exists and is accessible
- Locate the file in your project

### 2. Create a Backup

Automatically creates a timestamped backup of the original CSS:
- Backup stored in the same directory with suffix: `.backup-YYYYMMDD-HHMMSS.css`
- Use [backup script](./scripts/backup-css.ps1) if manual backup needed
- Backup allows safe rollback if refactoring results are unsatisfactory

### 3. Analyze CSS Issues

The refactoring identifies and addresses:

- **Class naming problems**: Poorly named, unclear, or inconsistent conventions
- **Simplifiable rules**: Overly complex selectors that can be streamlined
- **Deprecated properties**: Outdated CSS features replaced by modern alternatives
- **Repetitive declarations**: Duplicate rules across multiple selectors
- **Performance issues**: Inefficient selectors, unused utilities, heavy calculations
- **Compatibility concerns**: Browser-specific prefixes that are no longer needed

### 4. Consult MDN Web Docs (Context7)

Use the MCP context7 server to access MDN Web Docs documentation:

- **Primary method**: Use `mcp_io_github_ups_resolve-library-id` and `mcp_io_github_ups_get-library-docs` tools
- **Library ID**: `/mdn` (automatically resolved to MDN Web Docs)
- **Search strategy**: Target specific CSS topics to minimize token usage
  - Example queries: `"CSS Grid layout best practices"`, `"Flexbox over floats"`, `"CSS Variables vs preprocessor`
  - Specify exact CSS features when possible (e.g., `gap` property, `container queries`)
- **Token efficiency**: Request 4000-8000 tokens per documentation call to balance detail and cost

### 5. Fallback Documentation Sources

If Context7 is unavailable:

#### Option A: Direct Context7 URL (Recommended Fallback)
```
https://context7.com/mdn/content/llms.txt?topic=[SEARCH_TERMS]&tokens=[MAX_TOKENS]
```

Examples:
- `https://context7.com/mdn/content/llms.txt?topic=CSS+positioning&tokens=6000`
- `https://context7.com/mdn/content/llms.txt?topic=modern+CSS+features&tokens=8000`
- `https://context7.com/mdn/content/llms.txt?topic=CSS+selectors+performance&tokens=5000`

#### Option B: Official MDN Website
- Primary: https://developer.mozilla.org/fr/docs/Web/CSS
- Specific topics: https://developer.mozilla.org/fr/docs/Web/CSS/[feature_name]

### 6. Refactor the CSS

Based on MDN best practices:

1. **Replace deprecated patterns** with modern equivalents
   - Example: `float` layouts → Flexbox or Grid
   - Example: Vendor prefixes removal (generally no longer needed)
   
2. **Simplify selectors** for better performance and readability
   - Reduce specificity where possible
   - Rename classes using consistent conventions
   - Group related rules logically

3. **Eliminate repetition**
   - Combine similar rules using CSS variables
   - Use shorthand properties
   - Extract common patterns

4. **Modernize the syntax**
   - Use CSS custom properties (variables)
   - Adopt modern layout methods (Grid, Flexbox)
   - Implement logical properties for internationalization

5. **Improve naming conventions**
   - Use clear, semantic class names (e.g., `.button--primary` not `.btn-1`)
   - Follow a consistent naming scheme (BEM, SMACSS, etc.)
   - Document intent in comments where needed

### 7. Generate Refactoring Report

Create a summary document including:
- List of changes made
- Why each change follows MDN best practices
- Before/after comparisons of key sections
- Links to relevant MDN documentation
- Recommendations for further improvements

### 8. Review and Validate

- Compare refactored CSS with original (diff view)
- Test in browser to ensure styling is unchanged
- Verify selectors still match their targets
- Check for any unintended visual changes
- See [validation checklist](./references/refactoring-checklist.md)

### 9. Deploy or Rollback

**Deploy**: Replace the original CSS file with refactored version

**Rollback**: If issues occur, restore from backup:
```powershell
# PowerShell: Restore from backup
$backup = Get-ChildItem -Path "path/to/style.backup-*.css" | Sort-Object -Descending | Select-Object -First 1
Copy-Item -Path $backup.FullName -Destination "path/to/style.css" -Force
```

## Key MDN Concepts to Reference

- **CSS Layout**: Grid vs Flexbox vs Floats vs Positioning
- **CSS Variables**: Modern state management for styles
- **Selectors Performance**: Specificity and selector efficiency
- **Browser Support**: Modern feature compatibility
- **Property Shorthands**: Reducing code verbosity
- **Logical Properties**: Better internationalization support
- **Color Spaces**: Modern color notation (oklch, lab, etc.)

## Reference Materials

- [MDN CSS Best Practices Guide](./references/mdn-best-practices.md)
- [CSS Refactoring Checklist](./references/refactoring-checklist.md)
- [Common CSS Improvements](./references/common-improvements.md)
- [Naming Conventions](./references/naming-conventions.md)

## Scripts

- [Create Backup](./scripts/backup-css.ps1) - Manually create timestamped backup
- [Generate Report](./scripts/generate-report.ps1) - Create refactoring summary document

## Tips

1. **Start small**: Refactor one section at a time to identify patterns
2. **Test frequently**: Run visual regression tests after each major change
3. **Document decisions**: Keep notes on why specific changes were made
4. **Consider maintenance**: Prioritize readability and maintainability over brevity
5. **Use tools**: Leverage CSS linters and validators to catch issues
