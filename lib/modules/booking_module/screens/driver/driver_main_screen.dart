// Cette page regroupe les écrans principaux du conducteur
// - Liste des trajets (DriverHomeScreen)
// - Annonces (AnnounceScreen)
// - Dashboard (DashboardScreen)
// - Profil (DriverProfileScreen)

import 'package:flutter/material.dart';
import 'package:babigo/modules/booking_module/screens/driver/announce_screen.dart';
import 'package:babigo/modules/booking_module/screens/driver/dashboard_annonce_screen.dart';
import 'package:babigo/modules/booking_module/screens/driver/driver_home_screen.dart';
import 'package:babigo/modules/booking_module/widgets/bottom_nav_bar_drivers.dart';

// Ajout:
import 'package:babigo/modules/booking_module/services/announce_prefill_service.dart';

import 'driver_profile_screen.dart';

typedef DriverMainScreenState = _DriverMainScreenState;

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // Si l'historique a demandé un onglet spécifique, on le prend en compte
    final pending = AnnouncePrefillService().takePendingTab();
    if (pending != null) {
      _selectedIndex = pending;
    }
  }

  void navigateToTab(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return false; // bloque la fermeture si on n'est pas sur 0
    }
    return true; // sur 0 → autorise la fermeture de l'app
  }

  @override
  Widget build(BuildContext context) {
    
    // Les écrans principaux
    final screens = const <Widget>[
      DriverHomeScreen(),
      AnnounceScreen(),
      DashboardScreen(),
      DriverProfileScreen(),
    ];

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: screens),
        bottomNavigationBar: BottomNavBarDrivers(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}
