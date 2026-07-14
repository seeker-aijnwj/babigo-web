import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../app/database/models/vehicle.dart';

abstract class VehicleRepository {

  Stream<List<Vehicle>> watchVehicles(String uid);

  Future<List<Vehicle>> getVehicles(String uid);

  Future<Vehicle?> getVehicle({
    required String uid,
    required String vehicleId,
  });

  Future<String> createVehicle({
    required String uid,
    required Vehicle vehicle,
  });

  Future<void> updateVehicle({
    required String uid,
    required Vehicle vehicle,
  });

  Future<void> deleteVehicle({
    required String uid,
    required String vehicleId,
  });

  Future<void> setVehicleActive({
    required String uid,
    required String vehicleId,
    required bool active,
  });
}

class FirestoreVehicleRepository
    implements VehicleRepository {
  final FirebaseFirestore firestore;

  const FirestoreVehicleRepository(
      this.firestore,
      );

  @override
  Future<String> createVehicle({required String uid, required Vehicle vehicle}) {
    // TODO: implement createVehicle
    throw UnimplementedError();
  }

  @override
  Future<void> deleteVehicle({required String uid, required String vehicleId}) {
    // TODO: implement deleteVehicle
    throw UnimplementedError();
  }

  @override
  Future<Vehicle?> getVehicle({required String uid, required String vehicleId}) {
    // TODO: implement getVehicle
    throw UnimplementedError();
  }

  @override
  Future<List<Vehicle>> getVehicles(String uid) {
    // TODO: implement getVehicles
    throw UnimplementedError();
  }

  @override
  Future<void> setVehicleActive({required String uid, required String vehicleId, required bool active}) {
    // TODO: implement setVehicleActive
    throw UnimplementedError();
  }

  @override
  Future<void> updateVehicle({required String uid, required Vehicle vehicle}) {
    // TODO: implement updateVehicle
    throw UnimplementedError();
  }

  @override
  Stream<List<Vehicle>> watchVehicles(String uid) {
    // TODO: implement watchVehicles
    throw UnimplementedError();
  }

// implémentations...
}