// src/components/users/UserDetails.jsx

import boyAvatar from '../../assets/images/avatars/boy.jpg';
import girlAvatar from '../../assets/images/avatars/girl.jpg';
import "./users.css";

export default function UserDetails({

    user,

    isMobile = false,

    onBack

}) {

    if (!user) {

        return (

            <section className="user-details">

                <div className="user-details-empty">

                    <h2>

                        Aucun utilisateur sélectionné

                    </h2>

                    <p>

                        Sélectionnez un utilisateur dans la liste.

                    </p>

                </div>

            </section>

        );

    }

    const firstName = user.firstName || user.prenom || "";

    const lastName = user.lastName || user.nom || "";

    const fullName = `${firstName} ${lastName}`.trim() || "Utilisateur";

    const photo = user.photoUrl || user.avatar || "";

    const role = user.role || "Utilisateur";

    const phone = user.phone || user.numero || "Non renseigné";

    const email = user.email || "Non renseigné";

    const city = user.city || user.ville || "Non renseignée";

    const wallet = user.walletBalance ?? user.wallet ?? 0;

    const rating = user.rating ?? 0;

    const trips = user.totalTrips ?? 0;

    const status = user.status || "Actif";

    const initials = fullName
        .split(" ")
        .filter(Boolean)
        .slice(0, 2)
        .map(word => word.charAt(0).toUpperCase())
        .join("");

    return (

        <section className="user-details">

            {

                isMobile && (

                    <div className="user-details-mobile-header">

                        <button

                            className="back-button"

                            onClick={onBack}

                        >

                            ← Retour

                        </button>

                    </div>

                )

            }

            <div className="user-profile">

                <div className="profile-avatar">

                    {

                        photo ? (

                            <img
                                src={photo === 'boy' ? boyAvatar : girlAvatar}
                                alt={fullName}
                            />

                        ) : (

                            initials

                        )

                    }

                </div>

                <div>

                    <h2>{fullName}</h2>

                    <p>{role}</p>

                </div>

            </div>

            <div className="details-grid">

                <div className="detail-card">

                    <label>Téléphone</label>

                    <span>{phone}</span>

                </div>

                <div className="detail-card">

                    <label>Email</label>

                    <span>{email}</span>

                </div>

                <div className="detail-card">

                    <label>Ville</label>

                    <span>{city}</span>

                </div>

                <div className="detail-card">

                    <label>Statut</label>

                    <span>{status}</span>

                </div>

                <div className="detail-card">

                    <label>Portefeuille</label>

                    <span>{wallet} FCFA</span>

                </div>

                <div className="detail-card">

                    <label>Trajets</label>

                    <span>{trips}</span>

                </div>

                <div className="detail-card">

                    <label>Note</label>

                    <span>⭐ {rating}</span>

                </div>

            </div>

        </section>

    );

}