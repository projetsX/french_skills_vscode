# Theme to React Conversion Checklist

Complete this checklist after each conversion to ensure quality and consistency.

## Asset Setup

- [ ] Created `src/assets/[theme-name]/css/` directory
- [ ] Created `src/assets/[theme-name]/js/` directory (reference only)
- [ ] Created `src/assets/[theme-name]/images/` directory
- [ ] All CSS files copied without modification
- [ ] All JavaScript files copied to reference folder
- [ ] All images copied with correct folder structure
- [ ] CSS imports added to `src/main.tsx`

## Component Structure

- [ ] Main components created in `src/components/`
- [ ] Component names follow PascalCase convention
- [ ] Each component has defined TypeScript interface for props
- [ ] All props properly typed (no `any` types)

## CSS Class Preservation

- [ ] All original CSS class names preserved exactly
- [ ] No custom CSS added beyond theme files
- [ ] No class name changes or renaming
- [ ] CSS specificity respected from original theme
- [ ] Tested visual consistency with original HTML theme

## Animation & Interaction Migration

- [ ] JavaScript animations documented in hooks
- [ ] jQuery handlers converted to React event handlers
- [ ] Custom hooks created for reusable animation logic
- [ ] useState or useCallback used appropriately
- [ ] No direct DOM manipulation outside of React

## Component Size & Organization

- [ ] Created sub-components for files approaching 600 lines
- [ ] Created subdirectories with index.tsx for complex features
- [ ] Each sub-component has header documentation comment
- [ ] Extracted animation/state logic into useXxx hook files
- [ ] Parent component imports are clean and organized

## Code Quality

- [ ] No ESLint warnings or errors
- [ ] TypeScript compiler passes without errors
- [ ] All components properly exported in index files
- [ ] No console errors or warnings in browser
- [ ] Accessibility attributes preserved (alt, role, aria-\*)

## Documentation

- [ ] Each component has header documentation comment
- [ ] Hooks documented with JSDoc comments
- [ ] Props interfaces include descriptions
- [ ] Animation behavior explained in comments
- [ ] Created examples in Storybook if applicable

## Testing

- [ ] Rendered components visually match original theme
- [ ] All animations and interactions functional
- [ ] Responsive breakpoints working correctly
- [ ] tested in different browsers (Chrome, Firefox, Safari)
- [ ] No memory leaks in hooks (cleanup functions added)

## Performance

- [ ] CSS files loaded efficiently (no duplication)
- [ ] Images optimized (no oversized assets)
- [ ] React components don't cause unnecessary re-renders
- [ ] Node modules properly tree-shaken in build

## Final Verification

- [ ] `npm run dev` starts without errors
- [ ] `npm run build` completes successfully
- [ ] `npm run lint` shows no errors
- [ ] Visual regression testing passed
- [ ] Ready for code review and merge
