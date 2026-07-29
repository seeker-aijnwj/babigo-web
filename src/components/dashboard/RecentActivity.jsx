import {
    FiUsers,
    FiMap,
    FiCreditCard,
    FiTruck
} from "react-icons/fi";

import "./page.css";

/**
 * ============================================================
 * RecentActivity
 * ============================================================
 *
 * Affiche les dernières activités de la plateforme.
 *
 * Version F1.0 :
 * - Affichage des activités reçues en props
 * - Aucun accès direct à Firebase
 *
 * Les données sont préparées par DashboardService.
 *
 * ============================================================
 */

export default function RecentActivity({

    activities = []

}) {

    const getIcon = (type) => {

        switch (type) {

            case "user":
                return <FiUsers />;

            case "trip":
                return <FiMap />;

            case "transaction":
                return <FiCreditCard />;

            case "vehicle":
                return <FiTruck />;

            default:
                return <FiUsers />;

        }

    };

    return (

        <section className="dashboard-widget">

            <div className="dashboard-widget-header">

                <h2>

                    Activité récente

                </h2>

            </div>

            {

                activities.length === 0 ? (

                    <div className="empty-activity">

                        Aucune activité récente.

                    </div>

                ) : (

                    <div className="recent-activity-list">

                        {

                            activities.map((activity) => (

                                <div

                                    key={activity.id}

                                    className="activity-row"

                                >

                                    <div className="activity-icon">

                                        {

                                            getIcon(activity.type)

                                        }

                                    </div>

                                    <div className="activity-content">

                                        <strong>

                                            {activity.title}

                                        </strong>

                                        <span>

                                            {activity.description}

                                        </span>

                                    </div>

                                    <small>

                                        {activity.time}

                                    </small>

                                </div>

                            ))

                        }

                    </div>

                )

            }

        </section>

    );

}