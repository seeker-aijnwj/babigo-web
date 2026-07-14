import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../app/core/utils/colors.dart';
import '../../../auth_module/screens/signin_screen.dart';
import '../../database/models/admin/utilisateur.dart';
import '../../database/services/auth_service.dart';
import 'passengers/admin_passenger_home_screen.dart';
import 'passengers/admin_passenger_dashboard_screen.dart';
import 'passengers/admin_passenger_notifications_screen.dart';
import 'drivers/search/admin_search_tab.dart';

class AdminPassengerMainScreen extends StatefulWidget {

  final Utilisateur? selectedUser;

  const AdminPassengerMainScreen({
    super.key,
    this.selectedUser
  });

  @override
  State<AdminPassengerMainScreen> createState() => AdminPassengerMainScreenState();
}

class AdminPassengerMainScreenState extends State<AdminPassengerMainScreen> {
  int _selectedIndex = 0;
  late String userFullName;
  late String userEmail;

  late final List<Widget> _screens = [
    AdminPassengerHomeScreen(selectedUser: widget.selectedUser),
    AdminSearchTab(),
    AdminPassengerDashboardScreen(selectedUser: widget.selectedUser,),
    AdminPassengerNotificationsScreen(selectedUser: widget.selectedUser,),
  ];

  final List<_PassengerMenuItem> _items = const [

    _PassengerMenuItem(
      title: "Accueil",
      subtitle: "Vue générale",
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),

    _PassengerMenuItem(
      title: "Rechercher",
      subtitle: "Trouver un trajet",
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
    ),

    _PassengerMenuItem(
      title: "Suivi",
      subtitle: "Réservations",
      icon: Icons.route_outlined,
      selectedIcon: Icons.route,
    ),

    _PassengerMenuItem(
      title: "Notifications",
      subtitle: "Notes, Réservations, ...",
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
    ),

  ];

  void navigateToTab(int index) {
    if (index < 0 || index >= _screens.length) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;
    final isTablet = width >= 650 && width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      bottomNavigationBar: isDesktop || isTablet ? null : _buildBottomNav(),
      body: Row(
        children: [
          if (isDesktop) _buildSideMenu(),
          if (isTablet) _buildNavigationRail(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return SafeArea(
      child: Container(
        width: 280,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildProfileCard(),
            const SizedBox(height: 24),
            ...List.generate(
              _items.length,
                  (index) => _buildMenuItem(
                item: _items[index],
                selected: _selectedIndex == index,
                onTap: () => navigateToTab(index),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FE),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextButton(
                  child: Text("Déconnexion",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () async {

                    await AuthService.signOut();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SignInScreen(),
                      ),
                          (_) => false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    if (widget.selectedUser != null) {

      final user = widget.selectedUser;

      userFullName = user?.fullName.trim().isNotEmpty == true
          ? user!.fullName
          : "Passager";
      userEmail = user?.email ?? "Compte Babigo";

    } else {

      final user = FirebaseAuth.instance.currentUser;

      userFullName = user?.displayName?.trim().isNotEmpty == true
          ? user!.displayName!
          : "Passager";
      userEmail = user?.email ?? "Compte Babigo";

    }


    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1F6FEB),
            Color(0xFF5B8DFF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Color(0xFF1F6FEB),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userFullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required _PassengerMenuItem item,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1F6FEB) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          selected ? item.selectedIcon : item.icon,
          color: selected ? Colors.white : const Color(0xFF1E293B),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          style: TextStyle(
            color: selected ? Colors.white70 : const Color(0xFF94A3B8),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRail() {
    return SafeArea(
      child: NavigationRail(
        selectedIndex: _selectedIndex,
        onDestinationSelected: navigateToTab,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1F6FEB).withValues(alpha: .12),
        selectedIconTheme: const IconThemeData(color: Color(0xFF1F6FEB)),
        selectedLabelTextStyle: const TextStyle(
          color: Color(0xFF1F6FEB),
          fontWeight: FontWeight.bold,
        ),
        labelType: NavigationRailLabelType.all,
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: CircleAvatar(
            backgroundColor: Color(0xFF1F6FEB),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        destinations: _items
            .map(
              (item) => NavigationRailDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: Text(item.title),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: navigateToTab,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFF1F6FEB).withValues(alpha: .12),
      destinations: _items.map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(
                item.selectedIcon,
                color: const Color(0xFF1F6FEB),
              ),
              label: item.title,
            ),
      ).toList(),
    );
  }
}

class _PassengerMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;

  const _PassengerMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selectedIcon,
  });
}