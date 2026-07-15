import boyAvatar from '../../assets/images/avatars/boy.jpg';
import girlAvatar from '../../assets/images/avatars/girl.jpg';
import "./users.css";

export default function UserDetails({ user }) {

    if (!user) {

        return (

            <section className="user-details">

                <div className="user-details-empty">

                    <h2>Aucun utilisateur sélectionné</h2>

                    <p>
                        Sélectionnez un utilisateur dans la liste de gauche.
                    </p>

                </div>

            </section>

        );

    }

    const firstName = user.firstName || user.prenom || "";
    const lastName = user.lastName || user.nom || "";
    const phone = user.phone || user.numero || "";
    const photo = user.photoUrl || user.avatar || "";
    const status = user.status || user.accountStatus || "Inconnu";

    const fullName = `${firstName} ${lastName}`.trim();

    return (

        <section className="user-details">

            <div className="user-profile">

                <div className="profile-avatar">

                    {
                        photo ?

                            <img
                                src={user.avatar === "boy" ? boyAvatar : girlAvatar }
                                alt={fullName}
                            />

                            :

                            <span>

                                {fullName.charAt(0).toUpperCase()}

                            </span>

                    }

                </div>

                <div>

                    <h2>{fullName}</h2>

                    <p>{user.role}</p>

                </div>

            </div>

            <div className="details-grid">

                <div className="detail-card">

                    <label>Téléphone</label>

                    <span>{phone}</span>

                </div>

                <div className="detail-card">

                    <label>Email</label>

                    <span>{user.email}</span>

                </div>

                <div className="detail-card">

                    <label>Ville</label>

                    <span>{user.city}</span>

                </div>

                <div className="detail-card">

                    <label>Commune</label>

                    <span>{user.district}</span>

                </div>

                <div className="detail-card">

                    <label>Statut</label>

                    <span>{status}</span>

                </div>

                <div className="detail-card">

                    <label>Portefeuille</label>

                    <span>

                        {user.walletBalance ?? 0} FCFA

                    </span>

                </div>

                <div className="detail-card">

                    <label>Nombre de trajets</label>

                    <span>

                        {user.totalTrips ?? 0}

                    </span>

                </div>

                <div className="detail-card">

                    <label>Note</label>

                    <span>

                        {user.rating ?? 0}

                    </span>

                </div>

            </div>

        </section>

    );

}