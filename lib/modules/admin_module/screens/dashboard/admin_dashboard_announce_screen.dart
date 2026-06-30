
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../app/core/utils/colors.dart';
import '../../../../app/database/services/dashboard_service.dart';
import '../../../../app/widgets/dashboard_graph.dart';
import '../../../../app/widgets/dashboard_summary.dart';
import '../../../booking_module/widgets/announce_card.dart';
import '../booking/operations/admin_edit_announce_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late final DashboardService _service;

  int _selectedMonthIndex = 0;
  bool _graphIndexInitialized = false;

  @override
  void initState() {
    super.initState();
    _service = DashboardService(_db);
  }

  Future<void> _refresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: RefreshIndicator(
        color:AppColors. mainColor,
        onRefresh: _refresh,

        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [

            _buildHeader(),

            SliverPadding(
              padding: const EdgeInsets.all(20),

              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  _buildSummarySection(),

                  const SizedBox(height: 24),

                  _buildGraphSection(),

                  const SizedBox(height: 24),

                  _buildAnnouncementsSection(),

                  const SizedBox(height: 120),

                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 180,

      pinned: true,

      elevation: 0,

      backgroundColor: AppColors.mainColor,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Spacer(),

                  const Text(
                    "Tableau de bord",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Suivez vos performances en temps réel",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    final user = _auth.currentUser;

    if (user == null) {
      return _buildEmptyCard(
        "Connectez-vous pour accéder à vos statistiques.",
      );
    }

    return StreamBuilder<DashboardSummaryModel>(
      stream: _service.watchSummary(user.uid),

      builder: (context, snapshot) {
        final summary = snapshot.data;

        return DashboardSummary(
          annonces: summary?.annonces ?? 0,
          passagers: summary?.passagers ?? 0,
          note: summary?.note ?? 0,
        );
      },
    );
  }

  Widget _buildGraphSection() {
    final user = _auth.currentUser;

    if (user == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            "Évolution des réservations",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          StreamBuilder<DashboardGraphPayload>(
            stream: _service.watchGraphPayload(user.uid),

            builder: (context, snap) {
              final payload = snap.data;

              if (payload == null) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!_graphIndexInitialized) {
                _selectedMonthIndex =
                    payload.selectedMonthIndexDefault;

                _graphIndexInitialized = true;
              }

              return DashboardGraph(
                data: payload.dataByMonth[_selectedMonthIndex],
                months: payload.months,
                selectedMonthIndex: _selectedMonthIndex,

                onMonthSelected: (index) {
                  setState(() {
                    _selectedMonthIndex = index;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    final user = _auth.currentUser;

    if (user == null) {
      return _buildEmptyCard(
        "Aucune annonce disponible.",
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                Icons.directions_car,
                color: AppColors.secondColor,
              ),

              const SizedBox(width: 10),

              const Text(
                "Mes annonces récentes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildAnnouncementsList(user.uid),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('users')
          .doc(uid)
          .collection('announces')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildEmptyCard(
            "Impossible de charger les annonces.",
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return _buildEmptyCard(
            "Aucune annonce publiée.",
          );
        }

        return Column(
          children: docs.map((doc) {
            final data =
            doc.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),

              child: AnnonceCard(
                departure: data['depart'] ?? '',
                departureAddress: data['meetingPlace'] ?? '',
                arrival: data['destination'] ?? '',
                arrivalAddress: data['arrivalPlace'] ?? '',
                date: data['dateText'] ?? '',
                time: data['timeText'] ?? '',
                price: data['price'].toString(),
                seats: data['seats'] ?? 0,
                reservedSeats: data['reservedSeats'] ?? 0,

                annonceRef: doc.reference,

                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AdminEditAnnounceScreen(
                            annonceRef: doc.reference,
                          ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [

          Icon(
            Icons.inbox_outlined,
            size: 42,
            color: AppColors.secondColor,
          ),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}