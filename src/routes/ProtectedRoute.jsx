/******************************************************************************
 * BabiGO MVP
 * ----------------------------------------------------------------------------
 * Composant : ProtectedRoute
 *
 * Rôle :
 * Protège les pages nécessitant une authentification.
 *
 * Compatible :
 * - React Router v6
 * - Firebase Authentication
 ******************************************************************************/

import React from "react";

import {

    Navigate,

    Outlet,

} from "react-router-dom";

import useAuth from "../hooks/useAuth";

export default function ProtectedRoute() {

    /* =======================================================================
       AUTH
    ======================================================================= */

    const {

        loading,

        isAuthenticated,

    } = useAuth();

    /* =======================================================================
       CHARGEMENT
    ======================================================================= */

    if (loading) {

        return (

            <div
                className="app-loading"
            >

                Chargement...

            </div>

        );

    }

    /* =======================================================================
       UTILISATEUR NON CONNECTE
    ======================================================================= */

    if (!isAuthenticated) {

        return (

            <Navigate

                to="/login"

                replace

            />

        );

    }

    /* =======================================================================
       UTILISATEUR CONNECTE
    ======================================================================= */

    return <Outlet />;

}