// src/components/users/UserCard.jsx

import boyAvatar from '../../assets/images/avatars/boy.jpg';
import girlAvatar from '../../assets/images/avatars/girl.jpg';
import "./users.css";

export default function UserCard({
    user,
    selected = false,
    onClick
}) {

    const fullName =
        `${user.firstName || user.prenom || ""} ${user.lastName || user.nom || ""}`.trim();

    return (

        <div
            className={`user-card ${selected ? "selected" : ""}`}
            onClick={() => onClick(user)}
        >

            <div className="user-avatar">

                {
                    user.photoUrl || user.avatar ? (

                        <img
                            src={user.avatar === "boy" ? boyAvatar : girlAvatar }
                            alt={fullName.charAt(0).toUpperCase()}
                        />

                    ) : (

                        <span>

                            {fullName.charAt(0).toUpperCase()}

                        </span>

                    )
                }

            </div>

            <div className="user-info">

                <h3>

                    {fullName || "Utilisateur"}

                </h3>

                <p>

                    {user.role}

                </p>

                <small>

                    {user.phone || user.numero}

                </small>

            </div>

        </div>

    );

}