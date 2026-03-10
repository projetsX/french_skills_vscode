# Guide des hooks d'animation

Schémas de migration pour convertir les animations jQuery/JavaScript des fichiers de thème en hooks React.

## Modèles d'animation courants

### 1. Animation Fondu Entrée/Sortie

**jQuery original :**

```javascript
$(".element").fadeIn(300);
$(".element").fadeOut(300);
```

**Implémentation via hook React :**

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

**Utilisation dans un composant :**

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

### 2. Animation Glissement (Slide)

**jQuery original :**

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

### 3. Basculement de classe (Toggle Class)

**jQuery original :**

```javascript
$(".element").toggleClass("is-active", 300);
$(".element").addClass("is-active");
$(".element").removeClass("is-active");
```

**Implémentation React (utilisant state + classes CSS) :**

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

### 4. Animation avec délai et stagger

**jQuery original :**

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

### 5. Gestionnaire d'événement de défilement (scroll)

**jQuery original :**

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

## Directives de conversion

1. **État pour la visibilité** — Utiliser `useState` pour la logique show/hide
2. **requestAnimationFrame pour des animations fluides** — Ne pas utiliser `setInterval` pour les animations
3. **Nettoyage des effets** — Toujours enlever les listeners dans le retour de `useEffect`
4. **Classes CSS pour le style** — Laisser le CSS du thème gérer l'apparence
5. **Ref pour mesures DOM** — Utiliser `useRef` pour obtenir les dimensions d'un élément
6. **Extraire en hooks réutilisables** — Ne pas dupliquer la logique d'animation dans les composants

## Considérations de performance

- Utiliser `useCallback` pour éviter la recréation inutile de fonctions
- Ajouter une `key` aux éléments de liste lors de l'utilisation d'animations en stagger
- Envisager `useMemo` pour les calculs coûteux
- Limiter (throttle) les gestionnaires de scroll dans `useScrollDetection` pour de meilleures performances
- Nettoyer les intervals/timeouts pour éviter les fuites mémoire

## Tester les hooks

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
