import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/modules/admin_module/database/models/admin/utilisateur.dart';

import 'drivers/admin_driver_document_upload_screen.dart';
import 'drivers/admin_driver_notifications_screen.dart';
import 'drivers/admin_driver_trip_history_screen.dart';
import 'drivers/admin_announce_screen.dart';
import 'drivers/admin_driver_home_screen.dart';

class AdminDriverMainScreen extends StatefulWidget {

  final Utilisateur? selectedUser;

  const AdminDriverMainScreen({
    super.key,
    this.selectedUser
  });

  @override
  State<AdminDriverMainScreen> createState() => AdminDriverMainScreenState();
}

class AdminDriverMainScreenState extends State<AdminDriverMainScreen> {
  int _selectedIndex = 0;
  late String userFullName;
  late String userEmail;

  late final List<Widget> _screens = [
    AdminDriverHomeScreen(selectedUser: widget.selectedUser,),
    AdminDriverDocumentsUploadScreen(selectedUser: widget.selectedUser),
    AdminDriverNotificationsScreen(selectedUser: widget.selectedUser),
    AdminAnnounceScreen(selectedUser: widget.selectedUser),
    AdminDriverTripHistoryScreen(selectedUser: widget.selectedUser),
  ];

  final List<_PassengerMenuItem> _items = const [

    _PassengerMenuItem(
      title: "Accueil",
      subtitle: "Vue générale",
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),

    _PassengerMenuItem(
      title: "Documents",
      subtitle: "CNI, Permis de conduire, etc.",
      icon: Icons.document_scanner_outlined ,
      selectedIcon: Icons.document_scanner_rounded,
    ),

    _PassengerMenuItem(
      title: "Notifications",
      subtitle: "",
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications_rounded,
    ),

    _PassengerMenuItem(
      title: "Activités",
      subtitle: "Publier une annonce",
      icon: Icons.campaign_outlined,
      selectedIcon: Icons.campaign_rounded,
    ),

    _PassengerMenuItem(
      title: "Historique",
      subtitle: "Retrouver vos annonces",
      icon: Icons.history_toggle_off,
      selectedIcon: Icons.history,
    ),

    _PassengerMenuItem(
      title: "Déconnexion",
      subtitle: "Retrouver vos annonces",
      icon: Icons.logout_outlined,
      selectedIcon: Icons.logout_rounded,
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
      backgroundColor: Colors.white,
      bottomNavigationBar: isDesktop || isTablet ? null : _buildBottomNav(),
      body: Row(
        children: [
          (isDesktop) ? _buildSideMenu() : _buildNavigationRail()
          ,
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
          : "Conducteur";
      userEmail = user?.email ?? "Compte Babigo";

    } else {

      final user = FirebaseAuth.instance.currentUser;

      userFullName = user?.displayName?.trim().isNotEmpty == true
          ? user!.displayName!
          : "Conducteur";
      userEmail = user?.email ?? "Compte Babigo";

    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondColor,
            AppColors.secondColor.withValues(alpha: .8),
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
              color: AppColors.secondColor,
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
        color: selected ? AppColors.secondColor : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          selected ? item.selectedIcon : item.icon,
          color: selected ? Colors.white : AppColors.secondColor,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black45,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
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
        indicatorColor: AppColors.secondColor.withValues(alpha: .12),
        selectedIconTheme: const IconThemeData(color: AppColors.secondColor),
        selectedLabelTextStyle: const TextStyle(
          color: AppColors.secondColor,
          fontWeight: FontWeight.bold,
        ),
        labelType: NavigationRailLabelType.all,
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: CircleAvatar(
            backgroundColor: AppColors.secondColor,
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
        ).toList(),

      ),
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: navigateToTab,
      backgroundColor: Colors.white,
      indicatorColor: AppColors.secondColor.withValues(alpha: .12),
      destinations: _items
          .map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(
                item.selectedIcon,
                color: AppColors.secondColor,
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