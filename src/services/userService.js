import {
    collection,
    onSnapshot
} from "firebase/firestore";

import { db } from "./firebase";

const USERS_COLLECTION = "users";

export function subscribeToUsers(callback) {

    return onSnapshot(

        collection(db, USERS_COLLECTION),

        (snapshot) => {

            console.log("Nombre de documents :", snapshot.size);

            const users = snapshot.docs.map(doc => ({

                id: doc.id,

                ...doc.data()

            }));

            console.log(users);

            callback(users);

        },

        (error) => {

            console.error(error);

        }

    );

}