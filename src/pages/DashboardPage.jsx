import DashboardLayout from "../components/layouts/DashboardLayout/DashboardLayout";

import WelcomeBanner from "../components/dashboard/WelcomeBanner";
import StatsGrid from "../components/dashboard/StatsGrid";
import DashboardWorkspace from "../components/dashboard/DashboardWorkspace";

import useDashboard from "../hooks/useDashboard";

/**
 * ============================================================
 * DashboardPage
 * ============================================================
 *
 * Page principale du Back-Office.
 *
 * Cette page ne connaît ni Firebase,
 * ni DashboardRepository.
 *
 * Elle assemble simplement les widgets
 * qui composent le Dashboard.
 *
 * Architecture :
 *
 * DashboardPage
 *      │
 *      ▼
 * useDashboard()
 *      │
 *      ▼
 * DashboardService
 *      │
 *      ▼
 * DashboardRepository
 *      │
 *      ▼
 * Firestore
 *
 * ============================================================
 */

export default function DashboardPage() {

    const {

        stats,

        loading,

        error,

        refresh,

        lastRefresh

    } = useDashboard();

    return (

        <DashboardLayout pageTitle="Tableau de bord">

            <div className="dashboard-page">

                <WelcomeBanner

                    stats={stats}

                    loading={loading}

                    refresh={refresh}

                    lastRefresh={lastRefresh}

                />

                <StatsGrid

                    stats={stats}

                    loading={loading}

                />

                <DashboardWorkspace

                    stats={stats}

                    activities={stats?.activities ?? []}

                />

                {

                    error && (

                        <div className="dashboard-error">

                            Impossible de charger les statistiques.

                        </div>

                    )

                }

            </div>

        </DashboardLayout>

    );

}