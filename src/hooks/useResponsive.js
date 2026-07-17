import { useState, useEffect } from "react";

/**
 * Largeur maximale considérée comme mobile.
 */
const MOBILE_BREAKPOINT = 768;

/**
 * Hook permettant de connaître le type d'écran.
 */
export default function useResponsive() {

    /**
     * Vérifie si l'écran est mobile.
     */
    const getIsMobile = () => {

        return window.innerWidth <= MOBILE_BREAKPOINT;

    };

    /**
     * Etat principal.
     */
    const [isMobile, setIsMobile] = useState(getIsMobile());

    /**
     * Ecoute les changements de taille de fenêtre.
     */
    useEffect(() => {

        function handleResize() {

            setIsMobile(getIsMobile());

        }

        window.addEventListener("resize", handleResize);

        return () => {

            window.removeEventListener("resize", handleResize);

        };

    }, []);

    return {

        isMobile,

        isTablet: window.innerWidth > MOBILE_BREAKPOINT && window.innerWidth < 1024,

        isDesktop: window.innerWidth >= 1024

    };

}