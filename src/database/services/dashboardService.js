/* ==========================================================
   BABIGO Admin
   users.css
   Version : 0.3.0 F1.0

   src/database/services/dashboardService.js
   
   Ce fichier prépare les données métier
========================================================== */

import DashboardRepository from "../repositories/dashboardRepository";

/**
 * ============================================================
 * DashboardService
 * ============================================================
 *
 * Couche métier du Dashboard.
 *
 * Son rôle est de :
 *
 * - récupérer les données auprès du Repository ;
 * - les exécuter en parallèle ;
 * - préparer un objet unique pour l'interface ;
 * - gérer les erreurs.
 *
 * Aucun composant React ne doit appeler
 * directement DashboardRepository.
 *
 * ============================================================
 */

class DashboardService {

    /**
     * Charge toutes les statistiques nécessaires
     * au Dashboard.
     */
    async getDashboardStats() {

        try {

            const [

                users,
                drivers,
                passengers,
                admins,

                trips,
                activeTrips,
                completedTrips,
                cancelledTrips,

                vehicles,

                transactions,
                succeededTransactions,
                pendingTransactions,
                failedTransactions

            ] = await Promise.all([

                DashboardRepository.getUsersCount(),

                DashboardRepository.getDriversCount(),

                DashboardRepository.getPassengersCount(),

                DashboardRepository.getAdminsCount(),

                DashboardRepository.getTripsCount(),

                DashboardRepository.getActiveTripsCount(),

                DashboardRepository.getCompletedTripsCount(),

                DashboardRepository.getCancelledTripsCount(),

                DashboardRepository.getVehiclesCount(),

                DashboardRepository.getTransactionsCount(),

                DashboardRepository.getSucceededTransactionsCount(),

                DashboardRepository.getPendingTransactionsCount(),

                DashboardRepository.getFailedTransactionsCount()

            ]);

            return {

                success: true,

                updatedAt: new Date(),

                overview: {

                    users,

                    drivers,

                    passengers,

                    admins,

                    trips,

                    vehicles,

                    transactions

                },

                trips: {

                    total: trips,

                    active: activeTrips,

                    completed: completedTrips,

                    cancelled: cancelledTrips

                },

                finance: {

                    totalTransactions: transactions,

                    succeededTransactions,

                    pendingTransactions,

                    failedTransactions

                }

            };

        }

        catch (error) {

            console.error(

                "[DashboardService]",

                error

            );

            return {

                success: false,

                error,

                updatedAt: null,

                overview: {

                    users: 0,

                    drivers: 0,

                    passengers: 0,

                    admins: 0,

                    trips: 0,

                    vehicles: 0,

                    transactions: 0

                },

                trips: {

                    total: 0,

                    active: 0,

                    completed: 0,

                    cancelled: 0

                },

                finance: {

                    totalTransactions: 0,

                    succeededTransactions: 0,

                    pendingTransactions: 0,

                    failedTransactions: 0

                }

            };

        }

    }

}

const dashboardService = new DashboardService();

export default dashboardService;