/**
 * MODÈLE DE DÉMARRAGE : Composant React issu d'un thème HTML
 *
 * Copiez ce modèle et adaptez-le pour votre composant spécifique.
 * Supprimez ce bloc de commentaire lorsque vous l'utilisez.
 *
 * Points clés :
 * - Conserver exactement tous les noms de classes CSS existants
 * - L'interface des props définit tous les points de personnalisation
 * - Utiliser uniquement Tailwind ou les classes CSS du thème — PAS de CSS personnalisé
 * - Ajouter un commentaire JSDoc expliquant le rôle du composant
 * - Importer des hooks pour la gestion des animations/état
 */

import React, { useCallback, useState } from 'react'

/**
 * Props du composant
 * Définir toutes les props via une interface TypeScript
 * Inclure des descriptions pour les types complexes
 */
interface ThemeComponentProps {
    /** Main heading text */
    title: string

    /** Optional description or content */
    description?: string

    /** CSS classes to add (in addition to theme base classes) */
    className?: string

    /** Click handler - receives component ID/data */
    onClick?: (id: string) => void

    /** Whether component is disabled */
    disabled?: boolean

    /** Theme variant: 'primary' | 'secondary' | 'accent' */
    variant?: 'primary' | 'secondary' | 'accent'
}

/**
 * ThemeComponent
 *
 * Affiche un composant du thème avec titre, description et gestion du clic.
 * Correspond au balisage HTML original 'component-class-name' du thème.
 *
 * @example
 * ```tsx
 * <ThemeComponent
 *   title="Mon titre"
 *   description="Ma description"
 *   onClick={() => console.log('cliqué')}
 *   variant="primary"
 * />
 * ```
 */
export const ThemeComponent: React.FC<ThemeComponentProps> = ({
    title,
    description,
    className = '',
    onClick,
    disabled = false,
    variant = 'primary'
}) => {
    // State for component interactions
    const [isHovered, setIsHovered] = useState(false)
    const [isActive, setIsActive] = useState(false)

    // Event handlers
    const handleClick = useCallback(() => {
        if (!disabled && onClick) {
            onClick('component-id')
            setIsActive(true)
            setTimeout(() => setIsActive(false), 300)
        }
    }, [disabled, onClick])

    const handleMouseEnter = useCallback(() => {
        setIsHovered(true)
    }, [])

    const handleMouseLeave = useCallback(() => {
        setIsHovered(false)
    }, [])

    // Build class string preserving theme CSS class names
    const componentClass = [
        'component-class-name',         // Theme base class - REQUIRED, preserve exactly
        `component-class-name--${variant}`, // Theme variant class
        isHovered && 'is-hovered',      // Theme state class (exists in CSS)
        isActive && 'is-active',        // Theme state class (exists in CSS)
        disabled && 'is-disabled',      // Theme disabled state
        className                        // Additional custom classes if needed
    ]
        .filter(Boolean)
        .join(' ')

    return (
        <div
            className={componentClass}
            onClick={handleClick}
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
            role="button"
            tabIndex={disabled ? -1 : 0}
            aria-disabled={disabled}
        >
            {/* Header Section - from theme markup */}
            <div className="component-class-name__header">
                <h3 className="component-class-name__title">
                    {title}
                </h3>
            </div>

            {/* Content Section - from theme markup */}
            {description && (
                <div className="component-class-name__content">
                    <p className="component-class-name__description">
                        {description}
                    </p>
                </div>
            )}

            {/* Footer/Actions - from theme markup */}
            <div className="component-class-name__footer">
                <button
                    className="component-class-name__button"
                    onClick={handleClick}
                    disabled={disabled}
                    aria-label={`${title} action button`}
                >
                    Action
                </button>
            </div>
        </div>
    )
}

export default ThemeComponent
