// src/components/users/UserList.jsx

import { useMemo, useState } from "react";

import UserSearch from "./UserSearch";
import UserCard from "./UserCard";

import "./users.css";

export default function UserList({

    users = [],

    selectedUser,

    onSelectUser

}) {

    const [search, setSearch] = useState("");

    const filteredUsers = useMemo(() => {

        return users.filter((user) => {

            const fullName = `${user.firstName || user.prenom || ""} ${user.lastName || user.nom || ""}`
                .toLowerCase();

            return fullName.includes(search.toLowerCase());

        });

    }, [users, search]);

    return (

        <aside className="users-panel">

            <div className="users-header">

                <h2>

                    Utilisateurs

                </h2>

                <span>

                    {filteredUsers.length}

                </span>

            </div>

            <UserSearch

                value={search}

                onChange={setSearch}

            />

            <div className="users-scroll">

                {

                    filteredUsers.length === 0 ?

                        (

                            <div className="empty-users">

                                Aucun utilisateur trouvé.

                            </div>

                        )

                        :

                        filteredUsers.map(user => (

                            <UserCard

                                key={user.id}

                                user={user}

                                selected={selectedUser?.id === user.id}

                                onClick={onSelectUser}

                            />

                        ))

                }

            </div>

        </aside>

    );

}