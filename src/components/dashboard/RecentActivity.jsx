import {
    FiUserPlus,
    FiMap,
    FiCreditCard,
    FiTruck,
    FiArrowRight
} from "react-icons/fi";

import "./page.css";

const activities = [

    {
        id: 1,
        icon: FiUserPlus,
        color: "#2563EB",
        title: "Nouvel utilisateur",
        description: "KOUASSI Jean a créé un compte.",
        time: "Il y a 5 min"
    },

    {
        id: 2,
        icon: FiMap,
        color: "#10B981",
        title: "Trajet publié",
        description: "Abidjan → Yamoussoukro",
        time: "Il y a 18 min"
    },

    {
        id: 3,
        icon: FiCreditCard,
        color: "#8B5CF6",
        title: "Paiement reçu",
        description: "25 000 FCFA",
        time: "Il y a 34 min"
    },

    {
        id: 4,
        icon: FiTruck,
        color: "#F59E0B",
        title: "Véhicule ajouté",
        description: "Toyota Corolla 2024",
        time: "Aujourd'hui"
    }

];

export default function RecentActivity() {

    return (

        <section className="recent-activity">

            <div className="card-header">

                <h2>

                    Activité récente

                </h2>

                <button>

                    Tout voir

                    <FiArrowRight />

                </button>

            </div>

            <div className="activity-list">

                {

                    activities.map(activity => {

                        const Icon = activity.icon;

                        return (

                            <div
                                key={activity.id}
                                className="activity-item"
                            >

                                <div
                                    className="activity-icon"
                                    style={{
                                        background: activity.color
                                    }}
                                >

                                    <Icon />

                                </div>

                                <div className="activity-content">

                                    <strong>

                                        {activity.title}

                                    </strong>

                                    <p>

                                        {activity.description}

                                    </p>

                                </div>

                                <small>

                                    {activity.time}

                                </small>

                            </div>

                        );

                    })

                }

            </div>

        </section>

    );

}