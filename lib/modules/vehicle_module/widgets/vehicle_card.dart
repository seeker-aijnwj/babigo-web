import 'package:flutter/material.dart';
import '../../../app/database/models/vehicle.dart';
import 'vehicle_status_chip.dart';
import 'vehicle_verification_badges.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Vehicle vehicle;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .05,
            ),
            blurRadius: 20,
            offset: const Offset(
              0,
              8,
            ),
          ),
        ],
      ),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(24),
        onTap: onTap,
        child: Column(
          children: [
            _buildHeader(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInformations(),

                  const SizedBox(height: 16),

                  VehicleVerificationBadges(
                    vehicle: vehicle,
                  ),

                  const SizedBox(height: 20),

                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
          const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: vehicle.coverPhoto != null &&
                vehicle.coverPhoto!
                    .isNotEmpty
                ? Image.network(
              vehicle.coverPhoto!,
              fit: BoxFit.cover,
            )
                : Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(
                  Icons.directions_car,
                  size: 60,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 12,
          right: 12,
          child: VehicleStatusChip(
            status: vehicle.status,
          ),
        ),
      ],
    );
  }

  Widget _buildInformations() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          vehicle.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          vehicle.nickname,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            const Icon(
              Icons.badge_outlined,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              vehicle.plateNumber,
            ),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: _InfoTile(
                icon: Icons.event_seat,
                title: "Places",
                value:
                "${vehicle.availableSeats}/${vehicle.seats}",
              ),
            ),

            Expanded(
              child: _InfoTile(
                icon: Icons.speed,
                title: "Km",
                value:
                vehicle.mileageKm
                    .toStringAsFixed(0),
              ),
            ),

            Expanded(
              child: _InfoTile(
                icon: Icons.star,
                title: "Note",
                value:
                vehicle.rating
                    .toStringAsFixed(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(
              Icons.visibility,
            ),
            label: const Text("Voir"),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: FilledButton.icon(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit,
            ),
            label: const Text("Modifier"),
          ),
        ),

        const SizedBox(width: 10),

        IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}