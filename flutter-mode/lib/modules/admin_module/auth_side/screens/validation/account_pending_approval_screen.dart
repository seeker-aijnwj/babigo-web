// ============================================================================
// FILE : auth/screens/account_pending_approval_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';

class AccountPendingApprovalScreen
    extends StatelessWidget {

  const AccountPendingApprovalScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Validation en cours",
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.pending_actions,
                size: 120,
                color: Colors.orange,
              ),

              const SizedBox(height: 24),

              const Text(
                "Compte en attente",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Votre compte est actuellement en cours de vérification par l'équipe BabiGO.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.support_agent,
                ),
                label: const Text(
                  "Contacter le support",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}