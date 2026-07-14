import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:babigo/app/core/utils/colors.dart';
import '../../../../app/core/utils/constants.dart';

import '../../database/models/admin/utilisateur.dart';
import 'fleet_managers/admin_fleet_dashboard_screen.dart';
import 'fleet_managers/admin_fleet_page.dart';
import 'fleet_managers/admin_fleet_wallet_screen.dart';

class AdminFleetManagerMainScreen extends StatefulWidget {
  
  final Utilisateur? selectedUser;

  const AdminFleetManagerMainScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminFleetManagerMainScreen> createState() =>
      AdminFleetManagerMainScreenState();
}

class AdminFleetManagerMainScreenState
    extends State<AdminFleetManagerMainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  final List<_FleetMenuItem> _items = const [
    _FleetMenuItem(
      title: "Accueil",
      subtitle: "Vue générale",
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
    _FleetMenuItem(
      title: "Informations",
      subtitle: "Profil et société",
      icon: Icons.business_outlined,
      selectedIcon: Icons.business,
    ),
    _FleetMenuItem(
      title: "Documents",
      subtitle: "KYC, contrats, assurances",
      icon: Icons.folder_copy_outlined,
      selectedIcon: Icons.folder_copy,
    ),
    _FleetMenuItem(
      title: "Véhicules",
      subtitle: "Flotte et disponibilité",
      icon: Icons.directions_car_outlined,
      selectedIcon: Icons.directions_car,
    ),
    _FleetMenuItem(
      title: "Conducteurs",
      subtitle: "Équipe et affectations",
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
    ),
    _FleetMenuItem(
      title: "Portefeuille",
      subtitle: "Solde et transactions",
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
    ),
    _FleetMenuItem(
      title: "Alertes",
      subtitle: "Suivi opérationnel",
      icon: Icons.notifications_active_outlined,
      selectedIcon: Icons.notifications_active,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _screens = _createScreens();
  }

  @override
  void didUpdateWidget(covariant AdminFleetManagerMainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedUser?.id != widget.selectedUser?.id) {
      _screens = _createScreens();
    }
  }

  List<Widget> _createScreens() {
    
    return [

      AdminFleetDashboardScreen(
        managerName: _managerName,
        onNavigate: navigateToTab,
      ),

      _FleetSectionScreen(
        title: "Informations gestionnaire",
        subtitle: "Gérez les informations du compte, de la société ou du parc.",
        icon: Icons.business,
        tools: [
          _ToolData("Modifier le profil", Icons.edit, () {}),
          _ToolData("Vérifier le compte", Icons.verified_user, () {}),
          _ToolData("Paramètres", Icons.settings, () {}),
        ],
        cards: const [
          _FleetCardData(
            title: "Profil gestionnaire",
            subtitle: "Nom, email, téléphone et rôle dans l'organisation.",
            meta: "À jour",
            icon: Icons.person,
            color: AppColors.mainColor,
          ),
          _FleetCardData(
            title: "Entreprise ou parc",
            subtitle: "Nom commercial, adresse, pays et informations légales.",
            meta: "Complet",
            icon: Icons.apartment,
            color: Color(0xFF16A34A),
          ),
          _FleetCardData(
            title: "Préférences opérationnelles",
            subtitle: "Zones couvertes, types de trajets et disponibilité.",
            meta: "À configurer",
            icon: Icons.tune,
            color: Color(0xFFF59E0B),
          ),
        ],
      ),

      _FleetSectionScreen(
        title: "Documents",
        subtitle: "Suivez les documents nécessaires à la validation du parc.",
        icon: Icons.folder_copy,
        tools: [
          _ToolData("Ajouter document", Icons.upload_file, () {}),
          _ToolData("Voir expirations", Icons.event_busy, () {}),
        ],
        cards: const [
          _FleetCardData(
            title: "Pièce d'identité",
            subtitle: "Document du gestionnaire principal.",
            meta: "Validé",
            icon: Icons.badge,
            color: Color(0xFF16A34A),
          ),
          _FleetCardData(
            title: "Registre / RCCM",
            subtitle: "Document légal de l'entreprise ou du parc.",
            meta: "En attente",
            icon: Icons.description,
            color: Color(0xFFF59E0B),
          ),
          _FleetCardData(
            title: "Assurance flotte",
            subtitle: "Attestation globale ou documents par véhicule.",
            meta: "À renouveler",
            icon: Icons.health_and_safety,
            color: Color(0xFFEF4444),
          ),
        ],
      ),
      _FleetSectionScreen(
        title: "Véhicules",
        subtitle: "Ajoutez, vérifiez et affectez les véhicules de la flotte.",
        icon: Icons.directions_car,
        tools: [
          _ToolData("Ajouter véhicule", Icons.add, () {}),
          _ToolData("Disponibilités", Icons.event_available, () {}),
          _ToolData("Maintenance", Icons.build, () {}),
        ],
        cards: const [
          _FleetCardData(
            title: "Toyota Corolla",
            subtitle: "AB-245-CD · 4 places · Affecté à Koffi Marc",
            meta: "Disponible",
            icon: Icons.directions_car,
            color: Color(0xFF16A34A),
          ),
          _FleetCardData(
            title: "Hyundai Tucson",
            subtitle: "BG-109-AZ · 4 places · Aucun conducteur affecté",
            meta: "Libre",
            icon: Icons.car_rental,
            color: AppColors.mainColor,
          ),
          _FleetCardData(
            title: "Kia Rio",
            subtitle: "DK-410-TR · 3 places · Assurance à vérifier",
            meta: "Attention",
            icon: Icons.warning_amber,
            color: Color(0xFFF59E0B),
          ),
        ],
      ),
      _FleetSectionScreen(
        title: "Conducteurs",
        subtitle: "Gérez les conducteurs, leurs documents et leurs affectations.",
        icon: Icons.groups,
        tools: [
          _ToolData("Inviter conducteur", Icons.person_add, () {}),
          _ToolData("Affectations", Icons.swap_horiz, () {}),
          _ToolData("Performances", Icons.analytics, () {}),
        ],
        cards: const [
          _FleetCardData(
            title: "Koffi Marc",
            subtitle: "Toyota Corolla · Note 4.8 · 36 trajets",
            meta: "Actif",
            icon: Icons.person,
            color: Color(0xFF16A34A),
          ),
          _FleetCardData(
            title: "Awa Traoré",
            subtitle: "En attente d'affectation · Documents complets",
            meta: "Disponible",
            icon: Icons.person_outline,
            color: AppColors.mainColor,
          ),
          _FleetCardData(
            title: "Jean Kouamé",
            subtitle: "Permis à renouveler prochainement",
            meta: "À vérifier",
            icon: Icons.manage_accounts,
            color: Color(0xFFF59E0B),
          ),
        ],
      ),
      const AdminFleetWalletScreen(),
      _FleetSectionScreen(
        title: "Alertes et suivi",
        subtitle: "Gardez un œil sur les points importants du parc.",
        icon: Icons.notifications_active,
        tools: [
          _ToolData("Tout marquer lu", Icons.done_all, () {}),
          _ToolData("Paramètres alertes", Icons.settings, () {}),
        ],
        cards: const [
          _FleetCardData(
            title: "Assurance à renouveler",
            subtitle: "Le véhicule Kia Rio nécessite une mise à jour.",
            meta: "Urgent",
            icon: Icons.error_outline,
            color: Color(0xFFEF4444),
          ),
          _FleetCardData(
            title: "Conducteur sans véhicule",
            subtitle: "Awa Traoré peut être affectée à un véhicule libre.",
            meta: "Action",
            icon: Icons.person_search,
            color: AppColors.mainColor,
          ),
          _FleetCardData(
            title: "Objectif hebdomadaire",
            subtitle: "Votre parc a atteint 68% de l'objectif de trajets.",
            meta: "Suivi",
            icon: Icons.track_changes,
            color: Color(0xFF16A34A),
          ),
        ],
      ),
    ];
  }

  String get _managerName {
    final selected = widget.selectedUser;

    if (selected != null && selected.fullName.trim().isNotEmpty) {
      return selected.fullName;
    }

    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : "Gestionnaire de flotte";
  }

  String get _managerEmail {
    final selected = widget.selectedUser;

    if (selected != null && selected.email.trim().isNotEmpty) {
      return selected.email;
    }

    final user = FirebaseAuth.instance.currentUser;
    return user?.email ?? "Compte Babigo";
  }

  void navigateToTab(int index) {
    if (index < 0 || index >= _screens.length) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1000;
    final isTablet = width >= 650 && width < 1000;
    final isMobile = !isDesktop && !isTablet;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: isMobile
          ? AppBar(
        title: const Text(
          "Gestion flotte",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      )
          : null,
      drawer: isMobile ? Drawer(child: _buildDrawerMenu()) : null,
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

  Widget _buildDrawerMenu() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 18),
          _buildProfileCard(),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(
                  item: _items[index],
                  selected: _selectedIndex == index,
                  onTap: () {
                    Navigator.of(context).pop();
                    navigateToTab(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return SafeArea(
      child: Container(
        width: 292,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildProfileCard(),
            const SizedBox(height: 22),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _buildMenuItem(
                    item: _items[index],
                    selected: _selectedIndex == index,
                    onTap: () => navigateToTab(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondColor,
            AppColors.secondColor.withValues(alpha: .78),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.business, color: AppColors.secondColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _managerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _managerEmail,
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
    required _FleetMenuItem item,
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
            color: selected ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? Colors.white70 : const Color(0xFF64748B),
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
        labelType: NavigationRailLabelType.selected,
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: CircleAvatar(
            backgroundColor: AppColors.secondColor,
            child: Icon(Icons.business, color: Colors.white),
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
}

class _FleetSectionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_ToolData> tools;
  final List<_FleetCardData> cards;

  const _FleetSectionScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tools,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return AdminFleetPage(
      title: title,
      subtitle: subtitle,
      icon: icon,
      children: [
        _QuickActions(actions: tools),
        const SizedBox(height: 18),
        _FleetCardsGrid(cards: cards),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  final List<_ToolData> actions;

  const _QuickActions({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: Utils.cardDecoration(),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: actions.map((action) {
          return _ActionButton(
            label: action.label,
            icon: action.icon,
            onTap: action.onTap ?? () => Utils.showAction(context, action.label),
          );
        }).toList(),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _FleetCardsGrid extends StatelessWidget {
  final List<_FleetCardData> cards;

  const _FleetCardsGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 600
            ? 2
            : 1;

        return GridView.builder(
          itemCount: cards.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 174,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: Utils.cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: card.color.withValues(alpha: .1),
                        child: Icon(card.icon, color: card.color),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: card.color.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          card.meta,
                          style: TextStyle(
                            color: card.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    card.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FleetMenuItem {

  final String title;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;

  const _FleetMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selectedIcon,
  });
}

class _FleetCardData {

  final String title;
  final String subtitle;
  final String meta;
  final IconData icon;
  final Color color;

  const _FleetCardData({
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.icon,
    required this.color,
  });
}

class _ToolData {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _ToolData(
      this.label,
      this.icon,
      this.onTap,
      );
}