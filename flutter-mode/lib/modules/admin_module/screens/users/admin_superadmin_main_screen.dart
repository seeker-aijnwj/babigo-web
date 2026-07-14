import 'package:babigo/modules/admin_module/widgets/finance_view.dart';
import 'package:babigo/modules/admin_module/widgets/fleet_manager_view.dart';
import 'package:babigo/modules/admin_module/widgets/support_view.dart';
import 'package:babigo/modules/admin_module/widgets/trip_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:babigo/modules/admin_module/database/models/admin/utilisateur.dart';

import '../../../../app/core/utils/colors.dart';
import '../../../auth_module/screens/signin_screen.dart';
import '../../database/services/auth_service.dart';
import '../../widgets/announce_view.dart';
import '../../widgets/driver_view.dart';
import '../../widgets/passenger_view.dart';
import '../../widgets/user_view.dart';
import '../../widgets/vehicle_view.dart';
import 'admins/admin_super_dashboard_screen.dart';

class AdminSuperAdminMainScreen extends StatefulWidget {
  final Utilisateur? selectedUser;

  const AdminSuperAdminMainScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminSuperAdminMainScreen> createState() =>
      AdminSuperAdminMainScreenState();
}

class AdminSuperAdminMainScreenState extends State<AdminSuperAdminMainScreen> {

  int _selectedIndex = 0;

  late List<Widget> _screens;

  final List<_SuperMenuItem> _items = const [
    _SuperMenuItem(
        "Accueil", "Vue globale", Icons.dashboard_outlined, Icons.dashboard),
    _SuperMenuItem(
        "Utilisateurs", "Tous les comptes", Icons.people_alt_outlined, Icons.people_alt),
    _SuperMenuItem(
        "Passagers", "Suivi passagers", Icons.person_outline, Icons.person),
    _SuperMenuItem(
        "Conducteurs", "Activité conducteur", Icons.drive_eta_outlined, Icons.drive_eta),
    _SuperMenuItem(
        "Flottes", "Gestionnaires/parcs", Icons.business_outlined, Icons.business),
    _SuperMenuItem(
        "Support", "Agents et tickets", Icons.support_agent_outlined, Icons.support_agent),
    _SuperMenuItem(
        "Annonces", "Modération", Icons.campaign_outlined, Icons.campaign),
    _SuperMenuItem(
        "Trajets", "Réservations", Icons.route_outlined, Icons.route),
    _SuperMenuItem(
        "Véhicules", "Registre flotte", Icons.directions_car_outlined, Icons.directions_car),
    _SuperMenuItem(
        "Documents", "KYC et validations", Icons.folder_copy_outlined, Icons.folder_copy),
    _SuperMenuItem(
        "Paiements", "Wallets, retraits", Icons.account_balance_wallet_outlined, Icons.account_balance_wallet),
    _SuperMenuItem(
        "Tarifs", "Prix, commissions", Icons.price_change_outlined, Icons.price_change),
    _SuperMenuItem(
        "Incidents", "Sécurité", Icons.shield_outlined, Icons.shield),
    _SuperMenuItem(
        "Messages", "Notifications", Icons.notifications_outlined, Icons.notifications),
    _SuperMenuItem(
        "Analytics", "Rapports", Icons.analytics_outlined, Icons.analytics),
    _SuperMenuItem(
        "Système", "Paramètres", Icons.settings_outlined, Icons.settings),
    _SuperMenuItem(
        "Audit", "Journal admin", Icons.manage_history_outlined, Icons.manage_history),
  ];

  @override
  void initState() {
    super.initState();
    _screens = _createScreens();
  }

  List<Widget> _createScreens() {
    return [

      AdminSuperDashboardScreen(onNavigate: navigateToTab),

      UserListWidget(),

      /*

      _section("Rôles et permissions", "Attribuer les rôles, gérer les accès et protéger les privilèges sensibles.", Icons.admin_panel_settings, [
        _SuperAction("Créer rôle", Icons.add_moderator),
        _SuperAction("Matrice d'accès", Icons.grid_view),
        _SuperAction("Révoquer privilège", Icons.lock_reset, sensitive: true),
      ]),

      _section("Passagers", "Consulter réservations, wallets, litiges et activité passager.", Icons.person, [
        _SuperAction("Voir passager", Icons.visibility),
        _SuperAction("Wallet passager", Icons.account_balance_wallet),
        _SuperAction("Résoudre litige", Icons.balance),
      ]),

      _section("Conducteurs", "Valider profils, documents, annonces, performances et restrictions.", Icons.drive_eta, [
        _SuperAction("Valider conducteur", Icons.verified),
        _SuperAction("Voir documents", Icons.folder_copy),
        _SuperAction("Bloquer conducteur", Icons.block, sensitive: true),
      ]),

      _section("Gestionnaires de flotte", "Gérer parcs, véhicules, conducteurs liés, documents et revenus.", Icons.business, [
        _SuperAction("Créer parc", Icons.add_business),
        _SuperAction("Affectations", Icons.swap_horiz),
        _SuperAction("Audit flotte", Icons.fact_check),
      ]),

      _section("Support", "Superviser agents support, tickets, escalades et qualité de réponse.", Icons.support_agent, [
        _SuperAction("Créer agent", Icons.person_add_alt),
        _SuperAction("Assigner tickets", Icons.assignment_ind),
        _SuperAction("Retirer accès", Icons.no_accounts, sensitive: true),
      ]),

      _section("Annonces", "Modérer, publier, masquer ou supprimer les annonces problématiques.", Icons.campaign, [
        _SuperAction("Publier", Icons.publish),
        _SuperAction("Masquer", Icons.visibility_off),
        _SuperAction("Supprimer annonce", Icons.delete, sensitive: true),
      ]),*/

      PassengerListWidget(),

      DriverListWidget(),

      FleetManagerListWidget(),

      SupportListWidget(),

      AnnounceView(),

      TripView(),

      VehicleView(),

      /*

      _section("Trajets et réservations", "Superviser trajets actifs, annulations, réservations bloquées et historique.", Icons.route, [
        _SuperAction("Suivre trajet", Icons.location_searching),
        _SuperAction("Annuler réservation", Icons.cancel, sensitive: true),
        _SuperAction("Forcer résolution", Icons.task_alt, sensitive: true),
      ]),

      _section("Véhicules", "Registre complet des véhicules, assurances, états et maintenances.", Icons.directions_car, [
        _SuperAction("Ajouter véhicule", Icons.add_road),
        _SuperAction("Vérifier assurance", Icons.health_and_safety),
        _SuperAction("Retirer véhicule", Icons.remove_circle, sensitive: true),
      ]),

      _section("Paiements et portefeuilles", "Contrôler transactions, retraits, remboursements, commissions et soldes gelés.", Icons.account_balance_wallet, [
        _SuperAction("Approuver retrait", Icons.check_circle, sensitive: true),
        _SuperAction("Rembourser", Icons.request_quote, sensitive: true),
        _SuperAction("Voir transactions", Icons.receipt_long),
      ]), */

      _section("Documents et KYC", "Valider, refuser, signaler et suivre les pièces sensibles.", Icons.folder_copy, [
        _SuperAction("Valider document", Icons.verified_user),
        _SuperAction("Demander correction", Icons.edit_note),
        _SuperAction("Marquer fraude", Icons.flag, sensitive: true),
      ]),


      FinanceView(),

      _section("Tarifs et commissions", "Configurer prix, promotions, commissions, zones et règles business.", Icons.price_change, [
        _SuperAction("Modifier commission", Icons.percent, sensitive: true),
        _SuperAction("Créer promo", Icons.local_offer),
        _SuperAction("Zones tarifaires", Icons.map),
      ]),

      _section("Incidents et sécurité", "Gérer signalements, urgences, fraudes, bannissements et escalades critiques.", Icons.shield, [
        _SuperAction("Ouvrir incident", Icons.add_alert),
        _SuperAction("Contacter sécurité", Icons.security),
        _SuperAction("Bannir compte", Icons.gpp_bad, sensitive: true),
      ]),

      _section("Messages et campagnes", "Envoyer notifications ciblées ou globales et gérer les modèles système.", Icons.notifications, [
        _SuperAction("Campagne globale", Icons.campaign, sensitive: true),
        _SuperAction("Message ciblé", Icons.send),
        _SuperAction("Modèles", Icons.quickreply),
      ]),

      _section("Analytics et rapports", "Suivre croissance, revenus, activité, incidents et performances opérationnelles.", Icons.analytics, [
        _SuperAction("Exporter rapport", Icons.download),
        _SuperAction("Filtrer période", Icons.tune),
        _SuperAction("KPI revenus", Icons.show_chart),
      ]),

      _section("Paramètres système", "Configurer plateforme, pays, villes, intégrations, feature flags et règles globales.", Icons.settings, [
        _SuperAction("Feature flags", Icons.toggle_on),
        _SuperAction("Intégrations", Icons.api),
        _SuperAction("Maintenance système", Icons.build, sensitive: true),
      ]),

      _section("Journal d'audit", "Consulter toutes les actions sensibles effectuées par les administrateurs.", Icons.manage_history, [
        _SuperAction("Rechercher logs", Icons.search),
        _SuperAction("Exporter audit", Icons.download),
        _SuperAction("Voir actions sensibles", Icons.privacy_tip),
      ]),

      _section("Mon compte", "", Icons.account_circle, [
        _SuperAction("Mes informations", Icons.medical_information),
        _SuperAction(
            "Déconnexion", Icons.logout,
            onTap: () async {

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
            }
        ),
      ]),
    ];
  }

  Widget _section(
      String title,
      String subtitle,
      IconData icon,
      List<_SuperAction> actions,
      ) {
    return _SuperSectionScreen(
      title: title,
      subtitle: subtitle,
      icon: icon,
      actions: actions,
    );
  }

  String get _adminName {
    final selected = widget.selectedUser;
    if (selected != null && selected.fullName.trim().isNotEmpty) {
      return selected.fullName;
    }

    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : "Super administrateur";
  }

  String get _adminEmail {
    final selected = widget.selectedUser;
    if (selected != null && selected.email.trim().isNotEmpty) {
      return selected.email;
    }

    return FirebaseAuth.instance.currentUser?.email ?? "admin@babigo.app";
  }

  void navigateToTab(int index) {
    if (index < 0 || index >= _screens.length) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;
    final isTablet = width >= 700 && width < 1100;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: !isDesktop && !isTablet ? Drawer(child: _buildMenu(drawer: true)) : null,
      appBar: !isDesktop && !isTablet
          ? AppBar(
        title: const Text("Super Admin BabiGO", style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightMainColor,
        elevation: 0,
      )
          : null,
      body: Row(
        children: [
          if (isDesktop) _buildSideMenu(),
          if (isTablet) _buildCompactRail(),
          Expanded(child: IndexedStack(index: _selectedIndex, children: _screens)),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return SafeArea(
      child: Container(width: 310, color: Colors.white, child: _buildMenu()),
    );
  }

  Widget _buildMenu({bool drawer = false}) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 22),
          _buildProfileCard(),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _items.length,
              itemBuilder: (context, index) => _buildMenuItem(
                item: _items[index],
                selected: _selectedIndex == index,
                onTap: () {
                  if (drawer) Navigator.of(context).pop();
                  navigateToTab(index);
                },
              ),
            ),
          ),
          _buildPowerBadge(),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.mainColor, Color(0xFF5B8DFF)]
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.admin_panel_settings, color: AppColors.mainColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_adminName, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(_adminEmail, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required _SuperMenuItem item,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? AppColors.mainColor : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
            selected ? item.selectedIcon : item.icon,
            color: selected ? Colors.white : AppColors.mainColor
        ),
        title: Text(
            item.title,
            style: TextStyle(
                color: selected ? Colors.white : AppColors.lightMainColor,
                fontWeight: FontWeight.w800
            )
        ),
        subtitle: Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: selected ? Colors.white70 : AppColors.muted, fontSize: 12)),
      ),
    );
  }

  Widget _buildCompactRail() {
    return SafeArea(
      child: Container(
        width: 88,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 18),
            const CircleAvatar(
                backgroundColor: AppColors.mainColor,
                child: Icon(Icons.admin_panel_settings, color: Colors.white)
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final selected = _selectedIndex == index;

                  return Tooltip(
                    message: item.title,
                    child: InkWell(
                      onTap: () => navigateToTab(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        height: 48,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.mainColor.withValues(alpha: .12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          selected ? item.selectedIcon : item.icon,
                          color: selected ? AppColors.mainColor : AppColors.muted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerBadge() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: const Text(
          "Accès total : les actions sensibles doivent être confirmées.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF92400E), fontWeight: FontWeight.w800, fontSize: 12),
        ),
      ),
    );
  }
}

class _SuperSectionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_SuperAction> actions;

  const _SuperSectionScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return _SuperPage(
      title: title,
      subtitle: subtitle,
      icon: icon,
      children: [
        _QuickActions(actions: actions),
        const SizedBox(height: 18),
        _SuperCardsGrid(title: title),
      ],
    );
  }
}

class _SuperPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  const _SuperPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth >= 900;

      return SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 28 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _PageHeader(title: title, subtitle: subtitle, icon: icon),
              const SizedBox(height: 18),
              ...children,
            ]),
          ),
        ),
      );
    });
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PageHeader({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1F6FEB), Color(0xFF5B8DFF)]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), borderRadius: BorderRadius.circular(18)),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 26, height: 1.1, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, height: 1.35)),
        ])),
      ]),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final List<_SuperAction> actions;

  const _QuickActions({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: actions.map((action) {
          final color = action.sensitive
              ? AppColors.danger
              : AppColors.mainColor;

          return ElevatedButton.icon(
            onPressed: () {
              if (action.onTap != null) {
                action.onTap!();
              } else if (action.sensitive) {
                _confirmSensitiveAction(context, action.label);
              } else {
                _showAction(context, action.label);
              }
            },
            icon: Icon(action.icon),
            label: Text(action.label),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SuperCardsGrid extends StatelessWidget {
  final String title;

  const _SuperCardsGrid({required this.title});

  @override
  Widget build(BuildContext context) {
    const cards = [
      _SuperCardData(
          "Contrôle complet", "Accès lecture et action sur ce module.", "Super admin", Icons.verified_user, AppColors.mainColor),
      _SuperCardData(
          "Actions sensibles", "Toute opération critique doit être confirmée.", "Protégé", Icons.lock, AppColors.warning),
      _SuperCardData(
          "Journalisation", "Chaque modification est destinée au journal d'audit.", "Audit", Icons.manage_history, AppColors.success),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 900 ? 3 : constraints.maxWidth >= 600 ? 2 : 1;

      return GridView.builder(
        itemCount: cards.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisExtent: 176,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final card = cards[index];

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(backgroundColor: card.color.withValues(alpha: .1), child: Icon(card.icon, color: card.color)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: card.color.withValues(alpha: .1), borderRadius: BorderRadius.circular(99)),
                  child: Text(card.meta, style: TextStyle(color: card.color, fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ]),
              const Spacer(),
              Text("$title · ${card.title}", maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(card.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF64748B), height: 1.35)),
            ]),
          );
        },
      );
    });
  }
}

Future<void> _confirmSensitiveAction(BuildContext context, String label) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Action sensible"),
      content: Text("Confirmer l'action : $label ?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirmer")),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    _showAction(context, label);
  }
}

void _showAction(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("$label : action à connecter"),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
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

class _SuperMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;

  const _SuperMenuItem(this.title, this.subtitle, this.icon, this.selectedIcon);
}

class _SuperCardData {
  final String title;
  final String subtitle;
  final String meta;
  final IconData icon;
  final Color color;

  const _SuperCardData(this.title, this.subtitle, this.meta, this.icon, this.color);
}

class _SuperAction {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool sensitive;

  const _SuperAction(
      this.label,
      this.icon, {
        this.onTap,
        this.sensitive = false,
      });
}