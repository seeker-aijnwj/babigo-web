import "./dashboard.css";

const menus = [
    "Tableau de bord",
    "Utilisateurs",
    "Trajets",
    "Véhicules",
    "Paiements",
    "Support",
    "Investisseurs",
    "Paramètres"
];

export default function Sidebar() {

    return (

        <aside className="sidebar">

            <div className="logo">

                BabiGO Express

            </div>

            <nav>

                {
                    menus.map(menu => (

                        <div
                            key={menu}
                            className="menu-item"
                        >
                            {menu}
                        </div>

                    ))
                }

            </nav>

        </aside>

    );

}