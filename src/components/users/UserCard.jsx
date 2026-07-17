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
            className={

                selected

                    ? "user-card selected"

                    : "user-card"

            }

            onClick={() => onClick(user)}
        >

            <div className="user-card-avatar">

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

            <div className="user-card-content">

                <div className="user-card-header">

                    <h3>

                        {fullName || "Utilisateur"}

                    </h3>

                    <span className='user-role'>

                        {user.role}

                    </span>

                </div>
                
                <small>

                    {user.phone || user.numero}

                </small>

            </div>

        </div>

    );

}