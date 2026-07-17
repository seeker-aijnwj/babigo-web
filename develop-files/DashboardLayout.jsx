// src/components/layouts/DashboardLayout.jsx

import { useEffect, useState } from "react";

import Sidebar from "../Sidebar";

import useResponsive from "../../hooks/useResponsive";

import "./DashboardLayout.css";

export default function DashboardLayout({ children }) {

    const { isMobile } = useResponsive();

    const [sidebarOpen, setSidebarOpen] = useState(false);

    useEffect(() => {

        if (!isMobile) {

            setSidebarOpen(false);

        }

    }, [isMobile]);

    function openSidebar() {

        setSidebarOpen(true);

    }

    function closeSidebar() {

        setSidebarOpen(false);

    }

    return (

        <div className="dashboard-layout">

            {
                isMobile && sidebarOpen && (

                    <div
                        className="dashboard-overlay"
                        onClick={closeSidebar}
                    />

                )
            }

            <aside

                className={

                    isMobile

                        ? `dashboard-sidebar-mobile ${sidebarOpen ? "open" : ""}`

                        : "dashboard-sidebar"

                }

            >

                <Sidebar

                    onNavigate={closeSidebar}

                />

            </aside>

            <main className="dashboard-main">

                {

                    isMobile && (

                        <header className="mobile-header">

                            <button

                                className="mobile-menu-button"

                                onClick={openSidebar}

                                aria-label="Ouvrir le menu"

                            >

                                ☰

                            </button>

                            <div className="mobile-header-title">

                                BABIGO Admin

                            </div>

                        </header>

                    )

                }

                <section className="dashboard-content">

                    {children}

                </section>

            </main>

        </div>

    );

}