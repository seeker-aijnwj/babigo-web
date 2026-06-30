// ============================================================================
// FILE : widgets/common/babigo_card.dart
// ============================================================================

import 'package:flutter/material.dart';

/// ============================================================================
/// BabiGO CARD
/// ============================================================================
///
/// Carte moderne utilisée partout dans BabiGO.
///
/// Compatible :
///
/// - Dashboard
/// - Véhicules
/// - Conducteurs
/// - Réservations
/// - Courses
/// - Profil
/// - Statistiques
///
/// ============================================================================

class BabiGOCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets? padding;

  const BabiGOCard({
    super.key,
    this.title,
    required this.child,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      padding ??
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                ?trailing,
              ],
            ),

            const SizedBox(height: 20),
          ],

          child,
        ],
      ),
    );
  }
}