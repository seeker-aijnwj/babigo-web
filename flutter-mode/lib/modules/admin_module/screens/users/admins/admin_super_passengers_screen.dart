import 'package:babigo/modules/admin_module/widgets/passenger_view.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/utils/colors.dart';
import '../../../../../app/core/utils/constants.dart';

class AdminSuperPassengersScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const AdminSuperPassengersScreen({
    super.key,
    required this.onNavigate
  });

  @override
  State<AdminSuperPassengersScreen> createState() => _AdminSuperPassengersScreenState();
}

class _AdminSuperPassengersScreenState extends State<AdminSuperPassengersScreen> {

  @override
  Widget build(BuildContext context) {
    return SuperPage(
      title: "Centre de contrôle BabiGO",
      subtitle: "Supervision complète de la plateforme, des utilisateurs, des paiements et de la sécurité.",
      icon: Icons.dashboard,
      children: [
        const MetricGrid(metrics: [
          MetricData(
              "18 420", "Utilisateurs", Icons.people_alt, AppColors.mainColor),
          MetricData(
              "1 286", "Conducteurs", Icons.drive_eta, AppColors.success),
          MetricData(
              "72", "Incidents ouverts", Icons.shield, AppColors.danger),
          MetricData(
              "9.8M", "F CFA revenus", Icons.payments, AppColors.purple),
        ]),
        const SizedBox(height: 18),
        QuickActions(actions: [
          SuperAction("Utilisateurs", Icons.people_alt, onTap: () => widget.onNavigate(1)),
          SuperAction("Paiements", Icons.account_balance_wallet, onTap: () => widget.onNavigate(11)),
          SuperAction("Incidents", Icons.shield, onTap: () => widget.onNavigate(13)),
          SuperAction("Système", Icons.settings, onTap: () => widget.onNavigate(16), sensitive: true),
        ]),
        const SizedBox(height: 18),
        const NoticeBox(
          icon: Icons.privacy_tip,
          text: "Mode super administrateur : suppression, remboursements, rôles, paramètres système et audits sont accessibles ici.",
          danger: true,
        ),

        const SizedBox(height: 20),

        Expanded(

        child: PassengerListWidget(),

        ),

      ],
    );
  }
}
