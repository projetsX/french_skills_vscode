/**
 * Hook pour [description claire de la responsabilité].
 * 
 * Gère:
 * - [aspect 1]
 * - [aspect 2]
 * 
 * Retourne:
 * - [state1]: [type et description]
 * - [state2]: [type et description]  
 * - [handler]: [description]
 * 
 * Exemple d'utilisation:
 * const [data, setData, isLoading, fetchData] = useCustomHook(initialValue);
 */

import { useState, useCallback, useEffect } from 'react';

interface UseCustomHookReturn {
  data: any;
  isLoading: boolean;
  error: Error | null;
  fetchData: (param?: string) => Promise<void>;
  resetData: () => void;
}

/**
 * Hook pour charger et gérer des données complexes.
 */
export function useCustomHook(
  initialData: any = null,
  dependencies: any[] = []
): UseCustomHookReturn {
  // ===== État =====
  const [data, setData] = useState(initialData);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  // ===== Callbacks =====
  const fetchData = useCallback(async (param?: string) => {
    setIsLoading(true);
    setError(null);
    
    try {
      // Logique de fetch/traitement
      // const response = await fetch(`/api/data?param=${param}`);
      // const result = await response.json();
      // setData(result);
      
      // Placeholder: remplacer par vraie logique
      setData({ loaded: true, param });
    } catch (err) {
      const errorMessage = err instanceof Error ? err : new Error(String(err));
      setError(errorMessage);
      console.error('Erreur dans useCustomHook:', errorMessage);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const resetData = useCallback(() => {
    setData(initialData);
    setError(null);
    setIsLoading(false);
  }, [initialData]);

  // ===== Effects =====
  useEffect(() => {
    // Optionnel: fetch automatique au montage
    // fetchData();
  }, [fetchData, ...dependencies]);

  // ===== Retour =====
  return {
    data,
    isLoading,
    error,
    fetchData,
    resetData,
  };
}

export default useCustomHook;
