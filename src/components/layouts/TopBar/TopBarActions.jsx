import {

    FiBell,

    FiGlobe,

    FiMoon,

    FiSun,

    FiRefreshCw,

    FiUser

} from "react-icons/fi";

import {

    useState,

    useEffect,

} from "react";

import "./topbar.css";

export default function TopBarActions({

    refresh,

    loading = false,

    onProfileClick,

}) {

    /* =====================================================================
       THEME
    ===================================================================== */

    const [darkMode, setDarkMode] = useState(() => {

        return localStorage.getItem("babigo-theme") === "dark";

    });

    useEffect(() => {

        document.documentElement.setAttribute(

            "data-theme",

            darkMode ? "dark" : "light"

        );

        localStorage.setItem(

            "babigo-theme",

            darkMode ? "dark" : "light"

        );

    }, [darkMode]);

    function toggleTheme() {

        setDarkMode((value) => !value);

    }

    /* =====================================================================
       RAFRAICHISSEMENT
    ===================================================================== */

    function handleRefresh() {

        if (typeof refresh === "function") {

            refresh();

        }

    }

    /* =====================================================================
       PROFIL
    ===================================================================== */

    function handleProfile() {

        if (typeof onProfileClick === "function") {

            onProfileClick();

        }

    }

    return (

        <div className="topbar-actions">

            {/* ============================================================
                Synchronisation
            ============================================================ */}

            <button

                className="topbar-action-button"

                title="Actualiser"

                type="button"

                onClick={handleRefresh}

                disabled={loading}

            >

                <FiRefreshCw />

            </button>

            {/* ============================================================
                Notifications

                TODO M2 :
                - Lire Firestore notifications/{uid}
                - Badge temps réel
                - Dropdown
            ============================================================ */}

            <button

                className="topbar-action-button notification-button"

                title="Notifications"

                type="button"

                disabled

            >

                <FiBell />

                <span className="notification-dot"></span>

            </button>

            {/* ============================================================
                Langue

                TODO M2 :
                - react-i18next
                - Français
                - English
            ============================================================ */}

            <button

                className="topbar-action-button"

                title="Langue"

                type="button"

                disabled

            >

                <FiGlobe />

            </button>

            {/* ============================================================
                Theme
            ============================================================ */}

            <button

                className="topbar-action-button"

                title={

                    darkMode

                        ? "Mode clair"

                        : "Mode sombre"

                }

                type="button"

                onClick={toggleTheme}

            >

                {

                    darkMode

                        ? <FiSun />

                        : <FiMoon />

                }

            </button>

            {/* ============================================================
                Profil
            ============================================================ */}

            <button

                className="topbar-profile-button"

                type="button"

                onClick={handleProfile}

                title="Mon profil"

            >

                <FiUser />

            </button>

        </div>

    );

}