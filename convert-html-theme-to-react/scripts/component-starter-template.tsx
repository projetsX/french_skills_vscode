/**
 * STARTER TEMPLATE: React Component from HTML Theme
 * 
 * Copy this template and customize for your specific component.
 * Delete this comment block when using.
 * 
 * Key points:
 * - Preserve all existing CSS class names exactly
 * - Props interface defines all customization points
 * - Use Tailwind or theme CSS classes only - NO custom CSS
 * - Add JSDoc comment explaining the component's role
 * - Import hooks for animations/state management
 */

import React, { useCallback, useState } from 'react'

/**
 * Component Props
 * Define all props with TypeScript interface
 * Include descriptions for complex types
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
 * Displays a theme component with title, description, and click handling.
 * Maps to original HTML markup 'component-class-name' from theme.
 * 
 * @example
 * ```tsx
 * <ThemeComponent
 *   title="My Title"
 *   description="My description"
 *   onClick={() => console.log('clicked')}
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
