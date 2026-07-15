// src/components/users/UserSearch.jsx

import "./users.css";

export default function UserSearch({
    value,
    onChange,
    placeholder = "Rechercher un utilisateur..."
}) {

    return (

        <div className="user-search">

            <input
                type="text"
                className="user-search-input"
                placeholder={placeholder}
                value={value}
                onChange={(e) => onChange(e.target.value)}
            />

        </div>

    );

}