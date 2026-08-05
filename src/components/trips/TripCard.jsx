/******************************************************************************
 * ============================================================================
 * BabiGO
 * TripCard.jsx
 * ============================================================================
 *
 * Carte d'un trajet.
 *
 * Affiche toutes les informations essentielles
 * d'une annonce publiée.
 *
 ******************************************************************************/

import React from "react";

import {

    FaMapMarkerAlt,

    FaCalendarAlt,

    FaClock,

    FaCar,

    FaUsers,

    FaMoneyBillWave,

    FaWhatsapp,

    FaCheckCircle,

    FaBan,

    FaTrash,

    FaEdit,

} from "react-icons/fa";

import {

    TRIP_STATUS,

} from "../../database/repositories/tripRepository";

import "./trip-card.css";

/* ==========================================================================
   COMPOSANT
   ========================================================================== */

export default function TripCard({

    trip,

    onDelete,

    onCancel,

    onComplete,

    onEdit,

}) {

    /* =======================================================================
       FORMATAGE
    ======================================================================= */

    const date =

        trip.tripDate

            ? new Date(trip.tripDate)

            : null;

    const formattedDate =

        date

            ? new Intl.DateTimeFormat(

                "fr-FR",

                {

                    weekday: "long",

                    day: "2-digit",

                    month: "long",

                    year: "numeric",

                }

            ).format(date)

            : "--";

    const formattedPrice =

        new Intl.NumberFormat(

            "fr-FR"

        ).format(

            trip.price || 0

        );

    const statusLabel = {

        [TRIP_STATUS.PUBLISHED]: "Publié",

        [TRIP_STATUS.COMPLETED]: "Terminé",

        [TRIP_STATUS.CANCELLED]: "Annulé",

    };

    const statusClass = {

        [TRIP_STATUS.PUBLISHED]: "published",

        [TRIP_STATUS.COMPLETED]: "completed",

        [TRIP_STATUS.CANCELLED]: "cancelled",

    };

    /* ==========================================================================
   VALEURS PAR DÉFAUT
   ========================================================================== */

    const departureCity =

        trip.departureCity || "Ville de départ";

    const arrivalCity =

        trip.arrivalCity || "Ville d'arrivée";

    const departurePlace =

        trip.departurePlace || "";

    const arrivalPlace =

        trip.arrivalPlace || "";

    const vehicleType =

        trip.vehicleType || "Non renseigné";

    const availableSeats =

        Number(trip.availableSeats ?? 0);

    const whatsappNumber =

        trip.whatsappNumber || "Non renseigné";

    const description =

        trip.description?.trim() || "";

        /* =======================================================================
       RENDER
    ======================================================================= */

    return (

        <article className="trip-card">

            {/* ==========================================================
                HEADER
            ========================================================== */}

            <header className="trip-card-header">

                <div className="trip-route">

                    <div className="trip-city">

                        <FaMapMarkerAlt />

                        <span>

                            {departureCity}

                        </span>

                    </div>

                    <div className="trip-route-arrow">

                        →

                    </div>

                    <div className="trip-city">

                        <FaMapMarkerAlt />

                        <span>

                            {arrivalCity}

                        </span>

                    </div>

                </div>

                <span

                    className={

                        `trip-status ${

                            statusClass[trip.status]

                        }`

                    }

                >

                    {

                        statusLabel[trip.status] ||

                        "Inconnu"

                    }

                </span>

            </header>

            {/* ==========================================================
                DÉTAILS
            ========================================================== */}

            <section className="trip-card-body">

                <div className="trip-info">

                    <FaCalendarAlt />

                    <span>

                        {formattedDate}

                    </span>

                </div>

                <div className="trip-info">

                    <FaClock />

                    <span>

                        {trip.tripTime}

                    </span>

                </div>

                <div className="trip-info">

                    <FaCar />

                    <span>

                        {

                            vehicleType ||

                            "Non renseigné"

                        }

                    </span>

                </div>

                <div className="trip-info">

                    <FaUsers />

                    <span>

                        {availableSeats}

                        {" "}places

                    </span>

                </div>

            </section>

                        {/* ==========================================================
                INFORMATIONS COMPLÉMENTAIRES
            ========================================================== */}

            <section className="trip-card-details">

                <div className="trip-info">

                    <FaMoneyBillWave />

                    <span>

                        {formattedPrice}

                        {" "}FCFA / place

                    </span>

                </div>

                <div className="trip-info">

                    <FaWhatsapp />

                    <span>

                        {

                            whatsappNumber ||

                            "Non renseigné"

                        }

                    </span>

                </div>

                {

                    departurePlace && (

                        <div className="trip-info">

                            <FaMapMarkerAlt />

                            <span>

                                Départ :

                                {" "}

                                {departurePlace}

                            </span>

                        </div>

                    )

                }

                {

                    arrivalPlace && (

                        <div className="trip-info">

                            <FaMapMarkerAlt />

                            <span>

                                Arrivée :

                                {" "}

                                {arrivalPlace}

                            </span>

                        </div>

                    )

                }

                {

                    description && (

                        <div className="trip-description">

                            <strong>

                                Informations complémentaires

                            </strong>

                            <p>

                                {description}

                            </p>

                        </div>

                    )

                }

            </section>

                        {/* ==========================================================
                ACTIONS
            ========================================================== */}

            <footer className="trip-card-footer">

                {

                    typeof onEdit === "function" && (

                        <button

                            type="button"

                            className="trip-action-button edit"

                            aria-label="Modifier le trajet"

                            onClick={() => onEdit(trip)}

                        >

                            <FaEdit />

                            <span>

                                Modifier

                            </span>

                        </button>

                    )

                }

                {

                    trip.status === TRIP_STATUS.PUBLISHED &&

                    typeof onComplete === "function" && (

                        <button

                            type="button"

                            className="trip-action-button success"

                            onClick={() => onComplete(trip.id)}

                        >

                            <FaCheckCircle />

                            <span>

                                Terminer

                            </span>

                        </button>

                    )

                }

                {

                    trip.status === TRIP_STATUS.PUBLISHED &&

                    typeof onCancel === "function" && (

                        <button

                            type="button"

                            className="trip-action-button warning"

                            aria-label="Annuler le trajet"
                            
                            onClick={() => onCancel(trip.id)}

                        >

                            <FaBan />

                            <span>

                                Annuler

                            </span>

                        </button>

                    )

                }

                {

                    typeof onDelete === "function" && (

                        <button

                            type="button"

                            className="trip-action-button danger"

                            aria-label="Supprimer le trajet"

                            onClick={() => onDelete(trip.id)}

                        >

                            <FaTrash />

                            <span>

                                Supprimer

                            </span>

                        </button>

                    )

                }

            </footer>

        </article>

    );

}