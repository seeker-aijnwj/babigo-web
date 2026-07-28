import {
    FiCalendar,
    FiRefreshCw,
    FiSun
} from "react-icons/fi";

import "./page.css";

export default function WelcomeBanner() {

    const today = new Date().toLocaleDateString("fr-FR", {

        weekday: "long",

        day: "numeric",

        month: "long",

        year: "numeric"

    });

    return (

        <section className="welcome-banner">

            <div className="welcome-left">

                <div className="welcome-badge">

                    <FiSun />

                    <span>

                        Bonjour 👋

                    </span>

                </div>

                <h1>

                    Bienvenue sur BABIGO Admin

                </h1>

                <p>

                    Pilotez votre plateforme de mobilité depuis un tableau
                    de bord moderne, rapide et conçu pour évoluer.

                </p>

            </div>

            <div className="welcome-right">

                <div className="welcome-info">

                    <FiCalendar />

                    <span>

                        {today}

                    </span>

                </div>

                <div className="welcome-info">

                    <FiRefreshCw />

                    <span>

                        Synchronisé il y a 2 minutes

                    </span>

                </div>

            </div>

        </section>

    );

}