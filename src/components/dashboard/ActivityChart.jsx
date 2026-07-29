import "./page.css";

/**
 * ============================================================
 * ActivityChart
 * ============================================================
 *
 * Widget d'activité du Dashboard.
 *
 * Pour la Version F1.0, il présente les principaux
 * indicateurs de la plateforme.
 *
 * Les véritables graphiques (Chart.js / Recharts)
 * seront intégrés dans la prochaine phase.
 *
 * ============================================================
 */

export default function ActivityChart({

    stats

}) {

    const overview = stats?.overview;

    const trips = stats?.trips;

    const finance = stats?.finance;

    return (

        <section className="dashboard-widget">

            <div className="dashboard-widget-header">

                <h2>

                    Activité de la plateforme

                </h2>

                <span>

                    Vue générale

                </span>

            </div>

            <div className="activity-summary-grid">

                <div className="activity-stat">

                    <span className="activity-label">

                        Conducteurs

                    </span>

                    <strong className="activity-value">

                        {overview?.drivers ?? 0}

                    </strong>

                </div>

                <div className="activity-stat">

                    <span className="activity-label">

                        Passagers

                    </span>

                    <strong className="activity-value">

                        {overview?.passengers ?? 0}

                    </strong>

                </div>

                <div className="activity-stat">

                    <span className="activity-label">

                        Trajets actifs

                    </span>

                    <strong className="activity-value">

                        {trips?.active ?? 0}

                    </strong>

                </div>

                <div className="activity-stat">

                    <span className="activity-label">

                        Trajets terminés

                    </span>

                    <strong className="activity-value">

                        {trips?.completed ?? 0}

                    </strong>

                </div>

                <div className="activity-stat">

                    <span className="activity-label">

                        Paiements réussis

                    </span>

                    <strong className="activity-value">

                        {finance?.succeededTransactions ?? 0}

                    </strong>

                </div>

                <div className="activity-stat">

                    <span className="activity-label">

                        Paiements en attente

                    </span>

                    <strong className="activity-value">

                        {finance?.pendingTransactions ?? 0}

                    </strong>

                </div>

            </div>

            <div className="activity-placeholder">

                <p>

                    📈 Le graphique d'activité temps réel sera
                    connecté à Firebase dans la prochaine étape.

                </p>

            </div>

        </section>

    );

}