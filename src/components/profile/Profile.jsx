import {
    FiChevronUp,
    FiMoon,
    FiSettings
} from "react-icons/fi";

export default function name(params) {
    return (
        
        <button
            type="button"
            className="profile-card"
        >

            <div className="profile-avatar">

                <span>N</span>

                <div className="profile-status"></div>

            </div>

                
                <button className="profile-action">

                    <FiSettings />

                    <span>Préférences</span>

                </button>
            

                <button className="profile-action">

                    <FiMoon />

                    <span>Mode sombre</span>

                </button>

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
                
    )
} 