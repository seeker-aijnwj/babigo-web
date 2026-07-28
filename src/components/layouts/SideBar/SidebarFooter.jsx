import {
    FiChevronUp,
    FiLogOut,
    FiMoon,
    FiSettings,
    FiUser
} from "react-icons/fi";

import "../DashboardLayout/dashboard.css";

export default function SidebarFooter() {

    return (

        <footer className="sidebar-footer">

            <button
                type="button"
                className="profile-card"
            >

                <div className="profile-avatar">

                    <span>N</span>

                    <div className="profile-status"></div>

                </div>

                <div className="profile-body">

                    <div className="profile-name">

                        Nincekon YORO

                    </div>

                    <div className="profile-role">

                        Administrateur

                    </div>

                    <div className="profile-email">

                        admin@babigo.app

                    </div>

                </div>

                <FiChevronUp className="profile-chevron"/>

            </button>

            <nav className="profile-menu">

                <button className="profile-action">

                    <FiUser />

                    <span>Mon profil</span>

                </button>

                <button className="profile-action">

                    <FiSettings />

                    <span>Préférences</span>

                </button>

                <button className="profile-action">

                    <FiMoon />

                    <span>Mode sombre</span>

                </button>

                <button className="profile-action logout">

                    <FiLogOut />

                    <span>Déconnexion</span>

                </button>

            </nav>

        </footer>

    );

}