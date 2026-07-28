import DashboardLayout from "../components/layouts/DashboardLayout/DashboardLayout";

import WelcomeBanner from "../components/dashboard/WelcomeBanner";
import StatsGrid from "../components/dashboard/StatusGrid";
import RecentActivity from "../components/dashboard/RecentActivity";
import DashboardWorkspace from "../components/dashboard/DashboardWorkspace";

import "../components/dashboard/page.css";

export default function DashboardPage() {

    return (

        <DashboardLayout pageTitle="Tableau de bord">

            <WelcomeBanner />

            <StatsGrid />

            <DashboardWorkspace />

            <RecentActivity />

        </DashboardLayout>

    );

}