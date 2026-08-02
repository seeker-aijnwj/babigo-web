/******************************************************************************
 * BabiGO
 * ----------------------------------------------------------------------------
 * QuickActions
 *
 * MVP v1.0
 *
 * Centre des actions principales de l'utilisateur.
 *
 * Le composant ne connaît ni React Router
 * ni Firebase.
 *
 * Les actions sont reçues sous forme de callbacks.
 ******************************************************************************/

import {
    FiUser,
    FiUserPlus,
    FiTruck,
    FiCreditCard,
    FiSettings,
    FiLifeBuoy,
    FiSearch
} from "react-icons/fi";

import {
    FaPlusCircle,
} from "react-icons/fa";

import { FaRoute } from "react-icons/fa";

import "./quick-actions.css";


export default function QuickActions({

    onCreateTrip,

    onMyTrips,

    onSearchTrips,

    onProfile,

    onSettings,

}) {

    /* =======================================================================
       ACTIONS
    ======================================================================= */

    const actions = [

        {

            id: "create-trip",
            title: "Publier un trajet",
            description: "Créer une nouvelle annonce",
            icon: FaPlusCircle,
            primary: true,
            callback: onCreateTrip
        },

        {

            id: "my-trips",

            title: "Mes trajets",

            description: "Voir mes annonces",

            icon: FaRoute,

            primary: false,

            callback: onMyTrips,

        },

        {

            id: "search",

            title: "Rechercher",

            description: "Trouver un trajet",

            icon: FiSearch,

            primary: false,

            callback: onSearchTrips,

        },

        {

            id: "profile",

            title: "Mon profil",

            description: "Mes informations",

            icon: FiUser,

            primary: false,

            callback: onProfile,

        },

        {

            id: "settings",

            title: "Paramètres",

            description: "Préférences",

            icon: FiSettings,

            primary: false,

            callback: onSettings,

        },

        {
            id: "create-user",
            title: "Nouvel Utilisateur",
            icon: FiUserPlus,
            callback:() => {},
        },

        {
            id: "vehicles",
            title: "Véhicules",
            icon: FiTruck,
            callback:() => {},
        },

        {
            id: "transactions",
            title: "Paiements",
            icon: FiCreditCard,
            callback:() => {},
        },

        {
            id: "support",
            title: "Support",
            icon: FiLifeBuoy,
            callback:() => {},
        },

    ];

    /* ==========================================================================
   CALLBACKS PAR DÉFAUT
   ========================================================================== */

    /**
     * Si une action n'est pas encore connectée,
     * elle ne provoque aucune erreur.
     */

    QuickActions.defaultProps = {

        onCreateTrip: () => {

            console.info(

                "Navigation vers 'Publier un trajet' à connecter."

            );

        },

        onMyTrips: () => {

            console.info(

                "Navigation vers 'Mes trajets' à connecter."

            );

        },

        onSearchTrips: () => {

            console.info(

                "Navigation vers 'Rechercher un trajet' à connecter."

            );

        },

        onProfile: () => {

            console.info(

                "Navigation vers 'Mon profil' à connecter."

            );

        },

        onSettings: () => {

            console.info(

                "Navigation vers 'Paramètres' à connecter."

            );

        },

    };

    const primaryAction = actions.find(

        (action) => action.primary

    );

    const secondaryActions = actions.filter(

        (action) => !action.primary

    );

    const PrimaryIcon = primaryAction.icon;

    /* =======================================================================
       RENDER
    ======================================================================= */


    return (

        <section className="dashboard-widget">

            {/* ==========================================================
                HEADER
            ========================================================== */}

            <div className="dashboard-widget-header">

                <h2>

                    Actions rapides

                </h2>

                <p>

                    Accédez rapidement aux principales fonctionnalités.

                </p>

            </div>

            {/* ==========================================================
                ACTION PRINCIPALE
            ========================================================== */}

            <button

                type="button"

                className="quick-action-primary"

                onClick={primaryAction.callback}

            >

                <div className="quick-action-primary-icon">

                    <PrimaryIcon />

                </div>

                <div className="quick-action-primary-content">

                    <h3>

                        {primaryAction.title}

                    </h3>

                    <p>

                        {primaryAction.description}

                    </p>

                </div>

            </button>

            {/* ==========================================================
                ACTIONS SECONDAIRES
            ========================================================== */}

            <div className="quick-actions-grid">

                {

                    secondaryActions.map((action) => {

                        const Icon = action.icon;

                        return (

                            <button

                                key={action.id}

                                type="button"

                                className="quick-action-button"

                                onClick={action.callback}

                            >

                                <Icon

                                    className="quick-action-icon"

                                />

                                <div>

                                    <strong>

                                        {action.title}

                                    </strong>

                                    <span>

                                        {action.description}

                                    </span>

                                </div>

                            </button>

                        );

                    })

                }

            </div>

            {/* ==========================================================
                FOOTER
            ========================================================== */}

            <div className="dashboard-widget-footer">

                <small>

                    D'autres fonctionnalités seront disponibles
                    dans les prochaines versions de BabiGO.

                </small>

            </div>

        </section>

    );

}