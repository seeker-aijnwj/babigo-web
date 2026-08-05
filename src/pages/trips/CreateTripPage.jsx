/******************************************************************************
 * ============================================================================
 * BabiGO
 * CreateTripPage.jsx
 * ============================================================================
 *
 * MVP v1.0
 *
 * Création d'un trajet.
 *
 * Cette page permet à un conducteur de publier
 * une nouvelle annonce de covoiturage.
 *
 ******************************************************************************/

import React, {

    useState,

} from "react";

import {

    useNavigate,

} from "react-router-dom";

import {

    FaMapMarkerAlt,

    FaCalendarAlt,

    FaCar,

    FaMoneyBillWave,

    FaStickyNote,

    FaArrowLeft,

} from "react-icons/fa";

import useAuth from "../../hooks/useAuth";

import TripRepository from "../../database/repositories/tripRepository";
import DashboardLayout from "../../components/layouts/DashboardLayout/DashboardLayout";
import "./create-trip.css";

/* ==========================================================================
   COMMUNES DE CÔTE D'IVOIRE
   ========================================================================== */
import { IVORY_COAST_TOWNS } from "../../components/constants/places";

/* ==========================================================================
   COMPOSANT
   ========================================================================== */

export default function CreateTripPage() {

    const navigate = useNavigate();

    const {

        currentUser,

    } = useAuth();

    /* =======================================================================
       ÉTATS
    ======================================================================= */

    const [

        loading,

        setLoading,

    ] = useState(false);

    const [

        error,

        setError,

    ] = useState("");

    const [

        form,

        setForm,

    ] = useState({

        departureCity: "",

        departurePlace: "",

        arrivalCity: "",

        arrivalPlace: "",

        tripDate: "",

        tripTime: "",

        availableSeats: 3,

        vehicleType: "Berline",

        whatsappNumber: currentUser?.numero ?? "",

        price: "",

        description: "",

    });

    /* ==========================================================================
    TYPES DE VÉHICULE
    ========================================================================== */

    const VEHICLE_TYPES = [

        "Berline",

        "SUV",

        "Monospace",

        "Minibus",

        "Pick-up",

        "Autre",

    ];
    
    /* =======================================================================
       GESTION DES CHAMPS
    ======================================================================= */

    function handleChange(event) {

        const {

            name,

            value,

        } = event.target;

        setForm((previous) => ({

            ...previous,

            [name]: value,

        }));

    }

    /* =======================================================================
       VALIDATION
    ======================================================================= */

    function validateForm() {

        if (!form.departureCity) {

            return "Veuillez sélectionner une commune de départ.";

        }

        if (!form.departurePlace.trim()) {

            return "Veuillez indiquer le point de départ.";

        }

        if (!form.arrivalCity) {

            return "Veuillez sélectionner une commune d'arrivée.";

        }

        if (!form.arrivalPlace.trim()) {

            return "Veuillez indiquer le point d'arrivée.";

        }

        if (form.departureCity === form.arrivalCity) {

            return "Les communes de départ et d'arrivée doivent être différentes.";

        }

        if (!form.tripDate) {

            return "Veuillez choisir une date.";

        }

        if (!form.tripTime) {

            return "Veuillez choisir une heure.";

        }

        if (Number(form.availableSeats) < 1) {

            return "Le nombre de places doit être supérieur à zéro.";

        }

        if (!form.price || Number(form.price) <= 0) {

            return "Veuillez renseigner un prix valide.";

        }

        if (!form.whatsappNumber.trim()) {

            return "Veuillez renseigner un numéro WhatsApp.";

        }

        return null;

    }

    /* =======================================================================
       ENREGISTREMENT
    ======================================================================= */

    /* =======================================================================
       ENREGISTREMENT
    ======================================================================= */

    async function handleSubmit(event) {

        event.preventDefault();

        setError("");

        const validationError = validateForm();

        if (validationError) {

            setError(validationError);

            return;

        }

        if (!currentUser?.uid) {

            setError(

                "Vous devez être connecté pour publier un trajet."

            );

            return;

        }

        try {

            setLoading(true);

            const trip = {

                driverId: currentUser.uid,

                departureCity: form.departureCity,

                departurePlace: form.departurePlace,

                arrivalCity: form.arrivalCity,

                arrivalPlace: form.arrivalPlace,

                tripDate: form.tripDate,

                tripTime: form.tripTime,

                availableSeats: Number(form.availableSeats),

                price: Number(form.price),

                vehicleType: form.vehicleType,

                whatsappNumber: form.whatsappNumber,

                description: form.description.trim(),

                status: "published",

                createdAt: new Date(),

                updatedAt: new Date(),

            };

            await TripRepository.createTrip(trip);

            navigate("/dashboard");

        }

        catch (exception) {

            console.error(exception);

            setError(

                exception.message ||

                "Impossible de publier ce trajet."

            );

        }

        finally {

            setLoading(false);

        }

    }
    

    /* =======================================================================
       RENDER
    ======================================================================= */

    return (
    
            <DashboardLayout
                pageTitle="Utilisateurs"
            >

                <main className="create-trip-page">

                    <section className="create-trip-container">

                        {/* ==========================================================
                            HEADER
                        ========================================================== */}

                        <header className="create-trip-header">

                            <button

                                type="button"

                                className="back-button"

                                onClick={() => navigate(-1)}

                            >

                                <FaArrowLeft />

                                <span>

                                    Retour

                                </span>

                            </button>

                            <div>

                                <h1>

                                    Publier un trajet

                                </h1>

                                <p>

                                    Complétez les informations ci-dessous pour
                                    proposer votre trajet aux passagers.

                                </p>

                            </div>

                        </header>

                        {/* ==========================================================
                            FORMULAIRE
                        ========================================================== */}

                        <form

                            className="create-trip-form"

                            onSubmit={handleSubmit}

                        >

                            {

                                error && (

                                    <div className="form-error">

                                        {error}

                                    </div>

                                )

                            }

                            {/* ======================================================
                                DÉPART
                            ====================================================== */}

                            <div className="form-card">

                                <h2>

                                    <FaMapMarkerAlt />

                                    Départ

                                </h2>

                                <div className="form-grid">

                                    <div className="form-group">

                                        <label>

                                            Commune de départ

                                        </label>

                                        <select

                                            name="departureCity"

                                            value={form.departureCity}

                                            onChange={handleChange}

                                        >

                                            <option value="">

                                                Sélectionnez une commune

                                            </option>

                                            {

                                                IVORY_COAST_TOWNS.map(

                                                    (city) => (

                                                        <option

                                                            key={city}

                                                            value={city}

                                                        >

                                                            {city}

                                                        </option>

                                                    )

                                                )

                                            }

                                        </select>

                                    </div>

                                    <div className="form-group">

                                        <label>

                                            Point de départ

                                        </label>

                                        <input

                                            type="text"

                                            name="departurePlace"

                                            placeholder="Ex : Gare Sud"

                                            value={form.departurePlace}

                                            onChange={handleChange}

                                        />

                                    </div>

                                </div>

                            </div>

                            {/* ======================================================
                                ARRIVÉE
                            ====================================================== */}

                            <div className="form-card">

                                <h2>

                                    <FaMapMarkerAlt />

                                    Arrivée

                                </h2>

                                <div className="form-grid">

                                    <div className="form-group">

                                        <label>

                                            Commune d'arrivée

                                        </label>

                                        <select

                                            name="arrivalCity"

                                            value={form.arrivalCity}

                                            onChange={handleChange}

                                        >

                                            <option value="">

                                                Sélectionnez une commune

                                            </option>

                                            {

                                                IVORY_COAST_TOWNS.map(

                                                    (town) => (

                                                        <option

                                                            key={town}

                                                            value={town}

                                                        >

                                                            {town}

                                                        </option>

                                                    )

                                                )

                                            }

                                        </select>

                                    </div>

                                    <div className="form-group">

                                        <label>

                                            Point d'arrivée

                                        </label>

                                        <input

                                            type="text"

                                            name="arrivalPlace"

                                            placeholder="Ex : Gare UTB"

                                            value={form.arrivalPlace}

                                            onChange={handleChange}

                                        />

                                    </div>

                                </div>

                            </div>

                                                {/* ======================================================
                                DATE & HEURE
                            ====================================================== */}

                            <div className="form-card">

                                <h2>

                                    <FaCalendarAlt />

                                    Date et heure

                                </h2>

                                <div className="form-grid">

                                    <div className="form-group">

                                        <label>

                                            Date du trajet

                                        </label>

                                        <input

                                            type="date"

                                            name="tripDate"

                                            value={form.tripDate}

                                            onChange={handleChange}

                                        />

                                    </div>

                                    <div className="form-group">

                                        <label>

                                            Heure de départ

                                        </label>

                                        <input

                                            type="time"

                                            name="tripTime"

                                            value={form.tripTime}

                                            onChange={handleChange}

                                        />

                                    </div>

                                </div>

                            </div>

                            {/* ======================================================
                                PLACES & PRIX
                            ====================================================== */}

                            <div className="form-card">

                                <h2>

                                    <FaCar />

                                    Informations du trajet

                                </h2>

                                <div className="form-grid">

                                    <div className="form-group">

                                        <label>

                                            Nombre de places

                                        </label>

                                        <input

                                            type="number"

                                            min="1"

                                            max="15"

                                            name="availableSeats"

                                            value={form.availableSeats}

                                            onChange={handleChange}

                                        />

                                    </div>

                                    <div className="form-group">

                                        <label>

                                            <FaMoneyBillWave />

                                            Prix par place (FCFA)

                                        </label>

                                        <input

                                            type="number"

                                            min="0"

                                            step="500"

                                            name="price"

                                            placeholder="Ex : 3000"

                                            value={form.price}

                                            onChange={handleChange}

                                        />

                                    </div>

                                </div>

                            </div>

                            {/* ======================================================
                                VÉHICULE & CONTACT
                            ====================================================== */}

                            <div className="form-card">

                                <h2>

                                    <FaCar />

                                    Véhicule et contact

                                </h2>

                                <div className="form-grid">

                                    <div className="form-group">

                                        <label>

                                            Type de véhicule

                                        </label>

                                        <select

                                            name="vehicleType"

                                            value={form.vehicleType}

                                            onChange={handleChange}

                                        >

                                            {

                                                VEHICLE_TYPES.map((vehicle) => (

                                                    <option

                                                        key={vehicle}

                                                        value={vehicle}

                                                    >

                                                        {vehicle}

                                                    </option>

                                                ))

                                            }

                                        </select>

                                    </div>

                                    <div className="form-group">

                                        <label>

                                            Numéro WhatsApp

                                        </label>

                                        <input

                                            type="tel"

                                            name="whatsappNumber"

                                            placeholder="+225 07 XX XX XX XX"

                                            value={form.whatsappNumber}

                                            onChange={handleChange}

                                        />

                                    </div>

                                </div>

                            </div>

                            {/* ======================================================
                                DESCRIPTION
                            ====================================================== */}

                            <div className="form-card">

                                <h2>

                                    <FaStickyNote />

                                    Informations complémentaires

                                </h2>

                                <div className="form-group">

                                    <label>

                                        Description (facultative)

                                    </label>

                                    <textarea

                                        rows="5"

                                        name="description"

                                        placeholder="Ex : Climatisation, petit bagage accepté, départ à l'heure..."

                                        value={form.description}

                                        onChange={handleChange}

                                    />

                                </div>

                            </div>

                            {/* ======================================================
                                ACTIONS
                            ====================================================== */}

                            <div className="create-trip-actions">

                                <button

                                    type="button"

                                    className="secondary-button"

                                    onClick={() => navigate(-1)}

                                    disabled={loading}

                                >

                                    Annuler

                                </button>

                                <button

                                    type="submit"

                                    className="primary-button"

                                    disabled={loading}

                                >

                                    {

                                        loading

                                            ? "Publication..."

                                            : "🚗 Publier le trajet"

                                    }

                                </button>

                            </div>

                        </form>

                    </section>

                </main>
                
            </DashboardLayout>
                

    );

    

}
