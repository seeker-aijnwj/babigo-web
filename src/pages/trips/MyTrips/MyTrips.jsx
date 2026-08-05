/******************************************************************************
 * ============================================================================
 * BabiGO
 * MyTrips.jsx
 * ============================================================================
 *
 * Mes trajets.
 *
 * Cette page affiche tous les trajets publiés
 * par le conducteur connecté.
 *
 ******************************************************************************/

import React, {

    useEffect,

    useMemo,

    useState,

} from "react";

import {

    Link,

} from "react-router-dom";

import {

    FiPlus,

    FiSearch,

} from "react-icons/fi";

import useAuth from "../../../hooks/useAuth";

import TripRepository, {

    TRIP_STATUS,

} from "../../../database/repositories/tripRepository";

import DashboardLayout from "../../../components/layouts/DashboardLayout/DashboardLayout";

import TripCard from "../../../components/trips/TripCard";

import TripFilters from "../../../components/trips/TripFilters";

import EmptyTrips from "../../../components/trips/EmptyTrips";

import "./my-trips.css";

/* ==========================================================================
   FILTRES
   ========================================================================== */

const FILTERS = [

    {

        id: "all",

        label: "Tous",

    },

    {

        id: TRIP_STATUS.PUBLISHED,

        label: "Publiés",

    },

    {

        id: TRIP_STATUS.COMPLETED,

        label: "Terminés",

    },

    {

        id: TRIP_STATUS.CANCELLED,

        label: "Annulés",

    },

];

/* ==========================================================================
   COMPOSANT
   ========================================================================== */

export default function MyTrips() {

    const {

        currentUser,

    } = useAuth();

    const [

        trips,

        setTrips,

    ] = useState([]);

    const [

        loading,

        setLoading,

    ] = useState(true);

    const [

        search,

        setSearch,

    ] = useState("");

    const [

        selectedFilter,

        setSelectedFilter,

    ] = useState("all");

        /* =======================================================================
       CHARGEMENT DES TRAJETS
    ======================================================================= */

    useEffect(() => {

        if (!currentUser?.uid) {

            setLoading(false);

            return;

        }

        const unsubscribe =

            TripRepository.subscribeTripsByDriver(

                currentUser.uid,

                (driverTrips) => {

                    setTrips(driverTrips);

                    setLoading(false);

                }

            );

        return () => {

            unsubscribe();

        };

    }, [currentUser]);

    /* =======================================================================
       RECHERCHE + FILTRES
    ======================================================================= */

    const filteredTrips = useMemo(() => {

        const keyword =

            search

                .trim()

                .toLowerCase();

        return trips.filter((trip) => {

            const matchesFilter =

                selectedFilter === "all"

                    ? true

                    : trip.status === selectedFilter;

            const matchesSearch =

                keyword.length === 0 ||

                trip.departureCity

                    ?.toLowerCase()

                    .includes(keyword) ||

                trip.arrivalCity

                    ?.toLowerCase()

                    .includes(keyword) ||

                trip.departurePlace

                    ?.toLowerCase()

                    .includes(keyword) ||

                trip.arrivalPlace

                    ?.toLowerCase()

                    .includes(keyword) ||

                trip.vehicleType

                    ?.toLowerCase()

                    .includes(keyword);

            return (

                matchesFilter &&

                matchesSearch

            );

        });

    }, [

        trips,

        search,

        selectedFilter,

    ]);

    /* =======================================================================
    ACTIONS
    ======================================================================= */

    async function handleDeleteTrip(tripId) {

        const confirmation = window.confirm(

            "Voulez-vous vraiment supprimer ce trajet ?"

        );

        if (!confirmation) {

            return;

        }

        try {

            await TripRepository.deleteTrip(tripId);

        }

        catch (error) {

            console.error(error);

            alert(

                "Impossible de supprimer le trajet."

            );

        }

    }

    async function handleCancelTrip(tripId) {

        const confirmation = window.confirm(

            "Annuler ce trajet ?"

        );

        if (!confirmation) {

            return;

        }

        try {

            await TripRepository.cancelTrip(tripId);

        }

        catch (error) {

            console.error(error);

            alert(

                "Impossible d'annuler ce trajet."

            );

        }

    }

    async function handleCompleteTrip(tripId) {

        const confirmation = window.confirm(

            "Marquer ce trajet comme terminé ?"

        );

        if (!confirmation) {

            return;

        }

        try {

            await TripRepository.completeTrip(tripId);

        }

        catch (error) {

            console.error(error);

            alert(

                "Impossible de terminer ce trajet."

            );

        }

    }

        /* =======================================================================
       RENDER
    ======================================================================= */

    return (

        <DashboardLayout pageTitle="Mes trajets">

            <div className="my-trips-page">

                {/* ==========================================================
                    HEADER
                ========================================================== */}

                <div className="my-trips-header">

                    <div>

                        <h1>

                            Mes trajets

                        </h1>

                        <p>

                            Gérez les annonces que vous avez publiées.

                        </p>

                    </div>

                    <Link

                        to="/create-trip"

                        className="new-trip-button"

                    >

                        <FiPlus />

                        <span>

                            Publier un trajet

                        </span>

                    </Link>

                </div>

                {/* ==========================================================
                    RECHERCHE
                ========================================================== */}

                <div className="my-trips-search">

                    <FiSearch />

                    <input

                        type="text"

                        placeholder="Rechercher une ville, un lieu ou un véhicule..."

                        value={search}

                        onChange={(event) =>

                            setSearch(event.target.value)

                        }

                    />

                </div>

                {/* ==========================================================
                    FILTRES
                ========================================================== */}

                <TripFilters

                    filters={FILTERS}

                    selectedFilter={selectedFilter}

                    onChange={setSelectedFilter}

                />

                {/* ==========================================================
                    LISTE DES TRAJETS
                ========================================================== */}

                {

                    loading ? (

                        <div className="loading-trips">

                            Chargement des trajets...

                        </div>

                    ) : filteredTrips.length === 0 ? (

                        <EmptyTrips />

                    ) : (

                        <div className="trips-grid">

                            {

                                filteredTrips.map((trip) => (

                                    <TripCard

                                        key={trip.id}

                                        trip={trip}

                                        onDelete={handleDeleteTrip}

                                        onCancel={handleCancelTrip}

                                        onComplete={handleCompleteTrip}

                                    />

                                ))

                            }

                        </div>

                    )

                }

            </div>

        </DashboardLayout>

    );

}