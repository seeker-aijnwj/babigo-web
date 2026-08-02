import { FiRefreshCw, FiSun, FiSunset, FiMoon } from "react-icons/fi";

import {

    FaSignOutAlt,

} from "react-icons/fa";

import "./page.css";

/**
 * ============================================================
 * WelcomeBanner
 * ============================================================
 *
 * Bannière d'accueil du Dashboard.
 *
 * Affiche :
 * - un message de bienvenue ;
 * - un résumé de la plateforme ;
 * - la date de dernière mise à jour ;
 * - un bouton d'actualisation.
 *
 * ============================================================
 */

export default function WelcomeBanner({

    stats,

    user,

    loading,

    refresh,

    onLogout,

    lastRefresh

}) {

    // Détermination de la configuration selon l'heure actuelle
    const getGreetingConfig = () => {
        const hour = new Date().getHours();

        // De 04h00 à 11h59
        if (hour >= 4 && hour < 12) {
            return { text: "Bonjour 👋", icon: FiSun };
        }
        // De 12h00 à 19h59
        if (hour >= 12 && hour < 20) {
            return { text: "Bonsoir 🌆", icon: FiSunset };
        }
        // De 20h00 à 03h59 (la nuit)
        return { text: "Bonne nuit 🌙", icon: FiMoon };
    };

    const { text: greetingText, icon: GreetingIcon } = getGreetingConfig();
    
    /* =======================================================================
       VALEURS
    ======================================================================= */

    const displayName =

        `${user?.firstName ?? ""} ${user?.lastName ?? ""}`.trim() ||

        "Utilisateur";

    const formatDate = (date) => {

        if (!date) {

            return "--";

        }

        return new Intl.DateTimeFormat(

            "fr-FR",

            {

                dateStyle: "medium",

                timeStyle: "short"

            }

        ).format(date);

    };

    /* =======================================================================
       LOGOUT
    ======================================================================= */

    async function handleLogout() {

        try {

            if (typeof onLogout === "function") {

                await onLogout();

            }

        }

        catch (exception) {

            console.error(

                "Erreur lors de la déconnexion :", 

                exception

            );

        }

    }

    return (

        <section className="welcome-banner">

            <div className="welcome-banner-left">

                <div className="welcome-badge">

                    <GreetingIcon />
                    <span>

                        {greetingText} {displayName}

                    </span>

                </div>

                <h1>

                    Bienvenue sur votre espace personnel

                </h1>

                {/*<p>

                    Pilotez votre plateforme de mobilité depuis un tableau
                    de bord <br /> moderne, rapide et conçu pour évoluer.

                </p>*/}

                <p>
                    Publiez vos trajets, gérez vos annonces et retrouvez
                    <br /> facilement vos réservations depuis votre espace personnel.
                </p>

                <small>

                    Dernière mise à jour :

                    {" "}

                    {loading

                        ? "Chargement..."

                        : formatDate(lastRefresh)}

                </small>

            </div>

            <div className="welcome-banner-right">

                <div className="welcome-summary">

                    <strong>

                        {stats?.overview?.users ?? 0}

                    </strong>

                    <span>

                        utilisateurs

                    </span>

                </div>

                <div className="welcome-summary">

                    <strong>

                        {stats?.overview?.trips ?? 0}

                    </strong>

                    <span>

                        trajets

                    </span>

                </div>

                <button

                    className="refresh-button"

                    type="button"

                    onClick={refresh}

                    disabled={loading}

                >

                    <FiRefreshCw />

                    <span>

                        {loading

                            ? "Actualisation..."

                            : "Actualiser"}

                    </span>

                </button>

                <button

                    className="refresh-button"

                    type="button"

                    onClick={handleLogout}

                    disabled={loading}

                >

                    <FaSignOutAlt />

                    <span>

                        {loading

                            ? "Déconnexion..."

                            : "Quitter"}

                    </span>

                </button>

            </div>

        </section>

    );

}