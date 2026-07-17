// src/components/users/UserCard.jsx

import "./users.css";

export default function UserCard({

    user,

    selected = false,

    onClick

}) {

    const firstName = user.firstName || user.prenom || "";

    const lastName = user.lastName || user.nom || "";

    const fullName = `${firstName} ${lastName}`.trim() || "Utilisateur";

    const photo = user.photoUrl || user.avatar || "";

    const email = user.email || "";

    const role = user.role || "Utilisateur";

    const phone = user.phone || user.numero || "";

    const initials = fullName
        .split(" ")
        .filter(Boolean)
        .slice(0, 2)
        .map(word => word.charAt(0).toUpperCase())
        .join("");

    return (

        <article

            className={

                selected

                    ? "user-card selected"

                    : "user-card"

            }

            onClick={onClick}

        >

            <div className="user-card-avatar">

                {

                    photo ? (

                        <img

                            src={photo}

                            alt={fullName}

                        />

                    ) : (

                        <span>

                            {initials || "U"}

                        </span>

                    )

                }

            </div>

            <div className="user-card-content">

                <div className="user-card-header">

                    <h3>

                        {fullName}

                    </h3>

                    <span className="user-role">

                        {role}

                    </span>

                </div>

                <div className="user-card-info">

                    {

                        email ?

                        email

                        :

                        phone || "Aucune information"

                    }

                </div>

            </div>

        </article>

    );

}