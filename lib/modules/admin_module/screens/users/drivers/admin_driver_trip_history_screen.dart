/// ============================================================================
/// DRIVER HISTORY SCREEN - MODERN UI
/// ============================================================================
///
/// VERSION :
/// ----------
///
/// ✅ UI moderne
/// ✅ Responsive Mobile / Tablet / Desktop
/// ✅ Header Premium
/// ✅ Recherche moderne
/// ✅ Cards élégantes
/// ✅ Animations
/// ✅ Support selectedUser
/// ✅ Architecture scalable
/// ✅ Compatible avec le thème moderne précédent
///
/// ============================================================================

import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../../../app/core/utils/colors.dart';

import '../../../../booking_module/widgets/driver_history_card.dart';
import '../../../../booking_module/widgets/search_filter_bar.dart';
import '../../../../booking_module/widgets/filter_criteria.dart';

import '../../../../booking_module/models/announce_draft.dart';
import '../../../../booking_module/services/announce_prefill_service.dart';

import '../../../database/models/admin/utilisateur.dart';

class AdminDriverTripHistoryScreen extends StatefulWidget {

  final Utilisateur? selectedUser;

  const AdminDriverTripHistoryScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminDriverTripHistoryScreen> createState() =>
      _AdminDriverTripHistoryScreenState();
}

enum SortMode {
  none,
  priceAsc,
  passengerDesc,
  timeAsc,
}

class _AdminDriverTripHistoryScreenState
    extends State<AdminDriverTripHistoryScreen> {

  /// =========================================================================
  /// FILTERS
  /// =========================================================================

  FilterCriteria _criteria = FilterCriteria.empty;

  SortMode _sort = SortMode.none;

  /// =========================================================================
  /// HELPERS
  /// =========================================================================

  String _str(dynamic v) => v?.toString() ?? '';

  int _int(dynamic v) {

    if (v is int) return v;

    if (v is num) return v.toInt();

    return 0;
  }

  /// =========================================================================
  /// FORMAT DATE
  /// =========================================================================

  String _formatFrenchDateLabel({
    DateTime? dt,
    String? dateText,
  }) {

    DateTime? dateObj = dt;

    if (dateObj == null &&
        dateText != null &&
        dateText.isNotEmpty) {

      dateObj = DateTime.tryParse(dateText);
    }

    if (dateObj == null) {
      return "Date inconnue";
    }

    final formatter = DateFormat(
      'EEEE d MMMM yyyy',
      'fr_FR',
    );

    final s = formatter.format(dateObj);

    return s[0].toUpperCase() +
        s.substring(1);
  }

  /// =========================================================================
  /// PARSE PRICE
  /// =========================================================================

  double _parsePriceToDouble(
      String price,
      ) {

    if (price.isEmpty) return 0.0;

    var cleaned = price.replaceAll(
      RegExp(r'[^0-9,\.\-]'),
      '',
    );

    final lastComma =
    cleaned.lastIndexOf(',');

    final lastDot =
    cleaned.lastIndexOf('.');

    if (lastComma != -1 &&
        lastDot != -1) {

      if (lastComma > lastDot) {

        cleaned = cleaned.replaceAll('.', '');

        cleaned = cleaned.replaceRange(
          lastComma,
          lastComma + 1,
          '.',
        );

        cleaned = cleaned.replaceAll(',', '');

      } else {

        cleaned = cleaned.replaceAll(',', '');
      }

    } else if (lastComma != -1) {

      cleaned = cleaned.replaceAll(',', '.');
    }

    return double.tryParse(cleaned) ?? 0;
  }

  /// =========================================================================
  /// PARSE TIME
  /// =========================================================================

  TimeOfDay? _parseTimeOfDayFromText(
      String s,
      ) {

    final parts = s.split(':');

    if (parts.length >= 2) {

      final hh =
          int.tryParse(parts[0]) ?? 0;

      final mm =
          int.tryParse(parts[1]) ?? 0;

      return TimeOfDay(
        hour: hh,
        minute: mm,
      );
    }

    return null;
  }

  String _formatTimeOfDay(
      TimeOfDay? tod,
      ) {

    if (tod == null) return "";

    final h = tod.hour
        .toString()
        .padLeft(2, '0');

    final m = tod.minute
        .toString()
        .padLeft(2, '0');

    return "$h:$m";
  }

  int _weekdayFromDate(
      DateTime? dt,
      ) =>
      dt?.weekday ?? 0;

  /// =========================================================================
  /// MAP FIRESTORE -> VM
  /// =========================================================================

  List<_DriverTripVM> _mapDocsToVM(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) {

    return docs.map((doc) {

      final documentData = doc.data();

      DateTime? completedAt;

      if (documentData['completedAt'] is Timestamp) {

        completedAt = (documentData['completedAt'] as Timestamp)
                .toDate();

      }

      final timeText = _str(documentData['timeText']);

      final tod = timeText.isNotEmpty
          ? _parseTimeOfDayFromText(timeText)
          : null;

      final priceStr = _str(documentData['price']);

      final priceVal = _parsePriceToDouble(priceStr);

      return _DriverTripVM(

        depart: _str(documentData['depart']),

        meetingPlace: _str(documentData['meetingPlace']),

        departureAddress: _str(documentData['departureAddress']),

        destination: _str(documentData['destination']),

        arrivalAddress: _str(documentData['arrivalAddress']),

        priceStr: priceStr,

        priceVal: priceVal,

        timeText: timeText.isNotEmpty ? timeText : null,

        timeOfDay: tod,

        completedAt: completedAt,

        dateText: _str(documentData['dateText']),

        weekday: _weekdayFromDate(completedAt),

        passengerCount: _int(
          documentData['reservedSeats'] ?? 0,
        ),

        capacity: _int(
          documentData['seats'] ?? 0,
        ),
      );

    }).toList();
  }

  /// =========================================================================
  /// FILTERS
  /// =========================================================================

  List<_DriverTripVM> _applyFilters(
      List<_DriverTripVM> items,
      FilterCriteria c,
      ) {

    return items.where((t) {

      if (c.departureQuery != null &&
          c.departureQuery!.isNotEmpty) {

        if (!t.depart.toLowerCase().contains(
          c.departureQuery!.toLowerCase(),
        )) {
          return false;
        }
      }

      if (c.arrivalQuery != null &&
          c.arrivalQuery!.isNotEmpty) {

        if (!t.destination.toLowerCase().contains(
          c.arrivalQuery!.toLowerCase(),
        )) {
          return false;
        }
      }

      return true;

    }).toList();
  }

  /// =========================================================================
  /// SORT
  /// =========================================================================

  List<_DriverTripVM> _applySort(
      List<_DriverTripVM> list,
      SortMode mode,
      ) {

    final copy = [...list];

    switch (mode) {

      case SortMode.priceAsc:

        copy.sort(
              (a, b) =>
              a.priceVal.compareTo(
                b.priceVal,
              ),
        );

        break;

      case SortMode.passengerDesc:

        copy.sort(
              (a, b) =>
              b.passengerCount.compareTo(
                a.passengerCount,
              ),
        );

        break;

      case SortMode.timeAsc:

        copy.sort((a, b) {

          final ad = a.completedAt ??
              DateTime.now();

          final bd = b.completedAt ??
              DateTime.now();

          return ad.compareTo(bd);

        });

        break;

      case SortMode.none:
        break;
    }

    return copy;
  }

  /// =========================================================================
  /// SORT SHEET
  /// =========================================================================

  void _openSortSheet() {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      builder: (_) {

        return SafeArea(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              mainAxisSize: MainAxisSize.min,

              children: [

                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Trier les annonces",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _buildSortTile(
                  icon: Icons.price_change,
                  label: "Prix croissant",
                  value: SortMode.priceAsc,
                ),

                _buildSortTile(
                  icon: Icons.people_alt,
                  label: "Plus de passagers",
                  value: SortMode.passengerDesc,
                ),

                _buildSortTile(
                  icon: Icons.schedule,
                  label: "Heure de départ",
                  value: SortMode.timeAsc,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortTile({
    required IconData icon,
    required String label,
    required SortMode value,
  }) {

    return ListTile(

      leading: CircleAvatar(
        backgroundColor: AppColors.secondColor.withValues(alpha: .1),
        child: Icon(
          icon,
          color: AppColors.secondColor,
        ),
      ),

      title: Text(label),

      onTap: () {

        Navigator.pop(context);

        setState(() {
          _sort = value;
        });
      },
    );
  }

  /// =========================================================================
  /// BUILD
  /// =========================================================================

  @override
  Widget build(BuildContext context) {

    final uid = widget.selectedUser != null
        ? widget.selectedUser!.id
        : FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {

      return const Scaffold(
        body: Center(
          child: Text(
            "Veuillez vous connecter",
          ),
        ),
      );
    }

    final streamAnnounces = AdminDataService.usersRef
        .doc(uid)
        .collection('announces')
        .orderBy('completedAt', descending: true,)
        .snapshots();

    final streamAnnouncesEffectuees = AdminDataService.usersRef
        .doc(uid)
        .collection('announces_effectuees')
        .orderBy('completedAt', descending: true,)
        .snapshots();

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      body: SafeArea(

        child: Column(

          children: [

            /// =============================================================
            /// HEADER
            /// =============================================================

            Container(

              padding: const EdgeInsets.fromLTRB(
                20, 20, 20, 24,
              ),

              decoration: BoxDecoration(

                gradient: LinearGradient(

                  colors: [
                    AppColors.secondColor,
                    AppColors.secondColor.withValues(alpha: .8),
                  ],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: const BorderRadius.only(

                  bottomLeft: Radius.circular(32),

                  bottomRight: Radius.circular(32),
                ),
              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      IconButton(

                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),

                      const Spacer(),

                      Container(

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(

                          color: Colors.white.withValues(
                            alpha: .15,
                          ),

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: const Row(

                          children: [

                            Icon(
                              Icons.history,
                              color: Colors.white,
                              size: 18,
                            ),

                            SizedBox(width: 8),

                            Text(
                              "Historique",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                          ],

                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Historique des annonces",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.selectedUser != null
                        ? "Annonces de ${widget.selectedUser!.fullName}"
                        : "Retrouvez toutes vos annonces publiées",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .9),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            /// =============================================================
            /// FILTER BAR
            /// =============================================================

            Padding(

              padding: const EdgeInsets.all(16),

              child: Material(

                elevation: 3,

                borderRadius: BorderRadius.circular(22),

                child: SearchFilterBar(

                  criteria: _criteria,

                  onChanged: (c) {

                    setState(() {
                      _criteria = c;
                    });
                  },

                  onOpenSort: _openSortSheet,

                  backgroundColor: AppColors.mainColor,
                ),
              ),
            ),

            /// =============================================================
            /// STREAM
            /// =============================================================

            Expanded(

              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(

                stream: streamAnnounces,

                builder: (context, snap) {

                  if (snap.connectionState == ConnectionState.waiting) {

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snap.hasError) {

                    return Center(
                      child: Text(
                        "Erreur : ${snap.error}",
                      ),
                    );
                  }

                  final docs = snap.data?.docs ?? [];

                  if (docs.isEmpty) {

                    return _buildEmptyState();
                  }

                  final items = _mapDocsToVM(docs);

                  final filteredTrips = _applyFilters(
                    items, _criteria,
                  );

                  final visibleTrips = _applySort(filteredTrips, _sort);

                  if (visibleTrips.isEmpty) {

                    return _buildNoResultState();
                  }

                  return ListView.builder(

                    padding:
                    const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),

                    itemCount: visibleTrips.length,

                    itemBuilder: (context, i) {

                      final trip = visibleTrips[i];

                      final dateLabel = _formatFrenchDateLabel(
                        dt: trip.completedAt,
                        dateText: trip.dateText,
                      );

                      final time = trip.timeText ??
                          _formatTimeOfDay(trip.timeOfDay);

                      final departureAddrDisplay = trip.meetingPlace.isNotEmpty
                          ? trip.meetingPlace
                          : trip.departureAddress;

                      return Padding(

                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),

                        child: DriverHistoryCard(

                          dateLabel: dateLabel,

                          time: time,

                          departure: trip.depart,

                          departureAddress: departureAddrDisplay,

                          arrival: trip.destination,

                          arrivalAddress: trip.arrivalAddress,

                          price: trip.priceStr,

                          passengerCount: trip.passengerCount,

                          onReconduire: () {

                            final draft = AnnounceDraft(

                              depart: trip.depart,

                              destination: trip.destination,

                              meetingPlace: departureAddrDisplay,

                              arrivalPlace: trip.arrivalAddress,

                              date: null,

                              time: trip.timeOfDay,

                              seats: trip.capacity,

                              price: trip.priceVal.toInt(),
                            );

                            AnnouncePrefillService().setDraft(draft);

                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================================================================
  /// EMPTY STATE
  /// =========================================================================

  Widget _buildEmptyState() {

    return Center(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(

            width: 120,
            height: 120,

            decoration: BoxDecoration(

              color: AppColors.secondColor.withValues(
                alpha: .08,
              ),

              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.history_toggle_off,
              size: 60,
              color: AppColors.secondColor,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Aucune annonce trouvée",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Vos annonces passées apparaîtront ici.",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// =========================================================================
  /// NO RESULT STATE
  /// =========================================================================

  Widget _buildNoResultState() {

    return Center(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            Icons.search_off,
            size: 70,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 20),

          const Text(
            "Aucun résultat",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Essayez de modifier les filtres.",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// VIEW MODEL
/// ============================================================================

class _DriverTripVM {

  final String depart;

  final String meetingPlace;

  final String departureAddress;

  final String destination;

  final String arrivalAddress;

  final String priceStr;

  final double priceVal;

  final String? timeText;

  final TimeOfDay? timeOfDay;

  final DateTime? completedAt;

  final String dateText;

  final int weekday;

  final int passengerCount;

  final int capacity;

  _DriverTripVM({

    required this.depart,

    required this.meetingPlace,

    required this.departureAddress,

    required this.destination,

    required this.arrivalAddress,

    required this.priceStr,

    required this.priceVal,

    required this.timeText,

    required this.timeOfDay,

    required this.completedAt,

    required this.dateText,

    required this.weekday,

    required this.passengerCount,

    required this.capacity,
  });
}