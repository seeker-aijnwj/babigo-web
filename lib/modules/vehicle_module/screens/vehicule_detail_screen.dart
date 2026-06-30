/// ============================================================================
/// FILE : vehicle_detail_screen.dart
/// ============================================================================
///
/// Écran de détail complet d'un véhicule.
///
/// UI BabiGO V2
/// Compatible Mobile / Tablet / Desktop
///
/// ============================================================================

import 'package:flutter/material.dart';

import '../../../app/core/utils/colors.dart';
import '../../../app/database/models/vehicle.dart';
import '../../../app/screens/babigo_scaffold.dart';
import '../../../app/widgets/babigo_card.dart';


class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<VehicleDetailScreen> createState() =>
      _VehicleDetailScreenState();
}

class _VehicleDetailScreenState
    extends State<VehicleDetailScreen> {
  Vehicle get vehicle => widget.vehicle;

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: vehicle.fullName,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            _buildHeader(),

            const SizedBox(height: 20),

            _buildStatusCard(),

            const SizedBox(height: 20),

            _buildVehicleInformations(),

            const SizedBox(height: 20),

            _buildFeaturesCard(),

            const SizedBox(height: 20),

            _buildInsuranceCard(),

            const SizedBox(height: 20),

            _buildTechnicalInspectionCard(),

            const SizedBox(height: 20),

            _buildStatisticsCard(),

            const SizedBox(height: 20),

            _buildActionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BabiGOCard(
      child: Column(
        children: [

          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.secondColor.withValues(alpha: .15),
            child: Icon(
              Icons.directions_car,
              size: 40,
              color: AppColors.secondColor,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            vehicle.nickname,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            vehicle.fullName,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            vehicle.plateNumber,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return BabiGOCard(
      title: "État du véhicule",
      child: Row(
        children: [

          Expanded(
            child: _statusItem(
              "Disponible",
              vehicle.isAvailable,
            ),
          ),

          Expanded(
            child: _statusItem(
              "Actif",
              vehicle.active,
            ),
          ),

          Expanded(
            child: _statusItem(
              "En ligne",
              vehicle.liveStatus.online,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusItem(
      String title,
      bool value,
      ) {
    return Column(
      children: [

        Icon(
          value
              ? Icons.check_circle
              : Icons.cancel,
          color:
          value ? Colors.green : Colors.red,
        ),

        const SizedBox(height: 8),

        Text(
          title,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVehicleInformations() {
    return BabiGOCard(
      title: "Informations",
      child: Column(
        children: [

          _infoRow(
            "Marque",
            vehicle.brand,
          ),

          _infoRow(
            "Modèle",
            vehicle.model,
          ),

          _infoRow(
            "Année",
            vehicle.year.toString(),
          ),

          _infoRow(
            "Couleur",
            vehicle.color,
          ),

          _infoRow(
            "Places",
            vehicle.seats.toString(),
          ),

          _infoRow(
            "Places disponibles",
            vehicle.availableSeats.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final f = vehicle.features;

    return BabiGOCard(
      title: "Équipements",
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [

          if (f.airConditioning)
            _featureChip("Climatisation"),

          if (f.wifi)
            _featureChip("Wi-Fi"),

          if (f.bluetooth)
            _featureChip("Bluetooth"),

          if (f.usbCharging)
            _featureChip("USB"),

          if (f.music)
            _featureChip("Musique"),

          if (f.babySeat)
            _featureChip("Siège bébé"),

          if (f.gpsTracking)
            _featureChip("GPS"),
        ],
      ),
    );
  }

  Widget _featureChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: AppColors.secondColor.withValues(alpha: .10),
    );
  }

  Widget _buildInsuranceCard() {
    return BabiGOCard(
      title: "Assurance",
      child: Column(
        children: [

          _infoRow(
            "Compagnie",
            vehicle.insuranceCompany,
          ),

          _infoRow(
            "Police",
            vehicle.insuranceNumber,
          ),

          _infoRow(
            "Expiration",
            vehicle.insuranceExpiryDate
                .toString()
                .split(' ')
                .first,
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalInspectionCard() {
    return BabiGOCard(
      title: "Visite technique",
      child: Column(
        children: [

          _infoRow(
            "Dernière visite",
            vehicle.technicalInspectionDate
                .toString()
                .split(' ')
                .first,
          ),

          _infoRow(
            "Expiration",
            vehicle.technicalInspectionExpiry
                .toString()
                .split(' ')
                .first,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return BabiGOCard(
      title: "Statistiques",
      child: Row(
        children: [

          Expanded(
            child: _statTile(
              "Trajets",
              vehicle.totalTrips.toString(),
            ),
          ),

          Expanded(
            child: _statTile(
              "Distance",
              "${vehicle.totalDistanceKm.toInt()} km",
            ),
          ),

          Expanded(
            child: _statTile(
              "Note",
              vehicle.rating.toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(
      String title,
      String value,
      ) {
    return Column(
      children: [

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 6),

        Text(title),
      ],
    );
  }

  Widget _buildActionsCard() {
    return BabiGOCard(
      title: "Actions",
      child: Column(
        children: [

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text(
                "Modifier le véhicule",
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.build),
              label: const Text(
                "Maintenance",
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              label: const Text(
                "Supprimer",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(value),
        ],
      ),
    );
  }
}