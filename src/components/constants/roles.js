/******************************************************************************
==============================================================================
BabiGO
USER ROLES
==============================================================================

Définition centralisée des rôles de l'application.

Toutes les comparaisons de rôles doivent utiliser USER_ROLES
plutôt que des chaînes de caractères.

Exemple :

if (user.role === USER_ROLES.ADMIN) { ... }

==============================================================================
*/

export const USER_ROLES = Object.freeze({

    PASSENGER: "passenger",

    DRIVER: "driver",

    FLEET_MANAGER: "fleet_manager",

    SUPPORT: "support",

    ADMIN: "admin",

    INVESTOR: "investor",

});

/* ============================================================================
   LISTE DES RÔLES
============================================================================ */

export const USER_ROLE_LIST = Object.freeze(

    Object.values(USER_ROLES)

);

/* ============================================================================
   LIBELLÉS FRANÇAIS
============================================================================ */

export const USER_ROLE_LABELS = Object.freeze({

    [USER_ROLES.PASSENGER]: "Passager",

    [USER_ROLES.DRIVER]: "Conducteur",

    [USER_ROLES.FLEET_MANAGER]: "Gestionnaire de flotte",

    [USER_ROLES.SUPPORT]: "Support",

    [USER_ROLES.ADMIN]: "Administrateur",

    [USER_ROLES.INVESTOR]: "Investisseur",

});