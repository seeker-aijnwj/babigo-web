import { FiCommand, FiSearch } from "react-icons/fi";

import "./topbar.css";

export default function SearchBox({

    placeholder = "Rechercher un utilisateur, un trajet..."

}) {

    return (

        <button
            type="button"
            className="command-search"
        >

            <div className="command-search-left">

                <FiSearch className="command-search-icon" />

                <span>

                    {placeholder}

                </span>

            </div>

            <div className="command-shortcut">

                <FiCommand />

                <span>K</span>

            </div>

        </button>

    );

}