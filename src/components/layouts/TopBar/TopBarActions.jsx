import {
    FiBell,
    FiGlobe,
    FiMoon,
    FiRefreshCw,
    FiUser
} from "react-icons/fi";

import "./topbar.css";

export default function TopBarActions() {

    return (

        <div className="topbar-actions">

            {/* Synchronisation */}

            <button
                className="topbar-action-button"
                title="Synchronisation"
                type="button"
            >

                <FiRefreshCw />

            </button>

            {/* Notifications */}

            <button
                className="topbar-action-button notification-button"
                title="Notifications"
                type="button"
            >

                <FiBell />

                <span className="notification-dot"></span>

            </button>

            {/* Langue */}

            <button
                className="topbar-action-button"
                title="Langue"
                type="button"
            >

                <FiGlobe />

            </button>

            {/* Thème */}

            <button
                className="topbar-action-button"
                title="Mode clair / sombre"
                type="button"
            >

                <FiMoon />

            </button>

            {/* Profil YZ & Co */}

            <button
                className="topbar-profile-button"
                type="button"
            >

                <FiUser /> 

            </button>

        </div>

    );

}