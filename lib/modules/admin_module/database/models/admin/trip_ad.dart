/// ============================================================================
/// FILE : models/trips/trip_ad.dart
/// ============================================================================
///
/// MODÈLE ULTRA COMPLET DE TRAJET / COVOITURAGE
///
/// Compatible :
///
/// ✅ Mobile Flutter
/// ✅ Desktop Flutter
/// ✅ Web Flutter
/// ✅ Firebase Firestore
/// ✅ OpenStreetMap
/// ✅ Temps réel
/// ✅ GPS Live Tracking
/// ✅ Arrêts intermédiaires
/// ✅ Navigation
/// ✅ Historique GPS
/// ✅ Passagers multiples
/// ✅ Chauffeur
/// ✅ Flotte
/// ✅ Analytics
/// ✅ Paiement
/// ✅ Notifications
/// ✅ Chat
/// ✅ SOS
///
/// ============================================================================
///
/// CE MODÈLE GÈRE :
///
/// - annonces de trajet
/// - arrêts sur le trajet
/// - suivi temps réel
/// - conducteur en direct
/// - passagers en direct
/// - historique GPS
/// - navigation sans carte
/// - navigation avec carte
/// - ETA
/// - progression trajet
/// - réservations
/// - validations
/// - scan QR
/// - paiement
/// - sécurité
///
/// ============================================================================

import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utilisateur.dart';

/// ============================================================================
/// TRIP AD
/// ============================================================================

class TripAd {

  /// ==========================================================================
  /// IDENTIFIANTS
  /// ==========================================================================

  final String id;

  final String driverId;

  final String vehicleId;

  /// ==========================================================================
  /// VEHICLE
  /// ==========================================================================

  final String vehicleColor;

  final String vehiclePlateNumber;

  final String vehicleModel;

  double currentSpeedKmH;

  /// ==========================================================================
  /// CHAUFFEUR
  /// ==========================================================================

  final String driverName;

  final String driverPhoto;

  final double driverRating;

  final String driverPhone;

  final int driverTripsCount;

  /// ==========================================================================
  /// TRAJET
  /// ==========================================================================

  final String departureCity;

  final String destinationCity;

  final String departureAddress;

  final String destinationAddress;

  final double departureLatitude;

  final double departureLongitude;

  final double destinationLatitude;

  final double destinationLongitude;

  /// ==========================================================================
  /// ARRÊTS
  /// ==========================================================================

  final List<TripStop> stops;

  /// ==========================================================================
  /// TRACKING TEMPS RÉEL
  /// ==========================================================================

  final LiveTrackingData? tracking;

  String currentLocationLabel;

  /// ==========================================================================
  /// NAVIGATION
  /// ==========================================================================

  final AppNavigationMode navigationMode;

  /// ==========================================================================
  /// PLACES
  /// ==========================================================================

  final int totalSeats;

  final int reservedSeats;

  /// ==========================================================================
  /// PRIX
  /// ==========================================================================

  final double seatPrice;

  final double packagePrice;

  final double refundedAmount;

  final double pendingAmount;

  final double totalPaidAmount;

  final double totalRevenue;

  /// ==========================================================================
  /// STATUT
  /// ==========================================================================

  final TripStatus status;

  /// ==========================================================================
  /// DATES, DISTANCE
  /// ==========================================================================

  final double totalDistanceKm;

  final DateTime estimatedArrival;

  final DateTime departureDateTime;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// ==========================================================================
  /// OPTIONS
  /// ==========================================================================

  final bool acceptsPackages;

  final bool acceptsWomenOnly;

  final bool airConditioned;

  final bool petsAllowed;

  final bool smokingAllowed;

  final bool musicAllowed;

  /// ==========================================================================
  /// DESCRIPTION
  /// ==========================================================================

  final String description;

  /// Passagers qui sont montés au départ
  final List<String> passengerIds;

  /// ==========================================================================
  /// CONSTRUCTEUR
  /// ==========================================================================

  TripAd({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.vehicleColor,
    required this.vehicleModel,
    required this.currentSpeedKmH,
    required this.vehiclePlateNumber,
    required this.driverName,
    required this.driverPhoto,
    required this.driverRating,
    required this.driverTripsCount,
    required this.driverPhone,
    required this.departureCity,
    required this.destinationCity,
    required this.departureAddress,
    required this.destinationAddress,
    required this.departureLatitude,
    required this.departureLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.stops,
    required this.currentLocationLabel,
    required this.navigationMode,
    required this.totalDistanceKm,
    required this.estimatedArrival,
    required this.totalSeats,
    required this.reservedSeats,
    required this.seatPrice,
    required this.packagePrice,
    required this.status,
    required this.departureDateTime,
    required this.createdAt,
    required this.updatedAt,
    required this.acceptsPackages,
    required this.acceptsWomenOnly,
    required this.airConditioned,
    required this.petsAllowed,
    required this.smokingAllowed,
    required this.musicAllowed,
    required this.description,
    required this.passengerIds,
    required this.refundedAmount,
    required this.pendingAmount,
    required this.totalPaidAmount,
    required this.totalRevenue,
    this.tracking,
  });

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {

    return {

      'driverId': driverId,
      'vehicleId': vehicleId,

      'driverName': driverName,
      'driverPhoto': driverPhoto,
      'driverRating': driverRating,
      'driverPhone': driverPhone,

      'departureCity': departureCity,
      'destinationCity': destinationCity,

      'departureAddress': departureAddress,
      'destinationAddress': destinationAddress,

      'departureLatitude': departureLatitude,
      'departureLongitude': departureLongitude,

      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,

      'stops':
          stops
              .map((e) => e.toJson())
              .toList(),

      // 'tracking': tracking.toJson(),

      'navigationMode':
          navigationMode.name,

      'totalDistanceKm':
          totalDistanceKm,

      'totalSeats':
          totalSeats,

      'reservedSeats':
          reservedSeats,

      'seatPrice':
          seatPrice,

      'packagePrice':
          packagePrice,

      'status':
          status.name,

      'departureDateTime':
          departureDateTime,

      'createdAt':
          createdAt,

      'updatedAt':
          updatedAt,

      'acceptsPackages':
          acceptsPackages,

      'acceptsWomenOnly':
          acceptsWomenOnly,

      'airConditioned':
          airConditioned,

      'petsAllowed':
          petsAllowed,

      'smokingAllowed':
          smokingAllowed,

      'musicAllowed':
          musicAllowed,

      'description':
          description,

      'passengerIds':
          passengerIds,
    };
  }

  /// ==========================================================================
  /// FROM FIRESTORE
  /// ==========================================================================

  factory TripAd.fromFirestore(DocumentSnapshot doc) {

    final data =
        doc.data() as Map<String, dynamic>;

    return TripAd(

      id: doc.id,

      driverId:
          data['driverUserId'] ?? '',

      vehicleId:
          data['vehicleId'] ?? '',

      vehicleColor:
          data['vehicleColor'] ?? 'Colors.white',

      vehiclePlateNumber:
          data['vehiclePlateNumber'] ?? 'XXXXXXXXX',

      vehicleModel:
          data['vehicleModel'] ?? 'XXXXXXXXX',

      currentSpeedKmH:
          (data['currentSpeedKmH'] ?? 0)
              .toDouble(),

      driverName:
          data['driverName'] ?? '',

      driverPhoto:
          data['driverPhoto'] ?? '',

      driverRating:
          (data['driverRating'] ?? 0)
              .toDouble(),

      driverTripsCount:
          (data['driverTripsCount'] ?? 0)
              .toDouble(),

      driverPhone:
          data['driverPhone'] ?? '',

      departureCity:
          data['from'] ?? 'Non',

      destinationCity:
          data['to'] ?? 'Oui',

      departureAddress:
          data['departureAddress'] ?? 'Unknow',

      destinationAddress:
          data['destinationAddress'] ?? 'Unknow',

      departureLatitude:
          (data['departureLatitude'] ?? 0)
              .toDouble(),

      departureLongitude:
          (data['departureLongitude'] ?? 0)
              .toDouble(),

      destinationLatitude:
          (data['destinationLatitude'] ?? 0)
              .toDouble(),

      destinationLongitude:
          (data['destinationLongitude'] ?? 0)
              .toDouble(),

      stops:
          (data['stops'] as List?)
                  ?.map(
                    (e) => TripStop.fromJson(e),
                  )
                  .toList() ??
              [],

      tracking:
          LiveTrackingData.fromJson(
        data['tracking'],
      ),

      currentLocationLabel:
          data['currentLocationLabel'] ?? '',

      navigationMode:
          AppNavigationMode.values.firstWhere(
        (e) =>
            e.name ==
            data['navigationMode'],

        orElse: () => AppNavigationMode.map,
      ),

      totalDistanceKm:
          (data['totalDistanceKm'] ?? 0)
              .toDouble(),

      departureDateTime:
          (data['startTime']
          as Timestamp?)
              ?.toDate() ??
              DateTime.now(),

      estimatedArrival:
          (data['endTime']
          as Timestamp?)
              ?.toDate() ??
              DateTime.now(),

      totalSeats:
          data['totalSeats'] ?? 0,

      reservedSeats:
          data['reservedSeats'] ?? 0,

      seatPrice:
          (data['price'] ?? 0)
              .toDouble(),

      packagePrice:
          (data['packagePrice'] ?? 0)
              .toDouble(),

      refundedAmount:
          (data['refundedAmount'] ?? 0)
              .toDouble(),

      pendingAmount:
          (data['pendingAmount'] ?? 0)
              .toDouble(),

      totalPaidAmount:
          (data['totalPaidAmount'] ?? 0)
              .toDouble(),

      totalRevenue:
          (data['totalRevenue'] ?? 0)
              .toDouble(),

      status: TripStatus.values.firstWhere(

            (e) =>
        e.name ==
            data['status'],

        orElse: () => TripStatus.draft,
      ),

      createdAt:
          (data['createdAt']
                  as Timestamp?)
              ?.toDate() ??
              DateTime.now(),

      updatedAt:
          (data['updatedAt']
                  as Timestamp?)
              ?.toDate() ??
              DateTime.now(),

      acceptsPackages:
          data['acceptsPackages'] ?? false,

      acceptsWomenOnly:
          data['acceptsWomenOnly'] ?? false,

      airConditioned:
          data['airConditioned'] ?? false,

      petsAllowed:
          data['petsAllowed'] ?? false,

      smokingAllowed:
          data['smokingAllowed'] ?? false,

      musicAllowed:
          data['musicAllowed'] ?? false,

      description:
          data['description'] ?? '',

      passengerIds:
        List<String>.from(
          data['passengerIds'] ?? [],
        ),
    );
  }


  /// ==========================================================================
  /// GETTERS
  /// ==========================================================================

  String get fullRoute =>
      "$departureCity → $destinationCity";

  int get availableSeats =>
      totalSeats - reservedSeats;

  bool get isFull =>
      availableSeats <= 0;

  bool get hasStops =>
      stops.isNotEmpty;

  /*
  bool get isLiveTrackingEnabled =>
      tracking.enabled;

  bool get hasDriverPosition =>
      tracking.currentDriverPosition != null;

   */

  double get occupancyRate {

    if (totalSeats == 0) return 0;

    return reservedSeats / totalSeats;
  }

  double get getRefundedAmount => refundedAmount;

  double get getPendingAmount => pendingAmount;

  double get getTotalPaidAmount => totalPaidAmount;

  double get getTotalRevenue => totalRevenue;

  List<Utilisateur> get getPickupPassengerIds => AdminDataService.streamPickupPassengers(passengerIds);

  String get getCurrentLocationLabel => currentLocationLabel;

  String get getVehicleColor => vehicleColor;

  String get getVehiclePlateNumber => vehiclePlateNumber;

  String get getVehicleModel => vehicleModel;

  double get getCurrentSpeedKmH => currentSpeedKmH;

  bool get isStarted => status == TripStatus.started;

  int get getDriverTripsCount => driverTripsCount;

  TripStatus get getTripStatus => status;

  TripStatus getStatusFromFirestore(String status) {

    switch (status){

      case 'boarding': return TripStatus.boarding;
      case 'cancelled': return TripStatus.cancelled;
      case 'completed': return TripStatus.completed;
      case 'draft': return TripStatus.draft;
      case 'expired': return TripStatus.expired;
      case 'finished': return TripStatus.full;
      case 'paused': return TripStatus.paused;
      case 'scheduled': return TripStatus.published;
      case 'running': return TripStatus.started;
      default: return TripStatus.published;

    }

  }


  String getStatusName(TripStatus statusName) {

    switch (statusName){

      case TripStatus.boarding: return 'Embarquement en cours';
      case TripStatus.cancelled: return 'Annulé';
      case TripStatus.completed: return 'Avis en cours';
      case TripStatus.draft: return 'Brouillon';
      case TripStatus.expired: return 'Expiré';
      case TripStatus.full: return 'Terminé';
      case TripStatus.paused: return "A l'arrêt";
      case TripStatus.published: return 'Programmé';
      case TripStatus.started: return 'En route';
      default: return 'Brouillon';

    }

  }


}

/// ============================================================================
/// ENUMS
/// ============================================================================
enum TripStatus {
  all,
  draft,
  published,
  boarding,
  started,
  paused,
  completed,
  cancelled,
  expired,
  full,
}

enum PassengerTripStatus {
  waiting,
  confirmed,
  boarded,
  onRoute,
  dropped,
  cancelled,
}

enum TrackingMode {
  live,
  paused,
  disabled,
}

enum StopType {
  departure,
  intermediate,
  passengerPickup,
  passengerDropoff,
  rest,
  fuel,
  destination,
}

enum AppNavigationMode {
  map,
  compact,
  voiceOnly,
}

/// ============================================================================
/// GPS POSITION
/// ============================================================================
///
/// Position GPS temps réel.
///
/// Utilisé pour :
///
/// - chauffeur live
/// - passager live
/// - historique GPS
/// - ETA
/// - carte OpenStreetMap
///
/// ============================================================================

class GPSPosition {

  final double latitude;

  final double longitude;

  final double speedKmH;

  final double heading;

  final double accuracy;

  final DateTime timestamp;

  GPSPosition({
    required this.latitude,
    required this.longitude,
    required this.speedKmH,
    required this.heading,
    required this.accuracy,
    required this.timestamp,
  });

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speedKmH': speedKmH,
      'heading': heading,
      'accuracy': accuracy,
      'timestamp': timestamp,
    };
  }

  /// ==========================================================================
  /// FROM JSON
  /// ==========================================================================

  factory GPSPosition.fromJson(
      Map<String, dynamic>? json,
      ) {

    if (json == null) {
      return GPSPosition(
        latitude: 0,
        longitude: 0,
        speedKmH: 0,
        heading: 0,
        accuracy: 0,
        timestamp: DateTime.now(),
      );
    }

    return GPSPosition(
      latitude:
      (json['latitude'] ?? 0).toDouble(),

      longitude:
      (json['longitude'] ?? 0).toDouble(),

      speedKmH:
      (json['speedKmH'] ?? 0).toDouble(),

      heading:
      (json['heading'] ?? 0).toDouble(),

      accuracy:
      (json['accuracy'] ?? 0).toDouble(),

      timestamp:
      (json['timestamp'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),
    );
  }
}

/// ============================================================================
/// STOP / ARRÊT
/// ============================================================================
///
/// Représente un arrêt du trajet.
///
/// Exemple :
///
/// Abidjan → Yamoussoukro
///
/// Arrêts :
///
/// - Yopougon
/// - Adzopé
/// - Toumodi
///
/// ============================================================================

class TripStop {

  /// ID arrêt
  final String id;

  /// Nom affiché
  final String name;

  /// Adresse complète
  final String address;

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;

  /// Ordre dans le trajet
  final int order;

  /// Type arrêt
  final StopType type;

  /// Heure prévue arrivée
  final DateTime? estimatedArrival;

  /// Heure réelle arrivée
  final DateTime? actualArrival;

  /// Temps arrêt minutes
  final int stopDurationMinutes;

  /// Passagers qui montent ici
  final List<String> pickupPassengerIds;

  /// Passagers qui descendent ici
  final List<String> dropoffPassengerIds;

  /// Arrêt déjà passé ?
  final bool passed;

  TripStop({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.order,
    required this.type,
    required this.estimatedArrival,
    required this.actualArrival,
    required this.stopDurationMinutes,
    required this.pickupPassengerIds,
    required this.dropoffPassengerIds,
    required this.passed,
  });

  /// ==========================================================================
  /// GETTERS
  /// ==========================================================================

  bool get isPassed => passed;

  bool get isUpcoming => !passed;

  bool get hasPickupPassengers =>
      pickupPassengerIds.isNotEmpty;

  bool get hasDropoffPassengers =>
      dropoffPassengerIds.isNotEmpty;

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'order': order,
      'type': type.name,
      'estimatedArrival': estimatedArrival,
      'actualArrival': actualArrival,
      'stopDurationMinutes': stopDurationMinutes,
      'pickupPassengerIds': pickupPassengerIds,
      'dropoffPassengerIds': dropoffPassengerIds,
      'passed': passed,
    };
  }

  /// ==========================================================================
  /// FROM JSON
  /// ==========================================================================

  factory TripStop.fromJson(
      Map<String, dynamic>? json,
      ) {

    if (json == null) {
      throw Exception("TripStop null");
    }

    return TripStop(

      id: json['id'] ?? '',

      name: json['name'] ?? '',

      address: json['address'] ?? '',

      latitude:
      (json['latitude'] ?? 0).toDouble(),

      longitude:
      (json['longitude'] ?? 0).toDouble(),

      order: json['order'] ?? 0,

      type: StopType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => StopType.intermediate,
      ),

      estimatedArrival:
      (json['estimatedArrival']
      as Timestamp?)
          ?.toDate(),

      actualArrival:
      (json['actualArrival']
      as Timestamp?)
          ?.toDate(),

      stopDurationMinutes:
      json['stopDurationMinutes'] ?? 0,

      pickupPassengerIds:
      List<String>.from(
        json['pickupPassengerIds'] ?? [],
      ),

      dropoffPassengerIds:
      List<String>.from(
        json['dropoffPassengerIds'] ?? [],
      ),

      passed: json['passed'] ?? false,
    );
  }
}

/// ============================================================================
/// LIVE TRACKING
/// ============================================================================
///
/// Gestion du suivi temps réel.
///
/// ============================================================================

class LiveTrackingData {

  /// Tracking activé ?
  final bool enabled;

  /// Mode tracking
  final TrackingMode mode;

  /// Position actuelle chauffeur
  final GPSPosition? currentDriverPosition;

  /// Historique GPS
  final List<GPSPosition> routeHistory;

  /// Distance restante km
  final double remainingDistanceKm;

  /// Temps restant minutes
  final int remainingDurationMinutes;

  /// Progression %
  final double progress;

  /// ETA globale
  final DateTime? estimatedArrival;

  /// Dernière mise à jour
  final DateTime lastUpdate;

  LiveTrackingData({
    required this.enabled,
    required this.mode,
    required this.currentDriverPosition,
    required this.routeHistory,
    required this.remainingDistanceKm,
    required this.remainingDurationMinutes,
    required this.progress,
    required this.estimatedArrival,
    required this.lastUpdate,
  });

  /// ==========================================================================
  /// GETTERS
  /// ==========================================================================

  bool get isLive =>
      enabled && mode == TrackingMode.live;

  bool get hasDriverPosition =>
      currentDriverPosition != null;

  /// ==========================================================================
  /// TO JSON
  /// ==========================================================================

  Map<String, dynamic> toJson() {
    return {

      'enabled': enabled,

      'mode': mode.name,

      'currentDriverPosition':
      currentDriverPosition?.toJson(),

      'routeHistory':
      routeHistory
          .map((e) => e.toJson())
          .toList(),

      'remainingDistanceKm':
      remainingDistanceKm,

      'remainingDurationMinutes':
      remainingDurationMinutes,

      'progress': progress,

      'estimatedArrival':
      estimatedArrival,

      'lastUpdate':
      lastUpdate,
    };
  }

  /// ==========================================================================
  /// FROM JSON
  /// ==========================================================================

  factory LiveTrackingData.fromJson(
      Map<String, dynamic>? json,
      ) {

    if (json == null) {

      return LiveTrackingData(
        enabled: false,
        mode: TrackingMode.disabled,
        currentDriverPosition: null,
        routeHistory: [],
        remainingDistanceKm: 0,
        remainingDurationMinutes: 0,
        progress: 0,
        estimatedArrival: null,
        lastUpdate: DateTime.now(),
      );
    }

    return LiveTrackingData(

      enabled: json['enabled'] ?? false,

      mode: TrackingMode.values.firstWhere(
            (e) => e.name == json['mode'],
        orElse: () => TrackingMode.disabled,
      ),

      currentDriverPosition:
      json['currentDriverPosition'] != null
          ? GPSPosition.fromJson(
        json['currentDriverPosition'],
      )
          : null,

      routeHistory:
      (json['routeHistory'] as List?)
          ?.map(
            (e) => GPSPosition.fromJson(e),
      )
          .toList() ??
          [],

      remainingDistanceKm:
      (json['remainingDistanceKm'] ?? 0)
          .toDouble(),

      remainingDurationMinutes:
      json['remainingDurationMinutes'] ?? 0,

      progress:
      (json['progress'] ?? 0).toDouble(),

      estimatedArrival:
      (json['estimatedArrival']
      as Timestamp?)
          ?.toDate(),

      lastUpdate:
      (json['lastUpdate']
      as Timestamp?)
          ?.toDate() ??
          DateTime.now(),
    );
  }
}

