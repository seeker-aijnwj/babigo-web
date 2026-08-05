/******************************************************************************
 * ============================================================================
 * BabiGO
 * TripRepository.js
 * ============================================================================
 *
 * Gestion des trajets Firestore.
 *
 * Ce Repository est le seul composant qui dialogue
 * directement avec Firebase.
 *
 ******************************************************************************/

import {

    addDoc,

    collection,

    doc,

    getDoc,

    getDocs,

    query,

    where,

    orderBy,

    onSnapshot,

    updateDoc,

    deleteDoc,

    serverTimestamp,

} from "firebase/firestore";

import {

    db,

} from "../firebase/firebase.js";

/* ==========================================================================
   COLLECTION
   ========================================================================== */

const TRIPS_COLLECTION = "trips";

/* ==========================================================================
   STATUTS D'UN TRAJET
   ========================================================================== */

export const TRIP_STATUS = Object.freeze({

    PUBLISHED: "published",

    COMPLETED: "completed",

    CANCELLED: "cancelled",

});

/* ==========================================================================
   REPOSITORY
   ========================================================================== */

const TripRepository = {

    /**
     * ----------------------------------------------------------
     * Publier un trajet
     * ----------------------------------------------------------
     */

    async createTrip(trip) {

        const document = {

            ...trip,

            createdAt: serverTimestamp(),

            updatedAt: serverTimestamp(),

        };

        const reference = await addDoc(

            collection(db, TRIPS_COLLECTION),

            document

        );

        return reference.id;

    },

        /**
     * ----------------------------------------------------------
     * Récupérer un trajet par son identifiant
     * ----------------------------------------------------------
     */

    async getTripById(tripId) {

        const reference = doc(

            db,

            TRIPS_COLLECTION,

            tripId

        );

        const snapshot = await getDoc(reference);

        if (!snapshot.exists()) {

            return null;

        }

        return {

            id: snapshot.id,

            ...snapshot.data(),

        };

    },

    /**
     * ----------------------------------------------------------
     * Tous les trajets d'un conducteur
     * ----------------------------------------------------------
     */

    async getTripsByDriver(driverId) {

        const tripsQuery = query(

            collection(db, TRIPS_COLLECTION),

            where("driverId", "==", driverId),

            orderBy("createdAt", "desc")

        );

        const snapshot = await getDocs(tripsQuery);

        return snapshot.docs.map((document) => ({

            id: document.id,

            ...document.data(),

        }));

    },

    /**
     * ----------------------------------------------------------
     * Tous les trajets publiés
     * ----------------------------------------------------------
     */

    async getPublishedTrips() {

        const tripsQuery = query(

            collection(db, TRIPS_COLLECTION),

            where("status", "==", TRIP_STATUS.PUBLISHED),

            orderBy("tripDate"),

            orderBy("tripTime")

        );

        const snapshot = await getDocs(tripsQuery);

        return snapshot.docs.map((document) => ({

            id: document.id,

            ...document.data(),

        }));

    },

    /**
     * ----------------------------------------------------------
     * Écoute en temps réel des trajets d'un conducteur
     * ----------------------------------------------------------
     *
     * Utilisée par MyTrips.jsx.
     *
     * Retourne une fonction unsubscribe().
     *
     */

    subscribeTripsByDriver(driverId, callback) {

        const tripsQuery = query(

            collection(db, TRIPS_COLLECTION),

            where("driverId", "==", driverId),

            orderBy("createdAt", "desc")

        );

        return onSnapshot(

            tripsQuery,

            (snapshot) => {

                const trips = snapshot.docs.map((document) => ({

                    id: document.id,

                    ...document.data(),

                }));

                callback(trips);

            },

            (error) => {

                console.error(

                    "Erreur de synchronisation des trajets :",

                    error

                );

            }

        );

    },

    /**
     * ----------------------------------------------------------
     * Modifier un trajet
     * ----------------------------------------------------------
     */

    async updateTrip(tripId, data) {

        const reference = doc(

            db,

            TRIPS_COLLECTION,

            tripId

        );

        await updateDoc(

            reference,

            {

                ...data,

                updatedAt: serverTimestamp(),

            }

        );

    },

    /**
     * ----------------------------------------------------------
     * Annuler un trajet
     * ----------------------------------------------------------
     */

    async cancelTrip(tripId) {

        const reference = doc(

            db,

            TRIPS_COLLECTION,

            tripId

        );

        await updateDoc(

            reference,

            {

                status: TRIP_STATUS.CANCELLED,

                updatedAt: serverTimestamp(),

            }

        );

    },

    /**
     * ----------------------------------------------------------
     * Marquer un trajet comme terminé
     * ----------------------------------------------------------
     */

    async completeTrip(tripId) {

        const reference = doc(

            db,

            TRIPS_COLLECTION,

            tripId

        );

        await updateDoc(

            reference,

            {

                status: TRIP_STATUS.COMPLETED,

                updatedAt: serverTimestamp(),

            }

        );

    },

    /**
     * ----------------------------------------------------------
     * Supprimer définitivement un trajet
     * ----------------------------------------------------------
     */

    async deleteTrip(tripId) {

        const reference = doc(

            db,

            TRIPS_COLLECTION,

            tripId

        );

        await deleteDoc(reference);

    },

        /**
     * ----------------------------------------------------------
     * Compter le nombre de trajets publiés
     * ----------------------------------------------------------
     *
     * Utilisé par le Dashboard.
     *
     */

    async countTripsByDriver(driverId) {

        const trips = await this.getTripsByDriver(driverId);

        return trips.length;

    },

};


/* ==========================================================================
   EXPORT
   ========================================================================== */

export default TripRepository;