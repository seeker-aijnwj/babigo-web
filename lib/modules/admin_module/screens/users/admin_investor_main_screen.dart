import 'package:flutter/material.dart';

import '../../../auth_module/screens/signin_screen.dart';
import '../../database/models/admin/utilisateur.dart';
import '../../../../app/core/utils/colors.dart';
import '../../../../app/core/utils/constants.dart';
import '../../database/services/auth_service.dart';

class AdminInvestorMainScreen extends StatefulWidget {
  final Utilisateur? selectedUser;

  const AdminInvestorMainScreen({
    super.key,
    this.selectedUser,
  });

  @override
  State<AdminInvestorMainScreen> createState() =>
      AdminInvestorMainScreenState();
}

class AdminInvestorMainScreenState extends State<AdminInvestorMainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  final List<_InvestorMenuItem> _items = const [
    _InvestorMenuItem("Accueil", "Vue investisseur", Icons.dashboard_outlined, Icons.dashboard),
    _InvestorMenuItem("Croissance", "Utilisateurs et marché", Icons.trending_up_outlined, Icons.trending_up),
    _InvestorMenuItem("Finances", "Revenus et marges", Icons.payments_outlined, Icons.payments),
    _InvestorMenuItem("Opérations", "Trajets et qualité", Icons.route_outlined, Icons.route),
    _InvestorMenuItem("Impact", "Social et mobilité", Icons.public_outlined, Icons.public),
    _InvestorMenuItem("Expansion", "Villes et opportunités", Icons.map_outlined, Icons.map),
    _InvestorMenuItem("Rapports", "Documents clés", Icons.folder_copy_outlined, Icons.folder_copy),
    _InvestorMenuItem("Promotion", "Réseau et parrainage", Icons.campaign_outlined, Icons.campaign),
    _InvestorMenuItem("Investir", "Prochain tour", Icons.rocket_launch_outlined, Icons.rocket_launch),
  ];

  @override
  void initState() {
    super.initState();
    _screens = _createScreens();
  }

  @override
  void didUpdateWidget(covariant AdminInvestorMainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUser?.id != widget.selectedUser?.id) {
      _screens = _createScreens();
    }
  }

  List<Widget> _createScreens() {
    return [
      _InvestorDashboardScreen(onNavigate: navigateToTab),
      _InvestorSectionScreen(
        title: "Croissance de la plateforme",
        subtitle: "Suivez l'adoption de BabiGO par les passagers, conducteurs et flottes.",
        icon: Icons.trending_up,
        notice: "Les données affichées sont agrégées pour préserver la confidentialité des utilisateurs.",
        actions: const [
          _InvestorAction("Voir par ville", Icons.location_city),
          _InvestorAction("Comparer période", Icons.compare_arrows),
          _InvestorAction("Télécharger résumé", Icons.download),
        ],
        metrics: const [

          _InvestorMetric(
              "18 420", "Utilisateurs inscrits",
              Icons.people_alt, AppColors.mainColor
          ),

          _InvestorMetric(
              "+32%", "Croissance mensuelle",
              Icons.show_chart, AppColors.success
          ),

          _InvestorMetric(
              "1 286", "Conducteurs actifs",
              Icons.drive_eta, AppColors.purple
          ),

          _InvestorMetric(
              "42", "Flottes partenaires",
              Icons.business, AppColors.warning
          ),

        ],
        cards: const [
          _InvestorCardData(
              "Acquisition organique", "Les recommandations et partages génèrent une part importante des inscriptions.",
              "Fort potentiel", Icons.group_add, AppColors.success
          ),
          _InvestorCardData(
              "Rétention passager", "Les trajets récurrents progressent sur les axes domicile-travail.",
              "En hausse", Icons.repeat, AppColors.mainColor
          ),
          _InvestorCardData(
              "Offre conducteur", "La disponibilité augmente dans les zones urbaines prioritaires.",
              "Solide", Icons.local_taxi, AppColors.purple
          ),
        ],
      ),
      _InvestorSectionScreen(
        title: "Performance financière",
        subtitle: "Revenus, transactions, commissions et signaux de rentabilité.",
        icon: Icons.payments,
        actions: const [
          _InvestorAction("Voir revenus", Icons.insights),
          _InvestorAction("Flux wallet", Icons.account_balance_wallet),
          _InvestorAction("Exporter rapport", Icons.download),
        ],
        metrics: const [

          _InvestorMetric(
              "9.8M", "F CFA revenus",
              Icons.payments, AppColors.success
          ),

          _InvestorMetric(
              "1.4M", "F CFA commissions",
              Icons.percent, AppColors.primary
          ),

          _InvestorMetric(
              "38K", "Transactions",
              Icons.receipt_long, AppColors.purple
          ),

          _InvestorMetric(
              "4.2%", "Litiges paiement",
              Icons.report_problem, AppColors.warning
          ),

        ],
        cards: const [
          _InvestorCardData(
              "Revenus récurrents", "Les commissions sur trajets renforcent la traction économique.",
              "Stable", Icons.autorenew, AppColors.success
          ),
          _InvestorCardData(
              "Wallets actifs", "L'usage du portefeuille facilite la rétention et le suivi financier.",
              "Croissant", Icons.wallet, AppColors.primary
          ),
          _InvestorCardData(
              "Risque maîtrisé", "Les litiges sont suivis par le support et les administrateurs.",
              "Contrôlé", Icons.shield, AppColors.warning
          ),
        ],
      ),
      _InvestorSectionScreen(
        title: "Opérations et qualité",
        subtitle: "Trajets réalisés, réservations, disponibilité et expérience utilisateur.",
        icon: Icons.route,
        actions: const [
          _InvestorAction("Trajets actifs", Icons.play_circle),
          _InvestorAction("Qualité service", Icons.star),
          _InvestorAction("Incidents", Icons.shield),
        ],
        metrics: const [
          _InvestorMetric(
              "64 800", "Trajets facilités",
              Icons.route, AppColors.mainColor
          ),

          _InvestorMetric(
              "4.8/5", "Satisfaction",
              Icons.star, AppColors.warning
          ),

          _InvestorMetric(
              "92%", "Réservations honorées",
              Icons.verified, AppColors.success
          ),

          _InvestorMetric(
              "18 min", "Délai moyen support",
              Icons.support_agent, AppColors.purple
          ),

        ],
        cards: const [
          _InvestorCardData(
              "Expérience passager", "Recherche, réservation, suivi et wallet sont centralisés.",
              "Fluide", Icons.person, AppColors.primary
          ),
          _InvestorCardData(
              "Expérience conducteur", "Annonces, documents et historique améliorent la productivité.",
              "Structurée", Icons.drive_eta, AppColors.success
          ),
          _InvestorCardData(
              "Support opérationnel", "Les agents peuvent intervenir sans droits super admin.",
              "Encadré", Icons.support_agent, AppColors.purple
          ),
        ],
      ),
      _InvestorSectionScreen(
        title: "Impact mobilité",
        subtitle: "Mesurez l'utilité sociale, économique et environnementale de BabiGO.",
        icon: Icons.public,
        actions: const [
          _InvestorAction("Voir impact", Icons.eco),
          _InvestorAction("Partager chiffres", Icons.share),
          _InvestorAction("Résumé presse", Icons.article),
        ],
        metrics: const [
          _InvestorMetric(
              "21 600", "Places optimisées",
              Icons.event_seat, AppColors.success
          ),
          _InvestorMetric(
              "12", "Villes couvertes",
              Icons.location_city, AppColors.mainColor
          ),
          _InvestorMetric(
              "31%", "Coût moyen réduit",
              Icons.savings, AppColors.warning
          ),
          _InvestorMetric(
              "8.4T", "CO2 évité estimé",
              Icons.eco, AppColors.success
          ),
        ],
        cards: const [
          _InvestorCardData(
              "Mobilité accessible", "BabiGO réduit le coût des déplacements pour les utilisateurs réguliers.",
              "Impact", Icons.savings, AppColors.success
          ),
          _InvestorCardData(
              "Revenus conducteurs", "La plateforme crée des opportunités de revenus additionnels.",
              "Économie", Icons.payments, AppColors.mainColor
          ),
          _InvestorCardData(
              "Optimisation véhicules", "Le covoiturage réduit les sièges vides et améliore l'efficacité.",
              "Durable", Icons.eco, AppColors.success
          ),
        ],
      ),
      _InvestorSectionScreen(
        title: "Expansion et marché",
        subtitle: "Priorités géographiques, partenariats et prochaines zones à développer.",
        icon: Icons.map,
        actions: const [
          _InvestorAction("Carte expansion", Icons.map),
          _InvestorAction("Villes prioritaires", Icons.flag),
          _InvestorAction("Partenariats", Icons.handshake),
        ],
        metrics: const [
          _InvestorMetric(
              "5", "Villes prioritaires",
              Icons.flag, AppColors.mainColor
          ),
          _InvestorMetric(
              "14", "Partenaires ciblés",
              Icons.handshake, AppColors.success
          ),
          _InvestorMetric(
              "3", "Corridors majeurs",
              Icons.alt_route, AppColors.purple
          ),
          _InvestorMetric(
              "2.5M", "Marché adressable",
              Icons.groups, AppColors.warning
          ),
        ],
        cards: const [
          _InvestorCardData(
              "Grand Abidjan", "Densifier les zones à forte demande domicile-travail.",
              "Priorité 1", Icons.location_city, AppColors.primary
          ),
          _InvestorCardData(
              "Corridors interurbains", "Structurer les trajets entre villes et régions stratégiques.",
              "Priorité 2", Icons.alt_route, AppColors.purple
          ),
          _InvestorCardData(
              "Flottes partenaires", "Accélérer via gestionnaires de parcs et entreprises locales.",
              "Levier", Icons.business, AppColors.success
          ),
        ],
      ),
      _InvestorReportsScreen(),
      _InvestorPromotionScreen(),
      _InvestorRoundScreen(),
    ];
  }

  String get _investorName {
    final selected = widget.selectedUser;
    if (selected != null && selected.fullName.trim().isNotEmpty) {
      return selected.fullName;
    }

    final user = Utils.auth.currentUser;
    return user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : "Investisseur";
  }

  String get _investorEmail {
    final selected = widget.selectedUser;
    if (selected != null && selected.email.trim().isNotEmpty) {
      return selected.email;
    }

    return Utils.auth.currentUser?.email ?? "investor@babigo.com";
  }

  void navigateToTab(int index) {
    if (index < 0 || index >= _screens.length) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1080;
    final isTablet = width >= 700 && width < 1080;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: !isDesktop && !isTablet
          ? Drawer(child: _buildMenu(drawer: true))
          : null,
      appBar: !isDesktop && !isTablet
          ? AppBar(
        title: const Text(
          "Investor BabiGO",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.ink,
        elevation: 0,
      )
          : null,
      body: Row(
        children: [
          if (isDesktop) _buildSideMenu(),
          if (isTablet) _buildCompactRail(),
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
        width: 304,
        color: Colors.white,
        child: _buildMenu(),
      ),
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
              itemBuilder: (context, index) {
                return _buildMenuItem(
                  item: _items[index],
                  selected: _selectedIndex == index,
                  onTap: () {
                    if (drawer) Navigator.of(context).pop();
                    navigateToTab(index);
                  },
                );
              },
            ),
          ),
          _buildInvestorBadge(),
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
          colors: [AppColors.mainColor, Color(0xFF5B8DFF)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.trending_up, color: AppColors.mainColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _investorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _investorEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required _InvestorMenuItem item,
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
          color: selected ? Colors.white : AppColors.mainColor,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? Colors.white70 : AppColors.muted,
            fontSize: 12,
          ),
        ),
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
              backgroundColor:AppColors.mainColor,
              child: Icon(Icons.trending_up, color: Colors.white),
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
                        height: 48,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.mainColor.withValues(alpha: .12)
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

  Widget _buildInvestorBadge() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: const Text(
          "Accès investisseur : données agrégées, indicateurs stratégiques et documents autorisés.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _InvestorDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const _InvestorDashboardScreen({
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return _InvestorPage(
      title: "Tableau de bord investisseur",
      subtitle: "Visualisez la traction, les revenus, l'impact et les opportunités de BabiGO.",
      icon: Icons.dashboard,
      children: [
        const _InvestorHero(),
        const SizedBox(height: 18),
        const _MetricGrid(
          metrics: [
            _InvestorMetric("18 420", "Utilisateurs", Icons.people_alt, Color(0xFF1F6FEB)),
            _InvestorMetric("64 800", "Trajets facilités", Icons.route, Color(0xFF16A34A)),
            _InvestorMetric("9.8M", "F CFA revenus", Icons.payments, Color(0xFF7C3AED)),
            _InvestorMetric("+32%", "Croissance mensuelle", Icons.trending_up, Color(0xFFF59E0B)),
          ],
        ),
        const SizedBox(height: 18),
        _QuickActions(
          actions: [
            _InvestorAction("Croissance", Icons.trending_up, onTap: () => onNavigate(1)),
            _InvestorAction("Finances", Icons.payments, onTap: () => onNavigate(2)),
            _InvestorAction("Rapports", Icons.folder_copy, onTap: () => onNavigate(6)),
            _InvestorAction("Investir plus", Icons.rocket_launch, onTap: () => onNavigate(8)),
            _InvestorAction(
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
                }),

          ],
        ),
        const SizedBox(height: 18),
        const _TrendPanel(),
      ],
    );
  }
}

class _InvestorSectionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? notice;
  final List<_InvestorAction> actions;
  final List<_InvestorMetric> metrics;
  final List<_InvestorCardData> cards;

  const _InvestorSectionScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actions,
    required this.metrics,
    required this.cards,
    this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return _InvestorPage(
      title: title,
      subtitle: subtitle,
      icon: icon,
      children: [
        if (notice != null) ...[
          _NoticeBox(text: notice!),
          const SizedBox(height: 14),
        ],
        _MetricGrid(metrics: metrics),
        const SizedBox(height: 18),
        _QuickActions(actions: actions),
        const SizedBox(height: 18),
        _InvestorCardsGrid(cards: cards),
      ],
    );
  }
}

class _InvestorReportsScreen extends StatelessWidget {
  const _InvestorReportsScreen();

  @override
  Widget build(BuildContext context) {
    return const _InvestorSectionScreen(
      title: "Rapports investisseur",
      subtitle: "Documents autorisés pour suivre la performance et partager la vision BabiGO.",
      icon: Icons.folder_copy,
      notice: "Les documents financiers détaillés et données sensibles peuvent nécessiter une validation interne.",
      actions: [
        _InvestorAction("Télécharger deck", Icons.download),
        _InvestorAction("Rapport mensuel", Icons.article),
        _InvestorAction("Demander data room", Icons.lock_open),
      ],
      metrics: [
        _InvestorMetric("12", "Rapports disponibles", Icons.folder, Color(0xFF1F6FEB)),
        _InvestorMetric("4", "Notes marché", Icons.insights, Color(0xFF16A34A)),
        _InvestorMetric("3", "Documents financiers", Icons.receipt_long, Color(0xFF7C3AED)),
        _InvestorMetric("1", "Deck promotion", Icons.slideshow, Color(0xFFF59E0B)),
      ],
      cards: [
        _InvestorCardData("Pitch deck", "Présentation courte pour partenaires, investisseurs et réseaux.", "Partageable", Icons.slideshow, Color(0xFF1F6FEB)),
        _InvestorCardData("Rapport traction", "Utilisateurs, trajets, revenus et croissance par période.", "Mensuel", Icons.analytics, Color(0xFF16A34A)),
        _InvestorCardData("Note expansion", "Zones prioritaires, hypothèses marché et stratégie de déploiement.", "Stratégie", Icons.map, Color(0xFF7C3AED)),
      ],
    );
  }
}

class _InvestorPromotionScreen extends StatelessWidget {
  const _InvestorPromotionScreen();

  @override
  Widget build(BuildContext context) {
    return _InvestorPage(
      title: "Promotion et réseau",
      subtitle: "Aidez BabiGO à grandir en partageant les bons messages aux bons contacts.",
      icon: Icons.campaign,
      children: const [
        _NoticeBox(
          text: "Les investisseurs peuvent promouvoir la plateforme avec des supports approuvés afin de préserver la cohérence de marque.",
        ),
        SizedBox(height: 18),
        _InvestorCardsGrid(
          cards: [
            _InvestorCardData("Partager le pitch", "Envoyer une présentation claire à vos partenaires stratégiques.", "Action", Icons.share, Color(0xFF1F6FEB)),
            _InvestorCardData("Introductions utiles", "Recommander BabiGO à des flottes, entreprises ou institutions.", "Réseau", Icons.handshake, Color(0xFF16A34A)),
            _InvestorCardData("Ambassadeur investisseur", "Suivre vos introductions et leur contribution à la croissance.", "Programme", Icons.workspace_premium, Color(0xFFF59E0B)),
          ],
        ),
      ],
    );
  }
}

class _InvestorRoundScreen extends StatelessWidget {
  const _InvestorRoundScreen();

  @override
  Widget build(BuildContext context) {
    return _InvestorPage(
      title: "Opportunité d'investissement",
      subtitle: "Comprenez les besoins, les objectifs et les leviers du prochain tour.",
      icon: Icons.rocket_launch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1F6FEB), Color(0xFF5B8DFF)],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PROCHAIN OBJECTIF",
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Accélérer l'expansion, renforcer la technologie et densifier les flottes partenaires.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 18),
              _FundingProgress(),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _QuickActions(
          actions: const [
            _InvestorAction("Demander réunion", Icons.video_call),
            _InvestorAction("Manifester intérêt", Icons.handshake),
            _InvestorAction("Partager à mon réseau", Icons.share),
          ],
        ),
        const SizedBox(height: 18),
        const _InvestorCardsGrid(
          cards: [
            _InvestorCardData("Usage des fonds", "Produit, acquisition, support, expansion géographique et conformité.", "Clair", Icons.account_tree, Color(0xFF1F6FEB)),
            _InvestorCardData("Leviers de croissance", "Flottes, corridors urbains, partenariats et wallet intégré.", "Scalable", Icons.trending_up, Color(0xFF16A34A)),
            _InvestorCardData("Avantage investisseur", "Accès au suivi de performance, rapports et opportunités de réseau.", "Engagé", Icons.workspace_premium, Color(0xFF7C3AED)),
          ],
        ),
      ],
    );
  }
}

class _InvestorPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  const _InvestorPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                  _PageHeader(title: title, subtitle: subtitle, icon: icon),
                  const SizedBox(height: 18),
                  ...children,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PageHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestorHero extends StatelessWidget {
  const _InvestorHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xFFEFF6FF),
            child: Icon(Icons.visibility, color: Color(0xFF1F6FEB)),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              "Cet espace donne aux investisseurs une vision claire, rassurante et exploitable des performances de BabiGO.",
              style: TextStyle(
                color: Color(0xFF0F172A),
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final List<_InvestorMetric> metrics;

  const _MetricGrid({
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 560
            ? 2
            : 1;

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
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: metric.color.withValues(alpha: .1),
                    child: Icon(metric.icon, color: metric.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          metric.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
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

class _QuickActions extends StatelessWidget {
  final List<_InvestorAction> actions;

  const _QuickActions({
    required this.actions,
  });

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
              backgroundColor: const Color(0xFF1F6FEB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InvestorCardsGrid extends StatelessWidget {
  final List<_InvestorCardData> cards;

  const _InvestorCardsGrid({
    required this.cards,
  });

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
            mainAxisExtent: 178,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: _cardDecoration(),
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

class _TrendPanel extends StatelessWidget {
  const _TrendPanel();

  @override
  Widget build(BuildContext context) {
    const values = [.35, .48, .52, .64, .76, .84, .92];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Traction récente",
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Signal de croissance combinant utilisateurs, trajets et revenus.",
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                final value = values[index];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 160 * value,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1F6FEB), Color(0xFF5B8DFF)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _FundingProgress extends StatelessWidget {
  const _FundingProgress();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: const LinearProgressIndicator(
            value: .62,
            minHeight: 10,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "62% de l'objectif stratégique déjà engagé ou en discussion.",
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _NoticeBox extends StatelessWidget {
  final String text;

  const _NoticeBox({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1F6FEB)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1F6FEB),
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
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

class _InvestorMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;

  const _InvestorMenuItem(
      this.title,
      this.subtitle,
      this.icon,
      this.selectedIcon,
      );
}

class _InvestorMetric {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _InvestorMetric(
      this.value,
      this.label,
      this.icon,
      this.color,
      );
}

class _InvestorCardData {
  final String title;
  final String subtitle;
  final String meta;
  final IconData icon;
  final Color color;

  const _InvestorCardData(
      this.title,
      this.subtitle,
      this.meta,
      this.icon,
      this.color,
      );
}

class _InvestorAction {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _InvestorAction(
      this.label,
      this.icon, {
        this.onTap,
      });
}