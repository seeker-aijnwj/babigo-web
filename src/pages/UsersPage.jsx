import { useEffect, useState } from "react";

import DashboardLayout from "../components/layouts/DashboardLayout/DashboardLayout";

import UserList from "../components/users/UserList";
import UserDetails from "../components/users/UserDetails";

import { subscribeToUsers } from "../services/userService";

import useResponsive from "../hooks/useResponsive";

import "../components/users/users.css";

export default function UsersPage() {

    const { isMobile } = useResponsive();

    const [users, setUsers] = useState([]);

    const [selectedUser, setSelectedUser] = useState(null);

    const [showDetails, setShowDetails] = useState(false);

    const [loading, setLoading] = useState(true);

    useEffect(() => {

        const unsubscribe = subscribeToUsers((firebaseUsers) => {

            setUsers(firebaseUsers);

            setSelectedUser((currentUser) => {

                if (!firebaseUsers.length) {

                    return null;

                }

                if (!currentUser) {

                    return firebaseUsers[0];

                }

                const updatedUser = firebaseUsers.find(

                    user => user.id === currentUser.id

                );

                return updatedUser || firebaseUsers[0];

            });

            setLoading(false);

        });

        return () => unsubscribe();

    }, []);

    function handleSelectUser(user) {

        setSelectedUser(user);

        if (isMobile) {

            setShowDetails(true);

        }

    }

    function handleBack() {

        setShowDetails(false);

    }

    return (

        <DashboardLayout
            pageTitle="Utilisateurs"
        >

            <div className="users-page">

                {

                    loading ? (

                        <div className="users-loading">

                            Chargement des utilisateurs...

                        </div>

                    ) : (

                        <>

                            {

                                (!isMobile || !showDetails) && (

                                    <UserList

                                        users={users}

                                        selectedUser={selectedUser}

                                        onSelectUser={handleSelectUser}

                                    />

                                )

                            }

                            {

                                (!isMobile || showDetails) && (

                                    <UserDetails

                                        user={selectedUser}

                                        isMobile={isMobile}

                                        onBack={handleBack}

                                    />

                                )

                            }

                        </>

                    )

                }

            </div>

        </DashboardLayout>

    );

}