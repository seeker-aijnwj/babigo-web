import { useEffect, useState } from "react";

import UserList from "../components/users/UserList";
import UserDetails from "../components/users/UserDetails";

import { subscribeToUsers } from "../services/userService";

export default function UsersPage() {

    const [users, setUsers] = useState([]);
    const [selectedUser, setSelectedUser] = useState(null);

    useEffect(() => {

        const unsubscribe = subscribeToUsers((users) => {

            setUsers(users);

            // Sélection automatique du premier utilisateur
            if (users.length > 0 && !selectedUser) {
                setSelectedUser(users[0]);
            }

        });

        return () => unsubscribe();

    }, [selectedUser]);

    return (

        <div
            style={{
                display: "flex",
                height: "100vh",
                overflow: "hidden",
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

    );

}