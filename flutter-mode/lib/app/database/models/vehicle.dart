/// ============================================================================
/// FILE : models/vehicle/vehicle.dart
/// ============================================================================
///
/// MODÈLE ULTRA COMPLET DE VÉHICULE
///
/// Compatible :
///
/// ✅ Mobile Flutter
/// ✅ Desktop Flutter
/// ✅ Web Flutter
/// ✅ Firebase Firestore
/// ✅ GPS Temps réel
/// ✅ Gestion de flotte
/// ✅ Maintenance
/// ✅ Assurance
/// ✅ Paiement
/// ✅ Covoiturage
/// ✅ OpenStreetMap
/// ✅ Tracking
/// ✅ Conducteurs multiples
/// ✅ Analytics
///
/// ============================================================================
///
/// CE MODÈLE GÈRE :
///
/// - véhicule personnel
/// - véhicule flotte
/// - documents véhicule
/// - assurance
/// - géolocalisation
/// - maintenance
/// - disponibilité
/// - photos
/// - capacité
/// - confort
/// - sécurité
/// - statut temps réel
/// - historique
///
/// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================================================
/// ENUM : TYPE DE VÉHICULE
/// ============================================================================

enum VehicleType {
  sedan,
  suv,
  pickup,
  minibus,
  bus,
  motorcycle,
  electric,
  hybrid,
}

/// ============================================================================
/// ENUM : STATUT DU VÉHICULE
/// ============================================================================

enum VehicleStatus {
  pendingValidation,
  active,
  inactive,
  suspended,
  maintenance,
  deleted,
}

/// ============================================================================
/// ENUM : TYPE DE CARBURANT
/// ============================================================================

enum FuelType {
  gasoline,
  diesel,
  electric,
  hybrid,
  gas,
}

/// ============================================================================
/// ENUM : TRANSMISSION
/// ============================================================================

enum TransmissionType {
  manual,
  automatic,
}

/// ============================================================================
/// ENUM : ÉTAT TECHNIQUE
/// ============================================================================

enum VehicleCondition {
  excellent,
  good,
  average,
  damaged,
}

/// ============================================================================
/// ENUM : PROPRIÉTÉ
/// ============================================================================

enum VehicleOwnershipType {
  personal,
  fleet,
  rental,
  company,
}

/// ============================================================================
/// ENUM : INCIDENT
/// ============================================================================

enum VehicleIncident {
  accident,
  panne,
  crevaison
}

/// ============================================================================
/// CLASS : VEHICLE DOCUMENT
/// ============================================================================
///
/// Documents du véhicule.
///
/// ============================================================================

class VehicleDocument {

  /// ID document
  final String id;

  /// Type document
  final String type;

  /// URL Firebase Storage
  final String url;

  /// Nom fichier
  final String fileName;

  /// Date expiration
  final DateTime? expiryDate;

  /// Date upload
  final DateTime uploadedAt;

  /// Vérifié ?
  final bool verified;

  VehicleDocument({
    required this.id,
    required this.type,
    required this.url,
    required this.fileName,
    required this.expiryDate,
    required this.uploadedAt,
    required this.verified,
  });

  /// ==========================================================================
  /// GETTERS
  /// ==========================================================================


  bool get hasExpiry => expiryDate != null;

  bool get isExpired {

    if (expiryDate == null) {
      return false;
    }

    return expiryDate!.isBefore(
      DateTime.now(),
    );
  }

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'type': type,

      'url': url,

      'fileName': fileName,

      'expiryDate': expiryDate,

      'uploadedAt': uploadedAt,

      'verified': verified,
    };
  }

  /// ==========================================================================
  /// FROM JSON
  /// ==========================================================================

  factory VehicleDocument.fromJson(
    Map<String, dynamic>? json,
  ) {

    if (json == null) {
      throw Exception(
        "VehicleDocument null",
      );
    }

    return VehicleDocument(

      id: json['id'] ?? '',

      type: json['type'] ?? '',

      url: json['url'] ?? '',

      fileName:
          json['fileName'] ?? '',

      expiryDate:
          (json['expiryDate']
                  as Timestamp?)
              ?.toDate(),

      uploadedAt:
          (json['uploadedAt']
                  as Timestamp?)
              ?.toDate() ??
              DateTime.now(),

      verified:
          json['verified'] ?? false,
    );
  }
}

/// ============================================================================
/// CLASS : VEHICLE FEATURES
/// ============================================================================
///
/// Fonctionnalités du véhicule.
///
/// ============================================================================

class VehicleFeatures {

  final bool airConditioning;

  final bool wifi;

  final bool usbCharging;

  final bool bluetooth;

  final bool recliningSeats;

  final bool music;

  final bool luggageSpace;

  final bool petAllowed;

  final bool smokingAllowed;

  final bool babySeat;

  final bool wheelchairAccess;

  final bool gpsTracking;

  final bool securityCamera;

  VehicleFeatures({
    required this.airConditioning,
    required this.wifi,
    required this.usbCharging,
    required this.bluetooth,
    required this.recliningSeats,
    required this.music,
    required this.luggageSpace,
    required this.petAllowed,
    required this.smokingAllowed,
    required this.babySeat,
    required this.wheelchairAccess,
    required this.gpsTracking,
    required this.securityCamera,
  });

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {

    return {

      'airConditioning':
          airConditioning,

      'wifi': wifi,

      'usbCharging':
          usbCharging,

      'bluetooth':
          bluetooth,

      'recliningSeats':
          recliningSeats,

      'music': music,

      'luggageSpace':
          luggageSpace,

      'petAllowed':
          petAllowed,

      'smokingAllowed':
          smokingAllowed,

      'babySeat':
          babySeat,

      'wheelchairAccess':
          wheelchairAccess,

      'gpsTracking':
          gpsTracking,

      'securityCamera':
          securityCamera,
    };
  }

  /// ==========================================================================
  /// FROM JSON
  /// ==========================================================================

  factory VehicleFeatures.fromJson(
    Map<String, dynamic>? json,
  ) {

    if (json == null) {

      return VehicleFeatures(
        airConditioning: false,
        wifi: false,
        usbCharging: false,
        bluetooth: false,
        recliningSeats: false,
        music: false,
        luggageSpace: false,
        petAllowed: false,
        smokingAllowed: false,
        babySeat: false,
        wheelchairAccess: false,
        gpsTracking: false,
        securityCamera: false,
      );
    }

    return VehicleFeatures(

      airConditioning:
          json['airConditioning'] ?? false,

      wifi:
          json['wifi'] ?? false,

      usbCharging:
          json['usbCharging'] ?? false,

      bluetooth:
          json['bluetooth'] ?? false,

      recliningSeats:
          json['recliningSeats'] ?? false,

      music:
          json['music'] ?? false,

      luggageSpace:
          json['luggageSpace'] ?? false,

      petAllowed:
          json['petAllowed'] ?? false,

      smokingAllowed:
          json['smokingAllowed'] ?? false,

      babySeat:
          json['babySeat'] ?? false,

      wheelchairAccess:
          json['wheelchairAccess'] ?? false,

      gpsTracking:
          json['gpsTracking'] ?? false,

      securityCamera:
          json['securityCamera'] ?? false,
    );
  }
}

/// ============================================================================
/// CLASS : LIVE VEHICLE STATUS
/// ============================================================================
///
/// Statut temps réel.
///
/// ============================================================================

class LiveVehicleStatus {

  /// Véhicule en ligne ?
  final bool online;

  /// En trajet ?
  final bool onTrip;

  /// Disponible ?
  final bool available;

  /// Dernière activité
  final DateTime lastActivity;

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;

  /// Vitesse actuelle
  final double speedKmH;

  /// Batterie (%)
  final double batteryLevel;

  /// Carburant (%)
  final double fuelLevel;

  LiveVehicleStatus({
    required this.online,
    required this.onTrip,
    required this.available,
    required this.lastActivity,
    required this.latitude,
    required this.longitude,
    required this.speedKmH,
    required this.batteryLevel,
    required this.fuelLevel,
  });

  /// ==========================================================================
  /// GETTERS
  /// ==========================================================================

  bool get hasPosition =>
      latitude != 0 || longitude != 0;

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {

    return {

      'online': online,

      'onTrip': onTrip,

      'available': available,

      'lastActivity':
          lastActivity,

      'latitude': latitude,

      'longitude': longitude,

      'speedKmH': speedKmH,

      'batteryLevel':
          batteryLevel,

      'fuelLevel':
          fuelLevel,
    };
  }

  /// ==========================================================================
  /// FROM JSON
  /// ==========================================================================

  factory LiveVehicleStatus.fromJson(
    Map<String, dynamic>? json,
  ) {

    if (json == null) {

      return LiveVehicleStatus(
        online: false,
        onTrip: false,
        available: false,
        lastActivity: DateTime.now(),
        latitude: 0,
        longitude: 0,
        speedKmH: 0,
        batteryLevel: 0,
        fuelLevel: 0,
      );
    }

    return LiveVehicleStatus(

      online:
          json['online'] ?? false,

      onTrip:
          json['onTrip'] ?? false,

      available:
          json['available'] ?? false,

      lastActivity:
          (json['lastActivity']
                  as Timestamp?)
              ?.toDate() ??
              DateTime.now(),

      latitude:
          (json['latitude'] ?? 0)
              .toDouble(),

      longitude:
          (json['longitude'] ?? 0)
              .toDouble(),

      speedKmH:
          (json['speedKmH'] ?? 0)
              .toDouble(),

      batteryLevel:
          (json['batteryLevel'] ?? 0)
              .toDouble(),

      fuelLevel:
          (json['fuelLevel'] ?? 0)
              .toDouble(),
    );
  }
}

/// ============================================================================
/// CLASS : VEHICLE
/// ============================================================================

class Vehicle {

  /// ==========================================================================
  /// IDENTIFIANTS
  /// ==========================================================================

  final String id;

  final String ownerId;

  final String? fleetId;

  /// ==========================================================================
  /// INFOS PRINCIPALES
  /// ==========================================================================

  final String brand;

  final String model;

  final int year;

  final String color;

  final String plateNumber;

  final String vin;

  final String nickname;

  /// ==========================================================================
  /// TYPES
  /// ==========================================================================

  final VehicleType type;

  final FuelType fuelType;

  final TransmissionType transmission;

  final VehicleOwnershipType ownershipType;

  final String? assignedDriverId;

  final List<VehicleIncident> incidents;

  /// ==========================================================================
  /// CAPACITÉ
  /// ==========================================================================

  /// Nombre de sièges total
  final int seats;

  /// Nombre de sièges actuellement disponibles
  final int availableSeats;

  /// Poids de bagage accepté
  final double luggageCapacityKg;

  /// Type de bagage : Grand bagage / Valise cabine
  final String luggageDescription;

  /// ==========================================================================
  /// ÉTAT
  /// ==========================================================================

  final VehicleStatus status;

  final VehicleCondition condition;

  /// ==========================================================================
  /// DOCUMENTS
  /// ==========================================================================

  final List<VehicleDocument> documents;

  /// ==========================================================================
  /// PHOTOS
  /// ==========================================================================

  final List<String> photos;

  final String? coverPhoto;

  /// ==========================================================================
  /// FEATURES
  /// ==========================================================================

  final VehicleFeatures features;

  /// ==========================================================================
  /// LIVE STATUS
  /// ==========================================================================

  final LiveVehicleStatus liveStatus;

  /// ==========================================================================
  /// ASSURANCE
  /// ==========================================================================

  final String insuranceCompany;

  final String insuranceNumber;

  final DateTime insuranceExpiryDate;

  /// ==========================================================================
  /// VISITE TECHNIQUE
  /// ==========================================================================

  final DateTime technicalInspectionDate;

  final DateTime technicalInspectionExpiry;

  /// ==========================================================================
  /// MAINTENANCE
  /// ==========================================================================

  final double mileageKm;

  final DateTime lastMaintenanceDate;

  final DateTime nextMaintenanceDate;

  /// ==========================================================================
  /// TARIFICATION
  /// ==========================================================================

  final double pricePerKm;

  final double basePrice;

  /// ==========================================================================
  /// STATISTIQUES
  /// ==========================================================================

  final int totalTrips;

  final double totalDistanceKm;

  final double rating;

  final int reviewCount;

  /// ==========================================================================
  /// FLAGS
  /// ==========================================================================

  /// Véhicule par défaut ?
  final bool defaultVehicle;

  /// Immatriculé correctement ?
  final bool plateVerified;

  /// Véhicule assuré ou non ?
  final bool insuranceVerified;

  /// Visite technique
  final bool technicalInspectionVerified;

  final bool active;

  final bool acceptsPackages;

  /// ==========================================================================
  /// DESCRIPTION
  /// ==========================================================================

  final String description;

  /// ==========================================================================
  /// DATES
  /// ==========================================================================

  final DateTime createdAt;

  final DateTime updatedAt;

  /// ==========================================================================
  /// CONSTRUCTEUR
  /// ==========================================================================

  Vehicle({
    required this.id,
    required this.ownerId,
    required this.fleetId,
    required this.brand,
    required this.model,
    required this.year,
    required this.nickname,
    required this.color,
    required this.plateNumber,
    required this.vin,
    required this.type,
    required this.fuelType,
    required this.transmission,
    required this.ownershipType,
    this.assignedDriverId,
    required this.seats,
    required this.availableSeats,
    required this.luggageCapacityKg,
    required this.luggageDescription,
    required this.status,
    required this.incidents,
    required this.condition,
    required this.documents,
    required this.photos,
    this.coverPhoto,
    required this.features,
    required this.liveStatus,
    required this.insuranceCompany,
    required this.insuranceNumber,
    required this.insuranceExpiryDate,
    required this.technicalInspectionDate,
    required this.technicalInspectionExpiry,
    required this.mileageKm,
    required this.lastMaintenanceDate,
    required this.nextMaintenanceDate,
    required this.pricePerKm,
    required this.basePrice,
    required this.totalTrips,
    required this.totalDistanceKm,
    required this.rating,
    required this.reviewCount,
    required this.defaultVehicle,
    required this.plateVerified,
    required this.insuranceVerified,
    required this.technicalInspectionVerified,
    required this.active,
    required this.acceptsPackages,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ==========================================================================
  /// GETTERS
  /// ==========================================================================

  /// Nom complet
  String get fullName =>
      "$brand $model";

  /// Assurance expirée ?
  bool get insuranceExpired {

    return insuranceExpiryDate.isBefore(
      DateTime.now(),
    );
  }

  /// Visite technique expirée ?
  bool get technicalInspectionExpired {

    return technicalInspectionExpiry.isBefore(
      DateTime.now(),
    );
  }

  /// Véhicule disponible ?
  bool get isAvailable {

    return active &&
        status == VehicleStatus.active &&
        liveStatus.available;
  }

  /// A des photos ?
  bool get hasPhotos => photos.isNotEmpty;

  /// A documents ?
  bool get hasDocuments =>  documents.isNotEmpty;

  /// ==========================================================================
  /// COPY WITH
  /// ==========================================================================

  Vehicle copyWith({

    VehicleStatus? status,

    double? mileageKm,

    LiveVehicleStatus? liveStatus,

    String? assignedDriverId,

    bool? active,
  }) {

    return Vehicle(

      id: id,

      ownerId: ownerId,

      assignedDriverId: assignedDriverId,

      fleetId: fleetId,

      brand: brand,

      model: model,

      year: year,

      nickname: nickname,

      color: color,

      plateNumber: plateNumber,

      vin: vin,

      type: type,

      fuelType: fuelType,

      transmission: transmission,

      ownershipType: ownershipType,

      seats: seats,

      availableSeats: availableSeats,

      luggageCapacityKg: luggageCapacityKg,

      luggageDescription: luggageDescription,

      status: status ?? this.status,

      incidents: incidents,

      condition: condition,

      documents: documents,

      photos: photos,

      features: features,

      liveStatus: liveStatus ?? this.liveStatus,

      insuranceCompany: insuranceCompany,

      insuranceNumber: insuranceNumber,

      insuranceExpiryDate: insuranceExpiryDate,

      technicalInspectionDate: technicalInspectionDate,

      technicalInspectionExpiry: technicalInspectionExpiry,

      mileageKm: mileageKm ?? this.mileageKm,

      lastMaintenanceDate: lastMaintenanceDate,

      nextMaintenanceDate: nextMaintenanceDate,

      pricePerKm: pricePerKm,

      basePrice: basePrice,

      totalTrips: totalTrips,

      totalDistanceKm: totalDistanceKm,

      rating: rating,

      reviewCount: reviewCount,

      defaultVehicle: defaultVehicle,

      plateVerified: plateVerified,

      insuranceVerified: insuranceVerified,

      technicalInspectionVerified: technicalInspectionVerified,

      active: active ?? this.active,

      acceptsPackages: acceptsPackages,

      description: description,

      createdAt: createdAt,

      updatedAt: DateTime.now(),
    );
  }

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {

    return {

      'ownerId': ownerId,

      'assignedDriverId': assignedDriverId,

      'fleetId': fleetId,

      'brand': brand,

      'model': model,

      'year': year,

      'nickname': nickname,

      'color': color,

      'plateNumber': plateNumber,

      'vin': vin,

      'type': type.name,

      'fuelType': fuelType.name,

      'transmission': transmission.name,

      'ownershipType': ownershipType.name,

      'seats': seats,

      'availableSeats': availableSeats,

      'luggageCapacityKg': luggageCapacityKg,

      'luggageDescription': luggageDescription,

      'status': status.name,

      'condition': condition.name,

      'documents': documents.map((e) => e.toJson())
              .toList(),

      'photos': photos,

      'coverPhoto': coverPhoto,

      'features': features.toJson(),

      'liveStatus': liveStatus.toJson(),

      'incidents': incidents.map((e) => e.name)
          .toList(),

      'insuranceCompany': insuranceCompany,

      'insuranceNumber': insuranceNumber,

      'insuranceExpiryDate': insuranceExpiryDate,

      'technicalInspectionDate': technicalInspectionDate,

      'technicalInspectionExpiry': technicalInspectionExpiry,

      'mileageKm': mileageKm,

      'lastMaintenanceDate': lastMaintenanceDate,

      'nextMaintenanceDate': nextMaintenanceDate,

      'pricePerKm': pricePerKm,

      'basePrice': basePrice,

      'totalTrips': totalTrips,

      'totalDistanceKm': totalDistanceKm,

      'rating': rating,

      'reviewCount': reviewCount,

      'defaultVehicle': defaultVehicle,

      'plateVerified': plateVerified,

      'insuranceVerified': insuranceVerified,

      'technicalInspectionVerified': technicalInspectionVerified,

      'active': active,

      'acceptsPackages': acceptsPackages,

      'description': description,

      'createdAt': createdAt,

      'updatedAt': updatedAt,
    };
  }

  /// ==========================================================================
  /// FROM FIRESTORE
  /// ==========================================================================

  factory Vehicle.fromFirestore(
    DocumentSnapshot doc,
  ) {

    final data =
        doc.data() as Map<String, dynamic>;

    return Vehicle(

      id: doc.id,

      ownerId: data['ownerId'] ?? '',

      assignedDriverId: data['assignedDriverId'],

      fleetId: data['fleetId'],

      brand: data['brand'] ?? '',

      model: data['model'] ?? '',

      year: data['year'] ?? 0,

      nickname: data['nickname'] ?? 'Mon taxi principal',

      color: data['color'] ?? '',

      plateNumber: data['plateNumber'] ?? '',

      vin: data['vin'] ?? '',

      type: VehicleType.values.firstWhere(
        (e) =>
            e.name == data['type'],
        orElse: () => VehicleType.sedan,
      ),

      fuelType: FuelType.values.firstWhere(
        (e) =>
            e.name ==
            data['fuelType'],
        orElse: () => FuelType.gasoline,
      ),

      transmission: TransmissionType.values.firstWhere(
        (e) =>
            e.name ==
            data['transmission'],
        orElse: () => TransmissionType.manual,
      ),

      ownershipType: VehicleOwnershipType.values.firstWhere(
        (e) =>
            e.name ==
            data['ownershipType'],
        orElse: () =>
            VehicleOwnershipType.personal,
      ),

      seats: data['seats'] ?? 0,

      availableSeats: data['availableSeats'] ?? 0,

      luggageCapacityKg: (data['luggageCapacityKg'] ?? 0)
              .toDouble(),

      luggageDescription: data['luggageDescription'] ?? 'Valise cabine',

      status: VehicleStatus.values.firstWhere(
        (e) =>
            e.name ==
            data['status'],
        orElse: () =>
            VehicleStatus.pendingValidation,
      ),

      incidents: (data['incidents'] as List?)
          ?.map(
            (e) => VehicleIncident.values.firstWhere(
              (v) => v.name == e,
          orElse: () => VehicleIncident.panne,
        ),
      ).toList() ?? [],

      condition: VehicleCondition.values.firstWhere(
        (e) =>
            e.name ==
            data['condition'],
        orElse: () =>
            VehicleCondition.good,
      ),

      documents: (data['documents'] as List?)
                  ?.map((e) => VehicleDocument.fromJson(e),
                  ).toList() ?? [],

      photos: List<String>.from(
        data['photos'] ?? [],
      ),

      coverPhoto: data['coverPhoto'],

      features: VehicleFeatures.fromJson(
        data['features'],
      ),

      liveStatus: LiveVehicleStatus.fromJson(
        data['liveStatus'],
      ),

      insuranceCompany: data['insuranceCompany'] ?? '',

      insuranceNumber: data['insuranceNumber'] ?? '',

      insuranceExpiryDate: (data['insuranceExpiryDate']
                  as Timestamp?)?.toDate() ?? DateTime.now(),

      technicalInspectionDate: (data['technicalInspectionDate']
                  as Timestamp?)?.toDate() ?? DateTime.now(),

      technicalInspectionExpiry: (data['technicalInspectionExpiry']
                  as Timestamp?)?.toDate() ?? DateTime.now(),

      mileageKm: (data['mileageKm'] ?? 0).toDouble(),

      lastMaintenanceDate: (data['lastMaintenanceDate']
                  as Timestamp?)?.toDate() ?? DateTime.now(),

      nextMaintenanceDate: (data['nextMaintenanceDate']
                  as Timestamp?)?.toDate() ?? DateTime.now(),

      pricePerKm: (data['pricePerKm'] ?? 0).toDouble(),

      basePrice: (data['basePrice'] ?? 0).toDouble(),

      totalTrips: data['totalTrips'] ?? 0,

      totalDistanceKm: (data['totalDistanceKm'] ?? 0).toDouble(),

      rating: (data['rating'] ?? 0).toDouble(),

      reviewCount: data['reviewCount'] ?? 0,

      defaultVehicle: data['defaultVehicle'] ?? false,

      plateVerified: data['verified'] ?? false,

      insuranceVerified: data['insuranceVerified'] ?? false,

      technicalInspectionVerified: data['technicalInspectionVerified'] ?? false,

      active: data['active'] ?? false,

      acceptsPackages: data['acceptsPackages'] ?? false,

      description: data['description'] ?? '',

      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),

      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );

  }
}

