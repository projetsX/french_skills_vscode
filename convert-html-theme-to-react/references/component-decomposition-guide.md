# Guide de décomposition des composants

Stratégie pour fractionner les gros composants de thème lorsqu'ils dépassent 600 lignes.

## Quand décomposer

Surveiller la taille des fichiers de composants et décomposer lorsque :

- Un fichier de composant dépasse 600 lignes
- Plusieurs responsabilités peuvent être séparées proprement
- Les sous-composants sont réutilisables indépendamment
- La logique d'état peut être extraite en hooks personnalisés

## Stratégie de décomposition

### Niveau 1 : Extraction simple (économie de 100–200 lignes)

**Before:**

```
CardComponent.tsx (650 lines)
├── JSX Header
├── JSX Body
└── JSX Footer
```

**After:**

```
CardComponent/
├── index.tsx (main export)
├── CardComponent.tsx (parent, 400 lines)
├── CardHeader.tsx (150 lines)
├── CardBody.tsx (150 lines)
└── CardFooter.tsx (100 lines)
```

### Niveau 2 : Extraction de logique (économie de 300+ lignes)

**Before:**

```
ComplexFormComponent.tsx (700 lines)
├── State management (150 lines)
├── Validation logic (100 lines)
├── Event handlers (150 lines)
└── JSX rendering (300 lines)
```

**After:**

```
ComplexFormComponent/
├── index.tsx (main export)
├── ComplexFormComponent.tsx (300 lines - JSX only)
├── useFormValidation.ts (100 lines - validation hook)
├── useFormState.ts (150 lines - state management)
├── FormField.tsx (100 lines - reusable field)
└── FormSection.tsx (100 lines - grouping)
```

## Modèle de structure de fichiers

Lors de la décomposition d'un composant, suivez cette structure :

```
src/components/FeatureName/
├── index.tsx                    # Re-exports main component
├── FeatureName.tsx              # Main container component
├── subComponents/
│   ├── SubComponent1.tsx
│   ├── SubComponent2.tsx
│   └── SubComponent3.tsx
├── hooks/
│   ├── useFeatureState.ts
│   ├── useFeatureLogic.ts
│   └── useFeatureAnimation.ts
└── types.ts                     # Shared TypeScript interfaces
```

## Exemple : décomposer une fonctionnalité de 700 lignes

### Structure originale

```tsx
// OLD: ProductCard.tsx (700 lines)
export const ProductCard: React.FC<ProductCardProps> = ({
  product,
  onSelect,
  onDelete,
}) => {
  // Image handling (50 lines)
  // Rating calculation (40 lines)
  // Add to cart logic (60 lines)
  // Animations state (40 lines)
  // Modal state (30 lines)
  // Price formatting (20 lines)
  // JSX rendering (460 lines)
};
```

### Decomposed Structure

**Step 1: Create directory and main export**

```typescript
// src/components/ProductCard/index.tsx
export { ProductCard } from "./ProductCard";
export type { ProductCardProps } from "./types";
```

**Step 2: Extract types**

```typescript
// src/components/ProductCard/types.ts
export interface Product {
  id: string;
  name: string;
  price: number;
  image: string;
  rating: number;
}

export interface ProductCardProps {
  product: Product;
  onSelect: (product: Product) => void;
  onDelete: (productId: string) => void;
}
```

**Step 3: Create state hook**

```typescript
// src/components/ProductCard/hooks/useProductCardState.ts
/**
 * useProductCardState
 *
 * Manages all state for ProductCard component including
 * animations, modals, and user interactions.
 */

import { useState, useCallback } from "react";

export const useProductCardState = () => {
  const [isHovered, setIsHovered] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [isAnimating, setIsAnimating] = useState(false);

  const handleHover = useCallback((hover: boolean) => {
    setIsHovered(hover);
  }, []);

  const openModal = useCallback(() => {
    setShowModal(true);
    setIsAnimating(true);
  }, []);

  const closeModal = useCallback(() => {
    setIsAnimating(false);
    setTimeout(() => setShowModal(false), 300);
  }, []);

  return {
    isHovered,
    showModal,
    isAnimating,
    handleHover,
    openModal,
    closeModal,
  };
};
```

**Step 4: Create logic hook**

```typescript
// src/components/ProductCard/hooks/useProductLogic.ts
/**
 * useProductLogic
 *
 * Handles product calculations: rating display, price formatting,
 * and UI state derived from product data.
 */

import { useMemo, useCallback } from "react";
import type { Product } from "../types";

export const useProductLogic = (product: Product) => {
  const formattedPrice = useMemo(() => {
    return new Intl.NumberFormat("fr-FR", {
      style: "currency",
      currency: "EUR",
    }).format(product.price);
  }, [product.price]);

  const ratingDisplay = useMemo(() => {
    return Math.round(product.rating * 2) / 2;
  }, [product.rating]);

  const ratingStars = useMemo(() => {
    return Array.from({ length: 5 }, (_, i) =>
      i < Math.floor(product.rating) ? "full" : "empty",
    );
  }, [product.rating]);

  const handleAddToCart = useCallback(() => {
    console.log(`Added ${product.name} to cart`);
  }, [product]);

  return {
    formattedPrice,
    ratingDisplay,
    ratingStars,
    handleAddToCart,
  };
};
```

**Step 5: Create sub-components**

```typescript
// src/components/ProductCard/subComponents/ProductImage.tsx
/**
 * ProductImage
 *
 * Displays product image with hover overlay effects.
 * Part of ProductCard feature for image handling separation.
 */

import React from 'react'
import type { Product } from '../types'

interface ProductImageProps {
  product: Product
  isHovered: boolean
  onOpenModal: () => void
}

export const ProductImage: React.FC<ProductImageProps> = ({
  product,
  isHovered,
  onOpenModal
}) => {
  return (
    <div className={`product-card__image-wrapper ${isHovered ? 'is-hovered' : ''}`}>
      <img
        src={product.image}
        alt={product.name}
        className="product-card__image"
      />
      <button
        className="product-card__zoom-btn"
        onClick={onOpenModal}
        aria-label="Zoom image"
      >
        <span className="product-card__zoom-icon" />
      </button>
    </div>
  )
}
```

```typescript
// src/components/ProductCard/subComponents/ProductInfo.tsx
/**
 * ProductInfo
 *
 * Displays product details: name, price, rating.
 * Part of ProductCard feature for content organization.
 */

import React from 'react'
import type { Product } from '../types'

interface ProductInfoProps {
  product: Product
  formattedPrice: string
  ratingStars: string[]
  ratingDisplay: number
}

export const ProductInfo: React.FC<ProductInfoProps> = ({
  product,
  formattedPrice,
  ratingStars,
  ratingDisplay
}) => {
  return (
    <div className="product-card__info">
      <h3 className="product-card__name">{product.name}</h3>

      <div className="product-card__rating">
        <div className="product-card__stars">
          {ratingStars.map((star, i) => (
            <span key={i} className={`star star--${star}`} />
          ))}
        </div>
        <span className="product-card__rating-value">{ratingDisplay}</span>
      </div>

      <p className="product-card__price">{formattedPrice}</p>
    </div>
  )
}
```

**Step 6: Create main component**

```typescript
// src/components/ProductCard/ProductCard.tsx
/**
 * ProductCard
 *
 * Main container component that orchestrates all sub-components
 * and state for displaying a product card with interactions.
 */

import React from 'react'
import { ProductImage } from './subComponents/ProductImage'
import { ProductInfo } from './subComponents/ProductInfo'
import { useProductCardState } from './hooks/useProductCardState'
import { useProductLogic } from './hooks/useProductLogic'
import type { ProductCardProps } from './types'

export const ProductCard: React.FC<ProductCardProps> = ({
  product,
  onSelect,
  onDelete
}) => {
  const cardState = useProductCardState()
  const logic = useProductLogic(product)

  const handleProductClick = () => {
    onSelect(product)
  }

  return (
    <article
      className={`product-card ${cardState.isHovered ? 'product-card--hovered' : ''}`}
      onMouseEnter={() => cardState.handleHover(true)}
      onMouseLeave={() => cardState.handleHover(false)}
    >
      <ProductImage
        product={product}
        isHovered={cardState.isHovered}
        onOpenModal={cardState.openModal}
      />

      <ProductInfo
        product={product}
        formattedPrice={logic.formattedPrice}
        ratingStars={logic.ratingStars}
        ratingDisplay={logic.ratingDisplay}
      />

      <div className="product-card__actions">
        <button
          className="product-card__btn product-card__btn--primary"
          onClick={handleProductClick}
        >
          View Details
        </button>
        <button
          className="product-card__btn product-card__btn--danger"
          onClick={() => onDelete(product.id)}
          aria-label="Delete product"
        >
          ×
        </button>
      </div>
    </article>
  )
}
```

## Résultat

- **Fichier original** : 700 lignes, difficile à parcourir
- **Nouvelle structure** :
  - ProductCard.tsx : 80 lignes
  - ProductImage.tsx : 35 lignes
  - ProductInfo.tsx : 45 lignes
  - useProductCardState.ts : 40 lignes
  - useProductLogic.ts : 60 lignes
  - index.tsx : 5 lignes
  - types.ts : 20 lignes

Chaque fichier est désormais ciblé, testable et sous 100 lignes. L'ensemble est bien organisé et maintenable.

## Matrice de décision

Utilisez ceci pour décider comment décomposer :

| Scenario                     | Strategy                        |
| ---------------------------- | ------------------------------- |
| Multiple JSX sections        | Extract to sub-components       |
| Complex state logic          | Extract to custom hook `useXxx` |
| Reusable calculations        | Extract to `useMemo` hook       |
| Event handlers chain         | Group in custom hook            |
| Large lists                  | Extract list item to component  |
| Conditional rendering blocks | Each gets own component         |
| Form with many fields        | Create `<FormField />` wrapper  |

## Éviter la sur-décomposition

**Ne pas créer un composant si :**

- Il ne contient que 2–3 lignes de JSX simple
- Il n'est utilisé qu'à un seul endroit localement
- Il ajoute de la verbosité d'import sans clarté

Exemple de **sur-décomposition à éviter** :

```tsx
// BAD - Too granular
<Title title={title} />          // Just renders <h1>
<Description text={description}/> // Just renders <p>
<Icon name={icon} />             // Just renders <span>
```

Exemple de **décomposition appropriée** :

```tsx
// GOOD - Clear separation of concerns
<ProductImage product={product} />
<ProductActions onDelete={onDelete} onSelect={onSelect} />
```
