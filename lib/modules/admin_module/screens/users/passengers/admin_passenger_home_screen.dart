import 'package:flutter/material.dart';
import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/modules/booking_module/screens/passenger/passenger_main_screen.dart';

import '../../../database/models/admin/utilisateur.dart';
import '../../../../auth_module/screens/signin_screen.dart';
import '../../../database/services/auth_service.dart';


class AdminPassengerHomeScreen extends StatelessWidget {

  final Utilisateur? selectedUser;
  final VoidCallback? onSearchRide;
  final VoidCallback? onTrackTrip;
  final VoidCallback? onOpenWallet;
  final VoidCallback? onOpenSupport;

  const AdminPassengerHomeScreen({
    super.key,
    this.selectedUser,
    this.onSearchRide,
    this.onTrackTrip,
    this.onOpenWallet,
    this.onOpenSupport,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isWide = width >= 900;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isWide ? 28 : 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _buildHero(context, isWide),
                      const SizedBox(height: 22),
                      _buildStats(width),
                      const SizedBox(height: 28),
                      const _SectionHeader(
                        title: "Offres pour vous",
                        subtitle: "Des avantages pour fidéliser vos trajets",
                      ),
                      const SizedBox(height: 14),
                      _buildOffers(width),
                      const SizedBox(height: 28),
                      const _SectionHeader(
                        title: "Trajets effectués récemment",
                        subtitle: "Vos derniers déplacements avec Babigo",
                      ),
                      const SizedBox(height: 14),
                      _buildRecentTrips(width),
                      const SizedBox(height: 28),
                      _buildBottomTools(context, width),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isWide) {
    final actions = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [

      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F6FEB), Color(0xFF5B8DFF)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: isWide
          ? Row(
        children: [
          const Expanded(child: _HeroCopy()),
          const SizedBox(width: 24),
          SizedBox(width: 280, child: actions),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeroCopy(),
          const SizedBox(height: 22),
          actions,
        ],
      ),
    );
  }

  Widget _buildStats(double width) {
    final columns = width >= 760 ? 4 : 2;

    const stats = [
      _StatData("8", "Trajets", Icons.route, Color(0xFF1F6FEB)),
      _StatData("12 500", "F CFA économisés", Icons.savings, Color(0xFF16A34A)),
      _StatData("4.8", "Note moyenne", Icons.star, Color(0xFFF59E0B)),
      _StatData("72%", "Niveau fidélité", Icons.workspace_premium, Color(0xFF7C3AED)),
    ];

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 112,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, index) => _StatCard(data: stats[index]),
    );
  }

  Widget _buildRecentTrips(double width) {
    final columns = width >= 900 ? 2 : 1;

    const trips = [
      _TripData("Plateau", "Almadies", "Hier, 18:20", "2 500 F CFA", "Terminé"),
      _TripData("Yopougon", "Cocody", "Lun. 08:10", "1 800 F CFA", "Terminé"),
      _TripData("Aéroport", "Centre-ville", "Ven. 21:45", "4 000 F CFA", "Terminé"),
    ];

    return GridView.builder(
      itemCount: trips.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 118,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, index) => _TripCard(data: trips[index]),
    );
  }

  Widget _buildOffers(double width) {
    final columns = width >= 1000 ? 3 : width >= 650 ? 2 : 1;

    const offers = [
      _OfferData(
        "Bonus fidélité",
        "Encore 3 trajets et vous gagnez une remise de 15%.",
        Icons.card_giftcard,
        Color(0xFF1F6FEB),
      ),
      _OfferData(
        "Trajets matinaux",
        "Profitez de prix doux entre 6h et 9h cette semaine.",
        Icons.wb_sunny,
        Color(0xFFF59E0B),
      ),
      _OfferData(
        "Parrainage",
        "Invitez un ami et recevez un bonus sur votre wallet.",
        Icons.group_add,
        Color(0xFF16A34A),
      ),
    ];

    return GridView.builder(
      itemCount: offers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 168,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, index) => _OfferCard(data: offers[index]),
    );
  }

  Widget _buildBottomTools(BuildContext context, double width) {
    final content = [
      _LoyaltyCard(onTap: () => _showSnack(context, "Programme fidélité à connecter")),
      _ToolsCard(
        onWallet: () => _handleAction(
          context,
          callback: onOpenWallet,
          fallbackLabel: "Portefeuille",
        ),
        onSupport: () => _handleAction(
          context,
          callback: onOpenSupport,
          fallbackLabel: "Support",
        ),
      ),
    ];

    if (width >= 900) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: content[0]),
          const SizedBox(width: 14),
          Expanded(child: content[1]),
        ],
      );
    }

    return Column(
      children: [
        content[0],
        const SizedBox(height: 14),
        content[1],
      ],
    );
  }

  void _handleAction(
      BuildContext context, {
        int? tabIndex,
        VoidCallback? callback,
        required String fallbackLabel,
      }) {
    if (callback != null) {
      callback();
      return;
    }

    if (tabIndex != null) {
      final shell = context.findAncestorStateOfType<PassengerMainScreenState>();
      if (shell != null) {
        shell.navigateToTab(tabIndex);
        return;
      }
    }

    _showSnack(context, "$fallbackLabel : action à connecter");
  }

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bonjour 👋",
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        SizedBox(height: 8),
        Text(
          "Prêt pour une résevation ?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Retrouvez vos trajets, vos avantages et vos outils passager au même endroit.",
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.color),
          const Spacer(),
          Text(
            data.value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            data.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final _TripData data;

  const _TripCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFEFF6FF),
            child: Icon(Icons.directions_car, color: AppColors.mainColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.departure} → ${data.arrival}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(data.date, style: const TextStyle(color: AppColors.muted)),
                const Spacer(),
                Text(data.status, style: const TextStyle(color: Color(0xFF16A34A))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data.price,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final _OfferData data;

  const _OfferCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.color, data.color.withValues(alpha: .72)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: Colors.white, size: 30),
          const Spacer(),
          Text(
            data.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  final VoidCallback onTap;

  const _LoyaltyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: "Fidélité",
            subtitle: "Progression vers votre prochain avantage",
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: .72,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(AppColors.mainColor),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "72% atteint. Encore quelques trajets pour débloquer votre remise.",
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.workspace_premium),
            label: const Text("Voir mes avantages"),
          ),
        ],
      ),
    );
  }
}

class _ToolsCard extends StatelessWidget {
  final VoidCallback onWallet;
  final VoidCallback onSupport;

  const _ToolsCard({
    required this.onWallet,
    required this.onSupport,
  });

  @override
  Widget build(BuildContext context) {

    final tools = [
      _ToolData("Portefeuille", Icons.account_balance_wallet, onWallet),
      _ToolData("Favoris", Icons.favorite, () {}),
      _ToolData("Planifier", Icons.event_available, () {}),
      _ToolData("Aide", Icons.support_agent, onSupport),
      _ToolData("Aide", Icons.logout, () async {

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
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: "Outils utiles",
            subtitle: "Accès rapide aux actions importantes",
          ),
          const SizedBox(height: 14),
          GridView.builder(
            itemCount: tools.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 94,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, index) => InkWell(
              onTap: tools[index].onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tools[index].icon, color: AppColors.mainColor),
                    const SizedBox(height: 8),
                    Text(
                      tools[index].label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
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
        color: Colors.black.withValues(alpha: .04),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

class _StatData {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatData(this.value, this.label, this.icon, this.color);
}

class _TripData {
  final String departure;
  final String arrival;
  final String date;
  final String price;
  final String status;

  const _TripData(this.departure, this.arrival, this.date, this.price, this.status);
}

class _OfferData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _OfferData(this.title, this.description, this.icon, this.color);
}

class _ToolData {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolData(this.label, this.icon, this.onTap);
}