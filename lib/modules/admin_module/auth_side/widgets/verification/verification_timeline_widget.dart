// ============================================================================
// FILE : widgets/verification/verification_timeline_widget.dart
// ============================================================================
//
// Timeline moderne de vérification
//
// Compatible :
//
// ✅ KYC
// ✅ Conducteur
// ✅ Flotte
// ✅ Véhicule
// ✅ Documents
//
/// Exemple KYC Passager
// VerificationTimelineWidget(
//   steps: [
//
//     VerificationTimelineStep(
//       title: "Pièce d'identité",
//       description:
//           "Document transmis",
//       step: KycStep.identity,
//       completed: true,
//       current: false,
//       completedAt:
//           DateTime.now(),
//     ),
//
//     VerificationTimelineStep(
//       title: "Selfie de vérification",
//       description:
//           "Photo biométrique",
//       step: KycStep.selfie,
//       completed: true,
//       current: false,
//       completedAt:
//           DateTime.now(),
//     ),
//
//     VerificationTimelineStep(
//       title: "Analyse BabiGO",
//       description:
//           "Nos équipes vérifient vos informations.",
//       step: KycStep.driverLicense,
//       completed: false,
//       current: true,
//     ),
//
//     VerificationTimelineStep(
//       title: "Compte vérifié",
//       description:
//           "Accès complet à BabiGO.",
//       step: KycStep.vehicleDocuments,
//       completed: false,
//       current: false,
//     ),
//   ],
// )
///
/// Exemple Conducteur
// VerificationTimelineWidget(
//   steps: [
//
//     VerificationTimelineStep(
//       title: "Identité",
//       description:
//           "Validée",
//       step: KycStep.identity,
//       completed: true,
//       current: false,
//     ),
//
//     VerificationTimelineStep(
//       title: "Permis de conduire",
//       description:
//           "Validation du permis",
//       step: KycStep.driverLicense,
//       completed: false,
//       current: true,
//     ),
//
//     VerificationTimelineStep(
//       title: "Vérification véhicule",
//       description:
//           "Documents du véhicule",
//       step: KycStep.vehicleDocuments,
//       completed: false,
//       current: false,
//     ),
//
//     VerificationTimelineStep(
//       title: "Conducteur approuvé",
//       description:
//           "Vous pouvez recevoir des courses",
//       step: KycStep.fleetDocuments,
//       completed: false,
//       current: false,
//     ),
//   ],
// )
///
// ============================================================================

import 'package:flutter/material.dart';

import '../../../database/services/kyc_service.dart';

/// ============================================================================
/// MODEL
/// ============================================================================

class VerificationTimelineStep {

  final String title;

  final String description;

  final KycStep step;

  final bool completed;

  final bool current;

  final DateTime? completedAt;

  const VerificationTimelineStep({
    required this.title,
    required this.description,
    required this.step,
    required this.completed,
    required this.current,
    this.completedAt,
  });
}

/// ============================================================================
/// WIDGET
/// ============================================================================

class VerificationTimelineWidget extends StatelessWidget {

  final List<VerificationTimelineStep> steps;

  final EdgeInsetsGeometry? padding;

  const VerificationTimelineWidget({
    super.key,
    required this.steps,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: padding ??
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04,),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          steps.length,
              (index) {
            final step = steps[index];

            final isLast =
                index == steps.length - 1;

            return _TimelineItem(
              step: step,
              isLast: isLast,
            );
          },
        ),
      ),
    );
  }
}

/// ============================================================================
/// ITEM
/// ============================================================================

class _TimelineItem extends StatelessWidget {

  final VerificationTimelineStep step;

  final bool isLast;

  const _TimelineItem({
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {

    final color = _getColor();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          /// Colonne timeline

          SizedBox(
            width: 42,
            child: Column(
              children: [

                AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 300,
                  ),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(),
                    color: Colors.white,
                    size: 16,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      margin:
                      const EdgeInsets.only(
                        top: 4,
                      ),
                      color: step.completed
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.only(
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    step.title,
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    step.description,
                    style: TextStyle(
                      color:
                      Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),

                  if (step.completedAt != null)
                    Padding(
                      padding:
                      const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text(
                        _formatDate(
                          step.completedAt!,
                        ),
                        style: TextStyle(
                          color:
                          Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  if (step.current)
                    Container(
                      margin:
                      const EdgeInsets.only(
                        top: 10,
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0057FF,).withValues(alpha: 0.08,),
                        borderRadius: BorderRadius.circular(30,),
                      ),
                      child: const Text(
                        "Étape en cours",
                        style: TextStyle(
                          color:
                          Color(0xFF0057FF),
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {

    if (step.completed) {
      return Icons.check;
    }

    if (step.current) {
      return Icons.hourglass_top;
    }

    return Icons.lock_outline;
  }

  Color _getColor() {

    if (step.completed) {
      return Colors.green;
    }

    if (step.current) {
      return const Color(
        0xFF0057FF,
      );
    }

    return Colors.grey.shade400;
  }

  String _formatDate(
      DateTime date,
      ) {
    return
      "${date.day}/${date.month}/${date.year}";
  }
}