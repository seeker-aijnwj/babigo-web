import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:babigo/modules/booking_module/services/passenger_dashboard_service.dart';
import 'package:babigo/modules/booking_module/widgets/passenger_activity_graph.dart';
import 'package:babigo/modules/booking_module/widgets/reservation_card.dart';

import '../../../database/models/admin/utilisateur.dart';

class AdminPassengerDashboardScreen extends StatefulWidget {
  final Utilisateur? selectedUser;

  const AdminPassengerDashboardScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminPassengerDashboardScreen> createState() =>
      _AdminPassengerDashboardScreenState();
}

class _AdminPassengerDashboardScreenState
    extends State<AdminPassengerDashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late final PassengerDashboardService _service;

  Future<PassengerGraphPayload>? _graphFuture;
  int _selectedMonthIndex = 0;
  bool _graphIndexInitialized = false;

  static const Color _background = Color(0xFFF4F7FE);
  static const Color _primary = Color(0xFF1F6FEB);
  static const Color _ink = Color(0xFF0F172A);
  static const Color _muted = Color(0xFF64748B);
  static const Color _success = Color(0xFF16A34A);
  static const Color _warning = Color(0xFFF59E0B);

  String? get _uid => widget.selectedUser?.id ?? _auth.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
    _service = PassengerDashboardService(_db);
    _loadGraph();
  }

  @override
  void didUpdateWidget(covariant AdminPassengerDashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedUser?.id != widget.selectedUser?.id) {
      _selectedMonthIndex = 0;
      _graphIndexInitialized = false;
      _loadGraph();
    }
  }

  void _loadGraph() {
    final uid = _uid;
    _graphFuture = uid == null ? null : _service.getPassengerGraphPayload(uid);
  }

  @override
  Widget build(BuildContext context) {
    final uid = _uid;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Stats & Suivi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,

        ),
        body: _uid == null
            ? const _CenteredInfo(
          text: 'Vous devez être connecté pour voir vos notifications.',
        )
            : Container(
                color: _background,
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 900;

                      return SingleChildScrollView(
                        padding: EdgeInsets.all(isDesktop ? 28 : 16),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1180),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader(isDesktop),
                                const SizedBox(height: 18),
                                if (uid == null)
                                  const _InfoBox(
                                    icon: Icons.lock_outline,
                                    message:
                                    "Aucun passager sélectionné ou utilisateur connecté.",
                                  )
                                else ...[
                                  _buildGraphSection(),
                                  const SizedBox(height: 18),
                                  _buildReservationsSection(uid),
                                  const SizedBox(height: 18),
                                  _buildQuickStats(uid, isDesktop),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    final userName = widget.selectedUser?.fullName.trim().isNotEmpty == true
        ? widget.selectedUser!.fullName
        : "Passager";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F6FEB), Color(0xFF5B8DFF)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Suivi passager",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Activité, réservations et statistiques de $userName.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(String uid, bool isDesktop) {
    final stream = _reservationsQuery(uid).snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        final count = docs.length;

        final total = docs.fold<int>(0, (sum, doc) {
          final price = doc.data()['price'];
          if (price is int) return sum + price;
          return sum + (int.tryParse(price?.toString() ?? '') ?? 0);
        });

        return GridView.count(
          crossAxisCount: isDesktop ? 3 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: isDesktop ? 3.4 : 4,
          children: [
            _StatCard(
              icon: Icons.route,
              title: "Réservations en cours",
              value: "$count",
              color: _primary,
            ),
            _StatCard(
              icon: Icons.payments_outlined,
              title: "Montant estimé",
              value: "$total F CFA",
              color: _success,
            ),
            const _StatCard(
              icon: Icons.verified_user_outlined,
              title: "Statut",
              value: "Suivi actif",
              color: _warning,
            ),
          ],
        );
      },
    );
  }

  Widget _buildGraphSection() {
    return _Panel(
      title: "Activité du passager",
      subtitle: "Vue mensuelle des réservations et déplacements.",
      icon: Icons.bar_chart,
      child: _buildPassengerGraph(),
    );
  }

  Widget _buildPassengerGraph() {
    final uid = _uid;

    if (uid == null || _graphFuture == null) {
      return const PassengerActivityGraph(
        averageActivity: [0, 0, 0, 0, 0, 0, 0],
        months: ["-", "-", "-", "-"],
        selectedMonthIndex: 0,
        onMonthSelected: _noopMonth,
      );
    }

    return FutureBuilder<PassengerGraphPayload>(
      future: _graphFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return _InfoBox(
            icon: Icons.error_outline,
            message: "Erreur lors du chargement du graphe : ${snapshot.error}",
          );
        }

        final payload = snapshot.data;
        if (payload == null || payload.months.isEmpty) {
          return const PassengerActivityGraph(
            averageActivity: [0, 0, 0, 0, 0, 0, 0],
            months: ["-", "-", "-", "-"],
            selectedMonthIndex: 0,
            onMonthSelected: _noopMonth,
          );
        }

        if (!_graphIndexInitialized) {
          _selectedMonthIndex = _clampIndex(
            payload.selectedMonthIndexDefault,
            payload.months.length,
          );
          _graphIndexInitialized = true;
        } else {
          _selectedMonthIndex = _clampIndex(
            _selectedMonthIndex,
            payload.months.length,
          );
        }

        return PassengerActivityGraph(
          averageActivity: payload.dataByMonth[_selectedMonthIndex],
          months: payload.months,
          selectedMonthIndex: _selectedMonthIndex,
          onMonthSelected: (index) {
            setState(() {
              _selectedMonthIndex = _clampIndex(index, payload.months.length);
            });
          },
        );
      },
    );
  }

  Widget _buildReservationsSection(String uid) {
    return _Panel(
      title: "Réservations en cours",
      subtitle: "Liste des trajets actuellement suivis pour ce passager.",
      icon: Icons.event_available_outlined,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _reservationsQuery(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return const _InfoBox(
              icon: Icons.cloud_off_outlined,
              message:
              "Impossible de charger les réservations.\nRéessayez plus tard.",
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const _InfoBox(
              icon: Icons.inbox_outlined,
              message: "Aucune réservation en cours pour le moment.",
            );
          }

          return Column(
            children: docs.map((doc) {
              final data = doc.data();

              final departure = (data['depart'] ?? '').toString();
              final departureAddress =
              (data['departureAddress'] ?? '').toString();
              final arrival = (data['destination'] ?? '').toString();
              final dateText = (data['dateText'] ?? '').toString();
              final timeText = (data['timeText'] ?? '').toString();
              final price = (data['price'] ?? 0).toString();

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ReservationCard(
                  departure: departure,
                  departureAddress: departureAddress,
                  arrival: arrival,
                  arrivalAddress: arrival,
                  date: dateText.isNotEmpty
                      ? dateText
                      : DateFormat("d MMMM", "fr_FR").format(DateTime.now()),
                  time: timeText.isNotEmpty
                      ? timeText
                      : DateFormat("HH:mm", "fr_FR").format(DateTime.now()),
                  price: price,
                  reservationRef: doc.reference,
                  onCanceled: () {},
                  onCall: () {},
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Query<Map<String, dynamic>> _reservationsQuery(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('reservations')
        .where('passengerId', isEqualTo: uid)
        .where('status', isEqualTo: 'en_cours')
        .orderBy('createdAt', descending: true);
  }

  int _clampIndex(int index, int length) {
    if (length <= 0) return 0;
    return index.clamp(0, length - 1).toInt();
  }
}

void _noopMonth(int _) {}

class _Panel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _Panel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFEFF6FF),
                child: Icon(icon, color: _AdminPassengerDashboardScreenState._primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _AdminPassengerDashboardScreenState._ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _AdminPassengerDashboardScreenState._muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: .1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _AdminPassengerDashboardScreenState._ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _AdminPassengerDashboardScreenState._muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String message;

  const _InfoBox({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: _AdminPassengerDashboardScreenState._muted,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _AdminPassengerDashboardScreenState._muted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .05),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

class _CenteredInfo extends StatelessWidget {
  final String text;
  const _CenteredInfo({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }
}
