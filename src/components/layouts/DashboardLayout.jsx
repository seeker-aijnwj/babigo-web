import Sidebar from "../dashboard/Sidebar";
import Header from "../dashboard/Header";
import "../dashboard/dashboard.css";

export default function DashboardLayout({ children }) {
    return (
        <div className="dashboard">

            <Sidebar />

            <div className="dashboard-content">

                <Header />

                <main className="dashboard-page">
                    {children}
                </main>

            </div>

        </div>
    );
}