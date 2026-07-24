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
import TripsPage from "../pages/TripsPage";
import VehiclesPage from "../pages/VehiclesPage";
import PaymentsPage from "../pages/PaymentsPage";
import SupportPage from "../pages/SupportPage";
import InvestorsPage from "../pages/InvestorsPage";
import SettingsPage from "../pages/SettingsPage";

export default function AppRoutes() {

    return (

        <Routes>

            <Route

                path="/"

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

                path="/settings"

                element={<SettingsPage />}

            />

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