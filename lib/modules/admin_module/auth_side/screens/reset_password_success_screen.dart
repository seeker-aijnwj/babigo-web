// ============================================================================
// FILE : auth/screens/reset_password_success_screen.dart
// ============================================================================
//
// ÉCRAN DE CONFIRMATION DE RÉINITIALISATION
//
// Fonctionnalités :
//
// ✓ Confirmation visuelle
// ✓ UX rassurante
// ✓ Compatible Mobile/Web/Desktop
// ✓ Retour vers connexion
// ✓ Compatible BabiGOScaffold
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../app/screens/babigo_scaffold.dart';
import '../../../../app/widgets/babigo_card.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  final String email;

  const ResetPasswordSuccessScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: "Email envoyé",
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: BabiGOCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(
                          alpha: .10,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        color: Colors.green,
                        size: 70,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Email envoyé avec succès",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Nous avons envoyé un lien sécurisé à cette adresse email afin que vous puissiez choisir un nouveau mot de passe.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(
                          alpha: .06,
                        ),
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.info_outline),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Pensez à vérifier vos courriers indésirables.",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.schedule),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Le message peut prendre quelques minutes avant d'arriver.",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        label: const Text(
                          "Retour à la connexion",
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil(
                                (route) => route.isFirst,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}