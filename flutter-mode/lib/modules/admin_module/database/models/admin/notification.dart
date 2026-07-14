import 'package:cloud_firestore/cloud_firestore.dart';

/// =============================================================================
/// MODEL : APP NOTIFICATION
/// =============================================================================


class AppNotification {
  /// ===========================================================================
  /// ID
  /// ===========================================================================

  final String id;

  /// ===========================================================================
  /// DATES
  /// ===========================================================================

  final DateTime createdAt;
  final DateTime updatedAt;

  /// ===========================================================================
  /// MESSAGE
  /// ===========================================================================

  final String message;

  /// ===========================================================================
  /// PAYLOAD
  /// ===========================================================================

  final Map<String, dynamic> payload;

  /// ===========================================================================
  /// ÉTAT
  /// ===========================================================================

  final bool isRead;

  /// ===========================================================================
  /// TITRE
  /// ===========================================================================

  final String title;

  /// ===========================================================================
  /// TRAJET LIÉ
  /// ===========================================================================

  final String tripId;

  /// ===========================================================================
  /// UTILISATEUR
  /// ===========================================================================

  final String userId;

  /// ===========================================================================
  /// TYPE PUBLICATION
  /// ===========================================================================

  final PublicationType type;

  /// ===========================================================================
  /// TYPE NOTIFICATION
  /// ===========================================================================

  final NotificationType notifType;

  /// ===========================================================================
  /// EXPÉDITEUR
  /// ===========================================================================

  final String senderName;

  /// ===========================================================================
  /// CONSTRUCTEUR
  /// ===========================================================================

  AppNotification({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.message,
    required this.payload,
    required this.isRead,
    required this.title,
    required this.tripId,
    required this.userId,
    required this.type,
    required this.notifType,
    required this.senderName,
  });

  /// ===========================================================================
  /// FIRESTORE -> MODEL
  /// ===========================================================================

  factory AppNotification.fromFirestore(
      DocumentSnapshot doc,
      ) {
    final data =
    doc.data() as Map<String, dynamic>;

    return AppNotification(
      id: doc.id,

      createdAt:
      (data['createdAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      updatedAt:
      (data['updatedAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      message: data['message'] ?? '',

      payload:
      Map<String, dynamic>.from(
        data['payload'] ?? {},
      ),

      isRead: data['isRead'] ?? false,

      title: data['title'] ?? '',

      tripId: data['tripId'] ?? '',

      userId: data['userId'] ?? '',

      type: PublicationType.notification,

      notifType:
      NotificationTypeExtension
          .fromString(
        data['notifType'],
      ),

      senderName:
      data['senderName'] ?? 'Unknown',
    );
  }

  /// ===========================================================================
  /// MODEL -> FIRESTORE
  /// ===========================================================================

  Map<String, dynamic> toJson() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),

      'updatedAt': Timestamp.fromDate(updatedAt),

      'message': message,

      'payload': payload,

      'isRead': isRead,

      'title': title,

      'tripId': tripId,

      'userId': userId,

      'type': type.name,

      'notifType':
      notifType.firestoreValue,

      'senderName': senderName,
    };
  }
}

PublicationStatus getStatusFromFirestore(String status) {

  switch (status){

    case 'draft': return PublicationStatus.draft;
    case 'published': return PublicationStatus.published;
    case 'archived': return PublicationStatus.archived;
    case 'deleted': return PublicationStatus.deleted;
    default: return PublicationStatus.draft;

  }

}

class PassengerReservation extends Publication {

  int pickupIndex;
  String pickupStop;
  int dropoffIndex;
  String dropoffStop;
  String passengerId;
  DateTime canceledAt;
  String statut;
  List<String> stops;


  PassengerReservation({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.type,
    required this.passengerId,
    required this.canceledAt,
    required this.pickupIndex,
    required this.pickupStop,
    required this.dropoffIndex,
    required this.dropoffStop,
    required this.statut,
    required this.stops,
  });

}


class Publication {

  /// IDENTIFIANT DE LA PUBLICATION
  final String id;

  /// DATE DE CRÉATION
  DateTime createdAt;

  /// DATE DE MISE À JOUR
  DateTime updatedAt;

  /// TYPE
  PublicationType type;


  /// =============================================================
  /// CONSTRUCTEUR
  /// =============================================================
  Publication({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

}

/// =============================================================================
/// TYPE DE PUBLICATION
/// =============================================================================

enum PublicationType {
  /// Annonce
  announcement,

  /// Système
  system,
  /// Promotion commerciale
  promotion,

  /// Information système
  information,

  /// Alerte sécurité
  alert,

  /// Notification
  notification,

  /// Annonce
  announce,

  /// Réservation
  reservation,

  /// Annonce trajet
  trip,

  /// Maintenance
  maintenance,

  /// Publicité partenaire
  partner,

  /// Mise à jour application
  update,
}

/// ===============================================================
/// STATUT D'ANNONCE
/// ===============================================================

enum PublicationStatus {

  /// Brouillon
  draft,

  /// Publié
  published,

  /// Archivé
  archived,

  /// Supprimé
  deleted,
}


/// =============================================================================
/// TYPES DE NOTIFICATION
/// =============================================================================

enum NotificationType {
  tripInProgress,
  tripStarted,
  tripCompleted,
  tripCancelled,
  newReservation,
  paymentReceived,
  walletUpdated,
  systemAlert,
  accountBlocked,
  accountActivated,
}

/// =============================================================================
/// EXTENSION : LABELS
/// =============================================================================

extension NotificationTypeExtension on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.tripInProgress:
        return "Trajet en cours";

      case NotificationType.tripStarted:
        return "Trajet démarré";

      case NotificationType.tripCompleted:
        return "Trajet terminé";

      case NotificationType.tripCancelled:
        return "Trajet annulé";

      case NotificationType.newReservation:
        return "Nouvelle réservation";

      case NotificationType.paymentReceived:
        return "Paiement reçu";

      case NotificationType.walletUpdated:
        return "Wallet mis à jour";

      case NotificationType.systemAlert:
        return "Alerte système";

      case NotificationType.accountBlocked:
        return "Compte bloqué";

      case NotificationType.accountActivated:
        return "Compte activé";
    }
  }

  String get firestoreValue {
    switch (this) {
      case NotificationType.tripInProgress:
        return "TRIP_IN_PROGRESS";

      case NotificationType.tripStarted:
        return "TRIP_STARTED";

      case NotificationType.tripCompleted:
        return "TRIP_COMPLETED";

      case NotificationType.tripCancelled:
        return "TRIP_CANCELLED";

      case NotificationType.newReservation:
        return "NEW_RESERVATION";

      case NotificationType.paymentReceived:
        return "PAYMENT_RECEIVED";

      case NotificationType.walletUpdated:
        return "WALLET_UPDATED";

      case NotificationType.systemAlert:
        return "SYSTEM_ALERT";

      case NotificationType.accountBlocked:
        return "ACCOUNT_BLOCKED";

      case NotificationType.accountActivated:
        return "ACCOUNT_ACTIVATED";
    }
  }

  static NotificationType fromString(String? value) {
    switch (value) {
      case 'TRIP_STARTED':
        return NotificationType.tripStarted;

      case 'TRIP_COMPLETED':
        return NotificationType.tripCompleted;

      case 'TRIP_CANCELLED':
        return NotificationType.tripCancelled;

      case 'NEW_RESERVATION':
        return NotificationType.newReservation;

      case 'PAYMENT_RECEIVED':
        return NotificationType.paymentReceived;

      case 'WALLET_UPDATED':
        return NotificationType.walletUpdated;

      case 'SYSTEM_ALERT':
        return NotificationType.systemAlert;

      case 'ACCOUNT_BLOCKED':
        return NotificationType.accountBlocked;

      case 'ACCOUNT_ACTIVATED':
        return NotificationType.accountActivated;

      default:
        return NotificationType.tripInProgress;
    }
  }
}
