/******************************************************************************
 * BabiGO
 * ----------------------------------------------------------------------------
 * Dashboard
 *
 * MVP v1.0
 *
 * Partie 1
 *
 * - Imports
 * - Hooks
 * - États
 ******************************************************************************/

import React, {

    useEffect,

    useState,

} from "react";

import useAuth from "../../hooks/useAuth";

import DashboardHeader from "../../components/dashboard/DashboardHeader";

import DashboardProfile from "../../components/dashboard/DashboardProfile";

import DashboardActions from "../../components/dashboard/DashboardActions";

import DashboardTrips from "../../components/dashboard/DashboardTrips";

import "./dashboard.css";

export default function Dashboard() {

    /* =======================================================================
       AUTH
    ======================================================================= */

    const {

        currentUser,

        logout,

    } = useAuth();

    /* =======================================================================
       ÉTATS
    ======================================================================= */

    const [

        loading,

        setLoading,

    ] = useState(true);

    const [

        user,

        setUser,

    ] = useState(null);

    const [

        trips,

        setTrips,

    ] = useState([]);

    const [

        error,

        setError,

    ] = useState("");

    /* =======================================================================
       INITIALISATION
    ======================================================================= */

    useEffect(() => {

        async function initializeDashboard() {

            try {

                setLoading(true);

                setError("");

                if (!currentUser) {

                    return;

                }

                /*
                 * Les données utilisateur et les trajets
                 * seront chargés au Sprint M2
                 * via UserRepository et TripRepository.
                 */

                setUser(currentUser);

                setTrips([]);

            }

            catch (exception) {

                console.error(exception);

                setError(

                    "Impossible de charger votre tableau de bord."

                );

            }

            finally {

                setLoading(false);

            }

        }

        initializeDashboard();

    }, [

        currentUser,

    ]);

    /* =======================================================================
    RAFRAÎCHISSEMENT DES DONNÉES
    ======================================================================= */

    async function refreshDashboard() {

        try {

            setLoading(true);

            setError("");

            if (!currentUser) {

                setUser(null);

                setTrips([]);

                return;

            }

            /*
             * Sprint M2
             * ----------
             * Nous remplacerons cette partie par :
             *
             * const profile = await UserRepository.getById(currentUser.uid);
             * const userTrips = await TripRepository.getUserTrips(currentUser.uid);
             *
             * setUser(profile);
             * setTrips(userTrips);
             */

            setUser(currentUser);

            setTrips([]);

        }

        catch (exception) {

            console.error(exception);

            setError(

                "Impossible d'actualiser le tableau de bord."

            );

        }

        finally {

            setLoading(false);

        }

    }

    /* =======================================================================
       CALLBACKS
    ======================================================================= */

    function handleTripCreated() {

        refreshDashboard();

    }

    function handleTripUpdated() {

        refreshDashboard();

    }

    function handleTripDeleted() {

        refreshDashboard();

    }


    /* =======================================================================
    LOADING
    ======================================================================= */

    if (loading) {

        return (

            <main className="dashboard-page">

                <div className="dashboard-loading">

                    <div className="dashboard-spinner" />

                    <h2>

                        Chargement...

                    </h2>

                    <p>

                        Préparation de votre espace personnel.

                    </p>

                </div>

            </main>

        );

    }

    /* =======================================================================
       ERREUR
    ======================================================================= */

    if (error) {

        return (

            <main className="dashboard-page">

                <div className="dashboard-error">

                    <h2>

                        Oups !

                    </h2>

                    <p>

                        {error}

                    </p>

                    <button

                        className="dashboard-primary-button"

                        onClick={() => window.location.reload()}

                    >

                        Réessayer

                    </button>

                </div>

            </main>

        );

    }

    /* =======================================================================
       RENDER
    ======================================================================= */


    return (

        <main className="dashboard-page">

            <div className="dashboard-container">

                {/* ======================================================
                        PROFIL UTILISATEUR
                    ====================================================== */}

                    <DashboardHeader

                        user={user}

                        logout={logout}

                    />

                {/* ==========================================================
                    CONTENU
                ========================================================== */}

                <section className="dashboard-content">

                    {/* ======================================================
                        PROFIL UTILISATEUR
                    ====================================================== */}

                    <DashboardProfile

                        user={user}

                        logout={logout}

                    />

                    {/* ======================================================
                        ACTIONS RAPIDES
                    ====================================================== */}

                    <DashboardActions

                        user={user}

                        onTripCreated={handleTripCreated}

                    />

                    {/* ======================================================
                        MES TRAJETS
                    ====================================================== */}

                    <DashboardTrips

                        user={user}

                        trips={trips}

                        onTripUpdated={handleTripUpdated}

                        onTripDeleted={handleTripDeleted}

                    />

                </section>

            </div>

        </main>

    );

}