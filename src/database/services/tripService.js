import {
    collection,
    onSnapshot
} from "firebase/firestore";

import { db } from "../firebase/firebase";

const TRIPS_COLLECTION = "trips";

export function subscribeToTrips(callback) {

    return onSnapshot(

        collection(db, TRIPS_COLLECTION),

        (snapshot) => {

            console.log("Nombre de documents :", snapshot.size);

            const trips = snapshot.docs.map(doc => ({

                id: doc.id,

                ...doc.data()

            }));

            console.log(trips);

            callback(trips);

        },

        (error) => {

            console.error(error);

        }

    );

}