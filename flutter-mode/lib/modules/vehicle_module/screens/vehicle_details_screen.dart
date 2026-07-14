// ============================================================================
// FILE : screens/vehicle/vehicle_details_screen.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babigo/app/core/utils/constants.dart';

import '../../../app/database/models/vehicle.dart';
import '../../../app/screens/babigo_scaffold.dart';
import '../../../app/widgets/babigo_card.dart';


class VehicleDetailsScreen extends StatefulWidget {
  final String vehicleId;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  State<VehicleDetailsScreen> createState() =>
      _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState
    extends State<VehicleDetailsScreen> {

  bool _loading = true;

  Vehicle? _vehicle;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  Future<void> _loadVehicle() async {
    try {
      final doc = await FirebaseFirestore.instance
          .doc(widget.vehicleId)
          .get();

      if (!mounted) return;

      setState(() {
        _vehicle = Vehicle.fromFirestore(doc);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BabiGOScaffold(
      title: "Détails du véhicule",
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_vehicle == null) {
      return const Center(
        child: Text(
          "Impossible de charger le véhicule",
        ),
      );
    }

    final vehicle = _vehicle!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          _buildHeroCard(vehicle),

          const SizedBox(height: 20),

          _buildIdentityCard(vehicle),

          const SizedBox(height: 20),

          _buildStatusCard(vehicle),

          const SizedBox(height: 20),

          _buildFeaturesCard(vehicle),

          const SizedBox(height: 20),

          _buildDocumentsCard(vehicle),

          const SizedBox(height: 20),

          _buildMaintenanceCard(vehicle),

          const SizedBox(height: 20),

          _buildStatisticsCard(vehicle),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroCard(
      Vehicle vehicle,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 50,
            backgroundImage:
            vehicle.coverPhoto != null
                ? NetworkImage(
              vehicle.coverPhoto!,
            )
                : null,
            child: vehicle.coverPhoto == null
                ? const Icon(
              Icons.directions_car,
              size: 40,
            )
                : null,
          ),

          const SizedBox(height: 16),

          Text(
            vehicle.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            vehicle.plateNumber,
          ),

          const SizedBox(height: 16),

          _buildStatusChip(vehicle),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      Vehicle vehicle,
      ) {
    Color color;

    switch (vehicle.status) {
      case VehicleStatus.active:
        color = Colors.green;
        break;

      case VehicleStatus.maintenance:
        color = Colors.orange;
        break;

      case VehicleStatus.suspended:
        color = Colors.red;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        vehicle.status.name,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildIdentityCard(
      Vehicle vehicle,
      ) {
    return BabiGOCard(
      title: "Informations générales",
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
            "VIN",
            vehicle.vin,
          ),

          _infoRow(
            "Places",
            "${vehicle.availableSeats}/${vehicle.seats}",
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [

          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // FONCTIONNALITÉS DU VÉHICULE
  // ============================================================================

  Widget _buildFeaturesCard(
      Vehicle vehicle,
      ) {
    final features = vehicle.features;

    final items = <_FeatureItem>[
      _FeatureItem(
        icon: Icons.ac_unit,
        label: "Climatisation",
        enabled: features.airConditioning,
      ),
      _FeatureItem(
        icon: Icons.wifi,
        label: "Wi-Fi",
        enabled: features.wifi,
      ),
      _FeatureItem(
        icon: Icons.usb,
        label: "USB",
        enabled: features.usbCharging,
      ),
      _FeatureItem(
        icon: Icons.bluetooth,
        label: "Bluetooth",
        enabled: features.bluetooth,
      ),
      _FeatureItem(
        icon: Icons.airline_seat_recline_normal,
        label: "Sièges inclinables",
        enabled: features.recliningSeats,
      ),
      _FeatureItem(
        icon: Icons.music_note,
        label: "Musique",
        enabled: features.music,
      ),
      _FeatureItem(
        icon: Icons.luggage,
        label: "Bagages",
        enabled: features.luggageSpace,
      ),
      _FeatureItem(
        icon: Icons.pets,
        label: "Animaux",
        enabled: features.petAllowed,
      ),
      _FeatureItem(
        icon: Icons.smoking_rooms,
        label: "Fumeur",
        enabled: features.smokingAllowed,
      ),
      _FeatureItem(
        icon: Icons.child_care,
        label: "Siège bébé",
        enabled: features.babySeat,
      ),
      _FeatureItem(
        icon: Icons.accessible,
        label: "PMR",
        enabled: features.wheelchairAccess,
      ),
      _FeatureItem(
        icon: Icons.gps_fixed,
        label: "GPS",
        enabled: features.gpsTracking,
      ),
      _FeatureItem(
        icon: Icons.videocam,
        label: "Caméra",
        enabled: features.securityCamera,
      ),
    ];

    return BabiGOCard(
      title: "Confort & sécurité",
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items
            .map(
              (e) => _buildFeatureChip(e),
        )
            .toList(),
      ),
    );
  }

  Widget _buildFeatureChip(
      _FeatureItem item,
      ) {
    final color =
    item.enabled
        ? Colors.green
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: .25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            item.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
// DOCUMENTS
// ============================================================================

  Widget _buildDocumentsCard(
      Vehicle vehicle,
      ) {
    return BabiGOCard(
      title: "Documents administratifs",
      child: Column(
        children: [

          _documentTile(
            title: "Assurance",
            valid: vehicle.insuranceVerified,
            expiryDate:
            vehicle.insuranceExpiryDate,
          ),

          const Divider(),

          _documentTile(
            title: "Visite technique",
            valid:
            vehicle.technicalInspectionVerified,
            expiryDate:
            vehicle.technicalInspectionExpiry,
          ),

          const Divider(),

          _documentTile(
            title: "Immatriculation",
            valid: vehicle.plateVerified,
            expiryDate: null,
          ),
        ],
      ),
    );
  }

  Widget _documentTile({
    required String title,
    required bool valid,
    DateTime? expiryDate,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        backgroundColor:
        valid
            ? Colors.green.withValues(alpha: .15)
            : Colors.red.withValues(alpha: .15),
        child: Icon(
          valid
              ? Icons.check
              : Icons.warning_amber,
        ),
      ),

      title: Text(title),

      subtitle: expiryDate != null
          ? Text(
        "Expiration : ${Utils.formatDate(expiryDate)}",
      )
          : null,
    );
  }

  Widget _buildMaintenanceCard(
      Vehicle vehicle,
      ) {
    return BabiGOCard(
      title: "Maintenance",
      child: Column(
        children: [

          _infoRow(
            "Kilométrage",
            "${vehicle.mileageKm.toStringAsFixed(0)} km",
          ),

          _infoRow(
            "Dernière maintenance",
            Utils.formatDate(
              vehicle.lastMaintenanceDate,
            ),
          ),

          _infoRow(
            "Prochaine maintenance",
            Utils.formatDate(
              vehicle.nextMaintenanceDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(
      Vehicle vehicle,
      ) {
    return BabiGOCard(
      title: "Statistiques",
      child: Column(
        children: [

          _infoRow(
            "Trajets",
            vehicle.totalTrips.toString(),
          ),

          _infoRow(
            "Distance totale",
            "${vehicle.totalDistanceKm.toStringAsFixed(0)} km",
          ),

          _infoRow(
            "Note moyenne",
            vehicle.rating.toStringAsFixed(1),
          ),

          _infoRow(
            "Avis",
            vehicle.reviewCount.toString(),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STATUT GLOBAL DU VÉHICULE
  // ============================================================================

  Widget _buildStatusCard(
      Vehicle vehicle,
      ) {
    return BabiGOCard(
      title: "État du véhicule",

      child: Column(

        children: [

          Utils.statusRow(
            icon: Icons.check_circle,
            label: "Véhicule actif",
            value: vehicle.active,
          ),

          const Divider(),

          Utils.statusRow(
            icon: Icons.local_police,
            label: "Assurance valide",
            value: vehicle.insuranceVerified,
          ),

          const Divider(),

          Utils.statusRow(
            icon: Icons.fact_check,
            label: "Visite technique",
            value: vehicle .technicalInspectionVerified,
          ),

          const Divider(),

          Utils.statusRow(
            icon: Icons.badge,
            label: "Immatriculation validée",
            value: vehicle.plateVerified,
          ),

          const Divider(),

          Utils.statusRow(
            icon: Icons.location_on,
            label: "GPS disponible",
            value:
            vehicle.features.gpsTracking,
          ),

          const Divider(),

          Utils.statusRow(
            icon: Icons.route,
            label: "Disponible pour trajet",
            value: vehicle.isAvailable,
          ),

        ],

      ),
    );
  }

}


class _FeatureItem {
  final IconData icon;
  final String label;
  final bool enabled;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.enabled,
  });
}