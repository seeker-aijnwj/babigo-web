import {
    FiUsers,
    FiTruck,
    FiMap,
    FiCreditCard
} from "react-icons/fi";

import StatCard from "./StatCard";

import "./page.css";

/**
 * ============================================================
 * StatsGrid
 * ============================================================
 *
 * Affiche les principales statistiques du Dashboard.
 *
 * Ce composant ne connaît ni Firestore,
 * ni DashboardRepository.
 *
 * Il reçoit uniquement les données préparées
 * par DashboardService via useDashboard().
 *
 * ============================================================
 */

export default function StatsGrid({

    stats,

    loading

}) {

    const cards = [

        {

            id: "users",

            title: "Utilisateurs",

            value: stats?.overview?.users ?? 0,

            subtitle: `${stats?.overview?.drivers ?? 0} conducteurs et ${stats?.overview?.passengers ?? 0} passagers`,

            icon: FiUsers,

            color: "#2563EB"

        },

        {

            id: "trips",

            title: "Trajets",

            value: stats?.overview?.trips ?? 0,

            subtitle: `${stats?.trips?.active ?? 0} en cours`,

            icon: FiMap,

            color: "#10B981"

        },

        {

            id: "vehicles",

            title: "Véhicules",

            value: stats?.overview?.vehicles ?? 0,

            subtitle: "Flotte enregistrée",

            icon: FiTruck,

            color: "#F59E0B"

        },

        {

            id: "transactions",

            title: "Transactions",

            value: stats?.overview?.transactions ?? 0,

            subtitle: `${stats?.finance?.succeededTransactions ?? 0} réussies`,

            icon: FiCreditCard,

            color: "#8B5CF6"

        }

    ];

    return (

        <section className="stats-grid">

            {

                cards.map(card => (

                    <StatCard

                        key={card.id}

                        title={card.title}

                        value={card.value}

                        subtitle={card.subtitle}

                        icon={card.icon}

                        color={card.color}

                        loading={loading}

                    />

                ))

            }

        </section>

    );

}