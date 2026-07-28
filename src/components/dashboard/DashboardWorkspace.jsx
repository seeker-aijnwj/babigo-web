import ActivityChart from "./ActivityChart";
import QuickActions from "./QuickActions";

import "./page.css";

export default function DashboardWorkspace() {

    return (

        <section className="dashboard-workspace">

            <div className="dashboard-left">

                <ActivityChart />

            </div>

            <aside className="dashboard-right">

                <QuickActions />

            </aside>

        </section>

    );

}