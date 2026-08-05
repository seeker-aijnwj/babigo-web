import "../DashboardLayout/dashboard.css";

import SidebarHeader from "./SidebarHeader";
import SidebarMenu from "./SidebarMenu";
import SidebarWorkspace from "./SidebarWorkspace";
import SidebarFooter from "./SidebarFooter";

export default function Sidebar({
    user = {},
    onLogout = () => {}
}) {

    return (

        <aside className="sidebar">

            <SidebarHeader />

            <SidebarMenu />

            <SidebarWorkspace />

            <SidebarFooter
            
                
            />

        </aside>

    );

}