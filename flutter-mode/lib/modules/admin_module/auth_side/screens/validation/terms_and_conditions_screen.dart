// ============================================================================
// FILE : auth/screens/terms_and_conditions_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';

class TermsAndConditionsScreen
    extends StatelessWidget {

  const TermsAndConditionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Conditions générales",
      child: SingleChildScrollView(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: const [

            Text(
              "Conditions Générales d'Utilisation",
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            SizedBox(height: 24),

            Text(
              """
En utilisant BabiGO, vous acceptez les règles de sécurité, de transport, de protection des données et de respect mutuel.

Les conducteurs sont responsables de la validité de leurs documents.

Les passagers s'engagent à respecter les véhicules et les chauffeurs.

BabiGO peut suspendre un compte en cas de fraude ou de comportement abusif.
              """,
            ),
          ],
        ),
      ),
    );
  }
}