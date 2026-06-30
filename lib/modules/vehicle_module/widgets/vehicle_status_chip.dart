import 'package:flutter/material.dart';

import '../../../app/database/models/vehicle.dart';

class VehicleStatusChip extends StatelessWidget {

  final VehicleStatus status;

  const VehicleStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = _config(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: config.color.withValues(alpha: .25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 16,
            color: config.color,
          ),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _config(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active:
        return const _StatusConfig(
          label: "Actif",
          color: Colors.green,
          icon: Icons.check_circle,
        );

      case VehicleStatus.inactive:
        return const _StatusConfig(
          label: "Inactif",
          color: Colors.grey,
          icon: Icons.pause_circle,
        );

      case VehicleStatus.maintenance:
        return const _StatusConfig(
          label: "Maintenance",
          color: Colors.orange,
          icon: Icons.build_circle,
        );

      case VehicleStatus.suspended:
        return const _StatusConfig(
          label: "Suspendu",
          color: Colors.red,
          icon: Icons.block,
        );

      case VehicleStatus.pendingValidation:
        return const _StatusConfig(
          label: "Validation",
          color: Colors.blue,
          icon: Icons.verified_user,
        );

      case VehicleStatus.deleted:
        return const _StatusConfig(
          label: "Supprimé",
          color: Colors.black54,
          icon: Icons.delete_forever,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}