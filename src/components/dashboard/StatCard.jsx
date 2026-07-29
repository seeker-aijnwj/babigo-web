import "./page.css";

/**
 * ============================================================
 * StatCard
 * ============================================================
 *
 * Carte de statistique réutilisable.
 *
 * Le composant est volontairement "présentationnel".
 * Il ne connaît ni Firebase, ni le DashboardService.
 *
 * Toutes les données lui sont fournies via les props.
 *
 * ============================================================
 */

export default function StatCard({

    title,

    value = 0,

    subtitle = "",

    icon: Icon,

    color = "#2563EB",

    loading = false,

    onClick

}) {

    return (

        <article

            className="stat-card"

            onClick={onClick}

        >

            <div className="stat-card-top">

                <div
                    className="stat-card-icon"
                    style={{
                        backgroundColor: color
                    }}
                >

                    {

                        Icon && <Icon />

                    }

                </div>

            </div>

            <div className="stat-card-body">

                <span className="stat-card-title">

                    {title}

                </span>

                {

                    loading

                        ?

                        (

                            <div className="stat-card-loading">

                                ...

                            </div>

                        )

                        :

                        (

                            <h2 className="stat-card-value">

                                {

                                    typeof value === "number"

                                        ? value.toLocaleString()

                                        : value

                                }

                            </h2>

                        )

                }

                {

                    subtitle &&

                    (

                        <small className="stat-card-subtitle">

                            {subtitle}

                        </small>

                    )

                }

            </div>

        </article>

    );

}