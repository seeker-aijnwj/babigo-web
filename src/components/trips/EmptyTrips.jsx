/******************************************************************************
==============================================================================
BabiGO
EmptyTrips.jsx
==============================================================================
*/

import React from "react";

import { Link } from "react-router-dom";

import {

    FiPlusCircle,

    FiMapPin,

} from "react-icons/fi";

import "./empty-trips.css";

/* ==========================================================================
   COMPOSANT
   ========================================================================== */

export default function EmptyTrips() {

    return (

        <section className="empty-trips">

            <div className="empty-trips-card">

                <div className="empty-trips-icon">

                    <FiMapPin />

                </div>

                <h2>

                    Aucun trajet trouvé

                </h2>

                <p>

                    Vous n'avez encore publié aucun trajet.

                    <br />

                    Commencez dès maintenant à proposer vos places
                    disponibles aux voyageurs.

                </p>

                <Link

                    to="/create-trip"

                    className="empty-trips-button"

                >

                    <FiPlusCircle />

                    <span>

                        Publier mon premier trajet

                    </span>

                </Link>

            </div>

        </section>

    );

}