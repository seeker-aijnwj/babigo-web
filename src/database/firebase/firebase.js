/******************************************************************************
 * BabiGO MVP
 * ----------------------------------------------------------------------------
 * Configuration Firebase
 *
 * Ce fichier initialise Firebase et exporte les services utilisés
 * par l'application.
 *
 * Services :
 * - Authentication
 * - Firestore
 * - Storage
 *
 * Compatible :
 * - React
 * - Firebase v10+
 * - GitHub Pages
 ******************************************************************************/


import { getAuth, } from "firebase/auth";
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getStorage, } from "firebase/storage";
import { getAnalytics } from "firebase/analytics";

/* ============================================================================
   CONFIGURATION FIREBASE
   Remplacer les valeurs ci-dessous par celles de votre projet Firebase.
============================================================================ */


const firebaseConfig = {
  appId: process.env.REACT_APP_FIREBASE_APP_ID,
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  measurementId: process.env.REACT_APP_FIREBASE_MEASUREMENT_ID
};


/* ============================================================================
   INITIALISATION
============================================================================ */

const app = initializeApp(firebaseConfig);

/* ============================================================================
   SERVICES
============================================================================ */

const auth = getAuth(app);

const db = getFirestore(app);

const firestore = getFirestore(app);

const storage = getStorage(app);

const analytics = getAnalytics(app);

/* ============================================================================
   EXPORTS
============================================================================ */

export {

    app,

    auth,

    analytics,

    db,

    firestore,

    storage,

};