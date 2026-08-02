import {

    Routes,

    Route,

    Navigate

} from "react-router-dom";

import UsersPage from "../pages/UsersPage";

/*
|--------------------------------------------------------------------------
| Pages temporaires
|--------------------------------------------------------------------------
|
| Nous créerons ces pages une par une durant les prochains sprints.
|
*/

import DashboardPage from "../pages/DashboardPage";
import TripsPage from "../pages/trips/TripsPage";
import VehiclesPage from "../pages/VehiclesPage";
import PaymentsPage from "../pages/PaymentsPage";
import SupportPage from "../pages/SupportPage";
import InvestorsPage from "../pages/InvestorsPage";
import ProfilePage from "../pages/ProfilePage";
import SettingsPage from "../pages/SettingsPage";
import LoginPage from "../pages/auth/LoginPage";
import RegisterPage from "../pages/auth/RegisterPage";
import ForgotPasswordPage from "../pages/auth/ForgotPasswordPage";
import ProtectedRoute from "./ProtectedRoute";

export default function AppRoutes() {

    return (

        <Routes>

            {/* Pages publiques */}
            <Route

                path="/"

                element={<LoginPage />}

            />

            <Route

                path="/register"

                element={<RegisterPage />}

            />

            <Route

                path="/forgot-password"

                element={<ForgotPasswordPage />}

            />

            {/* Pages protégées */}

            <Route
                element={<ProtectedRoute />}
            >
                <Route

                    path="/dashboard"

                    element={<DashboardPage />}

                />

                <Route

                    path="/users"

                    element={<UsersPage />}

                />

                <Route

                    path="/trips"

                    element={<TripsPage />}

                />

                <Route

                    path="/vehicles"

                    element={<VehiclesPage />}

                />

                <Route

                    path="/payments"

                    element={<PaymentsPage />}

                />

                <Route

                    path="/support"

                    element={<SupportPage />}

                />

                <Route

                    path="/investors"

                    element={<InvestorsPage />}

                />

                <Route

                    path="/account"

                    element={<ProfilePage />}

                />

                <Route

                    path="/settings"

                    element={<SettingsPage />}

                />

            </Route>

            <Route

                path="*"

                element={

                    <Navigate

                        to="/"

                        replace

                    />

                }

            />

        </Routes>

    );

}