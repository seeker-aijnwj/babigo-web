/******************************************************************************
==============================================================================
BabiGO MVP

NotificationRepository

Centralise toutes les opérations Firestore liées
aux notifications.

Architecture

Firestore

↓

NotificationRepository

↓

useNotifications()

↓

TopBar
NotificationDropdown

Une amélioration que je recommande

Je ne supprimerais jamais physiquement une notification lorsqu'elle est lue. En revanche, je prévoirais deux états :

isRead : indique si l'utilisateur l'a consultée ;
isArchived (ou isDeleted) : permet de masquer la notification de l'interface sans la supprimer définitivement.

Cela offre plusieurs avantages :

conserver un historique utile (par exemple pour les paiements ou les réservations) ;
éviter les suppressions accidentelles ;
permettre une restauration si nécessaire.

Nous pourrons intégrer cette logique dans la prochaine étape.


Une amélioration que je voudrais apporter avant la Partie 5

Je vois encore un point à renforcer.

Aujourd'hui, create() accepte un objet libre.

Je préférerais définir un modèle unique de notification.

Par exemple :

notificationFactory.createReservation(...)

ou

NotificationModel

Ainsi, toutes les notifications auraient automatiquement :

une icône ;
une couleur ;
un titre cohérent ;
un type valide ;
une structure identique.

Cela évite les oublis de champs (type, actionUrl, etc.) et simplifie l'affichage
 dans le futur NotificationDropdown.

 Une amélioration importante avant de continuer

Je voudrais toutefois corriger un point d'architecture.

Dans les parties précédentes, j'ai utilisé :

archived

comme nom de champ.

Pour rester cohérent avec le reste de ton projet (isRead, isActive, etc.), je te recommande de renommer ce champ en :

isArchived

Ainsi, toutes les propriétés booléennes de ton application suivront la même convention :

isRead

isArchived

isActive

isDeleted

isVerified

isOnline

C'est plus cohérent, plus lisible et plus facile à maintenir sur le long terme.
==============================================================================
*/

import {

    collection,

    doc,

    query,

    where,

    orderBy,

    limit,

    onSnapshot,

    getDocs,

    getDoc,

    updateDoc,

    deleteDoc,

    addDoc,

    serverTimestamp,

    writeBatch,

} from "firebase/firestore";

import {

    db,

} from "../firebase/firebase";

import { DEFAULT_NOTIFICATION_LIMIT } from "../../components/constants/app";

class NotificationRepository {

    /* =======================================================================
       COLLECTION
    ======================================================================= */

    collection() {

        return collection(

            db,

            "notifications"

        );

    }

    /* =======================================================================
       DOCUMENT
    ======================================================================= */

    document(notificationId) {

        return doc(

            db,

            "notifications",

            notificationId

        );

    }

    /* =======================================================================
       SUBSCRIBE
       Ecoute en temps réel les notifications d'un utilisateur.
    ======================================================================= */

    /* =======================================================================
   SUBSCRIBE
======================================================================= */

    subscribe(userId, callback) {

        if (!userId) {

            callback({

                notifications: [],

                unreadCount: 0,

            });

            return () => {};

        }

        const notificationsQuery = query(

            this.collection(),

            where("userId", "==", userId),

            orderBy("createdAt", "desc"),

            limit(DEFAULT_NOTIFICATION_LIMIT),

        );

        let collectionNotifications = [];

        let legacyNotifications = [];

        const notify = () => {

            const notifications =

                this.mergeNotifications(

                    collectionNotifications,

                    legacyNotifications,

                );

            callback({

                notifications,

                unreadCount:

                    notifications.filter(

                        (notification) =>

                            !notification.isRead

                    ).length,

            });

        };

        this.getLegacyNotifications(

            userId

        ).then(

            (notifications) => {

                legacyNotifications = notifications;

                notify();

            }

        );

        const unsubscribe = onSnapshot(

            notificationsQuery,

            (snapshot) => {

                collectionNotifications =

                    snapshot.docs.map(

                        (documentSnapshot) => ({

                            id: documentSnapshot.id,

                            source: "collection",

                            ...documentSnapshot.data(),

                        })

                    );

                notify();

            },

            (error) => {

                console.error(

                    error

                );

            }

        );

        return unsubscribe;

    }

    /* =======================================================================
       RECUPERATION SIMPLE
    ======================================================================= */

    async getNotifications(userId) {

        const notificationsQuery = query(

            this.collection(),

            where("userId", "==", userId),

            orderBy("createdAt", "desc"),

            limit(30)

        );

        const snapshot = await getDocs(

            notificationsQuery

        );

        return snapshot.docs.map(

            (documentSnapshot) => ({

                id: documentSnapshot.id,

                ...documentSnapshot.data(),

            })

        );

    }

    /* =======================================================================
    PRIVATE
    Met à jour une notification
    ======================================================================= */

    async update(notificationId, data) {

        await updateDoc(

            this.document(notificationId),

            {

                ...data,

                updatedAt: serverTimestamp(),

            }

        );

    }

    /* =======================================================================
    MARQUER COMME LUE
    ======================================================================= */

    async markAsRead(notificationId) {

        await this.update(

            notificationId,

            {

                isRead: true,

                readAt: serverTimestamp(),

            }

        );

    }

    /* =======================================================================
    MARQUER COMME NON LUE
    ======================================================================= */

    async markAsUnread(notificationId) {

        await this.update(

            notificationId,

            {

                isRead: false,

                readAt: null,

            }

        );

    }

    /* =======================================================================
    TOUT MARQUER COMME LU
    ======================================================================= */

    async markAllAsRead(userId) {

        const notificationsQuery = query(

            this.collection(),

            where("userId", "==", userId),

            where("isRead", "==", false)

        );

        const snapshot = await getDocs(

            notificationsQuery

        );

        if (snapshot.empty) {

            return;

        }

        const batch = writeBatch(db);

        snapshot.forEach((documentSnapshot) => {

            batch.update(

                documentSnapshot.ref,

                {

                    isRead: true,

                    readAt: serverTimestamp(),

                    updatedAt: serverTimestamp(),

                }

            );

        });

        await batch.commit();

    }

    /* =======================================================================
    CREER UNE NOTIFICATION
    ======================================================================= */

    async create(notification) {

        const {

            userId,

            title,

            message,

            type,

            actionUrl = null,

            metadata = {},

        } = notification;

        const document = {

            userId,

            title,

            message,

            type,

            actionUrl,

            metadata,

            isRead: false,

            readAt: null,

            createdAt: serverTimestamp(),

            updatedAt: serverTimestamp(),

        };

        const reference = await addDoc(

            this.collection(),

            document

        );

        return reference.id;

    }

    /* =======================================================================
    ARCHIVER
    ======================================================================= */

    async archive(notificationId) {

        await this.update(

            notificationId,

            {

                archived: true,

                archivedAt: serverTimestamp(),

            }

        );

    }

    /* =======================================================================
    RESTAURER
    ======================================================================= */

    async restore(notificationId) {

        await this.update(

            notificationId,

            {

                archived: false,

                archivedAt: null,

            }

        );

    }

    /* =======================================================================
    SUPPRESSION DEFINITIVE
    ======================================================================= */

    async delete(notificationId) {

        await deleteDoc(

            this.document(notificationId)

        );

    }

        /* =======================================================================
       NOTIFICATIONS NON ARCHIVÉES
    ======================================================================= */

    async getActiveNotifications(userId) {

        const notifications =

            await this.getNotifications(userId);

        return notifications.filter(

            (notification) =>

                notification.archived !== true

        );

    }

    /* =======================================================================
       NOTIFICATIONS NON LUES
    ======================================================================= */

    async getUnreadNotifications(userId) {

        const notifications =

            await this.getNotifications(userId);

        return notifications.filter(

            (notification) =>

                notification.isRead === false &&

                notification.archived !== true

        );

    }

    /* =======================================================================
       NOMBRE DE NOTIFICATIONS NON LUES
    ======================================================================= */

    async getUnreadCount(userId) {

        const notifications =

            await this.getUnreadNotifications(userId);

        return notifications.length;

    }

    /* =======================================================================
    LECTURE DES NOTIFICATIONS LEGACY

    users/{uid}.notifications
    ======================================================================= */

    async getLegacyNotifications(userId) {

        if (!userId) {

            return [];

        }

        const userDocument = await getDoc(

            doc(

                db,

                "users",

                userId

            )

        );

        if (!userDocument.exists()) {

            return [];

        }

        const data = userDocument.data();

        const notificationsMap =

            data.notifications ?? {};

        const notifications =

            Object.entries(

                notificationsMap

            ).map(

                ([id, notification]) => ({

                    id,

                    source: "legacy",

                    ...notification,

                })

            );

        return notifications;

    }

    /* =======================================================================
    FUSION DES NOTIFICATIONS
    ======================================================================= */

    mergeNotifications(

        collectionNotifications,

        legacyNotifications,

    ) {

        const merged = new Map();

        [
            ...legacyNotifications,

            ...collectionNotifications,

        ].forEach((notification) => {

            /*
            * Si une notification existe dans les deux sources,
            * on conserve prioritairement celle provenant
            * de la nouvelle collection.
            */

            const key =

                notification.id ||

                `${notification.type}_${notification.createdAt?.seconds ?? Date.now()}`;

            if (

                !merged.has(key) ||

                notification.source === "collection"

            ) {

                merged.set(

                    key,

                    notification

                );

            }

        });

        return [...merged.values()].sort(

            (a, b) => {

                const aTime =

                    a.createdAt?.seconds ?? 0;

                const bTime =

                    b.createdAt?.seconds ?? 0;

                return bTime - aTime;

            }

        );

    }

}

const notificationRepository =

    new NotificationRepository();

export default notificationRepository;