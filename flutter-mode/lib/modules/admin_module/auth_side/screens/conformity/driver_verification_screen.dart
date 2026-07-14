// ============================================================================
// FILE : verification/screens/driver_verification_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';
import '../../../../../app/widgets/babigo_card.dart';

class DriverVerificationScreen extends StatelessWidget {

  const DriverVerificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: "Vérification chauffeur",
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [

          _item("Permis de conduire"),
          _item("Carte grise"),
          _item("Assurance"),
          _item("Visite technique"),
          _item("Selfie de vérification"),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: () {},
            child: const Text(
              "Soumettre les documents",
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BabiGOCard(
        child: ListTile(
          leading: const Icon(
            Icons.description,
          ),
          title: Text(title),
          trailing: const Icon(
            Icons.upload,
          ),
        ),
      ),
    );
  }
}