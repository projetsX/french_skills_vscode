/**
 * STARTER TEMPLATE: Animation Hook for Theme Components
 *
 * Copy this template and customize for your specific animation.
 * Delete this comment block when using.
 *
 * Common patterns:
 * - Fade in/out
 * - Slide up/down/left/right
 * - Scale/zoom
 * - Rotate
 * - Toggle class visibility
 *
 * Key points:
 * - Use requestAnimationFrame for smooth animations
 * - Clean up timeouts/intervals in useEffect return
 * - Use useCallback to prevent unnecessary re-creation
 * - Return animation state and trigger functions
 */

import { useState, useCallback, useRef, useEffect } from "react";

/**
 * useThemeAnimation
 *
 * Manages smooth animation state for theme components.
 * Maps jQuery animations from original theme JS to React hooks.
 *
 * @param options Configuration object
 * @param options.duration Animation duration in milliseconds (default: 300)
 * @param options.delay Initial delay before animation starts (default: 0)
 * @param options.easing Easing function: 'linear' | 'ease-in' | 'ease-out' (default: 'ease-out')
 *
 * @returns Object with animation state and control functions
 *
 * @example
 * ```tsx
 * const { isAnimating, progress, play, pause, reset } = useThemeAnimation({
 *   duration: 500,
 *   easing: 'ease-out'
 * })
 *
 * // Use in component:
 * <div style={{ opacity: progress }} />
 * <button onClick={play}>Start</button>
 * ```
 */

interface UseThemeAnimationOptions {
  duration?: number;
  delay?: number;
  easing?: "linear" | "ease-in" | "ease-out" | "ease-in-out";
}

interface UseThemeAnimationReturn {
  isAnimating: boolean;
  progress: number; // 0 to 1
  play: () => void;
  pause: () => void;
  reset: () => void;
  reverse: () => void;
}

export const useThemeAnimation = (
  options: UseThemeAnimationOptions = {},
): UseThemeAnimationReturn => {
  const { duration = 300, delay = 0, easing = "ease-out" } = options;

  const [isAnimating, setIsAnimating] = useState(false);
  const [progress, setProgress] = useState(0);
  const [isReversing, setIsReversing] = useState(false);
  const animationRef = useRef<number | null>(null);
  const startTimeRef = useRef<number>(0);

  // Easing functions
  const getEasedProgress = useCallback(
    (rawProgress: number): number => {
      switch (easing) {
        case "linear":
          return rawProgress;
        case "ease-in":
          return rawProgress * rawProgress;
        case "ease-out":
          return 1 - (1 - rawProgress) * (1 - rawProgress);
        case "ease-in-out":
          return rawProgress < 0.5
            ? 2 * rawProgress * rawProgress
            : -1 + (4 - 2 * rawProgress) * rawProgress;
        default:
          return rawProgress;
      }
    },
    [easing],
  );

  // Animation loop - using useRef to handle recursion
  useEffect(() => {
    if (!isAnimating) return;

    const animate = () => {
      const now = Date.now();
      const elapsed = now - startTimeRef.current - delay;

      if (elapsed < 0) {
        // Still in delay phase
        animationRef.current = requestAnimationFrame(animate);
        return;
      }

      const rawProgress = Math.min(elapsed / duration, 1);
      const easedProgress = getEasedProgress(rawProgress);
      const finalProgress = isReversing ? 1 - easedProgress : easedProgress;

      setProgress(finalProgress);

      if (rawProgress < 1) {
        animationRef.current = requestAnimationFrame(animate);
      } else {
        setIsAnimating(false);
        setIsReversing(false);
      }
    };

    animationRef.current = requestAnimationFrame(animate);

    return () => {
      if (animationRef.current !== null) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, [isAnimating, duration, delay, isReversing, getEasedProgress]);

  // Play animation forward
  const play = useCallback(() => {
    if (animationRef.current !== null) {
      cancelAnimationFrame(animationRef.current);
    }
    setIsAnimating(true);
    setIsReversing(false);
    startTimeRef.current = Date.now();
  }, []);

  // Pause animation
  const pause = useCallback(() => {
    if (animationRef.current !== null) {
      cancelAnimationFrame(animationRef.current);
      animationRef.current = null;
    }
    setIsAnimating(false);
  }, []);

  // Reset to start
  const reset = useCallback(() => {
    pause();
    setProgress(0);
    setIsReversing(false);
  }, [pause]);

  // Play animation backward (reverse)
  const reverse = useCallback(() => {
    if (animationRef.current !== null) {
      cancelAnimationFrame(animationRef.current);
    }
    setIsAnimating(true);
    setIsReversing(true);
    startTimeRef.current = Date.now();
  }, []);

  // Cleanup
  useEffect(() => {
    return () => {
      if (animationRef.current !== null) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, []);

  return {
    isAnimating,
    progress,
    play,
    pause,
    reset,
    reverse,
  };
};

/**
 * EXAMPLE USAGE IN COMPONENT
 */

// example:
/*

import { useThemeAnimation } from './useThemeAnimation'

interface FadeElementProps {
  children: React.ReactNode
}

export const FadeElement: React.FC<FadeElementProps> = ({ children }) => {
  const animation = useThemeAnimation({
    duration: 500,
    easing: 'ease-out'
  })

  return (
    <div>
      <div
        style={{
          opacity: animation.progress,
          transition: 'none' // Animation handled by hook, not CSS
        }}
        className="animated-element"
      >
        {children}
      </div>

      <div className="animation-controls">
        <button onClick={animation.play}>Play</button>
        <button onClick={animation.pause}>Pause</button>
        <button onClick={animation.reverse}>Reverse</button>
        <button onClick={animation.reset}>Reset</button>
      </div>

      <div className="progress-bar">
        <div
          style={{
            width: `${animation.progress * 100}%`,
            height: '4px',
            backgroundColor: '#3b82f6',
            transition: 'width 0.05s linear'
          }}
        />
      </div>
    </div>
  )
}

*/

export default useThemeAnimation;
