import ActivityChart from "./ActivityChart";
import QuickActions from "./QuickActions";
import RecentActivity from "./RecentActivity";

import "./page.css";

/**
 * ============================================================
 * DashboardWorkspace
 * ============================================================
 *
 * Zone principale du Dashboard.
 *
 * Elle regroupe les différents widgets
 * qui composent l'espace de travail.
 *
 * Structure :
 *
 * ┌──────────────────────────────┬─────────────────────┐
 * │                              │                     │
 * │      ActivityChart           │    QuickActions    │
 * │                              │                     │
 * ├──────────────────────────────┴─────────────────────┤
 * │                                                    │
 * │              RecentActivity                        │
 * │                                                    │
 * └────────────────────────────────────────────────────┘
 *
 * ============================================================
 */

export default function DashboardWorkspace({

    stats

}) {

    return (

        <section className="dashboard-workspace">

            <div className="dashboard-workspace-grid">

                <ActivityChart
                    stats={stats}
                />

                <QuickActions />

            </div>

            <RecentActivity />

        </section>

    );

}