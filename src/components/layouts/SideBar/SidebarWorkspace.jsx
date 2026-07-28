/**
 * Cette zone est déjà utile aujourd'hui, mais elle est 
 * surtout conçue pour l'avenir. Plus tard, elle pourra 
 * afficher :
 * - le pays ou la région active ;
 * - la ville sélectionnée (Abidjan, Bouaké, 
 * Yamoussoukro...) ;
 * - une entreprise cliente (pour un mode multi-tenant) ;
 * - ou même un autre produit de l'écosystème BABIGO.
 * 
 * 
 * @returns SidebarWorkspace
 */
import { FiChevronDown, FiGlobe } from "react-icons/fi";

import "../DashboardLayout/dashboard.css";

export default function SidebarWorkspace() {

    return (

        <section className="sidebar-workspace">

            <div className="workspace-title">

                ESPACE DE TRAVAIL

            </div>

            <button
                type="button"
                className="workspace-card"
            >

                <div className="workspace-icon">

                    <FiGlobe />

                </div>

                <div className="workspace-body">

                    <span className="workspace-name">

                        Afrique de l'Ouest

                    </span>

                    <span className="workspace-subtitle">

                        Région active

                    </span>

                </div>

                <FiChevronDown className="workspace-chevron"/>

            </button>

        </section>

    );

}