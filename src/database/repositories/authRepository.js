/******************************************************************************
 * BabiGO MVP
 * ----------------------------------------------------------------------------
 * Repository : AuthRepository
 *
 * Centralise toutes les opérations liées à Firebase Authentication.
 *
 * Compatible :
 * - React
 * - Firebase v10+
 * - GitHub Pages
 ******************************************************************************/

import {
    createUserWithEmailAndPassword,
    signInWithEmailAndPassword,
    signOut,
    sendPasswordResetEmail,
    updateProfile,
    onAuthStateChanged,
} from "firebase/auth";

import {
    doc,
    serverTimestamp,
    setDoc,
} from "firebase/firestore";

import { auth, db } from "../firebase/firebase";

class AuthRepository {

    /**
     * Retourne l'utilisateur actuellement connecté.
     */
    getCurrentUser() {

        return auth.currentUser;

    }

    /**
     * Inscription.
     */
    async register(userData) {

        const {

            firstName,
            lastName,
            phoneNumber,
            email,
            password,

        } = userData;

        /* ==============================================================
        FIREBASE AUTHENTICATION
        ============================================================== */

        const credential = await createUserWithEmailAndPassword(

            auth,

            email,

            password

        );

        const user = credential.user;

        /* ==============================================================
        DISPLAY NAME
        ============================================================== */

        const displayName = `${firstName} ${lastName}`.trim();

        await updateProfile(

            user,

            {

                displayName,

            }

        );

        /* ==============================================================
        FIRESTORE
        ============================================================== */

        await setDoc(

            doc(

                db,

                "users",

                user.uid,

            ),

            {

                uid: user.uid,

                firstName,

                lastName,

                displayName,

                phoneNumber,

                email,

                role: "passenger",

                isActive: true,

                createdAt: serverTimestamp(),

                updatedAt: serverTimestamp(),

            }

        );

        return user;

    }

    /**
     * Connexion.
     */
    async login(email, password) {

        const credential =

            await signInWithEmailAndPassword(

                auth,

                email,

                password,

            );

        return credential.user;

    }

    /**
     * Déconnexion.
     */
    async logout() {

        await signOut(auth);

    }

    /**
     * Réinitialisation du mot de passe.
     */
    async resetPassword(email) {

        await sendPasswordResetEmail(

            auth,

            email,

        );

    }

    /**
     * Écoute les changements d'authentification.
     */
    subscribe(callback) {

        return onAuthStateChanged(

            auth,

            callback,

        );

    }

}

const authRepository = new AuthRepository();

export default authRepository;