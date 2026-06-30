import 'package:flutter/material.dart';

import '../../../../../app/core/utils/colors.dart';
import '../../../../../app/core/utils/constants.dart';
import 'admin_fleet_page.dart';

class AdminFleetWalletScreen extends StatelessWidget {

  const AdminFleetWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return AdminFleetPage(
      title: "Portefeuille flotte",
      subtitle: "Suivez les revenus, retraits et transactions du parc.",
      icon: Icons.account_balance_wallet,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.mainColor, Color(0xFF5B8DFF)],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SOLDE DISPONIBLE",
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "458 000 F CFA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _WalletAction(
                    label: "Retirer",
                    icon: Icons.arrow_upward,
                    filled: true,
                    onTap: () => Utils.showAction(context, "Retrait"),
                  ),
                  _WalletAction(
                    label: "Historique",
                    icon: Icons.history,
                    onTap: () => Utils.showAction(context, "Historique"),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _FleetCardsGrid(
          cards: const [
            _FleetCardData(
              title: "Paiement trajet",
              subtitle: "Course #BG-245 · Koffi Marc",
              meta: "+ 12 000 F CFA",
              icon: Icons.arrow_downward,
              color: Color(0xFF16A34A),
            ),
            _FleetCardData(
              title: "Retrait gestionnaire",
              subtitle: "Transfert mobile money",
              meta: "- 80 000 F CFA",
              icon: Icons.arrow_upward,
              color: Color(0xFFEF4444),
            ),
            _FleetCardData(
              title: "Commission plateforme",
              subtitle: "Frais de service hebdomadaire",
              meta: "- 9 500 F CFA",
              icon: Icons.receipt_long,
              color: Color(0xFFF59E0B),
            ),
          ],
        ),
      ],
    );
  }
}

class _WalletAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _WalletAction({
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    )
        : OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
