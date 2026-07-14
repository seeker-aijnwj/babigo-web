// ============================================================================
// FILE : auth/screens/privacy_policy_screen.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../../../../../app/screens/babigo_scaffold.dart';

class PrivacyPolicyScreen
    extends StatelessWidget {

  const PrivacyPolicyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Politique de confidentialité",
      child: SingleChildScrollView(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: const [

            Text(
              "Protection des données",
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            SizedBox(height: 24),

            Text(
              """
BabiGO collecte uniquement les données nécessaires au fonctionnement de la plateforme.

Les données personnelles ne sont jamais revendues.

Les informations sont stockées de manière sécurisée dans Firebase.

Les utilisateurs peuvent demander la suppression de leurs données à tout moment.
              """,
            ),
          ],
        ),
      ),
    );
  }
}