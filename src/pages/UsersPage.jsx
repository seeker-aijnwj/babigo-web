import { useEffect, useState } from "react";

import DashboardLayout from "../components/layouts/DashboardLayout";

import UserList from "../components/users/UserList";
import UserDetails from "../components/users/UserDetails";

import { subscribeToUsers } from "../services/userService";

export default function UsersPage() {

    // ===============================
    // ETATS
    // ===============================

    const [users, setUsers] = useState([]);

    const [selectedUser, setSelectedUser] = useState(null);

    // ===============================
    // CHARGEMENT DES UTILISATEURS
    // ===============================

    useEffect(() => {

        const unsubscribe = subscribeToUsers((firebaseUsers) => {

            console.log("Utilisateurs reçus :", firebaseUsers);

            setUsers(firebaseUsers);

            // Sélection automatique du premier utilisateur
            if (firebaseUsers.length > 0) {

                setSelectedUser((currentUser) => {

                    if (currentUser) {
                        return currentUser;
                    }

                    return firebaseUsers[0];

                });

            }

        });

        // Nettoyage de l'écoute Firestore
        return () => unsubscribe();

    }, []);

    // ===============================
    // AFFICHAGE
    // ===============================

    return (

        <DashboardLayout>

            <div
                style={{
                    display: "flex",
                    height: "calc(100vh - 70px)",
                    background: "#f5f7fa"
                }}
            >

                <UserList
                    users={users}
                    selectedUser={selectedUser}
                    onSelectUser={setSelectedUser}
                />

                <UserDetails
                    user={selectedUser}
                />

            </div>

        </DashboardLayout>

    );

}