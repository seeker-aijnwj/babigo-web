import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/modules/admin_module/database/models/admin/utilisateur.dart';
import 'package:flutter/material.dart';

import '../../../../auth_module/screens/signin_screen.dart';
import '../../../database/services/auth_service.dart';

class AdminDriverHomeScreen extends StatelessWidget {

  final Utilisateur? selectedUser;
  final VoidCallback? onCreateRide;
  final VoidCallback? onOpenRequests;
  final VoidCallback? onOpenWallet;
  final VoidCallback? onOpenVehicle;
  final VoidCallback? onOpenSupport;

  const AdminDriverHomeScreen({
    super.key,
    this.selectedUser,
    this.onCreateRide,
    this.onOpenRequests,
    this.onOpenWallet,
    this.onOpenVehicle,
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
                        title: "Opportunités conducteur",
                        subtitle: "Des propositions pour augmenter vos revenus",
                      ),
                      const SizedBox(height: 14),
                      _buildOpportunities(width),
                      const SizedBox(height: 28),
                      const _SectionHeader(
                        title: "Trajets à venir",
                        subtitle: "Vos prochaines courses et réservations",
                      ),
                      const SizedBox(height: 14),
                      _buildUpcomingTrips(width),
                      const SizedBox(height: 28),
                      _buildBottomArea(context, width),
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
        _ActionButton(
          label: "Publier un trajet",
          icon: Icons.add_road,
          filled: true,
          onTap: () => _handleAction(context, onCreateRide, "Publication de trajet"),
        ),
        const SizedBox(height: 10),
        _ActionButton(
          label: "Voir les demandes",
          icon: Icons.inbox,
          onTap: () => _handleAction(context, onOpenRequests, "Demandes passagers"),
        ),
        const SizedBox(height: 10),
        _ActionButton(
          label: "Déconnexion",
          icon: Icons.logout,
          onTap: () => _handleAction(
              context, () async {

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
          }, "Demandes passagers"),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF1F6FEB)],
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
      _StatData("3", "Trajets aujourd'hui", Icons.route, AppColors.mainColor),
      _StatData("18 500", "F CFA revenus", Icons.payments, AppColors.success),
      _StatData("94%", "Taux accepté", Icons.verified, AppColors.warning),
      _StatData("4.9", "Note passagers", Icons.star, Color(0xFF7C3AED)),
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

  Widget _buildUpcomingTrips(double width) {
    final columns = width >= 900 ? 2 : 1;

    const trips = [
      _DriverTripData("Cocody", "Plateau", "Aujourd'hui, 17:30", "3 places", "Confirmé"),
      _DriverTripData("Almadies", "Aéroport", "Demain, 07:15", "2 places", "En attente"),
      _DriverTripData("Centre-ville", "Yopougon", "Vendredi, 18:00", "1 place", "Confirmé"),
    ];

    return GridView.builder(
      itemCount: trips.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: 124,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, index) => _DriverTripCard(data: trips[index]),
    );
  }

  Widget _buildOpportunities(double width) {
    final columns = width >= 1000 ? 3 : width >= 650 ? 2 : 1;

    const offers = [
      _OpportunityData(
        "Boost visibilité",
        "Publiez avant 18h et apparaissez en priorité aux passagers proches.",
        Icons.trending_up,
        Color(0xFF1F6FEB),
      ),
      _OpportunityData(
        "Prime heures creuses",
        "Gagnez un bonus sur les trajets entre 10h et 15h.",
        Icons.bolt,
        Color(0xFFF59E0B),
      ),
      _OpportunityData(
        "Objectif semaine",
        "Encore 5 trajets pour débloquer une prime conducteur.",
        Icons.emoji_events,
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
      itemBuilder: (_, index) => _OpportunityCard(data: offers[index]),
    );
  }

  Widget _buildBottomArea(BuildContext context, double width) {
    final vehicle = _VehicleStatusCard(
      onTap: () => _handleAction(context, onOpenVehicle, "Dossier véhicule"),
    );

    final tools = _DriverToolsCard(
      onCreateRide: () => _handleAction(context, onCreateRide, "Publication de trajet"),
      onRequests: () => _handleAction(context, onOpenRequests, "Demandes passagers"),
      onWallet: () => _handleAction(context, onOpenWallet, "Portefeuille"),
      onVehicle: () => _handleAction(context, onOpenVehicle, "Véhicule"),
      onSupport: () => _handleAction(context, onOpenSupport, "Support"),
    );

    if (width >= 900) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: vehicle),
          const SizedBox(width: 14),
          Expanded(child: tools),
        ],
      );
    }

    return Column(
      children: [
        vehicle,
        const SizedBox(height: 14),
        tools,
      ],
    );
  }

  void _handleAction(BuildContext context, VoidCallback? callback, String label) {
    if (callback != null) {
      callback();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label : action à connecter"),
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
          "Espace conducteur",
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        SizedBox(height: 8),
        Text(
          "Pilotez vos trajets et vos revenus",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Suivez vos réservations, publiez vos trajets et gérez votre activité simplement.",
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return filled
        ? ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.mainColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    )
        : OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
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

class _DriverTripCard extends StatelessWidget {
  final _DriverTripData data;

  const _DriverTripCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = data.status == "Confirmé";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isConfirmed ? const Color(0xFFEAF7EF) : const Color(0xFFFFF7E6),
            child: Icon(
              isConfirmed ? Icons.check_circle : Icons.schedule,
              color: isConfirmed ? AppColors.success : AppColors.warning,
            ),
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
                Text(data.seats, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data.status,
            style: TextStyle(
              color: isConfirmed ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final _OpportunityData data;

  const _OpportunityCard({required this.data});

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

class _VehicleStatusCard extends StatelessWidget {
  final VoidCallback onTap;

  const _VehicleStatusCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: "Véhicule",
            subtitle: "Documents et disponibilité conducteur",
          ),
          const SizedBox(height: 18),
          _StatusLine(label: "Assurance", value: "Valide", color: AppColors.success),
          const SizedBox(height: 10),
          _StatusLine(label: "Contrôle technique", value: "À vérifier", color: AppColors.warning),
          const SizedBox(height: 10),
          _StatusLine(label: "Disponibilité", value: "Actif", color: AppColors.success),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.directions_car),
            label: const Text("Gérer mon véhicule"),
          ),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusLine({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.muted))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _DriverToolsCard extends StatelessWidget {
  final VoidCallback onCreateRide;
  final VoidCallback onRequests;
  final VoidCallback onWallet;
  final VoidCallback onVehicle;
  final VoidCallback onSupport;

  const _DriverToolsCard({
    required this.onCreateRide,
    required this.onRequests,
    required this.onWallet,
    required this.onVehicle,
    required this.onSupport,
  });

  @override
  Widget build(BuildContext context) {
    final tools = [
      _ToolData("Publier", Icons.add_road, onCreateRide),
      _ToolData("Demandes", Icons.inbox, onRequests),
      _ToolData("Wallet", Icons.account_balance_wallet, onWallet),
      _ToolData("Véhicule", Icons.directions_car, onVehicle),
      _ToolData("Planning", Icons.calendar_month, () {}),
      _ToolData("Support", Icons.support_agent, onSupport),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: "Outils conducteur",
            subtitle: "Accès rapide à votre activité",
          ),
          const SizedBox(height: 14),
          GridView.builder(
            itemCount: tools.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 92,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, index) => InkWell(
              onTap: tools[index].onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(10),
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

class _DriverTripData {
  final String departure;
  final String arrival;
  final String date;
  final String seats;
  final String status;

  const _DriverTripData(this.departure, this.arrival, this.date, this.seats, this.status);
}

class _OpportunityData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _OpportunityData(this.title, this.description, this.icon, this.color);
}

class _ToolData {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolData(this.label, this.icon, this.onTap);
}