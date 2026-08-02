/******************************************************************************
 * BabiGO MVP
 * ----------------------------------------------------------------------------
 * Hook : useAuth
 *
 * Rôle :
 * Gère l'état global de l'authentification Firebase.
 *
 * Fournit :
 * - user
 * - loading
 * - isAuthenticated
 * - login()
 * - register()
 * - logout()
 * - resetPassword()
 ******************************************************************************/

import {
    useCallback,
    useEffect,
    useState,
} from "react";

import authRepository from "../database/repositories/authRepository";

export default function useAuth() {

    /* =======================================================================
       ETATS
    ======================================================================= */

    const [user, setUser] = useState(null);

    const [loading, setLoading] = useState(true);

    /* =======================================================================
       OBSERVER FIREBASE
    ======================================================================= */

    useEffect(() => {

        const unsubscribe = authRepository.subscribe(

            (firebaseUser) => {

                setUser(firebaseUser);

                setLoading(false);

            }

        );

        return unsubscribe;

    }, []);

    /* =======================================================================
       ACTIONS
    ======================================================================= */

    const login = useCallback(

        async (email, password) => {

            return await authRepository.login(

                email,

                password,

            );

        },

        [],

    );

    const register = useCallback(

        async (data) => {

            return await authRepository.register(data);

        },

        [],

    );

    const logout = useCallback(

        async () => {

            await authRepository.logout();

        },

        [],

    );

    const resetPassword = useCallback(

        async (email) => {

            await authRepository.resetPassword(email);

        },

        [],

    );

    /* =======================================================================
       ETAT DERIVE
    ======================================================================= */

    const isAuthenticated = !!user;

    /* =======================================================================
       EXPORT
    ======================================================================= */

    return {

        user,

        loading,

        isAuthenticated,

        login,

        register,

        logout,

        resetPassword,

    };

}