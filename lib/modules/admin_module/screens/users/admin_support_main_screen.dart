import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:babigo/app/core/utils/colors.dart';
import '../../../auth_module/screens/signin_screen.dart';
import '../../database/models/admin/utilisateur.dart';
import '../../database/services/auth_service.dart';

class AdminSupportMainScreen extends StatefulWidget {
  final Utilisateur? selectedUser;

  const AdminSupportMainScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminSupportMainScreen> createState() => AdminSupportMainScreenState();
}

class AdminSupportMainScreenState extends State<AdminSupportMainScreen> {
  int _selectedIndex = 0;

  late final List<_SupportMenuItem> _items = const [
    _SupportMenuItem("Accueil", "Vue support", Icons.dashboard_outlined, Icons.dashboard),
    _SupportMenuItem("Tickets", "Demandes ouvertes", Icons.support_agent_outlined, Icons.support_agent),
    _SupportMenuItem("Utilisateurs", "Passagers, conducteurs", Icons.people_alt_outlined, Icons.people_alt),
    _SupportMenuItem("Trajets", "Réservations", Icons.route_outlined, Icons.route),
    _SupportMenuItem("Paiements", "Wallets et litiges", Icons.account_balance_wallet_outlined, Icons.account_balance_wallet),
    _SupportMenuItem("Documents", "Vérifications", Icons.folder_copy_outlined, Icons.folder_copy),
    _SupportMenuItem("Incidents", "Sécurité", Icons.shield_outlined, Icons.shield),
    _SupportMenuItem("Flottes", "Parcs partenaires", Icons.business_outlined, Icons.business),
    _SupportMenuItem("Messages", "Notifications", Icons.notifications_outlined, Icons.notifications),
    _SupportMenuItem("Aide", "Base support", Icons.menu_book_outlined, Icons.menu_book),
    _SupportMenuItem("Rapports", "Synthèse", Icons.analytics_outlined, Icons.analytics),
  ];

  late final List<Widget> _screens = [
    _SupportDashboardScreen(onNavigate: navigateToTab),
    _SupportSectionScreen(
      title: "Tickets support",
      subtitle: "Priorisez, répondez et escaladez les demandes utilisateurs.",
      icon: Icons.support_agent,
      actions: const [
        _SupportAction("Nouveau ticket", Icons.add),
        _SupportAction("Assigner", Icons.assignment_ind),
        _SupportAction("Escalader", Icons.priority_high),
      ],
      cards: const [
        _SupportCardData(
            "Retard conducteur", "Passager en attente depuis 18 minutes.",
            "Urgent", Icons.timer, AppColors.danger
        ),
        _SupportCardData(
            "Remboursement demandé", "Paiement débité, trajet annulé.",
            "À traiter", Icons.payments, AppColors.warning
        ),
        _SupportCardData(
            "Compte bloqué", "Utilisateur ne reçoit pas son OTP.",
            "Ouvert", Icons.lock_open, AppColors.mainColor
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Utilisateurs",
      subtitle: "Consultez les comptes, aidez sans modifier les droits sensibles.",
      icon: Icons.people_alt,
      actions: const [
        _SupportAction("Rechercher", Icons.search),
        _SupportAction("Contacter", Icons.chat),
        _SupportAction("Suspendre temporairement", Icons.pause_circle),
      ],
      cards: const [
        _SupportCardData(
            "Passager", "Historique, réservations, wallet, réclamations.",
            "Lecture + aide", Icons.person, AppColors.mainColor
        ),
        _SupportCardData(
            "Conducteur", "Documents, annonces, notes, incidents.",
            "Contrôle limité", Icons.drive_eta, AppColors.success
        ),
        _SupportCardData(
            "Gestionnaire de flotte", "Véhicules, conducteurs et suivi opérationnel.",
            "Support", Icons.business, AppColors.warning
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Trajets et réservations",
      subtitle: "Aidez les utilisateurs sur les réservations, annulations et suivis.",
      icon: Icons.route,
      actions: const [
        _SupportAction("Rechercher trajet", Icons.manage_search),
        _SupportAction("Suivre réservation", Icons.location_searching),
        _SupportAction("Annulation assistée", Icons.cancel_schedule_send),
      ],
      cards: const [
        _SupportCardData(
            "Trajets en cours", "Surveillance des trajets actifs.",
            "Live", Icons.play_circle, AppColors.success
        ),
        _SupportCardData(
            "Réservations bloquées", "Paiement ou validation non finalisé.",
            "À vérifier", Icons.sync_problem, AppColors.warning
        ),
        _SupportCardData(
            "Historique utilisateur", "Consultation pour résolution de litige.",
            "Lecture", Icons.history, AppColors.mainColor
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Paiements et portefeuilles",
      subtitle: "Vérifiez les transactions, signalez les anomalies et préparez les remboursements.",
      icon: Icons.account_balance_wallet,
      restrictedNote: "Le support peut initier une demande, mais ne valide pas les retraits ni les remboursements finaux.",
      actions: const [
        _SupportAction("Chercher transaction", Icons.search),
        _SupportAction("Créer litige", Icons.report_problem),
        _SupportAction("Demande remboursement", Icons.request_quote),
      ],
      cards: const [
        _SupportCardData(
            "Transaction échouée", "Paiement mobile money non confirmé.",
            "Litige", Icons.error_outline, AppColors.danger
        ),
        _SupportCardData(
            "Solde gelé", "Montant réservé pour trajet en cours.",
            "Info", Icons.ac_unit, AppColors.mainColor
        ),
        _SupportCardData(
            "Remboursements", "Demandes envoyées à validation admin.",
            "Restreint", Icons.verified_user, AppColors.warning
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Documents",
      subtitle: "Assistez la vérification des pièces et signalez les documents problématiques.",
      icon: Icons.folder_copy,
      restrictedNote: "Le support ne peut pas valider définitivement un document critique.",
      actions: const [
        _SupportAction("Voir documents", Icons.visibility),
        _SupportAction("Demander correction", Icons.edit_note),
        _SupportAction("Marquer suspect", Icons.flag),
      ],
      cards: const [
        _SupportCardData(
            "Permis conducteur", "Contrôle lisibilité et cohérence.",
            "Pré-check", Icons.badge, AppColors.mainColor
        ),
        _SupportCardData(
            "Assurance véhicule", "Suivi expiration et anomalies.",
            "Attention", Icons.health_and_safety, AppColors.warning
        ),
        _SupportCardData(
            "KYC gestionnaire", "Pièces entreprise ou parc.",
            "Support", Icons.business_center, AppColors.success
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Incidents et sécurité",
      subtitle: "Centralisez les signalements et déclenchez les procédures adaptées.",
      icon: Icons.shield,
      actions: const [
        _SupportAction("Créer incident", Icons.add_alert),
        _SupportAction("Contacter utilisateur", Icons.call),
        _SupportAction("Escalader sécurité", Icons.security),
      ],
      cards: const [
        _SupportCardData(
            "Signalement urgent", "Comportement dangereux ou menace.",
            "Priorité haute", Icons.emergency, AppColors.danger
        ),
        _SupportCardData(
            "Objet oublié", "Mise en relation passager/conducteur.",
            "Standard", Icons.work_outline, AppColors.mainColor
        ),
        _SupportCardData(
            "Litige trajet", "Désaccord prix, retard ou annulation.",
            "Médiation", Icons.balance, AppColors.warning
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Flottes et parcs",
      subtitle: "Accompagnez les gestionnaires dans leurs véhicules et conducteurs.",
      icon: Icons.business,
      actions: const [
        _SupportAction("Voir flotte", Icons.directions_car),
        _SupportAction("Affectations", Icons.swap_horiz),
        _SupportAction("Alertes parc", Icons.notifications_active),
      ],
      cards: const [
        _SupportCardData(
            "Véhicules", "Disponibilité, documents, maintenance.",
            "Suivi", Icons.directions_car, AppColors.mainColor
        ),
        _SupportCardData(
            "Conducteurs liés", "Affectations et documents.",
            "Support", Icons.groups, AppColors.success
        ),
        _SupportCardData(
            "Alertes flotte", "Assurance, permis, activité faible.",
            "À traiter", Icons.warning_amber, AppColors.warning
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Messages et notifications",
      subtitle: "Envoyez des messages utiles sans accéder aux campagnes globales super admin.",
      icon: Icons.notifications,
      restrictedNote: "Le support peut envoyer des messages ciblés, pas des campagnes système globales.",
      actions: const [
        _SupportAction("Message ciblé", Icons.send),
        _SupportAction("Modèle réponse", Icons.quickreply),
        _SupportAction("Historique", Icons.history),
      ],
      cards: const [
        _SupportCardData(
            "Réponse rapide", "Templates pour tickets fréquents.",
            "Prêt", Icons.bolt, AppColors.success
        ),
        _SupportCardData(
            "Notification trajet", "Message lié à une réservation.",
            "Ciblé", Icons.route, AppColors.mainColor
        ),
        _SupportCardData(
            "Relance document", "Demande de correction utilisateur.",
            "Action", Icons.edit_document, AppColors.warning
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Base d'aide",
      subtitle: "Guides, procédures et réponses prêtes pour gagner du temps.",
      icon: Icons.menu_book,
      actions: const [
        _SupportAction("Chercher article", Icons.search),
        _SupportAction("Copier réponse", Icons.content_copy),
        _SupportAction("Suggérer article", Icons.lightbulb),
      ],
      cards: const [
        _SupportCardData(
            "Remboursement", "Procédure de traitement d'un litige paiement.",
            "Guide", Icons.receipt_long, AppColors.mainColor
        ),
        _SupportCardData(
            "Compte bloqué", "Étapes OTP, email, téléphone et sécurité.",
            "Guide", Icons.lock, AppColors.warning
        ),
        _SupportCardData(
            "Incident sécurité", "Arbre de décision et escalade.",
            "Critique", Icons.shield, AppColors.danger
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Rapports support",
      subtitle: "Suivez la charge, les délais et les sujets les plus fréquents.",
      icon: Icons.analytics,
      restrictedNote: "Ces rapports sont opérationnels. Les exports complets restent réservés au super admin.",
      actions: const [
        _SupportAction("Filtrer", Icons.tune),
        _SupportAction("Exporter résumé", Icons.download),
      ],
      cards: const [
        _SupportCardData(
            "Tickets ouverts", "42 demandes en attente.",
            "Aujourd'hui", Icons.inbox, AppColors.mainColor
        ),
        _SupportCardData(
            "Délai moyen", "18 min avant première réponse.",
            "SLA", Icons.timer, AppColors.success
        ),
        _SupportCardData(
            "Escalades", "7 dossiers transmis aux admins.",
            "Restreint", Icons.priority_high, AppColors.warning
        ),
      ],
    ),
    _SupportSectionScreen(
      title: "Rapports support",
      subtitle: "Suivez la charge, les délais et les sujets les plus fréquents.",
      icon: Icons.analytics,
      restrictedNote: "Ces rapports sont opérationnels. Les exports complets restent réservés au super admin.",
      actions: [
        _SupportAction("Mes informations", Icons.account_circle),
        _SupportAction(
            "Déconnexion", Icons.logout,
                () async {

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
            }),
      ],
      cards: const [],
    ),
  ];

  String get _supportName {
    final selected = widget.selectedUser;
    if (selected != null && selected.fullName.trim().isNotEmpty) return selected.fullName;

    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName?.trim().isNotEmpty == true ? user!.displayName! : "Agent support";
  }

  String get _supportEmail {
    final selected = widget.selectedUser;
    if (selected != null && selected.email.trim().isNotEmpty) return selected.email;

    return FirebaseAuth.instance.currentUser?.email ?? "support@babigo.app";
  }

  void navigateToTab(int index) {
    if (index < 0 || index >= _screens.length) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1000;
    final isTablet = width >= 650 && width < 1000;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: !isDesktop && !isTablet ? Drawer(child: _buildMenu(drawer: true)) : null,
      appBar: !isDesktop && !isTablet
          ? AppBar(
        title: const Text("Support Babigo", style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightMainColor,
        elevation: 0,
      )
          : null,
      body: Row(
        children: [
          if (isDesktop) _buildSideMenu(),
          if (isTablet) _buildNavigationRail(),
          Expanded(child: IndexedStack(index: _selectedIndex, children: _screens)),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return SafeArea(
      child: Container(width: 292, color: Colors.white, child: _buildMenu()),
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
          _buildRestrictionBadge(),
        ],
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
              AppColors.secondColor.withValues(alpha: .78)
            ]),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.support_agent, color: AppColors.secondColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_supportName, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(_supportEmail, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required _SupportMenuItem item,
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
            color: selected ? Colors.white : AppColors.secondColor),
        title: Text(item.title, style: TextStyle(
          color: selected ? Colors.white : AppColors.lightMainColor,
          fontWeight: FontWeight.w800,
        )),
        subtitle: Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: selected ? Colors.white70 : AppColors.muted, fontSize: 12)),
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
        selectedLabelTextStyle: const TextStyle(color: AppColors.secondColor, fontWeight: FontWeight.bold),
        labelType: NavigationRailLabelType.selected,
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: CircleAvatar(backgroundColor: AppColors.secondColor, child: Icon(Icons.support_agent, color: Colors.white)),
        ),
        destinations: _items.map((item) => NavigationRailDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.selectedIcon),
          label: Text(item.title),
        )).toList(),
      ),
    );
  }

  Widget _buildRestrictionBadge() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.lightCardColor),
        ),
        child: const Text(
          "Rôle support : assistance, médiation et escalade. Pas d'accès super admin.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF92400E), fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    );
  }
}

class _SupportDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const _SupportDashboardScreen({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return _SupportPage(
      title: "Centre support",
      subtitle: "Aidez les passagers, conducteurs et gestionnaires sans dépasser vos droits.",
      icon: Icons.support_agent,
      children: [
        const _MetricGrid(metrics: [
          _MetricData(
              "42", "Tickets ouverts", Icons.inbox, AppColors.mainColor),
          _MetricData(
              "7", "Urgences", Icons.priority_high, AppColors.danger),
          _MetricData(
              "18 min", "Réponse moyenne", Icons.timer, AppColors.success),
          _MetricData(
              "11", "Escalades", Icons.admin_panel_settings, AppColors.warning),
        ]),
        const SizedBox(height: 18),
        _QuickActions(actions: [
          _SupportAction("Tickets", Icons.support_agent, () => onNavigate(1)),
          _SupportAction("Utilisateur", Icons.people_alt, () => onNavigate(2)),
          _SupportAction("Trajet", Icons.route, () => onNavigate(3)),
          _SupportAction("Incident", Icons.shield, () => onNavigate(6)),
        ]),
        const SizedBox(height: 18),
        const _RestrictionPanel(),
      ],
    );
  }
}

class _SupportSectionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? restrictedNote;
  final List<_SupportAction> actions;
  final List<_SupportCardData> cards;

  const _SupportSectionScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actions,
    required this.cards,
    this.restrictedNote,
  });

  @override
  Widget build(BuildContext context) {
    return _SupportPage(
      title: title,
      subtitle: subtitle,
      icon: icon,
      children: [
        if (restrictedNote != null) ...[
          _NoticeBox(text: restrictedNote!),
          const SizedBox(height: 14),
        ],
        _QuickActions(actions: actions),
        const SizedBox(height: 18),
        _SupportCardsGrid(cards: cards),
      ],
    );
  }
}

class _SupportPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  const _SupportPage({
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
        gradient: LinearGradient(
            colors: [
              AppColors.secondColor,
              AppColors.secondColor.withValues(alpha: .78)
            ]
        ),
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

class _MetricGrid extends StatelessWidget {
  final List<_MetricData> metrics;

  const _MetricGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 900 ? 4
          : constraints.maxWidth >= 560 ? 2 : 1;

      return GridView.builder(
        itemCount: metrics.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisExtent: 118,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Row(children: [

              CircleAvatar(
                  backgroundColor: metric.color.withValues(alpha: .1),
                  child: Icon(metric.icon, color: metric.color)
              ),
              const SizedBox(width: 12),

              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(metric.value, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.lightMainColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w900
                            )
                        ),
                        const SizedBox(height: 4),

                        Text(metric.label, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF64748B))),
              ])),
            ]),
          );
        },
      );
    });
  }
}

class _QuickActions extends StatelessWidget {
  final List<_SupportAction> actions;

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
          return ElevatedButton.icon(
            onPressed: action.onTap ?? () => _showAction(context, action.label),
            icon: Icon(action.icon),
            label: Text(action.label),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondColor,
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

class _SupportCardsGrid extends StatelessWidget {
  final List<_SupportCardData> cards;

  const _SupportCardsGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
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
              Text(card.title, maxLines: 1, overflow: TextOverflow.ellipsis,
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

class _NoticeBox extends StatelessWidget {
  final String text;

  const _NoticeBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(children: [
        const Icon(Icons.lock_outline, color: Color(0xFF92400E)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF92400E), fontWeight: FontWeight.w700))),
      ]),
    );
  }
}

class _RestrictionPanel extends StatelessWidget {
  const _RestrictionPanel();

  @override
  Widget build(BuildContext context) {
    return const _NoticeBox(
      text: "Restrictions support : pas de suppression définitive, pas de modification des rôles, pas de validation finale des paiements, pas d'accès aux paramètres système.",
    );
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

class _SupportMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;

  const _SupportMenuItem(this.title, this.subtitle, this.icon, this.selectedIcon);
}

class _MetricData {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _MetricData(this.value, this.label, this.icon, this.color);
}

class _SupportCardData {
  final String title;
  final String subtitle;
  final String meta;
  final IconData icon;
  final Color color;

  const _SupportCardData(this.title, this.subtitle, this.meta, this.icon, this.color);
}

class _SupportAction {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _SupportAction(this.label, this.icon, [this.onTap]);
}