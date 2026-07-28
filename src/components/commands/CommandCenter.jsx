import {
    FiUsers,
    FiTruck,
    FiMap,
    FiCreditCard,
    FiLifeBuoy,
    FiSettings,
    FiClock,
    FiSearch
} from "react-icons/fi";

import "./command.css";

const items = [

    {
        icon: FiUsers,
        title: "Utilisateurs",
        description: "Gérer les utilisateurs"
    },

    {
        icon: FiMap,
        title: "Trajets",
        description: "Consulter les trajets"
    },

    {
        icon: FiTruck,
        title: "Véhicules",
        description: "Gérer les véhicules"
    },

    {
        icon: FiCreditCard,
        title: "Paiements",
        description: "Voir les paiements"
    },

    {
        icon: FiLifeBuoy,
        title: "Support",
        description: "Centre d'assistance"
    },

    {
        icon: FiSettings,
        title: "Paramètres",
        description: "Configuration"
    }

];

export default function CommandCenter() {

    return (

        <div className="command-overlay">

            <div className="command-dialog">

                <div className="command-search-header">

                    <FiSearch />

                    <input

                        placeholder="Que souhaitez-vous faire ?"

                    />

                </div>

                <div className="command-section-title">

                    Accès rapide

                </div>

                {

                    items.map(item => {

                        const Icon = item.icon;

                        return (

                            <button
                                key={item.title}
                                className="command-item"
                            >

                                <Icon className="command-item-icon"/>

                                <div>

                                    <strong>

                                        {item.title}

                                    </strong>

                                    <small>

                                        {item.description}

                                    </small>

                                </div>

                            </button>

                        );

                    })

                }

                <div className="command-history">

                    <FiClock />

                    Aucun historique pour le moment.

                </div>

            </div>

        </div>

    );

}