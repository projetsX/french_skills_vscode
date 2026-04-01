# Best Practices & Troubleshooting

Do's and don'ts for theme-to-React conversions.

## DO's ✅

- **Preserve CSS class names** - Copy them exactly, no renames
- **Test visually** - Compare side-by-side with original HTML theme
- **Document assumptions** - Add comments about original theme behavior
- **Use TypeScript** - Type all props, state, hook parameters
- **Import CSS globally** - Load theme styles in `main.tsx` or root component
- **Version control assets** - Commit all copied theme files
- **Review CSS specificity** - Ensure no conflicts with other styles
- **Create hooks** - Reuse animation/state logic across components
- **Add JSDoc comments** - Document complex hooks and components

## DON'Ts ❌

- **Don't modify theme CSS files** - Edit only if fixing genuine bugs
- **Don't add extra CSS** - Use existing theme classes exclusively
- **Don't use CSS Modules** - Global theme CSS won't work with CSS Modules
- **Don't manipulate DOM directly** - Use React state and props
- **Don't forget cleanup** - Add return statements in useEffect hooks
- **Don't hoist all state to parent** - Keep component state local when possible
- **Don't create massive Components** - Monitor file size and decompose early
- **Don't skip TypeScript** - Use proper types instead of `any`

## Common Issues & Solutions

### Issue: CSS Classes Not Applying

**Symptom**: Styles don't show up despite correct class names

**Solutions**:

1. Check CSS file import order in `main.tsx`
2. Verify class name spelling exactly matches theme CSS
3. Check for CSS specificity conflicts with other loaded styles
4. Ensure CSS files are relative paths in assets folder

```tsx
// main.tsx - Correct import order
import "./assets/theme-name/css/reset.css"; // Reset first
import "./assets/theme-name/css/variables.css"; // Variables
import "./assets/theme-name/css/components.css"; // Components
import "./assets/theme-name/css/theme.css"; // Theme
import "./index.css"; // App styles last
```

### Issue: Animations Not Smooth

**Symptom**: Animations stutter or don't work

**Solutions**:

1. Use `requestAnimationFrame` instead of `setInterval`
2. Check for triggering multiple re-renders
3. Wrap animation functions in `useCallback`
4. Verify cleanup is happening in useEffect

```tsx
// GOOD - Smooth animation
const animate = useCallback(() => {
  const start = Date.now();

  const frame = () => {
    const progress = (Date.now() - start) / duration;
    setOpacity(progress);
    if (progress < 1) requestAnimationFrame(frame);
  };

  requestAnimationFrame(frame);
}, []);

// BAD - Choppy animation
setInterval(() => {
  setOpacity((prev) => prev + 0.01);
}, 16);
```

### Issue: Component Has Memory Leak Issues

**Symptom**: Console warns about memory leaks when unmounting

**Solutions**:

1. Always clean up event listeners
2. Clear timeouts/intervals in useEffect return
3. Cancel animations on unmount

```tsx
// GOOD - With cleanup
useEffect(() => {
  const handler = () => {
    /* ... */
  };
  window.addEventListener("scroll", handler);

  return () => {
    window.removeEventListener("scroll", handler);
  };
}, []);

// BAD - No cleanup
useEffect(() => {
  window.addEventListener("scroll", () => {
    /* ... */
  });
}, []);
```

### Issue: Component File Too Large

**Symptom**: Single component exceeds 600 lines

**Solutions**:

1. Extract sub-components → separate files
2. Extract hooks → separate `useXxx.ts` files
3. Extract types → separate `types.ts` file
4. Use component directory pattern with index.tsx

```
Before: ComponentName.tsx (800 lines)

After:
ComponentName/
├── index.tsx (export)
├── ComponentName.tsx (300 lines)
├── SubComponent1.tsx
├── SubComponent2.tsx
├── useComponentLogic.ts
└── types.ts
```

### Issue: TypeScript Errors with Props

**Symptom**: Props not being recognized, lots of type errors

**Solutions**:

1. Define prop interfaces clearly
2. Export interfaces from types file
3. Use specific types, avoid `any`
4. Enable strict TypeScript mode

```tsx
// GOOD - With types
interface CardProps {
  title: string;
  onClick: (id: string) => void;
  className?: string;
}

export const Card: React.FC<CardProps> = ({
  title,
  onClick,
  className = "",
}) => {
  // Implementation
};

// BAD - With any
export const Card: React.FC<any> = (props) => {
  // Implementation
};
```

### Issue: Performance Degradation

**Symptom**: Page slows down with many theme components

**Solutions**:

1. Use `React.memo` for components that don't need frequent updates
2. Use `useMemo` for expensive calculations
3. Lazy load theme CSS that's not immediately needed
4. Analyze bundle size of theme assets

```tsx
// GOOD - Memoized to prevent re-renders
export const ThemeCard = React.memo(({ title, content }: Props) => {
  return <div className="theme-card">{title}</div>;
});

// GOOD - Memoized calculation
const memoizedValue = useMemo(() => {
  return expensiveCalculation(data);
}, [data]);
```

### Issue: Responsive Design Breaking

**Symptom**: Layout doesn't adapt to mobile/tablet

**Solutions**:

1. Verify CSS media queries are in imported theme files
2. Test at actual breakpoints
3. Check viewport meta tag in HTML
4. Ensure base font-size is set correctly

```html
<!-- index.html - Required for responsive -->
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
```

## Validation Checklist Before Deployment

- [ ] Run `npm run lint` → 0 errors
- [ ] Run `npm run build` → completes without errors
- [ ] Open DevTools → no console errors or warnings
- [ ] Check network tab → all CSS/JS loaded properly
- [ ] Test animations → smooth and responsive
- [ ] Test on mobile → responsive layout works
- [ ] Lighthouse audit → Core Web Vitals good
- [ ] Visual regression → matches original theme design

## Debugging Tools

### Inspector (DevTools)

1. Right-click element → Inspect
2. Check if correct classes applied
3. Review computed styles
4. Look for conflicting CSS rules

### React Dev Tools

1. Install React DevTools extension
2. Check component props in Elements tab
3. Profile rendering performance
4. Track state changes

### Performance Tab

1. DevTools → Performance tab
2. Record interaction
3. Look for long tasks and rendering bottlenecks
4. Identify animation frame drops

## Performance Metrics

Track these for theme components:

- **First Contentful Paint (FCP)**: < 1.8s
- **Largest Contentful Paint (LCP)**: < 2.5s
- **Cumulative Layout Shift (CLS)**: < 0.1
- **Time to Interactive (TTI)**: < 3.8s
- **CSS bundle size**: < 50KB (after gzip)

Use Lighthouse audit: `npm run build && npm run preview`

## Testing Strategies

### Visual Regression Testing

1. Take screenshots of original HTML theme
2. Take screenshots of React components
3. Compare pixel-by-pixel
4. Document any intentional differences

### Interaction Testing

```typescript
// Example: Testing component interaction
import { render, screen, userEvent } from '@testing-library/react'
import { Card } from './Card'

test('Card click handler called with correct data', async () => {
  const handleClick = vi.fn()
  render(<Card onClick={handleClick} />)

  await userEvent.click(screen.getByRole('button'))
  expect(handleClick).toHaveBeenCalled()
})
```

### Animation Testing

```typescript
// Test animation state changes
test("Animation completes successfully", async () => {
  const { result } = renderHook(() => useAnimationFade());

  act(() => {
    result.current.fadeIn(100);
  });

  expect(result.current.isVisible).toBe(true);
});
```

## Getting Help

- Check theme CSS files for original class behaviors
- Reference original HTML markup for structure
- Review browser console for React/TypeScript errors
- Use React DevTools to inspect component state
- Test in browser DevTools Network tab for CSS loading issues
