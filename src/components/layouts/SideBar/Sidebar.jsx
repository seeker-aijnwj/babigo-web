import "../DashboardLayout/dashboard.css";

import SidebarHeader from "./SidebarHeader";
import SidebarMenu from "./SidebarMenu";
import SidebarWorkspace from "./SidebarWorkspace";

export default function Sidebar() {

    return (

        <aside className="sidebar">

            <SidebarHeader />

            <SidebarMenu />

            <SidebarWorkspace />

        </aside>

    );

}