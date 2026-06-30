// lib/screens/passenger/passenger_main_screen.dart
// Cette page est le tableau de bord du passager

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:babigo/modules/booking_module/screens/passenger/passenger_home_screen.dart';
import 'package:babigo/modules/booking_module/screens/passenger/search_tab.dart';
import 'package:babigo/modules/booking_module/screens/passenger/passenger_dashboard_screen.dart';
import 'package:babigo/modules/booking_module/screens/passenger/profile_screen.dart';

import 'package:babigo/modules/booking_module/widgets/bottom_nav_bar.dart';
import 'package:babigo/modules/booking_module/widgets/rate_driver_dialog.dart';

// 👇 ajout pour appeler le watcher
import 'package:babigo/modules/trip_module/widgets/trip_start_watcher.dart';

typedef PassengerMainScreenState = _PassengerMainScreenState;

class PassengerMainScreen extends StatefulWidget {
  const PassengerMainScreen({super.key});

  @override
  State<PassengerMainScreen> createState() => _PassengerMainScreenState();
}

class _PassengerMainScreenState extends State<PassengerMainScreen> {
  int _selectedIndex = 0;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _notifSub;
  bool _ratingDialogOpen = false;

  // 👇 ajout : garder la souscription du watcher pour pouvoir l’annuler
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _tripWatcherSub;

  @override
  void initState() {
    super.initState();
    _listenRateDriverNotifications();

    // Par sécurité : annule si jamais existait (ex. hot-reload)
    _tripWatcherSub?.cancel();
    _tripWatcherSub = TripStartWatcher.startListening(context);
  }

  @override
  void dispose() {
    _notifSub?.cancel();
    _tripWatcherSub?.cancel();
    TripStartWatcher.resetOpenedTripsCache(); // optionnel
    super.dispose();
  }

  void _listenRateDriverNotifications() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    _notifSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('type', isEqualTo: 'rate_driver')
        .where('consumed', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) async {
          if (!mounted) return;
          if (snap.docs.isEmpty) return;

          final doc = snap.docs.first;
          final data = doc.data();

          final driverId = (data['driverId'] ?? '').toString();
          final announceId = (data['announceId'] ?? '').toString();
          final reservationId = (data['reservationId'] ?? '').toString();

          if (driverId.isEmpty || announceId.isEmpty || reservationId.isEmpty) {
            return;
          }

          if (_ratingDialogOpen) return;
          _ratingDialogOpen = true;

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            try {
              await showRateDriverDialog(
                context,
                driverId: driverId,
                passengerId: uid,
                announceId: announceId,
                reservationId: reservationId,
                notifRef: doc.reference,
              );
            } finally {
              if (mounted) _ratingDialogOpen = false;
            }
          });
        });
  }

  // Appelé par tes écrans via findAncestorStateOfType<HomeScreenState>()
  void navigateToTab(int index) {
    if (!mounted) return;
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  // Back: si pas sur index 0 -> revenir à 0. Si déjà sur 0 -> quitter l'app.
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return false; // on bloque le pop (on ne quitte pas)
    }
    return true; // déjà sur 0: on autorise la fermeture de l'app
  }

  @override
  Widget build(BuildContext context) {
    final screens = const <Widget>[
      PassengerHomeScreen(),
      SearchTab(),
      DashboardPassengerScreen(),
      ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(index: _selectedIndex, children: screens),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}
