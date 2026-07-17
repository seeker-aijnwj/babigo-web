import "./Button.css";

export default function Button({

    children,

    variant = "primary",

    size = "md",

    loading = false,

    disabled = false,

    leftIcon = null,

    rightIcon = null,

    onClick,

    type = "button"

}) {

    const className = [

        "babigo-button",

        `babigo-button-${variant}`,

        `babigo-button-${size}`

    ].join(" ");

    return (

        <button

            type={type}

            className={className}

            disabled={loading || disabled}

            onClick={onClick}

        >

            {

                loading ?

                (

                    <span className="babigo-button-spinner"></span>

                )

                :

                (

                    <>

                        {leftIcon}

                        <span>

                            {children}

                        </span>

                        {rightIcon}

                    </>

                )

            }

        </button>

    );

}