import { useEffect, useState } from "react";

import { getUsers } from "../services/userService";

export default function UsersPage() {

    const [users, setUsers] = useState([]);

    const [loading, setLoading] = useState(true);

    useEffect(() => {

        async function loadUsers() {

            const result = await getUsers();

            setUsers(result);

            setLoading(false);

        }

        loadUsers();

    }, []);

    if (loading) {

        return <h2>Chargement...</h2>;

    }

    return (

        <div>

            <h1>Utilisateurs</h1>

            <p>{users.length} utilisateur(s)</p>

            {
                users.map(user => (

                    <div
                        key={user.id}
                        style={{
                            padding:20,
                            marginBottom:10,
                            border:"1px solid #ddd",
                            borderRadius:10
                        }}
                    >

                        <h3>

                            {user.firstName || user.prenom}

                            {" "}

                            {user.lastName || user.nom}

                        </h3>

                        <p>

                            {user.email}

                        </p>

                        <p>

                            {user.phone || user.numero}

                        </p>

                        <p>

                            {user.role}

                        </p>

                    </div>

                ))
            }

        </div>

    );

}