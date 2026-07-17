// src/components/users/UserList.jsx

import { useMemo, useState } from "react";

import UserCard from "./UserCard";

import "./users.css";

export default function UserList({

    users = [],

    selectedUser,

    onSelectUser

}) {

    const [search, setSearch] = useState("");

    const filteredUsers = useMemo(() => {

        if (!search.trim()) {

            return users;

        }

        const keyword = search.toLowerCase();

        return users.filter((user) => {

            const firstName =

                user.firstName ||

                user.prenom ||

                "";

            const lastName =

                user.lastName ||

                user.nom ||

                "";

            const fullName =

                `${firstName} ${lastName}`.toLowerCase();

            const email =

                (user.email || "").toLowerCase();

            const phone =

                (user.phone || user.numero || "").toLowerCase();

            return (

                fullName.includes(keyword) ||

                email.includes(keyword) ||

                phone.includes(keyword)

            );

        });

    }, [users, search]);

    return (

        <aside className="user-list">

            <div className="user-list-header">

                <div>

                    <h2>

                        Utilisateurs

                    </h2>

                    <span>

                        {filteredUsers.length} utilisateur(s)

                    </span>

                </div>

            </div>

            <div className="user-search">

                <input

                    type="text"

                    placeholder="Rechercher un utilisateur..."

                    value={search}

                    onChange={(event) => {

                        setSearch(event.target.value);

                    }}

                />

            </div>

            <div className="user-list-content">

                {

                    filteredUsers.length === 0 ? (

                        <div className="user-list-empty">

                            Aucun utilisateur trouvé.

                        </div>

                    ) : (

                        filteredUsers.map((user) => (

                            <UserCard

                                key={user.id}

                                user={user}

                                selected={

                                    selectedUser?.id === user.id

                                }

                                onClick={() => {

                                    onSelectUser(user);

                                }}

                            />

                        ))

                    )

                }

            </div>

        </aside>

    );

}