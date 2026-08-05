/******************************************************************************
==============================================================================
BabiGO
TripFilters.jsx
==============================================================================
*/

import React from "react";

import "./trip-filters.css";

/* ==========================================================================
   COMPOSANT
   ========================================================================== */

export default function TripFilters({

    filters = [],

    selectedFilter,

    onChange,

}) {

    return (

        <section className="trip-filters">

            <div className="trip-filters-container">

                {

                    filters.map((filter) => {

                        const isActive =

                            filter.id === selectedFilter;

                        return (

                            <button

                                key={filter.id}

                                type="button"

                                className={`trip-filter-button ${

                                    isActive

                                        ? "active"

                                        : ""

                                }`}

                                onClick={() =>

                                    onChange?.(

                                        filter.id

                                    )

                                }

                                aria-pressed={isActive}

                            >

                                {filter.label}

                            </button>

                        );

                    })

                }

            </div>

        </section>

    );

}