// ============================================================================
// FILE : auth/screens/unauthorized_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../app/screens/babigo_scaffold.dart';


class UnauthorizedScreen extends StatelessWidget {

  final String reason;

  const UnauthorizedScreen({
    super.key,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {

    return BabiGOScaffold(
      title: "Accès refusé",
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.lock_outline,
                size: 90,
                color: Colors.red,
              ),

              const SizedBox(height: 24),

              const Text("Accès refusé",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                reason,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: () {

                  Navigator.pop(
                    context,
                  );
                },
                icon: const Icon(Icons.arrow_back,),
                label: const Text("Retour",),
              ),
            ],
          ),
        ),
      ),
    );
  }
}