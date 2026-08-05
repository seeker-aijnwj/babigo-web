/******************************************************************************
==============================================================================
BabiGO
SidebarFooter.jsx
==============================================================================

Affiche les informations de l'utilisateur connecté.

==============================================================================
*/

import { FiChevronUp, FiUser } from "react-icons/fi";
import boyAvatar from '../../../assets/images/avatars/boy.jpg';
import girlAvatar from '../../../assets/images/avatars/girl.jpg';

import useAuth from "../../../hooks/useAuth";

import {

    USER_ROLE_LABELS,

} from "../../../components/constants/roles";

import "../DashboardLayout/dashboard.css";

export default function SidebarFooter() {

    /* ========================================================================
       AUTH
    ======================================================================== */

    const {

        user,

        loading,

    } = useAuth();

    /* ========================================================================
       CHARGEMENT
    ======================================================================== */

    if (loading) {

        return (

            <footer className="sidebar-footer">

                <div className="profile-card loading">

                    Chargement...

                </div>

            </footer>

        );

    }

    /* ========================================================================
       AUCUN UTILISATEUR
    ======================================================================== */

    if (!user) {

        return null;

    }

    /* ========================================================================
       VALEURS
    ======================================================================== */

    const displayName =

        user.fullName ||

        user.displayName ||

        `${user.nom ?? ""} ${user.prenom ?? ""}`.trim() ||

        "Utilisateur";

    const displayRole =

        USER_ROLE_LABELS[user.role] ||

        user.role ||

        "Utilisateur";

    return (

        <footer className="sidebar-footer">

            <button

                type="button"

                className="profile-card"

            >

                <div className="workspace-icon">

                    {

                        user.avatar ? (

                            <img
                                src={user.avatar === "boy" ? boyAvatar : girlAvatar }
                                alt={displayName.charAt(0).toUpperCase()}
                                className="workspace-icon"
                            />

                        ) : (

                            <FiUser />

                        )

                    }

                </div>

                <div className="profile-body">

                    <div className="profile-name">

                        {displayName}

                    </div>

                    <div className="profile-role">

                        {displayRole}

                    </div>

                    <div className="profile-email">

                        {user.email}

                    </div>

                </div>

                <FiChevronUp className="profile-chevron" />

            </button>

        </footer>

    );

}