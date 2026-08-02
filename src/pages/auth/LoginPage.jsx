/******************************************************************************
 * BabiGO
 * ----------------------------------------------------------------------------
 * Page : Login
 *
 * MVP v1.0
 *
 * Partie 1
 *
 * - Imports
 * - Hooks
 * - Carrousel
 * - Etats
 ******************************************************************************/

import React, {

    useEffect,

    useState,

} from "react";

import {

    Link,

    useNavigate,

} from "react-router-dom";

import {

    FaShieldAlt,

    FaCarSide,

    FaMoneyBillWave,

} from "react-icons/fa";

import useAuth from "../../hooks/useAuth";

import "./login.css";

/* ============================================================================
   IMAGES
============================================================================ */

import imageAuto from "../../assets/images/image-1.jpg";

import imageGare from "../../assets/images/image-2.jpg";

import imageJoie from "../../assets/images/image-3.jpg";

import imageTaxi from "../../assets/images/image-4.jpg";

import logo from "../../assets/images/icons/Icon-192.png";

/* ============================================================================
   IMAGES DU CAROUSEL
============================================================================ */

const carouselSlides = [

    {

        id: 1,

        image: imageAuto,

        title: "Voyagez ensemble, dépensez moins.",

        description:

            "Trouvez facilement un conducteur ou des passagers partout en Côte d'Ivoire.",

    },

    {

        id: 2,

        image: imageGare,

        title: "Des trajets sûrs et organisés.",

        description:

            "Réservez vos places en quelques secondes et voyagez sereinement.",

    },

    {

        id: 3,

        image: imageJoie,

        title: "Des milliers de kilomètres à partager.",

        description:

            "BabiGO rapproche les voyageurs et réduit les coûts de transport.",

    },

    {

        id: 4,

        image: imageTaxi,

        title: "Le covoiturage pensé pour l'Afrique.",

        description:

            "Une plateforme moderne adaptée aux habitudes de déplacement africaines.",

    },

];

/* ============================================================================
   CARTES DE CONFIANCE
============================================================================ */

const trustCards = [

    {

        id: 1,

        icon: FaShieldAlt,

        title: "Conducteurs vérifiés",

        description:

            "Des profils fiables pour voyager en toute confiance.",

    },

    {

        id: 2,

        icon: FaCarSide,

        title: "Réservation rapide",

        description:

            "Publiez ou réservez un trajet en quelques clics.",

    },

    {

        id: 3,

        icon: FaMoneyBillWave,

        title: "Économisez",

        description:

            "Réduisez vos dépenses en partageant vos trajets.",

    },

];

/* ============================================================================
   COMPOSANT
============================================================================ */

export default function Login() {

    /* =======================================================================
       NAVIGATION
    ======================================================================= */

    const navigate = useNavigate();

    /* =======================================================================
       AUTH
    ======================================================================= */

    const {

        login,

        isAuthenticated,

    } = useAuth();

    /* =======================================================================
       ETATS
    ======================================================================= */

    const [email, setEmail] = useState("");

    const [password, setPassword] = useState("");

    const [loading, setLoading] = useState(false);

    const [error, setError] = useState("");

    /* =======================================================================
       CAROUSEL
    ======================================================================= */

    const [currentSlide, setCurrentSlide] = useState(0);

    /* =======================================================================
       CAROUSEL AUTOMATIQUE
    ======================================================================= */

    useEffect(() => {

        const interval = setInterval(() => {

            setCurrentSlide((previousSlide) =>

                previousSlide === carouselSlides.length - 1

                    ? 0

                    : previousSlide + 1

            );

        }, 5000);

        return () => clearInterval(interval);

    }, []);

    /* =======================================================================
       REDIRECTION SI DEJA CONNECTE
    ======================================================================= */

    useEffect(() => {

        if (isAuthenticated) {

            navigate(

                "/dashboard",

                {

                    replace: true,

                }

            );

        }

    }, [

        isAuthenticated,

        navigate,

    ]);

    /* =======================================================================
       CONNEXION
    ======================================================================= */

    async function handleSubmit(event) {

        event.preventDefault();

        setError("");

        setLoading(true);

        try {

            await login(

                email.trim(),

                password,

            );

        }

        catch (exception) {

            console.error(exception);

            switch (exception.code) {

                case "auth/invalid-email":

                    setError(

                        "Adresse e-mail invalide."

                    );

                    break;

                case "auth/invalid-credential":

                    setError(

                        "Adresse e-mail ou mot de passe incorrect."

                    );

                    break;

                case "auth/user-disabled":

                    setError(

                        "Ce compte a été désactivé."

                    );

                    break;

                case "auth/network-request-failed":

                    setError(

                        "Connexion Internet indisponible."

                    );

                    break;

                case "auth/too-many-requests":

                    setError(

                        "Trop de tentatives. Veuillez réessayer plus tard."

                    );

                    break;

                default:

                    setError(

                        "Impossible de se connecter pour le moment."

                    );

            }

        }

        finally {

            setLoading(false);

        }

    }

    /* =======================================================================
       DONNEES DE LA DIAPOSITIVE COURANTE
    ======================================================================= */

    const currentCarousel =

        carouselSlides[currentSlide];

            /* =======================================================================
       RENDER
    ======================================================================= */

    return (

        <main className="login-page">

            <div className="login-container">

                {/* ==========================================================
                    HERO / CAROUSEL
                ========================================================== */}

                <section className="login-carousel">

                    <img

                        src={currentCarousel.image}

                        alt={currentCarousel.title}

                        className="login-carousel-image"

                    />

                    <div className="login-carousel-overlay" />

                    <div className="login-carousel-content">

                        <span className="login-carousel-badge">

                            🇨🇮 Le covoiturage nouvelle génération

                        </span>

                        <h1 className="login-carousel-title">

                            {currentCarousel.title}

                        </h1>

                        <p className="login-carousel-description">

                            {currentCarousel.description}

                        </p>

                        <div className="login-carousel-indicators">

                            {

                                carouselSlides.map((slide, index) => (

                                    <span

                                        key={slide.id}

                                        className={

                                            index === currentSlide

                                                ? "login-carousel-dot active"

                                                : "login-carousel-dot"

                                        }

                                    />

                                ))

                            }

                        </div>

                    </div>

                </section>

                {/* ==========================================================
                    PANNEAU DE CONNEXION
                ========================================================== */}

                <section className="login-panel">

                    {/* Logo */}

                    <div className="login-logo">

                        <img

                            src={logo}

                            alt="BabiGO"

                        />

                        <div className="login-logo-text">

                            <h1>

                                BabiGO

                            </h1>

                            <span>

                                Voyagez ensemble.

                            </span>

                        </div>

                    </div>

                    {/* Titre */}

                    <header className="login-header">

                        <h2>

                            Bon retour 👋

                        </h2>

                        <p>

                            Connectez-vous pour publier un trajet,

                            réserver une place ou retrouver vos voyages.

                        </p>

                    </header>

                    {/* ======================================================
                        FORMULAIRE
                    ====================================================== */}

                    <form

                        className="login-form"

                        onSubmit={handleSubmit}

                    >

                        <div className="form-group">

                            <label htmlFor="email">

                                Adresse e-mail

                            </label>

                            <input

                                id="email"

                                type="email"

                                placeholder="exemple@email.com"

                                autoComplete="email"

                                value={email}

                                onChange={(event) =>

                                    setEmail(

                                        event.target.value

                                    )

                                }

                                required

                            />

                        </div>

                        <div className="form-group">

                            <label htmlFor="password">

                                Mot de passe

                            </label>

                            <input

                                id="password"

                                type="password"

                                placeholder="••••••••"

                                autoComplete="current-password"

                                value={password}

                                onChange={(event) =>

                                    setPassword(

                                        event.target.value

                                    )

                                }

                                required

                            />

                        </div>

                        {

                            error && (

                                <div className="login-error">

                                    {error}

                                </div>

                            )

                        }

                        <button

                            className="login-button"

                            type="submit"

                            disabled={loading}

                        >

                            {

                                loading

                                    ? "Connexion en cours..."

                                    : "Se connecter"

                            }

                        </button>

                                                {/* ==================================================
                            LIENS
                        ================================================== */}

                        <div className="login-links">

                            <Link

                                to="/forgot-password"

                            >

                                Mot de passe oublié ?

                            </Link>

                            <Link

                                to="/register"

                            >

                                Créer un compte

                            </Link>

                        </div>

                    </form>

                    {/* ======================================================
                        SEPARATEUR
                    ====================================================== */}

                    <div className="login-divider">

                        Pourquoi choisir BabiGO ?

                    </div>

                    {/* ======================================================
                        CARTES DE CONFIANCE
                    ====================================================== */}

                    <div className="login-trust">

                        {

                            trustCards.map((card) => {

                                const Icon = card.icon;

                                return (

                                    <div

                                        key={card.id}

                                        className="login-trust-card"

                                    >

                                        <div className="login-trust-icon">

                                            <Icon />

                                        </div>

                                        <h3 className="login-trust-title">

                                            {card.title}

                                        </h3>

                                        <p className="login-trust-description">

                                            {card.description}

                                        </p>

                                    </div>

                                );

                            })

                        }

                    </div>

                    {/* ======================================================
                        FOOTER
                    ====================================================== */}

                    <footer className="login-footer">

                        <span>

                            © {new Date().getFullYear()} BabiGO.

                            Tous droits réservés.

                        </span>

                        <div
                            style={{
                                display: "flex",
                                gap: "18px",
                                flexWrap: "wrap",
                                alignItems: "center",
                            }}
                        >

                            <Link to="/privacy">

                                Confidentialité

                            </Link>

                            <Link to="/terms">

                                Conditions

                            </Link>

                            <span className="login-version">

                                MVP v1.0

                            </span>

                        </div>

                    </footer>

                </section>

            </div>

        </main>

    );

}