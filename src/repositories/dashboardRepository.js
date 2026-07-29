/* ==========================================================
   BABIGO Admin
   users.css
   Version : 0.3.0 F1.0

   src/database/repositories/dashboardRepository.js
   
   Ce fichier gère la communication avec la base de données
========================================================== */

import {
    collection,
    getCountFromServer,
    query,
    where
} from "firebase/firestore";

import { db } from "../services/firebase";

/**
 * ============================================================
 * DashboardRepository
 * ============================================================
 *
 * Couche d'accès aux données du Dashboard.
 *
 * Cette classe est la seule autorisée à communiquer
 * directement avec Firestore pour les statistiques.
 *
 * Les composants React ne doivent jamais effectuer
 * directement des requêtes Firestore.
 *
 * Architecture :
 *
 * React
 *    ↓
 * useDashboard()
 *    ↓
 * DashboardService
 *    ↓
 * DashboardRepository
 *    ↓
 * Firestore
 *
 * ============================================================
 */

class DashboardRepository {

    // ============================================================
    // MÉTHODES GÉNÉRIQUES
    // ============================================================

    /**
     * Compte tous les documents d'une collection.
     *
     * @param {string} collectionName
     * @returns {Promise<number>}
     */
    async getCollectionCount(collectionName) {

        const snapshot = await getCountFromServer(
            collection(db, collectionName)
        );

        return snapshot.data().count;

    }

    /**
     * Compte les documents correspondant à une requête.
     *
     * @param {Query} firestoreQuery
     * @returns {Promise<number>}
     */
    async getQueryCount(firestoreQuery) {

        const snapshot = await getCountFromServer(
            firestoreQuery
        );

        return snapshot.data().count;

    }

    // ============================================================
    // USERS
    // ============================================================

    async getUsersCount() {

        return this.getCollectionCount("users");

    }

    async getDriversCount() {

        return this.getQueryCount(

            query(

                collection(db, "users"),

                where("role", "==", "driver")

            )

        );

    }

    async getPassengersCount() {

        return this.getQueryCount(

            query(

                collection(db, "users"),

                where("role", "==", "passenger")

            )

        );

    }

    async getAdminsCount() {

        return this.getQueryCount(

            query(

                collection(db, "users"),

                where("role", "==", "admin")

            )

        );

    }

    async getSupportsCount() {

        return this.getQueryCount(

            query(

                collection(db, "users"),

                where("role", "==", "support")

            )

        );

    }

    async getFleetManagersCount() {

        return this.getQueryCount(

            query(

                collection(db, "users"),

                where("role", "==", "manager")

            )

        );

    }

    // ============================================================
    // TRIPS
    // ============================================================

    async getTripsCount() {

        return this.getCollectionCount("trips");

    }

    async getActiveTripsCount() {

        return this.getQueryCount(

            query(

                collection(db, "trips"),

                where("status", "==", "started")

            )

        );

    }

    async getCompletedTripsCount() {

        return this.getQueryCount(

            query(

                collection(db, "trips"),

                where("status", "==", "completed")

            )

        );

    }

    async getCancelledTripsCount() {

        return this.getQueryCount(

            query(

                collection(db, "trips"),

                where("status", "==", "cancelled")

            )

        );

    }

    async getPausedTripsCount() {

        return this.getQueryCount(

            query(

                collection(db, "trips"),

                where("status", "==", "pending")

            )

        );

    }


    // ============================================================
    // VEHICLES
    // ============================================================

    async getVehiclesCount() {

        return this.getCollectionCount("vehicles");

    }

    // ============================================================
    // TRANSACTIONS
    // ============================================================

    async getTransactionsCount() {

        return this.getCollectionCount("transactions");

    }

    async getSucceededTransactionsCount() {

        return this.getQueryCount(

            query(

                collection(db, "transactions"),

                where("status", "==", "SUCCEEDED")

            )

        );

    }

    async getPendingTransactionsCount() {

        return this.getQueryCount(

            query(

                collection(db, "transactions"),

                where("status", "==", "PENDING")

            )

        );

    }

    async getFailedTransactionsCount() {

        return this.getQueryCount(

            query(

                collection(db, "transactions"),

                where("status", "==", "FAILED")

            )

        );

    }

}

const dashboardRepository = new DashboardRepository();

export default dashboardRepository;