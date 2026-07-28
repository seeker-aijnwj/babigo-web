import "./page.css";

export default function StatCard({

    icon: Icon,

    title,

    value,

    subtitle,

    color = "#2563EB"

}) {

    return (

        <article className="stat-card">

            <div
                className="stat-icon"
                style={{
                    background: color
                }}
            >

                <Icon />

            </div>

            <div className="stat-content">

                <div className="stat-title">

                    {title}

                </div>

                <div className="stat-value">

                    {value}

                </div>

                <div className="stat-subtitle">

                    {subtitle}

                </div>

            </div>

        </article>

    );

}