import React, {

    useState,

} from "react";

import Sidebar from "../SideBar/Sidebar";
import TopBar from "../TopBar/TopBar";

import "./dashboard.css";

import useAuth from "../../../hooks/useAuth";

export default function DashboardLayout({

    children,

    pageTitle = "Tableau de bord"

}) {

    /* =======================================================================
        AUTH
    ======================================================================= */

    const {
    
        user,

        loading,

    } = useAuth();
    
    const [sidebarOpen, setSidebarOpen] = useState(false);

    function toggleSidebar() {

        setSidebarOpen(current => !current);

    }

    function closeSidebar() {

        setSidebarOpen(false);

    }

    return (

        <div className="dashboard-layout">

            <div
                className={
                    sidebarOpen

                        ? "sidebar-wrapper open"

                        : "sidebar-wrapper"
                }
            >

                <Sidebar

                    user={user}
                    loading={loading}
                
                />

            </div>

            {
                sidebarOpen && (

                    <div

                        className="sidebar-backdrop"

                        onClick={closeSidebar}

                    />

                )
            }

            <main className="dashboard-main">

                <TopBar

                    title={pageTitle}

                    onToggleSidebar={toggleSidebar}

                />

                <section className="dashboard-content">

                    {children}

                </section>

            </main>

        </div>

    );

}