/* ==========================================================
   BABIGO Admin
   users.css
   Version : 0.3.0 F1.0

   src/hooks/useDashboard.js
   
   Ce fichier fournit les données au Dashboard avec les états
========================================================== */

import { useCallback, useEffect, useState } from "react";

import DashboardService from "../database/services/dashboardService";

/**
 * ============================================================
 * useDashboard
 * ============================================================
 *
 * Hook personnalisé permettant aux composants React
 * d'accéder facilement aux données du Dashboard.
 *
 * Le hook est responsable de :
 *
 * - charger les statistiques
 * - gérer le chargement
 * - gérer les erreurs
 * - permettre un rafraîchissement manuel
 *
 * Les composants ne connaissent ni Firestore,
 * ni le Repository.
 *
 * ============================================================
 */

export default function useDashboard() {

    // ============================================================
    // ÉTATS
    // ============================================================

    const [stats, setStats] = useState(null);

    const [loading, setLoading] = useState(true);

    const [error, setError] = useState(null);

    const [lastRefresh, setLastRefresh] = useState(null);

    // ============================================================
    // CHARGEMENT
    // ============================================================

    const refresh = useCallback(async () => {

        setLoading(true);

        setError(null);

        try {

            const response =
                await DashboardService.getDashboardStats();

            if (!response.success) {

                throw response.error ??
                    new Error("Impossible de charger le Dashboard.");

            }

            setStats(response);

            setLastRefresh(new Date());

        }

        catch (err) {

            console.error(

                "[useDashboard]",

                err

            );

            setError(err);

        }

        finally {

            setLoading(false);

        }

    }, []);

    // ============================================================
    // CHARGEMENT INITIAL
    // ============================================================

    useEffect(() => {

        refresh();

    }, [refresh]);

    // ============================================================
    // RETOUR
    // ============================================================

    return {

        stats,

        loading,

        error,

        lastRefresh,

        refresh

    };

}