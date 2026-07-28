import {
    FiPlusCircle,
    FiTruck,
    FiUsers,
    FiMap
} from "react-icons/fi";

import "./page.css";

const actions = [

    { icon: FiUsers, label: "Ajouter un utilisateur" },
    { icon: FiTruck, label: "Ajouter un véhicule" },
    { icon: FiMap, label: "Créer un trajet" },
    { icon: FiPlusCircle, label: "Nouvelle annonce" }

];

export default function QuickActions() {

    return (

        <section className="dashboard-card">

            <div className="card-header">

                <h2>

                    Actions rapides

                </h2>

            </div>

            <div className="quick-actions">

                {

                    actions.map(action => {

                        const Icon = action.icon;

                        return (

                            <button
                                key={action.label}
                                className="quick-action-button"
                                type="button"
                            >

                                <Icon />

                                <span>

                                    {action.label}

                                </span>

                            </button>

                        );

                    })

                }

            </div>

        </section>

    );

}