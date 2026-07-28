import {

    FiUsers,
    FiTruck,
    FiMap,
    FiCreditCard

} from "react-icons/fi";

import StatCard from "./StatCard";

import "./page.css";

const stats = [

    {

        title: "Utilisateurs",

        value: "2 845",

        subtitle: "+24 aujourd'hui",

        icon: FiUsers,

        color: "#2563EB"

    },

    {

        title: "Trajets",

        value: "184",

        subtitle: "36 en cours",

        icon: FiMap,

        color: "#10B981"

    },

    {

        title: "Véhicules",

        value: "563",

        subtitle: "529 disponibles",

        icon: FiTruck,

        color: "#F59E0B"

    },

    {

        title: "Paiements",

        value: "8 450 000 FCFA",

        subtitle: "Aujourd'hui",

        icon: FiCreditCard,

        color: "#8B5CF6"

    }

];

export default function StatsGrid() {

    return (

        <section className="stats-grid">

            {

                stats.map(stat => (

                    <StatCard

                        key={stat.title}

                        {...stat}

                    />

                ))

            }

        </section>

    );

}