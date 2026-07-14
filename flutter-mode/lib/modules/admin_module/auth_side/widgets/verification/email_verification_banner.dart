// ============================================================================
// FILE : widgets/email_verification_banner.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../database/services/auth_service.dart';

class EmailVerificationBanner extends StatelessWidget {

  const EmailVerificationBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final user = AuthService().currentUser;

    if (user == null) {
      return const SizedBox();
    }

    if (user.emailVerified) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange,
        ),
      ),
      child: Row(
        children: [

          const Icon(
            Icons.warning_amber,
            color: Colors.orange,
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              "Veuillez vérifier votre adresse email afin d'accéder à toutes les fonctionnalités.",
            ),
          ),

          TextButton(
            onPressed: () async {

              await AuthService().sendVerificationEmail();
            },
            child: const Text(
              "Renvoyer",
            ),
          ),
        ],
      ),
    );
  }
}