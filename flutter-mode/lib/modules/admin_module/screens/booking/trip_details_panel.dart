import 'package:flutter/material.dart';
import '../../../../app/core/themes/admin_light_theme.dart';
import '../../database/models/admin/trip_ad.dart';

/// ============================================================================
/// TRIP DETAILS PANEL
/// ============================================================================
///
/// Widget réutilisable permettant d'afficher
/// tous les détails d'un trajet.
///
/// Ce widget peut être utilisé dans :
///
/// ✅ Desktop
/// ✅ Mobile
/// ✅ Web
/// ✅ Dialog
/// ✅ BottomSheet
/// ✅ Drawer
/// ✅ Page plein écran
///
/// Architecture inspirée de WhatsApp Desktop.
///
/// ============================================================================

class TripDetailsPanel extends StatelessWidget {

  /// ==========================================================================
  /// TRAJET À AFFICHER
  /// ==========================================================================

  final TripAd trip;

  const TripDetailsPanel({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {

    final statusColor =
    _getStatusColor(trip.status.name);

    return Container(

      color: UGOAdminTheme.background,

      child: SingleChildScrollView(

        padding: const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// ===============================================================
            /// HEADER
            /// ===============================================================

            _buildHeader(statusColor),

            const SizedBox(height: 24),

            /// ===============================================================
            /// DRIVER + VEHICLE
            /// ===============================================================

            _buildDriverAndVehicleSection(),

            const SizedBox(height: 24),

            /// ===============================================================
            /// ROUTE
            /// ===============================================================

            _buildRouteSection(),

            const SizedBox(height: 24),

            /// ===============================================================
            /// GPS / LIVE TRACKING
            /// ===============================================================

            if (trip.isStarted)
              _buildTrackingSection(),

            if (trip.isStarted)
              const SizedBox(height: 24),

            /// ===============================================================
            /// PASSAGERS
            /// ===============================================================

            _buildPassengersSection(),

            const SizedBox(height: 24),

            /// ===============================================================
            /// PAYMENT
            /// ===============================================================

            _buildPaymentSection(),

            const SizedBox(height: 24),

            /// ===============================================================
            /// ACTIONS
            /// ===============================================================

            _buildActions(context),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  /// ==========================================================================
  /// HEADER
  /// ==========================================================================

  Widget _buildHeader(Color statusColor) {

    return Container(

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withValues(alpha: .04),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// =============================================================
          /// STATUS + ID
          /// =============================================================

          Row(

            children: [

              Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(

                  color:
                  statusColor.withValues(alpha: .1),

                  borderRadius:
                  BorderRadius.circular(30),
                ),

                child: Text(

                  trip.status.name.toUpperCase(),

                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                "ID : ${trip.id}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// =============================================================
          /// ROUTE
          /// =============================================================

          Text(

            trip.fullRoute,

            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: UGOAdminTheme.primaryBlue,
            ),
          ),

          const SizedBox(height: 10),

          /// =============================================================
          /// DESCRIPTION
          /// =============================================================

          Text(

            trip.description.isNotEmpty
                ? trip.description
                : "Aucune description",

            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          /// =============================================================
          /// QUICK STATS
          /// =============================================================

          Wrap(

            spacing: 12,
            runSpacing: 12,

            children: [

              _quickInfo(
                Icons.calendar_month,
                "Départ",
                trip.departureDateTime.toString(),
              ),

              _quickInfo(
                Icons.access_time,
                "Heure",
                trip.departureDateTime.hour.toString(),
              ),

              _quickInfo(
                Icons.route,
                "Distance",
                "${trip.totalDistanceKm} km",
              ),

              _quickInfo(
                Icons.timer,
                "Durée",
                trip.estimatedArrival.minute.toString(),
              ),

              _quickInfo(
                Icons.event_seat,
                "Places",
                "${trip.availableSeats}/${trip.totalSeats}",
              ),

              _quickInfo(
                Icons.payments,
                "Prix",
                "${trip.seatPrice} FCFA",
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// DRIVER + VEHICLE
  /// ==========================================================================

  Widget _buildDriverAndVehicleSection() {

    return Row(

      children: [

        /// ===============================================================
        /// DRIVER
        /// ===============================================================

        Expanded(
          child: _card(
            title: "Conducteur",
            icon: Icons.person,
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                ListTile(

                  contentPadding: EdgeInsets.zero,

                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor:
                    UGOAdminTheme.primaryBlue
                        .withValues(alpha: .1),

                    child: Text(
                      trip.driverName.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  title: Text(
                    trip.driverName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    trip.driverPhone,
                  ),
                ),

                const SizedBox(height: 12),

                _infoRow(
                  Icons.star,
                  "Note",
                  "${trip.driverRating}/5",
                ),

                _infoRow(
                  Icons.trip_origin,
                  "Trajets",
                  "${trip.driverTripsCount}",
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        /// ===============================================================
        /// VEHICLE
        /// ===============================================================

        Expanded(
          child: _card(
            title: "Véhicule",
            icon: Icons.directions_car,
            child: Column(

              children: [

                _infoRow(
                  Icons.directions_car,
                  "Modèle",
                  trip.vehicleModel,
                ),

                _infoRow(
                  Icons.confirmation_number,
                  "Immatriculation",
                  trip.vehiclePlateNumber,
                ),

                _infoRow(
                  Icons.color_lens,
                  "Couleur",
                  trip.vehicleColor,
                ),

                _infoRow(
                  Icons.event_seat,
                  "Capacité",
                  "${trip.totalSeats} places",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ==========================================================================
  /// ROUTE SECTION
  /// ==========================================================================

  Widget _buildRouteSection() {

    return _card(

      title: "Itinéraire & Arrêts",
      icon: Icons.route,

      child: Column(

        children: [

          /// =============================================================
          /// DÉPART
          /// =============================================================

          _stopLine(
            title: trip.departureCity,
            subtitle: trip.departureAddress,
            type: "DÉPART",
            isFirst: true,
          ),

          /// =============================================================
          /// ARRÊTS
          /// =============================================================

          ...trip.stops.map(
                (stop) => _stopLine(
              title: stop.name,
              subtitle: stop.address,
              type: "ARRÊT",
            ),
          ),

          /// =============================================================
          /// ARRIVÉE
          /// =============================================================

          _stopLine(
            title: trip.destinationCity,
            subtitle: trip.destinationAddress,
            type: "ARRIVÉE",
            isLast: true,
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// LIVE TRACKING
  /// ==========================================================================

  Widget _buildTrackingSection() {

    return _card(

      title: "Suivi Temps Réel",
      icon: Icons.gps_fixed,

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              const Icon(
                Icons.circle,
                size: 10,
                color: Colors.green,
              ),

              const SizedBox(width: 8),

              const Text(
                "Trajet en cours",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const Spacer(),

              Text(
                "${(trip.tracking!.progress * 100).toInt()} %",
              ),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: trip.tracking!.progress,
            minHeight: 10,
            borderRadius:
            BorderRadius.circular(30),
          ),

          const SizedBox(height: 16),

          _infoRow(
            Icons.location_pin,
            "Position actuelle",
            trip.currentLocationLabel,
          ),

          _infoRow(
            Icons.speed,
            "Vitesse",
            "${trip.currentSpeedKmH} km/h",
          ),

          _infoRow(
            Icons.access_time,
            "Arrivée estimée",
            trip.estimatedArrival.hour.toString(),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// PASSAGERS
  /// ==========================================================================

  Widget _buildPassengersSection() {

    return _card(

      title:
      "Passagers (${trip.passengerIds.length})",

      icon: Icons.people,

      child: trip.passengerIds.isEmpty

          ? const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Aucun passager",
        ),
      )

          : Wrap(

        spacing: 10,
        runSpacing: 10,

        children: trip.getPickupPassengerIds.map((p) {

          return Chip(

            avatar: CircleAvatar(
              child: Text(
                p.fullName[0].toUpperCase(),
              ),
            ),

            label: Text(p.fullName),

            backgroundColor:
            Colors.grey.shade100,
          );
        }).toList(),
      ),
    );
  }

  /// ==========================================================================
  /// PAYMENT
  /// ==========================================================================

  Widget _buildPaymentSection() {

    return _card(

      title: "Paiements",
      icon: Icons.payments,

      child: Column(

        children: [

          _infoRow(
            Icons.account_balance_wallet,
            "Montant total",
            "${trip.totalRevenue} FCFA",
          ),

          _infoRow(
            Icons.check_circle,
            "Payé",
            "${trip.totalPaidAmount} F. CFA",
          ),

          _infoRow(
            Icons.pending,
            "En attente",
            "${trip.pendingAmount} F. CFA",
          ),

          _infoRow(
            Icons.money_off,
            "Remboursé",
            "${trip.refundedAmount} F. CFA",
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// ACTIONS
  /// ==========================================================================

  Widget _buildActions(BuildContext context) {

    return Row(

      children: [

        Expanded(
          child: OutlinedButton.icon(

            onPressed: () {},

            icon: const Icon(Icons.edit),

            label: const Text("MODIFIER"),

            style: OutlinedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: ElevatedButton.icon(

            onPressed: () {},

            icon: const Icon(Icons.settings),

            label: const Text("GÉRER"),

            style: ElevatedButton.styleFrom(
              backgroundColor:
              UGOAdminTheme.primaryBlue,

              foregroundColor: Colors.white,

              padding:
              const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ==========================================================================
  /// CARD
  /// ==========================================================================

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withValues(alpha: .04),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Icon(
                icon,
                color: UGOAdminTheme.primaryBlue,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  /// ==========================================================================
  /// QUICK INFO
  /// ==========================================================================

  Widget _quickInfo(
      IconData icon,
      String title,
      String value,
      ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),

      decoration: BoxDecoration(

        color:
        UGOAdminTheme.primaryBlue
            .withValues(alpha: .05),

        borderRadius:
        BorderRadius.circular(12),
      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 16,
            color: UGOAdminTheme.primaryBlue,
          ),

          const SizedBox(width: 8),

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// INFO ROW
  /// ==========================================================================

  Widget _infoRow(
      IconData icon,
      String label,
      String value,
      ) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(vertical: 8),

      child: Row(

        children: [

          Icon(
            icon,
            size: 18,
            color: Colors.grey,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(label),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// STOP LINE
  /// ==========================================================================

  Widget _stopLine({
    required String title,
    required String subtitle,
    required String type,
    bool isFirst = false,
    bool isLast = false,
  }) {

    return IntrinsicHeight(

      child: Row(

        children: [

          /// =============================================================
          /// LINE
          /// =============================================================

          SizedBox(

            width: 24,

            child: Column(

              children: [

                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),

                Container(

                  width: 14,
                  height: 14,

                  decoration: BoxDecoration(

                    color: isFirst || isLast
                        ? UGOAdminTheme.primaryBlue
                        : Colors.grey,

                    shape: BoxShape.circle,
                  ),
                ),

                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// =============================================================
          /// TEXT
          /// =============================================================

          Expanded(

            child: Padding(

              padding:
              const EdgeInsets.symmetric(
                vertical: 16,
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight:
                            isFirst || isLast
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),

                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// STATUS COLOR
  /// ==========================================================================

  Color _getStatusColor(String status) {

    switch (status) {

      case "published":
        return Colors.blue;

      case "started":
        return Colors.orange;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      case "full":
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }
}