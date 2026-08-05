/******************************************************************************
==============================================================================
BabiGO

LegacyRepository

Repository de compatibilité.

Il centralise la lecture des anciennes structures Firestore
stockées sous forme de Map dans les documents utilisateurs.

A supprimer lorsque la migration sera terminée.

==============================================================================
*/

import {

    doc,

    getDoc,

} from "firebase/firestore";

import {

    db,

} from "../firebase/firebase";

class LegacyRepository {

    /* =======================================================================
       DOCUMENT UTILISATEUR
    ======================================================================= */

    async getUserDocument(userId) {

        if (!userId) {

            return null;

        }

        const snapshot = await getDoc(

            doc(

                db,

                "users",

                userId

            )

        );

        if (!snapshot.exists()) {

            return null;

        }

        return snapshot.data();

    }

}

const legacyRepository =

    new LegacyRepository();

export default legacyRepository;