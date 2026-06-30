// ============================================================================
// FILE : widgets/verification/verification_status_widget.dart
// ============================================================================
///
/// Widget universel d'affichage du statut de vérification.
///
/// Compatible :
/// - KYC
/// - Conducteur
/// - Flotte
/// - Véhicule
/// - Documents
///
/// Exemple dans ProfileScreen
///
/// VerificationStatusWidget(
///   status: KycStatus.approved,
/// )
///
/// Exemple dans DriverDashboard
///
/// VerificationStatusWidget(
///   title: "Vérification conducteur",
///   status: kycStatus,
///   onTap: () {
///     Navigator.push(
///       context,
///       MaterialPageRoute(
///         builder: (_) =>
///             const DriverVerificationScreen(),
///       ),
///     );
///   },
/// )
///
///
/// ============================================================================

import 'package:flutter/material.dart';
import '../../../database/services/kyc_service.dart';

class VerificationStatusWidget extends StatelessWidget {

  final KycStatus status;

  final String? title;

  final bool compact;

  final VoidCallback? onTap;

  const VerificationStatusWidget({
    super.key,
    required this.status,
    this.title,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final config =
    _VerificationStatusConfig.fromStatus(
      status,
    );

    if (compact) {
      return _CompactStatus(
        config: config,
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: config.color.withValues(alpha: .25),
          ),
        ),
        child: Row(
          children: [

            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: config.color.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                color: config.color,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    title ?? "Statut de vérification",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    config.label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                      color: config.color,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    config.description,
                    style: TextStyle(
                      color:
                      Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade500,
              ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// VERSION COMPACTE
/// ============================================================================

class _CompactStatus extends StatelessWidget {

  final _VerificationStatusConfig config;

  const _CompactStatus({
    required this.config,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius:
        BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            config.icon,
            color: config.color,
            size: 16,
          ),

          const SizedBox(width: 6),

          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// CONFIGURATION DU STATUT
/// ============================================================================

class _VerificationStatusConfig {

  final String label;

  final String description;

  final IconData icon;

  final Color color;

  final Color backgroundColor;

  const _VerificationStatusConfig({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  factory _VerificationStatusConfig.fromStatus(
      KycStatus status,
      ) {

    switch (status) {

      case KycStatus.notStarted:
        return const _VerificationStatusConfig(
          label: "Non démarré",
          description:
          "Aucune procédure de vérification n'a été lancée.",
          icon: Icons.hourglass_empty,
          color: Colors.grey,
          backgroundColor:
          Color(0xFFF3F4F6),
        );

      case KycStatus.pending:
        return const _VerificationStatusConfig(
          label: "En attente",
          description:
          "Votre dossier a été envoyé et attend une validation.",
          icon: Icons.schedule,
          color: Colors.orange,
          backgroundColor:
          Color(0xFFFFF3E0),
        );

      case KycStatus.underReview:
        return const _VerificationStatusConfig(
          label: "Analyse en cours",
          description:
          "Nos équipes examinent actuellement vos documents.",
          icon: Icons.fact_check,
          color: Colors.blue,
          backgroundColor:
          Color(0xFFE3F2FD),
        );

      case KycStatus.approved:
        return const _VerificationStatusConfig(
          label: "Vérifié",
          description:
          "Votre compte est entièrement vérifié.",
          icon: Icons.verified,
          color: Colors.green,
          backgroundColor:
          Color(0xFFE8F5E9),
        );

      case KycStatus.rejected:
        return const _VerificationStatusConfig(
          label: "Refusé",
          description:
          "Votre dossier nécessite une nouvelle soumission.",
          icon: Icons.cancel,
          color: Colors.red,
          backgroundColor:
          Color(0xFFFFEBEE),
        );

      case KycStatus.expired:
        return const _VerificationStatusConfig(
          label: "Expiré",
          description:
          "Vos documents doivent être renouvelés.",
          icon: Icons.warning,
          color: Colors.deepOrange,
          backgroundColor:
          Color(0xFFFFF4E5),
        );
    }
  }
}