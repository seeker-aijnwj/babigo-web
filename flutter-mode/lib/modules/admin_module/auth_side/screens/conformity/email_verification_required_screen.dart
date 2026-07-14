// ============================================================================
// FILE : auth/screens/email_verification_required_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';

class EmailVerificationRequiredScreen extends StatelessWidget {

  const EmailVerificationRequiredScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Vérification requise",
      child: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.mark_email_unread,
              size: 100,
            ),

            const SizedBox(height: 24),

            const Text(
              "Veuillez vérifier votre adresse email",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}