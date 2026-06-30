import 'package:babigo/modules/admin_module/database/models/admin/utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/modules/booking_module/models/announce_draft.dart';
import 'package:babigo/modules/booking_module/services/announce_prefill_service.dart';
import 'package:babigo/modules/booking_module/screens/driver/driver_main_screen.dart';
import 'package:babigo/modules/trip_module/screens/tracking_screen.dart';

// ============================================================
// DRIVER ANNOUNCE DETAIL SCREEN
// ============================================================
//
// Écran moderne de détail d'annonce conducteur
//
// Fonctionnalités :
//
// • Consultation détaillée d'une annonce
// • Visualisation des statistiques
// • Refaire une annonce similaire
// • Démarrer une course
// • UI Premium Babigo
//
// ============================================================


class DriverAnnounceDetailScreen extends StatefulWidget {
  final String announceId;

  /// Callback facultatif
  final VoidCallback? onReconduire;

  final Utilisateur? selectedUser;

  const DriverAnnounceDetailScreen({
    super.key,
    required this.announceId,
    this.selectedUser,
    this.onReconduire,
  });

  @override
  State<DriverAnnounceDetailScreen> createState() =>
      _DriverAnnounceDetailScreenState();
}

class _DriverAnnounceDetailScreenState
    extends State<DriverAnnounceDetailScreen> {

  // ==========================================================
  // FIREBASE
  // ==========================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==========================================================
  // ÉTAT LOCAL
  // ==========================================================

  bool _startingTrip = false;

  // ==========================================================
  // UTILISATEUR CONNECTÉ
  // ==========================================================

  String? get currentUid => (widget.selectedUser != null)
      ? widget.selectedUser!.id : _auth.currentUser?.uid;

  // ==========================================================
  // DÉMARRER UNE COURSE
  // ==========================================================

  Future<void> onStartTrip(
      BuildContext context,
      String tripId,
      ) async {

    try {

      setState(() {
        _startingTrip = true;
      });

      await _firestore
          .collection('trips')
          .doc(tripId)
          .set({

        'status': 'running',

      }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.push(context,

        MaterialPageRoute(

          builder: (_) => TrackingScreen(

            tripId: tripId,

            isDriver: true,
          ),
        ),
      );

    } catch (e) {

      _toast(context,
        "Impossible de démarrer la course.",
      );

    } finally {

      if (mounted) {

        setState(() {
          _startingTrip = false;
        });
      }
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    // ========================================================
    // UTILISATEUR NON CONNECTÉ
    // ========================================================

    if (currentUid == null) {

      return Scaffold(

        backgroundColor: AppColors.backgroundColor,

        body: const Center(

          child: Text(
            "Utilisateur non connecté",
          ),
        ),
      );
    }

    // ========================================================
    // DOCUMENT FIRESTORE
    // ========================================================

    final announceRef = _firestore

        .collection('users')

        .doc(currentUid)

        .collection('announces_effectuees')

        .doc(widget.announceId);

    return Scaffold(

      backgroundColor: AppColors.backgroundColor,

      body: StreamBuilder<
          DocumentSnapshot<Map<String, dynamic>>>(

        stream: announceRef.snapshots(),

        builder: (context, snapshot) {

          // ==================================================
          // LOADING
          // ==================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ==================================================
          // ERREUR
          // ==================================================

          if (snapshot.hasError) {

            return _buildErrorState();
          }

          final data =
          snapshot.data?.data();

          // ==================================================
          // AUCUNE DONNÉE
          // ==================================================

          if (data == null) {

            return _buildEmptyState();
          }

          // ==================================================
          // CONTENU PRINCIPAL
          // ==================================================

          return CustomScrollView(

            physics:
            const BouncingScrollPhysics(),

            slivers: [

              // =============================================
              // HEADER PREMIUM
              // =============================================

              SliverToBoxAdapter(

                child: _buildModernHeader(
                  data,
                ),
              ),

              // =============================================
              // CONTENU
              // =============================================

              SliverToBoxAdapter(

                child: Padding(

                  padding:
                  const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      // ===============================
                      // TRAJET
                      // ===============================

                      _buildRouteCard(data),

                      // ===============================
                      // INFORMATIONS
                      // ===============================

                      _buildTripInformations(data),

                      // ===============================
                      // STOPS
                      // ===============================

                      _buildStopsCard(data),

                      // ===============================
                      // ACTIONS
                      // ===============================

                      _buildActionButtons(data),

                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // HEADER PREMIUM
  // ==========================================================

  Widget _buildModernHeader(
      Map<String, dynamic> data,
      ) {

    final from =
    (data['depart'] ?? '')
        .toString();

    final to =
    (data['destination'] ?? '')
        .toString();

    final announceNumber =
    (data['announceNumber'] ?? '')
        .toString();

    final status =
    (data['status'] ?? 'pending')
        .toString();

    return Container(

      padding: const EdgeInsets.only(

        left: 20,
        right: 20,
        top: 60,
        bottom: 30,
      ),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            AppColors.secondColor,

            AppColors.secondColor.withValues(
              alpha: .75,
            ),
          ],
        ),

        borderRadius:
        const BorderRadius.only(

          bottomLeft:
          Radius.circular(30),

          bottomRight:
          Radius.circular(30),
        ),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              InkWell(

                onTap: () {
                  Navigator.pop(context);
                },

                child: Container(

                  height: 42,

                  width: 42,

                  decoration:
                  const BoxDecoration(

                    color: Colors.white,

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),

              const Spacer(),

              _buildStatusChip(status),
            ],
          ),

          const SizedBox(height: 30),

          Text(

            announceNumber.isEmpty
                ? "Annonce"
                : announceNumber,

            style: const TextStyle(

              color: Colors.white70,

              fontWeight:
              FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Text(

            "$from → $to",

            style: const TextStyle(

              color: Colors.white,

              fontWeight:
              FontWeight.bold,

              fontSize: 24,
            ),
          ),

          const SizedBox(height: 14),

          Text(

            _formatDeparture(

              data['departureAt'],

              data['dateText'],

              data['timeText'],
            ),

            style: const TextStyle(

              color: Colors.white70,

              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // UI STATES
  // ===========================================================================

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 70,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              "Impossible de charger l'annonce",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 20,
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.route_outlined,
              size: 70,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "Annonce introuvable",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ===========================================================================
  // STATUS CHIP
  // ===========================================================================

  Widget _buildStatusChip(String status) {
    final normalized = status.toLowerCase();

    Color backgroundColor;
    Color textColor;
    IconData icon;
    String label;

    switch (normalized) {
      case 'completed':
      case 'completed_trip':
      case 'terminee':
      case 'terminée':
        backgroundColor = Colors.green.withValues(alpha: .12);
        textColor = Colors.green.shade700;
        icon = Icons.check_circle_rounded;
        label = "Terminée";
        break;

      case 'running':
      case 'in_progress':
      case 'ongoing':
        backgroundColor = Colors.blue.withValues(alpha: .12);
        textColor = Colors.blue.shade700;
        icon = Icons.directions_car_filled_rounded;
        label = "En cours";
        break;

      case 'cancelled':
      case 'canceled':
        backgroundColor = Colors.red.withValues(alpha: .12);
        textColor = Colors.red.shade700;
        icon = Icons.cancel_rounded;
        label = "Annulée";
        break;

      case 'pending':
        backgroundColor = Colors.orange.withValues(alpha: .12);
        textColor = Colors.orange.shade700;
        icon = Icons.schedule_rounded;
        label = "En attente";
        break;

      default:
        backgroundColor = Colors.grey.withValues(alpha: .12);
        textColor = Colors.grey.shade700;
        icon = Icons.info_outline_rounded;
        label = status.isEmpty ? "Inconnu" : status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: textColor.withValues(alpha: .20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),

          const SizedBox(width: 6),

          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CARD TRAJET
  // ===========================================================================

  Widget _buildRouteCard(
      Map<String, dynamic> data,
      ) {
    final departure =
    (data['depart'] ?? '').toString();

    final destination =
    (data['destination'] ?? '').toString();

    final meetingPlace =
    (data['meetingPlace'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainColor,
            AppColors.mainColor.withValues(alpha: .85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: .25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  departure,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(
              left: 7,
              top: 4,
              bottom: 4,
            ),
            height: 40,
            width: 2,
            color: Colors.white54,
          ),

          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 18,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  destination,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          if (meetingPlace.isNotEmpty) ...[
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.place_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      meetingPlace,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // INFORMATIONS
  // ===========================================================================

  Widget _buildTripInformations(
      Map<String, dynamic> data,
      ) {
    final price =
    (data['price'] ?? '').toString();

    final seats =
    _toInt(data['seats']);

    final reservedSeats =
    _toInt(data['reservedSeats']);

    final status =
    (data['status'] ?? '').toString();

    final departureDate =
    _formatDeparture(
      data['departureAt'],
      data['dateText'],
      data['timeText'],
    );

    final completedDate =
    _fmtDateTime(data['completedAt']);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          _modernInfoTile(
            Icons.calendar_month_rounded,
            "Départ",
            departureDate,
          ),

          const Divider(height: 28),

          _modernInfoTile(
            Icons.people_alt_rounded,
            "Réservations",
            "$reservedSeats / $seats places",
          ),

          if (price.isNotEmpty) ...[
            const Divider(height: 28),

            _modernInfoTile(
              Icons.payments_rounded,
              "Prix",
              "$price FCFA",
            ),
          ],

          const Divider(height: 28),

          _modernInfoTile(
            Icons.flag_circle_rounded,
            "Statut",
            status.toUpperCase(),
          ),

          if (completedDate != null) ...[
            const Divider(height: 28),

            _modernInfoTile(
              Icons.check_circle_rounded,
              "Terminé le",
              completedDate,
            ),
          ],
        ],
      ),
    );
  }

  Widget _modernInfoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.secondColor.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.secondColor,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STOPS INTERMÉDIAIRES
  // ===========================================================================

  Widget _buildStopsCard(
      Map<String, dynamic> data,
      ) {
    final stops = _asStringList(data['stops']);

    if (stops.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.alt_route_rounded,
                color: AppColors.secondColor,
              ),
              SizedBox(width: 10),
              Text(
                "Stops intermédiaires",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: stops.map((stop) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondColor.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.secondColor.withValues(alpha: .15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.secondColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      stop,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACTIONS
  // ===========================================================================

  Widget _buildActionButtons(
      Map<String, dynamic> data,
      ) {
    return Column(
      children: [
        _buildModernButton(
          icon: Icons.replay_rounded,
          label: "Refaire une annonce similaire",
          color: AppColors.secondColor,
          onPressed: () async {
            if (widget.onReconduire != null) {
              widget.onReconduire!.call();
            } else {
              await _refaireSimilaireViaDraft(
                context,
                data,
              );
            }
          },
        ),

        const SizedBox(height: 14),

        if (data['tripId'] != null)
          _buildModernButton(
            icon: Icons.play_circle_fill_rounded,
            label: "Démarrer la course",
            color: Colors.green,
            onPressed: () async {
              await onStartTrip(
                context,
                data['tripId'].toString(),
              );
            },
          ),
      ],
    );
  }

  Widget _buildModernButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 58,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // RECONDUCTION D'ANNONCE
  // ===========================================================================

  Future<void> _refaireSimilaireViaDraft(
      BuildContext context,
      Map<String, dynamic> data,
      ) async {
    try {
      final from =
      (data['depart'] ?? '').toString();

      final to =
      (data['destination'] ?? '').toString();

      final meetingPlace =
      (data['meetingPlace'] ?? '').toString();

      final arrivalAddress =
      (data['arrivalAddress'] ?? '').toString();

      final priceStr =
      (data['price'] ?? '').toString();

      final time = _extractTimeOfDay(
        timeText: data['timeText'],
        departureAt: data['departureAt'],
      );

      final seats = _toInt(
        data['seats'],
      );

      final draft = AnnounceDraft(
        depart: from,
        destination: to,
        meetingPlace: meetingPlace,
        arrivalPlace: arrivalAddress,
        date: null,
        time: time,
        seats: seats,
        price: _priceToInt(priceStr),
      );

      final service =
      AnnouncePrefillService();

      service.setDraft(draft);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const DriverMainScreen(
            initialIndex: 1,
          ),
        ),
      );
    } catch (_) {
      _toast(
        context,
        "Impossible de reconduire cette annonce.",
      );
    }
  }

  // ===========================================================================
  // FIRESTORE HELPERS
  // ===========================================================================

  static int _toInt(
      dynamic value,
      ) {
    if (value is int) return value;

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  static int _priceToInt(
      String value,
      ) {
    if (value.isEmpty) return 0;

    final cleaned = value.replaceAll(
      RegExp(r'[^\d\-]'),
      '',
    );

    return int.tryParse(cleaned) ?? 0;
  }

  static List<String> _asStringList(
      dynamic value,
      ) {
    if (value is List) {
      return value
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
    }

    if (value is String &&
        value.trim().isNotEmpty) {
      return [value.trim()];
    }

    return const [];
  }

  static TimeOfDay? _extractTimeOfDay({
    dynamic timeText,
    dynamic departureAt,
  }) {
    final text =
        timeText?.toString() ?? '';

    if (text.contains(':')) {
      final parts = text.split(':');

      final hh =
          int.tryParse(parts[0]) ?? 0;

      final mm =
          int.tryParse(parts[1]) ?? 0;

      return TimeOfDay(
        hour: hh,
        minute: mm,
      );
    }

    final date =
    _toDateTime(departureAt);

    if (date == null) {
      return null;
    }

    return TimeOfDay(
      hour: date.hour,
      minute: date.minute,
    );
  }

  static DateTime? _toDateTime(
      dynamic value,
      ) {
    try {
      if (value == null) return null;

      if (value is Timestamp) {
        return value.toDate();
      }

      if (value is int) {
        return DateTime
            .fromMillisecondsSinceEpoch(
          value,
        );
      }

      if (value is String) {
        final ms =
        int.tryParse(value);

        if (ms != null) {
          return DateTime
              .fromMillisecondsSinceEpoch(
            ms,
          );
        }

        return DateTime.tryParse(
          value,
        );
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  String _formatDeparture(
      dynamic departureAt,
      dynamic dateText,
      dynamic timeText,
      ) {
    final complete =
    _fmtDateTime(departureAt);

    if (complete != null) {
      return complete;
    }

    final date =
        dateText?.toString() ?? '';

    final time =
        timeText?.toString() ?? '';

    if (date.isEmpty &&
        time.isEmpty) {
      return "Non défini";
    }

    String displayDate = date;

    try {
      final parts = date.split('-');

      if (parts.length == 3) {
        displayDate =
        "${parts[2]}/${parts[1]}/${parts[0]}";
      }
    } catch (_) {}

    if (time.isEmpty) {
      return displayDate;
    }

    return "$displayDate à $time";
  }

  String? _fmtDateTime(
      dynamic value,
      ) {
    try {
      final dt =
      _toDateTime(value);

      if (dt == null) {
        return null;
      }

      String two(int n) =>
          n.toString().padLeft(2, '0');

      return "${two(dt.day)}/${two(dt.month)}/${dt.year} "
          "${two(dt.hour)}:${two(dt.minute)}";
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // TOAST
  // ===========================================================================

  void _toast(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        behavior:
        SnackBarBehavior.floating,
        content: Text(message),
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),
      ),
    );
  }
}