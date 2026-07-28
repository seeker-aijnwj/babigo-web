import { FiMenu } from "react-icons/fi";

import SearchBox from "./SearchBox";
import TopBarActions from "./TopBarActions";

import "./topbar.css";

export default function TopBar({

    title,

    onToggleSidebar

}) {

    return (

        <header className="topbar">

            <div className="topbar-left">

                <button
                    className="topbar-menu-button"
                    type="button"
                    onClick={onToggleSidebar}
                >

                    <FiMenu />

                </button>

                <h1 className="topbar-title">

                    {title}

                </h1>

            </div>

            <div className="topbar-center">

                <SearchBox />

            </div>

            <TopBarActions />

        </header>

    );

}