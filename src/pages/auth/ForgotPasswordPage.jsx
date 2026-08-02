/******************************************************************************
 * BabiGO
 * ----------------------------------------------------------------------------
 * Page : ForgotPassword
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

    useState,

} from "react";

import {

    Link,

} from "react-router-dom";

import useAuth from "../../hooks/useAuth";

import logo from "../../assets/images/icons/Icon-192.png";

import "./forgot-password.css";

export default function ForgotPassword() {

    /* =======================================================================
       AUTH
    ======================================================================= */

    const {

        resetPassword,

    } = useAuth();

    /* =======================================================================
       ETATS
    ======================================================================= */

    const [email, setEmail] = useState("");

    const [loading, setLoading] = useState(false);

    const [error, setError] = useState("");

    const [success, setSuccess] = useState("");

        /* =======================================================================
       REINITIALISATION DU MOT DE PASSE
    ======================================================================= */

    async function handleSubmit(event) {

        event.preventDefault();

        setError("");

        setSuccess("");

        if (!email.trim()) {

            setError(

                "Veuillez saisir votre adresse e-mail."

            );

            return;

        }

        setLoading(true);

        try {

            await resetPassword(

                email.trim()

            );

            setSuccess(

                "Un e-mail de réinitialisation a été envoyé. Vérifiez votre boîte de réception ainsi que vos courriers indésirables."

            );

        }

        catch (exception) {

            console.error(exception);

            switch (exception.code) {

                case "auth/user-not-found":

                    setError(

                        "Aucun compte n'est associé à cette adresse e-mail."

                    );

                    break;

                case "auth/invalid-email":

                    setError(

                        "Adresse e-mail invalide."

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

                        "Impossible d'envoyer l'e-mail de réinitialisation."

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

        <main className="forgot-password-page">

            <div className="forgot-password-container">

                {/* ==========================================================
                    HEADER
                ========================================================== */}

                <div className="forgot-password-logo">

                    <img

                        src={logo}

                        alt="BabiGO"

                    />

                    <div>

                        <h1>

                            BabiGO

                        </h1>

                        <span>

                            Réinitialisation du mot de passe

                        </span>

                    </div>

                </div>

                <div className="forgot-password-header">

                    <h2>

                        Mot de passe oublié ?

                    </h2>

                    <p>

                        Saisissez l'adresse e-mail utilisée lors de votre
                        inscription. Nous vous enverrons un lien pour créer
                        un nouveau mot de passe.

                    </p>

                </div>

                {/* ==========================================================
                    FORMULAIRE
                ========================================================== */}

                <form

                    className="forgot-password-form"

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

                    {

                        error && (

                            <div className="forgot-password-error">

                                {error}

                            </div>

                        )

                    }

                    {

                        success && (

                            <div className="forgot-password-success">

                                {success}

                            </div>

                        )

                    }

                    <button

                        type="submit"

                        className="forgot-password-button"

                        disabled={loading}

                    >

                        {

                            loading

                                ? "Envoi en cours..."

                                : "Envoyer le lien de réinitialisation"

                        }

                    </button>

                </form>

                {/* ==========================================================
                    RETOUR A LA CONNEXION
                ========================================================== */}

                <div className="forgot-password-links">

                    <Link

                        to="/login"

                    >

                        ← Retour à la connexion

                    </Link>

                </div>

                {/* ==========================================================
                    FOOTER
                ========================================================== */}

                <footer className="forgot-password-footer">

                    <span>

                        © {new Date().getFullYear()} BabiGO

                    </span>

                    <span>

                        MVP v1.0

                    </span>

                </footer>

            </div>

        </main>

    );

}