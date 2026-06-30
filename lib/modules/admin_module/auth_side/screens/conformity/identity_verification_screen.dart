// ============================================================================
// FILE : verification/screens/identity_verification_screen.dart
// ============================================================================
/// Documents acceptés :
///
/// CNI
/// Passeport
/// Permis de conduire
///


import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';
import '../../../../../app/widgets/babigo_card.dart';


class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({
    super.key,
  });

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {

  File? _front;

  File? _back;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: "Vérification d'identité",
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [

          const Text(
            "Téléchargez une pièce d'identité valide.",
          ),

          const SizedBox(height: 24),

          _buildDocumentPicker(
            "Recto",
            _front,
          ),

          const SizedBox(height: 16),

          _buildDocumentPicker(
            "Verso",
            _back,
          ),

          const SizedBox(height: 32),

          FilledButton(
            onPressed:
            _loading ? null : _submit,
            child: _loading
                ? const CircularProgressIndicator()
                : const Text(
              "Envoyer",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPicker(
      String label,
      File? file,
      ) {
    return BabiGOCard(
      child: ListTile(
        leading: const Icon(Icons.badge),
        title: Text(label),
        subtitle: Text(
          file == null
              ? "Aucun document"
              : file.path,
        ),
      ),
    );
  }

  Future<void> _submit() async {}
}