import { NavLink } from "react-router-dom";
import "../DashboardLayout/dashboard.css";

import {
    FiHome,
    FiUsers,
    FiMap,
    FiTruck,
    FiCreditCard,
    FiHeadphones,
    FiTrendingUp,
    FiSettings,
    FiUser
} from "react-icons/fi";

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
        icon: FiHeadphones,
        badge: 3
    },

    {
        label: "Investisseurs",
        path: "/investors",
        icon: FiTrendingUp
    },

    {
        label: "Mon profil",
        path: "/account",
        icon: FiUser
    },

    {
        label: "Paramètres",
        path: "/settings",
        icon: FiSettings
    }

];

export default function SidebarMenu() {

    return (

        <div className="sidebar-menu-container">

            <nav className="sidebar-menu">

                {

                    menus.map((menu) => {

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

                                {menu.badge && (

                                    <div className="menu-badge">

                                        {menu.badge}

                                    </div>

                                )}

                            </NavLink>

                        );

                    })

                }

            </nav>

        </div>

    );

}