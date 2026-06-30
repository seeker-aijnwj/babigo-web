import 'package:flutter/material.dart';

import '../../../../../app/core/utils/colors.dart';
import '../../../../../app/core/utils/constants.dart';
import '../../../../auth_module/screens/signin_screen.dart';
import '../../../database/services/auth_service.dart';
import 'admin_fleet_page.dart';

class AdminFleetDashboardScreen extends StatelessWidget {

  final String managerName;
  final ValueChanged<int> onNavigate;

  const AdminFleetDashboardScreen({
    super.key,
    required this.managerName,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return AdminFleetPage(
      title: "Tableau de bord flotte",
      subtitle: "Bienvenue $managerName. Suivez vos véhicules, conducteurs et revenus.",
      icon: Icons.dashboard,
      children: [

        _MetricGrid(
          metrics: const [
            _MetricData("12", "Véhicules", Icons.directions_car, AppColors.mainColor),
            _MetricData("9", "Conducteurs", Icons.groups, Color(0xFF16A34A)),
            _MetricData("3", "Alertes", Icons.warning_amber, Color(0xFFF59E0B)),
            _MetricData("458 000", "F CFA", Icons.payments, Color(0xFF7C3AED)),
          ],
        ),

        const SizedBox(height: 18),
        _QuickActions(
          actions: [
            _ToolData("Ajouter véhicule", Icons.add_road, () => onNavigate(3)),
            _ToolData("Inviter conducteur", Icons.person_add, () => onNavigate(4)),
            _ToolData("Voir portefeuille", Icons.account_balance_wallet, () => onNavigate(5)),
            _ToolData("Contrôler alertes", Icons.notifications_active, () => onNavigate(6)),
            _ToolData(
                "Déconnexion",
                Icons.notifications_active,
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
        ),
        const SizedBox(height: 18),
        const _ProgressPanel(),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {

  final List<_MetricData> metrics;

  const _MetricGrid({required this.metrics});

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
              decoration: Utils.cardDecoration(),
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

class _MetricData {

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _MetricData(
      this.value,
      this.label,
      this.icon,
      this.color,
      );
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: Utils.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Objectif opérationnel",
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Votre parc a atteint 68% de l'objectif de trajets de la semaine.",
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: .68,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(AppColors.secondColor),
            ),
          ),
        ],
      ),
    );
  }
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
