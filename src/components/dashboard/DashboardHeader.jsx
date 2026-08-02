/******************************************************************************
 * BabiGO
 * ----------------------------------------------------------------------------
 * DashboardHeader
 *
 * MVP v1.0
 *
 * Partie 1
 *
 * - Imports
 * - Props
 ******************************************************************************/

import React from "react";

import {

    FaSignOutAlt,

    FaUserCircle,

} from "react-icons/fa";

import logo from "../../assets/images/icons/Icon-192.png";

export default function DashboardHeader({

    user,

    onLogout,

}) {

    /* =======================================================================
       VALEURS
    ======================================================================= */

    const displayName =

        user?.fullName ||

        `${user?.firstName ?? ""} ${user?.lastName ?? ""}`.trim() ||

        "Utilisateur";

    /* =======================================================================
       ROLE UTILISATEUR
    ======================================================================= */

    function getRoleLabel(roleValue) {

        switch (roleValue) {

            case "driver":

                return "Conducteur";

            case "passenger":

                return "Passager";

            case "fleetManager":

                return "Gestionnaire de flotte";

            case "support":

                return "Support";

            case "admin":

                return "Administrateur";

            default:

                return "Utilisateur";

        }

    }

    const userRole = getRoleLabel(user?.role);

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

    /* =======================================================================
       MISE A JOUR DU ROLE
    ======================================================================= */

    // Remplace simplement {role} par {userRole}
    // dans le JSX de la Partie 2.

    // Et remplace également :

    // onClick={onLogout}

    // par :

    // onClick={handleLogout}

    /* =======================================================================
       RENDER
    ======================================================================= */

    return (

        <header className="dashboard-header">

            {/* ==============================================================
                LOGO
            ============================================================== */}

            <div className="dashboard-header-brand">

                <img

                    src={logo}

                    alt="BabiGO"

                    className="dashboard-header-logo"

                />

                <div className="dashboard-header-brand-text">

                    <h1>

                        BabiGO

                    </h1>

                    <span>

                        Tableau de bord

                    </span>

                </div>

            </div>

            {/* ==============================================================
                UTILISATEUR
            ============================================================== */}

            <div className="dashboard-header-user">

                <div className="dashboard-header-avatar">

                    <FaUserCircle />

                </div>

                <div className="dashboard-header-user-info">

                    <h2>

                        Bonjour {displayName} 👋

                    </h2>

                    <span>

                        {userRole}

                    </span>

                </div>

            </div>

            {/* ==============================================================
                ACTIONS
            ============================================================== */}

            <div className="dashboard-header-actions">

                <button

                    type="button"

                    className="dashboard-logout-button"

                    onClick={handleLogout}

                >

                    <FaSignOutAlt />

                    <span>

                        Déconnexion

                    </span>

                </button>

            </div>

        </header>

    )

}