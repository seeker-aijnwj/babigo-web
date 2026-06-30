// ============================================================================
// FILE : auth/screens/account_suspended_screen.dart
// ============================================================================
//
// ÉCRAN DE COMPTE RESTREINT / SUSPENDU
//
// Utilisé par :
//
// ✓ AuthGuard
// ✓ AuthRouteManager
// ✓ Admin Dashboard
// ✓ Modération
// ✓ Contrôle qualité
// ✓ Vérification documents
//
// États gérés :
//
// pendingReview
// suspended
// banned
// documentsRejected
// documentsExpired
//
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../app/screens/babigo_scaffold.dart';
import '../../../../../app/widgets/babigo_card.dart';

enum AccountRestrictionType {
  pendingReview,
  suspended,
  banned,
  documentsRejected,
  documentsExpired,
}

class AccountSuspendedScreen extends StatelessWidget {
  final AccountRestrictionType type;

  const AccountSuspendedScreen({
    super.key,
    required this.type,
  });

  String get title {
    switch (type) {
      case AccountRestrictionType.pendingReview:
        return "Compte en cours de vérification";

      case AccountRestrictionType.suspended:
        return "Compte suspendu";

      case AccountRestrictionType.banned:
        return "Compte bloqué";

      case AccountRestrictionType.documentsRejected:
        return "Documents refusés";

      case AccountRestrictionType.documentsExpired:
        return "Documents expirés";
    }
  }

  String get description {
    switch (type) {
      case AccountRestrictionType.pendingReview:
        return "Notre équipe vérifie actuellement vos informations. Cette étape permet d'assurer la sécurité et la qualité du service BabiGO.";

      case AccountRestrictionType.suspended:
        return "Votre compte a été temporairement suspendu. Contactez le support pour obtenir davantage d'informations.";

      case AccountRestrictionType.banned:
        return "L'accès à votre compte a été définitivement bloqué conformément aux règles de la plateforme.";

      case AccountRestrictionType.documentsRejected:
        return "Les documents transmis n'ont pas pu être validés. Veuillez envoyer de nouvelles versions lisibles et conformes.";

      case AccountRestrictionType.documentsExpired:
        return "Certains documents sont expirés. Merci de les mettre à jour afin de continuer à utiliser BabiGO.";
    }
  }

  IconData get icon {
    switch (type) {
      case AccountRestrictionType.pendingReview:
        return Icons.pending_actions;

      case AccountRestrictionType.suspended:
        return Icons.pause_circle_outline;

      case AccountRestrictionType.banned:
        return Icons.gpp_bad;

      case AccountRestrictionType.documentsRejected:
        return Icons.description_outlined;

      case AccountRestrictionType.documentsExpired:
        return Icons.warning_amber_rounded;
    }
  }

  Color get color {
    switch (type) {
      case AccountRestrictionType.pendingReview:
        return Colors.orange;

      case AccountRestrictionType.suspended:
        return Colors.deepOrange;

      case AccountRestrictionType.banned:
        return Colors.red;

      case AccountRestrictionType.documentsRejected:
        return Colors.redAccent;

      case AccountRestrictionType.documentsExpired:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: "État du compte",
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: BabiGOCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 70,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.support_agent),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Notre équipe est disponible pour vous accompagner.",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.verified_user),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "La sécurité et la confiance sont au cœur de BabiGO.",
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
                          Icons.support_agent,
                        ),
                        label: const Text(
                          "Contacter le support",
                        ),
                        onPressed: () {
                          // TODO:
                          // ouvrir chat support
                          // email support
                          // ticket support
                        },
                      ),
                    ),

                    if (type ==
                        AccountRestrictionType
                            .documentsRejected ||
                        type ==
                            AccountRestrictionType
                                .documentsExpired)
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.upload_file,
                            ),
                            label: const Text(
                              "Mettre à jour mes documents",
                            ),
                            onPressed: () {
                              // TODO:
                              // Upload documents
                            },
                          ),
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