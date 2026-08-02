/******************************************************************************
 * BabiGO
 * ----------------------------------------------------------------------------
 * Page : Register
 *
 * MVP v1.0
 *
 * Partie 1
 *
 * - Imports
 * - Hooks
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

import useAuth from "../../hooks/useAuth";

import "./register.css";

import logo from "../../assets/images/icons/Icon-192.png";

export default function RegisterPage() {

    /* =======================================================================
       NAVIGATION
    ======================================================================= */

    const navigate = useNavigate();

    /* =======================================================================
       AUTH
    ======================================================================= */

    const {

        register,

        isAuthenticated,

    } = useAuth();

    /* =======================================================================
       ETATS
    ======================================================================= */

    const [firstName, setFirstName] = useState("");

    const [lastName, setLastName] = useState("");

    const [phoneNumber, setPhoneNumber] = useState("");

    const [email, setEmail] = useState("");

    const [password, setPassword] = useState("");

    const [

        confirmPassword,

        setConfirmPassword,

    ] = useState("");

    const [

        acceptTerms,

        setAcceptTerms,

    ] = useState(false);

    const [loading, setLoading] = useState(false);

    const [error, setError] = useState("");

    /* =======================================================================
       REDIRECTION
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
       INSCRIPTION
    ======================================================================= */

    async function handleSubmit(event) {

        event.preventDefault();

        setError("");

        /* ==============================================================
           VALIDATIONS
        ============================================================== */

        if (!firstName.trim()) {

            setError("Veuillez saisir votre prénom.");

            return;

        }

        if (!lastName.trim()) {

            setError("Veuillez saisir votre nom.");

            return;

        }

        if (!phoneNumber.trim()) {

            setError("Veuillez saisir votre numéro de téléphone.");

            return;

        }

        if (!email.trim()) {

            setError("Veuillez saisir votre adresse e-mail.");

            return;

        }

        if (password.length < 6) {

            setError(

                "Le mot de passe doit contenir au moins 6 caractères."

            );

            return;

        }

        if (password !== confirmPassword) {

            setError(

                "Les mots de passe ne correspondent pas."

            );

            return;

        }

        if (!acceptTerms) {

            setError(

                "Veuillez accepter les conditions d'utilisation."

            );

            return;

        }

        setLoading(true);

        try {

            await register({

                firstName: firstName.trim(),

                lastName: lastName.trim(),

                phoneNumber: phoneNumber.trim(),

                email: email.trim(),

                password,

            });

        }

        catch (exception) {

            console.error(exception);

            switch (exception.code) {

                case "auth/email-already-in-use":

                    setError(

                        "Cette adresse e-mail est déjà utilisée."

                    );

                    break;

                case "auth/invalid-email":

                    setError(

                        "Adresse e-mail invalide."

                    );

                    break;

                case "auth/weak-password":

                    setError(

                        "Le mot de passe est trop faible."

                    );

                    break;

                case "auth/network-request-failed":

                    setError(

                        "Aucune connexion Internet."

                    );

                    break;

                default:

                    setError(

                        "Impossible de créer votre compte."

                    );

            }

        }

        finally {

            setLoading(false);

        }

    }

    /* =======================================================================
       RENDER
    ======================================================================= */

    return (

        <main className="register-page">

            <div className="register-container">

                {/* ==========================================================
                    PANNEAU GAUCHE
                ========================================================== */}

                <section className="register-left">

                    <div className="register-logo">

                        <img

                            src={logo}

                            alt="BabiGO"

                        />

                        <div>

                            <h1>BabiGO</h1>

                            <span>

                                Le covoiturage pensé pour l'Afrique.

                            </span>

                        </div>

                    </div>

                    <div className="register-header">

                        <h2>

                            Créez votre compte gratuitement

                        </h2>

                        <p>

                            Rejoignez la communauté BabiGO et commencez à
                            publier ou réserver des trajets partout en
                            Côte d'Ivoire.

                        </p>

                    </div>

                </section>

                {/* ==========================================================
                    FORMULAIRE
                ========================================================== */}

                <section className="register-right">

                    <form

                        className="register-form"

                        onSubmit={handleSubmit}

                    >

                        {/* NOM */}

                        <div className="form-row">

                            <div className="form-group">

                                <label>

                                    Prénom

                                </label>

                                <input

                                    type="text"

                                    value={firstName}

                                    onChange={(event) =>

                                        setFirstName(

                                            event.target.value

                                        )

                                    }

                                    required

                                />

                            </div>

                            <div className="form-group">

                                <label>

                                    Nom

                                </label>

                                <input

                                    type="text"

                                    value={lastName}

                                    onChange={(event) =>

                                        setLastName(

                                            event.target.value

                                        )

                                    }

                                    required

                                />

                            </div>

                        </div>

                        {/* TELEPHONE */}

                        <div className="form-group">

                            <label>

                                Téléphone

                            </label>

                            <input

                                type="tel"

                                placeholder="+225 07 00 00 00 00"

                                value={phoneNumber}

                                onChange={(event) =>

                                    setPhoneNumber(

                                        event.target.value

                                    )

                                }

                                required

                            />

                        </div>

                        {/* EMAIL */}

                        <div className="form-group">

                            <label>

                                Adresse e-mail

                            </label>

                            <input

                                type="email"

                                value={email}

                                onChange={(event) =>

                                    setEmail(

                                        event.target.value

                                    )

                                }

                                required

                            />

                        </div>

                        {/* MOT DE PASSE */}

                        <div className="form-row">

                            <div className="form-group">

                                <label>

                                    Mot de passe

                                </label>

                                <input

                                    type="password"

                                    value={password}

                                    onChange={(event) =>

                                        setPassword(

                                            event.target.value

                                        )

                                    }

                                    required

                                />

                            </div>

                            <div className="form-group">

                                <label>

                                    Confirmation

                                </label>

                                <input

                                    type="password"

                                    value={confirmPassword}

                                    onChange={(event) =>

                                        setConfirmPassword(

                                            event.target.value

                                        )

                                    }

                                    required

                                />

                            </div>

                        </div>

                        {

                            error && (

                                <div className="register-error">

                                    {error}

                                </div>

                            )

                        }

                        {/* ==================================================
                            CONDITIONS D'UTILISATION
                        ================================================== */}

                        <div className="register-terms">

                            <label className="register-checkbox">

                                <input

                                    type="checkbox"

                                    checked={acceptTerms}

                                    onChange={(event) =>

                                        setAcceptTerms(

                                            event.target.checked

                                        )

                                    }

                                />

                                <span>

                                    J'accepte les

                                    {" "}

                                    <Link

                                        to="/terms"

                                    >

                                        Conditions d'utilisation

                                    </Link>

                                    {" "}et la{" "}

                                    <Link

                                        to="/privacy"

                                    >

                                        Politique de confidentialité

                                    </Link>

                                </span>

                            </label>

                        </div>

                        {/* ==================================================
                            BOUTON
                        ================================================== */}

                        <button

                            type="submit"

                            className="register-button"

                            disabled={loading}

                        >

                            {

                                loading

                                    ? "Création du compte..."

                                    : "Créer mon compte"

                            }

                        </button>

                        {/* ==================================================
                            CONNEXION
                        ================================================== */}

                        <div className="register-login">

                            <span>

                                Vous avez déjà un compte ?

                            </span>

                            <Link

                                to="/login"

                            >

                                Se connecter

                            </Link>

                        </div>

                    </form>

                    {/* ======================================================
                        FOOTER
                    ====================================================== */}

                    <footer className="register-footer">

                        <span>

                            © {new Date().getFullYear()} BabiGO.

                        </span>

                        <span>

                            Version MVP 1.0

                        </span>

                    </footer>

                </section>

            </div>

        </main>

    );

}
