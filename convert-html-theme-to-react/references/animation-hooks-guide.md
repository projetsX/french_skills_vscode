# Animation Hooks Guide

Migration patterns for converting jQuery/JavaScript animations from theme files to React hooks.

## Common Animation Patterns

### 1. Fade In/Out Animation

**Original jQuery:**

```javascript
$(".element").fadeIn(300);
$(".element").fadeOut(300);
```

**React Hook Implementation:**

```typescript
// src/hooks/useAnimationFade.ts
import { useState, useCallback } from "react";

export const useAnimationFade = (initialOpacity = 0) => {
  const [isVisible, setIsVisible] = useState(initialOpacity === 1);
  const [opacity, setOpacity] = useState(initialOpacity);

  const fadeIn = useCallback((duration = 300) => {
    setIsVisible(true);
    const start = Date.now();

    const animate = () => {
      const progress = Math.min((Date.now() - start) / duration, 1);
      setOpacity(progress);
      if (progress < 1) requestAnimationFrame(animate);
    };

    requestAnimationFrame(animate);
  }, []);

  const fadeOut = useCallback((duration = 300) => {
    const start = Date.now();

    const animate = () => {
      const progress = Math.min((Date.now() - start) / duration, 1);
      setOpacity(1 - progress);
      if (progress < 1) {
        requestAnimationFrame(animate);
      } else {
        setIsVisible(false);
      }
    };

    requestAnimationFrame(animate);
  }, []);

  return { isVisible, opacity, fadeIn, fadeOut };
};
```

**Component Usage:**

```tsx
const { opacity, fadeIn, fadeOut } = useAnimationFade();

return (
  <>
    <button onClick={() => fadeIn(300)}>Fade In</button>
    <button onClick={() => fadeOut(300)}>Fade Out</button>
    <div style={{ opacity }} className="animated-element">
      Content
    </div>
  </>
);
```

### 2. Slide Animation

**Original jQuery:**

```javascript
$(".element").slideDown(300);
$(".element").slideUp(300);
```

**React Hook Implementation:**

```typescript
// src/hooks/useAnimationSlide.ts
import { useState, useCallback, useRef } from "react";

export const useAnimationSlide = () => {
  const [height, setHeight] = useState(0);
  const [isSliding, setIsSliding] = useState(false);
  const elementRef = useRef<HTMLDivElement>(null);

  const slideDown = useCallback((duration = 300) => {
    if (elementRef.current) {
      const fullHeight = elementRef.current.scrollHeight;
      setIsSliding(true);
      const start = Date.now();

      const animate = () => {
        const progress = Math.min((Date.now() - start) / duration, 1);
        setHeight(fullHeight * progress);
        if (progress < 1) requestAnimationFrame(animate);
      };

      requestAnimationFrame(animate);
    }
  }, []);

  const slideUp = useCallback((duration = 300) => {
    setIsSliding(true);
    const start = Date.now();
    const startHeight = elementRef.current?.scrollHeight || 0;

    const animate = () => {
      const progress = Math.min((Date.now() - start) / duration, 1);
      setHeight(startHeight * (1 - progress));
      if (progress < 1) requestAnimationFrame(animate);
      else setIsSliding(false);
    };

    requestAnimationFrame(animate);
  }, []);

  return { height, isSliding, slideDown, slideUp, elementRef };
};
```

### 3. Toggle Class Animation

**Original jQuery:**

```javascript
$(".element").toggleClass("is-active", 300);
$(".element").addClass("is-active");
$(".element").removeClass("is-active");
```

**React Implementation (using state + CSS classes):**

```typescript
// src/hooks/useClassToggle.ts
import { useState, useCallback } from "react";

export const useClassToggle = (initialState = false) => {
  const [isActive, setIsActive] = useState(initialState);

  const toggle = useCallback(() => {
    setIsActive((prev) => !prev);
  }, []);

  const addClass = useCallback(() => {
    setIsActive(true);
  }, []);

  const removeClass = useCallback(() => {
    setIsActive(false);
  }, []);

  return { isActive, toggle, addClass, removeClass };
};
```

**Component Usage:**

```tsx
const { isActive, toggle } = useClassToggle();

return (
  <div className={`theme-element ${isActive ? "is-active" : ""}`}>
    {/* CSS handles transition via: .theme-element.is-active { ... } */}
  </div>
);
```

### 4. Delay & Stagger Animation

**Original jQuery:**

```javascript
$(".item").each(function (i) {
  $(this)
    .delay(i * 100)
    .fadeIn(300);
});
```

**React Hook Implementation:**

```typescript
// src/hooks/useStaggerAnimation.ts
import { useState, useEffect } from "react";

export const useStaggerAnimation = (itemCount: number, delay = 100) => {
  const [visibleItems, setVisibleItems] = useState<Set<number>>(new Set());

  useEffect(() => {
    const timeouts: NodeJS.Timeout[] = [];

    for (let i = 0; i < itemCount; i++) {
      timeouts.push(
        setTimeout(() => {
          setVisibleItems((prev) => new Set(prev).add(i));
        }, i * delay),
      );
    }

    return () => timeouts.forEach(clearTimeout);
  }, [itemCount, delay]);

  const isVisible = (index: number) => visibleItems.has(index);

  return { isVisible, visibleItems };
};
```

### 5. Scroll Event Handler

**Original jQuery:**

```javascript
$(window).on("scroll", function () {
  if (window.scrollY > 100) {
    $(".navbar").addClass("is-scrolled");
  }
});
```

**React Hook Implementation:**

```typescript
// src/hooks/useScrollDetection.ts
import { useState, useEffect } from "react";

export const useScrollDetection = (threshold = 100) => {
  const [isScrolled, setIsScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > threshold);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, [threshold]);

  return { isScrolled };
};
```

## Conversion Guidelines

1. **State for visibility** - Use `useState` for show/hide logic
2. **requestAnimationFrame for smooth animation** - Don't use setInterval for animations
3. **Cleanup effects** - Always remove event listeners in useEffect cleanup
4. **CSS classes for styling** - Let theme CSS handle the actual appearance
5. **Ref for DOM measurement** - Use `useRef` to get element dimensions
6. **Extract to reusable hooks** - Don't repeat animation logic in components

## Performance Considerations

- Use `useCallback` to prevent unnecessary hook function recreations
- Add `key` to list items when using stagger animations
- Consider `useMemo` for expensive calculations
- Throttle scroll handlers in useScrollDetection for better performance
- Clean up intervals/timeouts to prevent memory leaks

## Testing Hooks

```typescript
import { renderHook, act } from "@testing-library/react";
import { useAnimationFade } from "./useAnimationFade";

test("fadeIn and fadeOut work", () => {
  const { result } = renderHook(() => useAnimationFade());

  act(() => {
    result.current.fadeIn(100);
  });

  expect(result.current.isVisible).toBe(true);

  act(() => {
    jest.advanceTimersByTime(100);
  });

  expect(result.current.opacity).toBe(1);
});
```
