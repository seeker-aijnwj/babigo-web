import { NavLink } from "react-router-dom";

import {
    FiHome,
    FiUsers,
    FiMap,
    FiTruck,
    FiCreditCard,
    FiHeadphones,
    FiTrendingUp,
    FiSettings
} from "react-icons/fi";

import "./dashboard.css";

const menus = [

    {
        label: "Tableau de bord",
        path: "/",
        icon: FiHome
    },

    {
        label: "Utilisateurs",
        path: "/users",
        icon: FiUsers
    },

    {
        label: "Trajets",
        path: "/trips",
        icon: FiMap
    },

    {
        label: "Véhicules",
        path: "/vehicles",
        icon: FiTruck
    },

    {
        label: "Paiements",
        path: "/payments",
        icon: FiCreditCard
    },

    {
        label: "Support",
        path: "/support",
        icon: FiHeadphones
    },

    {
        label: "Investisseurs",
        path: "/investors",
        icon: FiTrendingUp
    },

    {
        label: "Paramètres",
        path: "/settings",
        icon: FiSettings
    }

];

export default function Sidebar() {

    return (

        <aside className="sidebar">

            <div className="logo">

                <div className="logo-circle">

                    B

                </div>

                <div>

                    <div className="logo-title">

                        BABIGO

                    </div>

                    <div className="logo-subtitle">

                        Admin Platform

                    </div>

                </div>

            </div>

            <nav className="sidebar-menu">

                {

                    menus.map(menu => {

                        const Icon = menu.icon;

                        return (

                            <NavLink

                                key={menu.path}

                                to={menu.path}

                                end={menu.path === "/"}

                                className={({ isActive }) =>

                                    isActive

                                        ? "menu-item active"

                                        : "menu-item"

                                }

                            >

                                <Icon className="menu-icon" />

                                <span>

                                    {menu.label}

                                </span>

                            </NavLink>

                        );

                    })

                }

            </nav>

            <div className="sidebar-footer">

                <div className="sidebar-user">

                    <div className="sidebar-avatar">

                        A

                    </div>

                    <div className="sidebar-user-info">

                        <div className="sidebar-user-name">

                            Administrateur

                        </div>

                        <div className="sidebar-user-email">

                            admin@babigo.africa

                        </div>

                    </div>

                </div>

                <button

                    className="collapse-button"

                >

                    ⇤ Réduire

                </button>

            </div>

        </aside>

    );

}