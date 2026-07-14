// ============================================================================
// FILE : services/vehicle/vehicle_service.dart
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/database/models/vehicle.dart';

class VehicleService {
  VehicleService._();

  static final VehicleService instance =
  VehicleService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ==========================================================================
  // Collection utilisateur
  // ==========================================================================

  CollectionReference<Map<String, dynamic>>
  get _vehiclesCollection {
    final uid = _auth.currentUser!.uid;

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('vehicles');
  }

  // ==========================================================================
  // CREATE
  // ==========================================================================

  Future<String> createVehicle(
      Vehicle vehicle,
      ) async {
    final doc =
    _vehiclesCollection.doc();

    await doc.set(
      vehicle.copyWith().toJson(),
    );

    return doc.id;
  }

  // ==========================================================================
  // UPDATE
  // ==========================================================================

  Future<void> updateVehicle(
      Vehicle vehicle,
      ) async {
    await _vehiclesCollection
        .doc(vehicle.id)
        .update(
      vehicle.toJson(),
    );
  }

  // ==========================================================================
  // DELETE
  // ==========================================================================

  Future<void> deleteVehicle(
      String vehicleId,
      ) async {
    await _vehiclesCollection
        .doc(vehicleId)
        .delete();
  }

  // ==========================================================================
  // GET ONE
  // ==========================================================================

  Future<Vehicle?> getVehicle(
      String vehicleId,
      ) async {
    final doc =
    await _vehiclesCollection
        .doc(vehicleId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return Vehicle.fromFirestore(doc);
  }

  // ==========================================================================
  // STREAM ONE
  // ==========================================================================

  Stream<Vehicle?> watchVehicle(
      String vehicleId,
      ) {
    return _vehiclesCollection
        .doc(vehicleId)
        .snapshots()
        .map(
          (doc) {
        if (!doc.exists) {
          return null;
        }

        return Vehicle.fromFirestore(doc);
      },
    );
  }

  // ==========================================================================
  // STREAM LIST
  // ==========================================================================

  Stream<List<Vehicle>> watchVehicles() {
    return _vehiclesCollection
        .orderBy(
      'createdAt',
      descending: true,
    )
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs
            .map(
          Vehicle.fromFirestore,
        )
            .toList();
      },
    );
  }

  // ==========================================================================
  // ACTIVER
  // ==========================================================================

  Future<void> activateVehicle(
      String vehicleId,
      ) async {
    await _vehiclesCollection
        .doc(vehicleId)
        .update({
      'active': true,
      'status': VehicleStatus.active.name,
    });
  }

  // ==========================================================================
  // DÉSACTIVER
  // ==========================================================================

  Future<void> deactivateVehicle(
      String vehicleId,
      ) async {
    await _vehiclesCollection
        .doc(vehicleId)
        .update({
      'active': false,
      'status': VehicleStatus.inactive.name,
    });
  }
}