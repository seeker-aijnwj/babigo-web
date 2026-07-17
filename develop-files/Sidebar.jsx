// src/components/Sidebar.jsx

import { useState } from "react";

import "./dashboard.css";

const menus = [

    {
        id: "dashboard",
        title: "Tableau de bord",
        icon: "🏠"
    },

    {
        id: "users",
        title: "Utilisateurs",
        icon: "👥"
    },

    {
        id: "trips",
        title: "Trajets",
        icon: "🚘"
    },

    {
        id: "vehicles",
        title: "Véhicules",
        icon: "🚗"
    },

    {
        id: "payments",
        title: "Paiements",
        icon: "💳"
    },

    {
        id: "support",
        title: "Support",
        icon: "🛠"
    },

    {
        id: "investors",
        title: "Investisseurs",
        icon: "📈"
    },

    {
        id: "settings",
        title: "Paramètres",
        icon: "⚙"
    }

];

export default function Sidebar({

    onNavigate

}) {

    const [activeMenu, setActiveMenu] = useState("users");

    function handleMenuClick(menuId) {

        setActiveMenu(menuId);

        console.log("Navigation :", menuId);

        if (onNavigate) {

            onNavigate();

        }

    }

    return (

        <aside className="sidebar">

            <div className="sidebar-header">

                <div className="sidebar-logo">

                    B

                </div>

                <div className="sidebar-brand">

                    <h2>BABIGO</h2>

                    <span>Express Admin</span>

                </div>

            </div>

            <nav className="sidebar-menu">

                {

                    menus.map((menu) => (

                        <button

                            key={menu.id}

                            className={

                                menu.id === activeMenu

                                    ? "menu-item active"

                                    : "menu-item"

                            }

                            onClick={() => handleMenuClick(menu.id)}

                        >

                            <span className="menu-icon">

                                {menu.icon}

                            </span>

                            <span className="menu-title">

                                {menu.title}

                            </span>

                        </button>

                    ))

                }

            </nav>

            <div className="sidebar-footer">

                Version 0.2.0

            </div>

        </aside>

    );

}