import {
    FiUserPlus,
    FiTruck,
    FiCreditCard,
    FiSettings,
    FiLifeBuoy
} from "react-icons/fi";
import { FaRoute } from "react-icons/fa";

import "./page.css";

/**
 * ============================================================
 * QuickActions
 * ============================================================
 *
 * Centre des actions rapides.
 *
 * Ce composant permet d'accéder rapidement
 * aux principales pages du Back-Office.
 *
 * Dans la Version F1.0, les actions sont
 * simplement affichées.
 *
 * Dans les prochaines versions, elles
 * utiliseront React Router.
 *
 * ============================================================
 */

export default function QuickActions() {

    const actions = [

        {
            id: "users",
            title: "Nouvel Utilisateur",
            icon: FiUserPlus
        },

        {
            id: "trips",
            title: "Nouvel Annonce",
            icon: FaRoute
        },

        {
            id: "vehicles",
            title: "Véhicules",
            icon: FiTruck
        },

        {
            id: "transactions",
            title: "Paiements",
            icon: FiCreditCard
        },

        {
            id: "support",
            title: "Support",
            icon: FiLifeBuoy
        },

        {
            id: "settings",
            title: "Paramètres",
            icon: FiSettings
        }

    ];

    return (

        <section className="dashboard-widget">

            <div className="dashboard-widget-header">

                <h2>

                    Actions rapides

                </h2>

            </div>

            <div className="quick-actions-grid">

                {

                    actions.map((action) => {

                        const Icon = action.icon;

                        return (

                            <button

                                key={action.id}

                                type="button"

                                className="quick-action-button"

                            >

                                <Icon className="quick-action-icon" />

                                <span>

                                    {action.title}

                                </span>

                            </button>

                        );

                    })

                }

            </div>

        </section>

    );

}