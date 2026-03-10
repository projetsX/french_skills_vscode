/**
 * MODÈLE DE DÉMARRAGE : Hook d'animation pour composants de thème
 *
 * Copiez ce modèle et adaptez-le pour votre animation spécifique.
 * Supprimez ce bloc de commentaire lorsque vous l'utilisez.
 *
 * Modèles courants :
 * - Fondu (fade in/out)
 * - Glissement (slide up/down/left/right)
 * - Mise à l'échelle/zoom
 * - Rotation
 * - Basculement de visibilité de classe
 *
 * Points clés :
 * - Utiliser requestAnimationFrame pour des animations fluides
 * - Nettoyer timeouts/intervals dans le return de useEffect
 * - Utiliser useCallback pour éviter les re-créations inutiles
 * - Retourner l'état d'animation et les fonctions de contrôle
 */

import { useState, useCallback, useRef, useEffect } from "react";

/**
 * useThemeAnimation
 *
 * Gère l'état d'animation fluide pour les composants du thème.
 * Mappe les animations jQuery du JS du thème vers des hooks React.
 *
 * @param options Objet de configuration
 * @param options.duration Durée de l'animation en millisecondes (par défaut : 300)
 * @param options.delay Délai initial avant le démarrage de l'animation (par défaut : 0)
 * @param options.easing Fonction d'easing : 'linear' | 'ease-in' | 'ease-out' (par défaut : 'ease-out')
 *
 * @returns Objet avec l'état d'animation et les fonctions de contrôle
 *
 * @example
 * ```tsx
 * const { isAnimating, progress, play, pause, reset } = useThemeAnimation({
 *   duration: 500,
 *   easing: 'ease-out'
 * })
 *
 * // Utilisation dans un composant :
 * <div style={{ opacity: progress }} />
 * <button onClick={play}>Démarrer</button>
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
