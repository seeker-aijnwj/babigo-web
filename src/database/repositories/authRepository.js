/******************************************************************************
==============================================================================
BabiGO
Repository : AuthRepository
==============================================================================

Architecture

Firebase Authentication
        │
        ▼
Firestore users/{uid}
        │
        ▼
AppUser
        │
        ▼
useAuth()
        │
        ▼
Toute l'application

==============================================================================
*/

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

    getDoc,

    onSnapshot,

    setDoc,

    serverTimestamp,

} from "firebase/firestore";

import {

    auth,

    db,

} from "../firebase/firebase";

import { USER_ROLES } from "../../components/constants/roles";

/* ============================================================================
   CLASSE
============================================================================ */

class AuthRepository {

    /* ========================================================================
       CONSTRUCTEUR
    ======================================================================== */

    constructor() {

        this.unsubscribeProfile = null;

    }

    /* ========================================================================
       PRIVATE
       Retourne la référence Firestore
    ======================================================================== */

    getUserDocument(uid) {

        return doc(

            db,

            "users",

            uid,

        );

    }

    /* ========================================================================
    PRIVATE
    Construit l'objet AppUser
    ======================================================================== */

    buildUserProfile(firebaseUser, firestoreUser = {}) {

        if (!firebaseUser) {

            return null;

        }

        return {

            uid: firebaseUser.uid,

            email: firebaseUser.email,

            displayName: firebaseUser.displayName ?? "",

            photoURL: firebaseUser.avatar ?? null,

            fullName:
                firebaseUser.displayName ?? "",

            role: "passenger",

            numero: "",

            isActive: true,

            ...firestoreUser,

        };

    }

    /* ========================================================================
    PRIVATE
    Charge le profil Firestore
    ======================================================================== */

    async loadUserProfile(firebaseUser) {

        if (!firebaseUser) {

            return null;

        }

        const snapshot = await getDoc(

            this.getUserDocument(

                firebaseUser.uid

            )

        );

        if (!snapshot.exists()) {

            return this.buildUserProfile(

                firebaseUser

            );

        }

        return this.buildUserProfile(

            firebaseUser,

            snapshot.data()

        );

    }

    /* ========================================================================
    INSCRIPTION
    ======================================================================== */

    async register(userData) {

        const {

            prenom,

            nom,

            numero,

            email,

            password,

        } = userData;

        /* ==============================================================
        FIREBASE AUTH
        ============================================================== */

        const credential =

            await createUserWithEmailAndPassword(

                auth,

                email,

                password,

            );

        const firebaseUser = credential.user;

        /* ==============================================================
        NOM COMPLET
        ============================================================== */

        const displayName =

            `${prenom} ${nom}`.trim();

        await updateProfile(

            firebaseUser,

            {

                displayName,

            }

        );

        /* ==============================================================
        PROFIL FIRESTORE
        ============================================================== */

        const profile = {

            /* -----------------------------
            Identité
            ------------------------------ */

            uid: firebaseUser.uid,

            prenom,

            nom,

            fullName: displayName,

            displayName,

            email,

            numero,

            photoURL:

                firebaseUser.avatar ?? null,

            /* -----------------------------
            Compte
            ------------------------------ */

            role: USER_ROLES.PASSENGER,

            isActive: true,

            emailVerified:

                firebaseUser.emailVerified,

            /* -----------------------------
            Statistiques MVP
            ------------------------------ */

            totalTrips: 0,

            totalReservations: 0,

            completedTrips: 0,

            cancelledTrips: 0,

            rating: 5,

            totalReviews: 0,

            /* -----------------------------
            Paramètres
            ------------------------------ */

            language: "fr",

            currency: "XOF",

            notifications: {

                email: true,

                push: true,

                sms: false,

            },

            /* -----------------------------
            Dates
            ------------------------------ */

            createdAt: serverTimestamp(),

            updatedAt: serverTimestamp(),

        };

        await setDoc(

            this.getUserDocument(

                firebaseUser.uid

            ),

            profile,

        );

        /* ==============================================================
        RETOUR
        ============================================================== */

        return await this.buildUserProfile(

            firebaseUser

        );

    }

    /* ========================================================================
    UTILISATEUR COURANT
    ======================================================================== */

    async getCurrentUser() {

        const firebaseUser = auth.currentUser;

        if (!firebaseUser) {

            return null;

        }

        return await this.loadUserProfile(

            firebaseUser

        );

    }

    /* ========================================================================
    CONNEXION
    ======================================================================== */

    async login(email, password) {

        /* ==============================================================
        FIREBASE AUTH
        ============================================================== */

        const credential =

            await signInWithEmailAndPassword(

                auth,

                email,

                password,

            );

        const firebaseUser = credential.user;

        /* ==============================================================
        PROFIL COMPLET
        ============================================================== */

        const profile =

            await this.loadUserProfile(

                firebaseUser

            );

        /* ==============================================================
        COMPTE DÉSACTIVÉ
        ============================================================== */

        if (!profile.isActive) {

            await signOut(auth);

            throw new Error(

                "Votre compte est désactivé."

            );

        }

        /* ==============================================================
        RETOUR
        ============================================================== */

        return profile;

    }

    /* ========================================================================
    OBSERVER AUTH + FIRESTORE
    ======================================================================== */

    subscribe(callback) {

        let unsubscribeProfile = null;

        const unsubscribeAuth = onAuthStateChanged(

            auth,

            async (firebaseUser) => {

                /* ----------------------------------------------------------
                Nettoyage de l'ancien listener Firestore
                ---------------------------------------------------------- */

                if (unsubscribeProfile) {

                    unsubscribeProfile();

                    unsubscribeProfile = null;

                }

                /* ----------------------------------------------------------
                Déconnecté
                ---------------------------------------------------------- */

                if (!firebaseUser) {

                    callback(null);

                    return;

                }

                /* ----------------------------------------------------------
                Document Firestore
                ---------------------------------------------------------- */

                const userRef = this.getUserDocument(

                    firebaseUser.uid

                );

                unsubscribeProfile = onSnapshot(

                    userRef,

                    async (snapshot) => {

                        let profile;

                        if (snapshot.exists()) {

                            profile = {

                                uid: firebaseUser.uid,

                                email: firebaseUser.email,

                                displayName:
                                    firebaseUser.displayName,

                                photoURL:
                                    firebaseUser.avatar,

                                ...snapshot.data(),

                            };

                        }

                        else {

                            profile = await this.loadUserProfile(

                                firebaseUser

                            );

                        }

                        callback(profile);

                    },

                    (error) => {

                        console.error(

                            "Erreur Firestore :", error

                        );

                        callback(null);

                    }

                );

            }

        );

        /* --------------------------------------------------------------
        Nettoyage global
        -------------------------------------------------------------- */

        return () => {

            if (unsubscribeProfile) {

                unsubscribeProfile();

            }

            unsubscribeAuth();

        };

    }

    /* ========================================================================
    RESET PASSWORD
    ======================================================================== */

    async resetPassword(email) {

        await sendPasswordResetEmail(

            auth,

            email,

        );

    }

}

const authRepository = new AuthRepository();

export default authRepository;


