import {

    FiHome,

    FiUsers,

    FiMap,

    FiTruck,

    FiCreditCard,

    FiHeadphones,

    FiTrendingUp,

    FiSettings,

    FiUser,

    FiPlusCircle,

    FiBookmark,

    FiBarChart2,

} from "react-icons/fi";

import {

    USER_ROLES,

} from "../components/constants/roles";
import { FaCar } from "react-icons/fa";

export const MENU_CONFIGURATION = [

    /* ============================================================
       TABLEAU DE BORD
    ============================================================ */

    {

        id: "dashboard",

        label: "Tableau de bord",

        path: "/dashboard",

        icon: FiHome,

        roles: [

            USER_ROLES.ADMIN,

            USER_ROLES.DRIVER,

            USER_ROLES.PASSENGER,

            USER_ROLES.SUPPORT,

            USER_ROLES.FLEET_MANAGER,

            USER_ROLES.INVESTOR,

        ],

    },

    /* ============================================================
       PASSAGER
    ============================================================ */

    {

        id: "search",

        label: "Rechercher un trajet",

        path: "/search",

        icon: FiMap,

        roles: [

            USER_ROLES.PASSENGER,

        ],

    },

    {

        id: "reservations",

        label: "Mes réservations",

        path: "/reservations",

        icon: FiBookmark,

        roles: [

            USER_ROLES.PASSENGER,

        ],

    },

    /* ============================================================
       CONDUCTEUR
    ============================================================ */

    {

        id: "createTrip",

        label: "Publier un trajet",

        path: "/create-trip",

        icon: FiPlusCircle,

        roles: [

            USER_ROLES.DRIVER,

        ],

    },

    {

        id: "myTrips",

        label: "Mes trajets",

        path: "/my-trips",

        icon: FiMap,

        roles: [

            USER_ROLES.DRIVER,

        ],

    },

    {

        id: "vehicles",

        label: "Mes véhicules",

        path: "/vehicles",

        icon: FaCar,

        roles: [

            USER_ROLES.DRIVER,

            USER_ROLES.FLEET_MANAGER,

        ],

    },

        /* ============================================================
       GESTIONNAIRE DE FLOTTE
    ============================================================ */

    {

        id: "fleet",

        label: "Ma flotte",

        path: "/fleet",

        icon: FaCar,

        roles: [

            USER_ROLES.FLEET_MANAGER,

        ],

    },

    {

        id: "fleetStatistics",

        label: "Statistiques",

        path: "/fleet/statistics",

        icon: FiBarChart2,

        roles: [

            USER_ROLES.FLEET_MANAGER,

        ],

    },

    /* ============================================================
       SUPPORT
    ============================================================ */

    {

        id: "users",

        label: "Utilisateurs",

        path: "/users",

        icon: FiUsers,

        roles: [

            USER_ROLES.SUPPORT,

            USER_ROLES.ADMIN,

        ],

    },

    {

        id: "support",

        label: "Support",

        path: "/support",

        icon: FiHeadphones,

        badge: 3,

        roles: [

            USER_ROLES.SUPPORT,

            USER_ROLES.ADMIN,

        ],

    },

    /* ============================================================
       PAIEMENTS
    ============================================================ */

    {

        id: "payments",

        label: "Paiements",

        path: "/payments",

        icon: FiCreditCard,

        roles: [

            USER_ROLES.ADMIN,

            USER_ROLES.SUPPORT,

            USER_ROLES.DRIVER,

            USER_ROLES.PASSENGER,

            USER_ROLES.FLEET_MANAGER,

        ],

    },

    /* ============================================================
       INVESTISSEURS
    ============================================================ */

    {

        id: "investors",

        label: "Investisseurs",

        path: "/investors",

        icon: FiTrendingUp,

        roles: [

            USER_ROLES.ADMIN,

            USER_ROLES.INVESTOR,

        ],

    },

    /* ============================================================
       PROFIL
    ============================================================ */

    {

        id: "account",

        label: "Mon profil",

        path: "/account",

        icon: FiUser,

        roles: [

            USER_ROLES.ADMIN,

            USER_ROLES.DRIVER,

            USER_ROLES.PASSENGER,

            USER_ROLES.SUPPORT,

            USER_ROLES.FLEET_MANAGER,

            USER_ROLES.INVESTOR,

        ],

    },

    /* ============================================================
       PARAMÈTRES
    ============================================================ */

    {

        id: "settings",

        label: "Paramètres",

        path: "/settings",

        icon: FiSettings,

        roles: [

            USER_ROLES.ADMIN,

            USER_ROLES.DRIVER,

            USER_ROLES.PASSENGER,

            USER_ROLES.SUPPORT,

            USER_ROLES.FLEET_MANAGER,

            USER_ROLES.INVESTOR,

        ],

    },

];