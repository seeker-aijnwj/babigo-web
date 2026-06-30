import 'package:flutter/material.dart';

import '../../../app/database/models/vehicle.dart';


class VehicleVerificationBadges extends StatelessWidget {
  const VehicleVerificationBadges({
    super.key,
    required this.vehicle,
  });

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildInsuranceBadge(),
        _buildPlateBadge(),
        _buildTechnicalInspectionBadge(),
      ],
    );
  }

  Widget _buildInsuranceBadge() {
    final valid =
        vehicle.insuranceVerified &&
            !vehicle.insuranceExpired;

    return _VerificationChip(
      label: valid
          ? 'Assurance'
          : 'Assurance expirée',
      icon: valid
          ? Icons.verified
          : Icons.warning_amber_rounded,
      color: valid
          ? Colors.green
          : Colors.red,
    );
  }

  Widget _buildPlateBadge() {
    return _VerificationChip(
      label: vehicle.plateVerified
          ? 'Carte grise'
          : 'Carte grise non validée',
      icon: vehicle.plateVerified
          ? Icons.badge
          : Icons.warning_amber_rounded,
      color: vehicle.plateVerified
          ? Colors.green
          : Colors.orange,
    );
  }

  Widget _buildTechnicalInspectionBadge() {
    final valid =
        vehicle.technicalInspectionVerified &&
            !vehicle.technicalInspectionExpired;

    return _VerificationChip(
      label: valid
          ? 'Visite technique'
          : 'Visite expirée',
      icon: valid
          ? Icons.fact_check
          : Icons.warning_amber_rounded,
      color: valid
          ? Colors.green
          : Colors.red,
    );
  }
}

class _VerificationChip extends StatelessWidget {
  const _VerificationChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: .25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}