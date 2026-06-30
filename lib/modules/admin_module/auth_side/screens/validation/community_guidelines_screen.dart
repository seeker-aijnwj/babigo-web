// ============================================================================
// FILE : auth/screens/community_guidelines_screen.dart
// ============================================================================
///
/// Ce fichier est affiché :
///
/// à l'inscription ;
/// avant la première annonce ;
/// après une suspension ;
/// dans les paramètres.
///

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';
import '../../../../../app/widgets/babigo_card.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: "Règles de la communauté",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            _buildRule(
              Icons.handshake,
              "Respect",
              "Traitez tous les utilisateurs avec respect.",
            ),

            _buildRule(
              Icons.shield,
              "Sécurité",
              "La sécurité des passagers est prioritaire.",
            ),

            _buildRule(
              Icons.verified_user,
              "Authenticité",
              "Utilisez votre véritable identité.",
            ),

            _buildRule(
              Icons.block,
              "Tolérance zéro",
              "Aucune fraude, harcèlement ou discrimination.",
            ),

            _buildRule(
              Icons.payments,
              "Paiements",
              "Toutes les transactions doivent passer par BabiGO.",
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
              label: const Text(
                "J'ai compris",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRule(
      IconData icon,
      String title,
      String description,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BabiGOCard(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(description),
        ),
      ),
    );
  }
}