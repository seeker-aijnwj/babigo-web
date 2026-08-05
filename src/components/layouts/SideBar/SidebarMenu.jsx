/******************************************************************************
==============================================================================
BabiGO
SidebarMenu.jsx
==============================================================================

Navigation principale du Back Office.

Le composant est entièrement piloté par la configuration
MENU_CONFIGURATION.

Aucun menu n'est codé en dur dans le JSX.

==============================================================================
*/

import { NavLink } from "react-router-dom";

import useAuth from "../../../hooks/useAuth";

import "../DashboardLayout/dashboard.css";

/* ============================================================================
   CONFIGURATION
============================================================================ */
import { MENU_CONFIGURATION } from "../../../config/sidebarMenu";

/* ============================================================================
   COMPOSANT
============================================================================ */

export default function SidebarMenu() {

    /* ========================================================================
       AUTH
    ======================================================================== */

    const {

        user,

        loading,

    } = useAuth();

    /* ========================================================================
       ROLE
    ======================================================================== */

    const role = user?.role;

    /* ========================================================================
       MENUS VISIBLES
    ======================================================================== */

    const visibleMenus = MENU_CONFIGURATION.filter(

        (menu) => {

            if (!role) {

                return false;

            }

            return menu.roles.includes(role);

        }

    );

    /* ========================================================================
       CHARGEMENT
    ======================================================================== */

    if (loading) {

        return (

            <div className="sidebar-menu-container">

                <nav className="sidebar-menu">

                    <div className="sidebar-loading">

                        Chargement...

                    </div>

                </nav>

            </div>

        );

    }

    /* ========================================================================
       AUCUN ROLE
    ======================================================================== */

    if (!role) {

        return (

            <div className="sidebar-menu-container">

                <nav className="sidebar-menu">

                    <div className="sidebar-loading">

                        Aucun rôle attribué.

                    </div>

                </nav>

            </div>

        );

    }

    /* ========================================================================
       RENDU
    ======================================================================== */

    return (

        <div className="sidebar-menu-container">

            <nav

                className="sidebar-menu"

                aria-label="Navigation principale"

            >

                {

                    visibleMenus.map((menu) => {

                        const Icon = menu.icon;

                        return (

                            <NavLink

                                key={menu.id}

                                to={menu.path}

                                end={menu.path === "/"}

                                className={({ isActive }) =>

                                    isActive

                                        ? "menu-item active"

                                        : "menu-item"

                                }

                            >

                                <Icon

                                    className="menu-icon"

                                    aria-hidden="true"

                                />

                                <span className="menu-label">

                                    {menu.label}

                                </span>

                                {

                                    menu.badge && (

                                        <span

                                            className="menu-badge"

                                            aria-label={`${menu.badge} notifications`}

                                        >

                                            {menu.badge}

                                        </span>

                                    )

                                }

                            </NavLink>

                        );

                    })

                }

            </nav>

        </div>

    );

}