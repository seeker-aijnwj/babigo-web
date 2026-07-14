// ============================================================================
// FILE : auth/widgets/session_expired_dialog.dart
// ============================================================================

import 'package:flutter/material.dart';

class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.lock_clock,
            color: Colors.orange,
          ),
          SizedBox(width: 12),
          Text(
            "Session expirée",
          ),
        ],
      ),
      content: const Text(
        "Votre session a expiré. Veuillez vous reconnecter afin de continuer à utiliser BabiGO.",
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(
            "Se reconnecter",
          ),
        ),
      ],
    );
  }
}