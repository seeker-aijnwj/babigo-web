import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification.dart';

/// ===============================================================
/// ANNOUNCEMENT MODEL
/// ===============================================================
///
/// OBJECTIF
/// ---------
///
/// Cette classe représente :
///
/// ✅ une annonce publiée dans l'application
/// ✅ une publicité
/// ✅ une promotion
/// ✅ une communication système
/// ✅ une annonce de trajet
/// ✅ une annonce administrative
/// ✅ une alerte de sécurité
/// ✅ une information conducteur/passager
///
/// Compatible avec :
///
/// ✅ Firebase Firestore
/// ✅ Flutter Mobile
/// ✅ Flutter Desktop
/// ✅ Flutter Web
///
/// ===============================================================


/// ===============================================================
/// CLASSE PRINCIPALE
/// ===============================================================

class Announcement{

  /// =============================================================
  /// IDENTIFIANTS
  /// =============================================================

  /// Identifiant
  final String id;

  /// Identifiant du conducteur
  final String? driverId;

  /// Identifiant de l'annonce
  final String? tripId;

  /// STATUT
  PublicationStatus status;

  /// TYPE
  PublicationType type;

  /// =============================================================
  /// DESCRIPTION COURTE
  /// =============================================================

  String shortDescription;

  /// =============================================================
  /// DESCRIPTION COMPLÈTE
  /// =============================================================

  String description;

  /// Nombre de places du véhicule
  int? seats;

  /// Numéro de l'annonce
  String? announceNumber;

  /// Nombre de réservations
  int? reservedCount;

  /// =============================================================
  /// IMAGE PRINCIPALE
  /// =============================================================

  String imageUrl;

  /// DATE DE CREATION
  DateTime? createdAt;

  /// DATE DE PUBLICATION
  DateTime? publishedAt;

  /// DATE DE MISE A JOUR
  DateTime? updatedAt;

  /// =============================================================
  /// AUTEUR
  /// =============================================================

  String authorId;

  String authorName;

  /// =============================================================
  /// CIBLE
  /// =============================================================

  /// Exemple :
  ///
  /// - passagers
  /// - chauffeurs
  /// - tous
  /// - support
  /// - flotte
  /// - administrateurs et super administrateurs
  ///
  String targetAudience;

  /// PRIORITÉ
  int priority;

  /// TAGS
  List<String> tags;

  /// VUES
  int views;

  /// LIKES
  int likes;

  /// COMMENTAIRES
  int commentsCount;

  /// EST ÉPINGLÉ
  bool isPinned;

  /// EST IMPORTANT
  bool isImportant;

  /// EST ACTIF
  bool isActive;

  /// URL D'ACTION
  String actionUrl;

  /// TEXTE DU BOUTON
  String actionText;

  /// =============================================================
  /// CONSTRUCTEUR
  /// =============================================================

  Announcement({

    required this.id,

    required this.status,

    required this.type,

    required this.shortDescription,

    required this.description,

    required this.imageUrl,

    this.publishedAt,

    required this.authorId,

    required this.authorName,

    required this.targetAudience,

    required this.priority,

    required this.tags,

    required this.views,

    required this.likes,

    required this.commentsCount,

    required this.isPinned,

    required this.isImportant,

    required this.isActive,

    required this.actionUrl,

    required this.actionText,

    required this.tripId,

    this.driverId,

    this.announceNumber,

    this.seats,

    this.reservedCount,

    this.updatedAt,

    this.createdAt,
  });

  /// =============================================================
  /// EMPTY
  /// =============================================================
  factory Announcement.empty() {

    return Announcement(

      id: '',

      driverId: '',

      tripId: '',

      announceNumber: '',

      type: PublicationType.announce,

      shortDescription: '',

      description: '',

      imageUrl: '',

      publishedAt: null,

      authorId: '',

      authorName: '',

      targetAudience: 'tous',

      priority: 0,

      tags: [],

      views: 0,

      likes: 0,

      commentsCount: 0,

      isPinned: false,

      isImportant: false,

      isActive: true,

      actionUrl: '',

      actionText: '',

      seats: 0,

      reservedCount: 0,

      status: PublicationStatus.draft,

      updatedAt: DateTime.now(),

    );
  }

  /// =============================================================
  /// FROM JSON
  /// =============================================================
  factory Announcement.fromJson(
      Map<String, dynamic> json,
      ) {

    return Announcement(

      id: json['id'] ?? '',

      driverId: json['driverId'] ?? '',

      announceNumber: json['announceNumber'] ?? '',

      tripId: json['tripId'] ?? 0,

      reservedCount: json['reservedCount'] ?? 0,

      updatedAt: (json['updatedAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      createdAt: (json['createdAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      seats: json['seats'] ?? 0,

      shortDescription: json['shortDescription'] ?? '',

      description: json['description'] ?? '',

      imageUrl: json['imageUrl'] ?? '',

      type: PublicationType.values.firstWhere(

            (e) =>
        e.name ==
            json['type'],

        orElse: () => PublicationType.announce,
      ),

      status: PublicationStatus.values.firstWhere(

            (e) =>
        e.name ==
            json['status'],

        orElse: () => PublicationStatus.draft,
      ),

      publishedAt: (json['publishedAt'] as Timestamp?)
          ?.toDate(),

      authorId: json['authorId'] ?? '',

      authorName: json['authorName'] ?? '',

      targetAudience: json['targetAudience'] ?? 'tous',

      priority: json['priority'] ?? 0,

      tags: List<String>.from(
        json['tags'] ?? [],
      ),

      views: json['views'] ?? 0,

      likes: json['likes'] ?? 0,

      commentsCount: json['commentsCount'] ?? 0,

      isPinned: json['isPinned'] ?? false,

      isImportant: json['isImportant'] ?? false,

      isActive: json['isActive'] ?? true,

      actionUrl: json['actionUrl'] ?? '',

      actionText: json['actionText'] ?? '',

    );
  }

  /// =============================================================
  /// GET DATA FROM FIRESTORE
  /// =============================================================
  factory Announcement.getAnnounceReservationData(DocumentSnapshot doc) {

    final data =
    doc.data() as Map<String, dynamic>;

    return Announcement(

      id: doc.id,

      announceNumber:  data['announceNumber'] ?? '',

      driverId:  data['driverId'] ?? '',

      tripId: data['tripId'] ?? '',

      reservedCount: data['reservedCount'] ?? 0,

      seats: data['seats'] ?? 0,

      updatedAt: (data['updatedAt'] as Timestamp?)
          ?.toDate() ??
          DateTime.now(),

      type: PublicationType.values.firstWhere(

            (e) =>
        e.name ==
            data['type'],

        orElse: () =>
        PublicationType.information,
      ),

      status: PublicationStatus.values.firstWhere(

            (e) =>
        e.name ==
            data['status'],

        orElse: () =>
        PublicationStatus.draft,
      ),

      shortDescription: '',

      description: '',

      imageUrl: '',

      authorId: '',

      authorName: '',

      targetAudience: '',

      priority: data['priority'] ?? 0,

      tags: [],

      views: data['views'] ?? 0,

      likes: data['likes'] ?? 0,

      commentsCount: data['commentsCount'] ?? 0,

      isPinned: false,

      isImportant: false,

      isActive: false,

      actionUrl: data['actionUrl'] ?? '',

      actionText: data['actionText'] ?? '',

    );
  }



  /// =============================================================
  /// TO JSON
  /// =============================================================

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'shortDescription': shortDescription,

      'description': description,

      'imageUrl': imageUrl,

      'status': status.name,

      'publishedAt': publishedAt != null
          ? Timestamp.fromDate(
        publishedAt!,
      )
          : null,

      'authorId': authorId,

      'authorName': authorName,

      'targetAudience': targetAudience,

      'priority': priority,

      'tags': tags,

      'views': views,

      'likes': likes,

      'commentsCount': commentsCount,

      'isPinned': isPinned,

      'isImportant': isImportant,

      'isActive': isActive,

      'actionUrl': actionUrl,

      'actionText': actionText,
    };
  }

  /// =============================================================
  /// COPY WITH
  /// =============================================================

  Announcement copyWith({

    String? driverId,

    String? tripId,

    String? authorId,

    String? authorName,

    String? announceNumber,

    String? shortDescription,

    String? description,

    String? imageUrl,

    PublicationType? type,

    PublicationStatus? status,

    DateTime? updatedAt,

    DateTime? publishedAt,

    String? targetAudience,

    int? priority,

    List<String>? tags,

    int? views,

    int? likes,

    int? commentsCount,

    bool? isPinned,

    bool? isImportant,

    bool? isActive,

    String? actionUrl,

    String? actionText,

    int? seats,

    int? reservedCount,
  }) {

    return Announcement(

      id: id,

      driverId: driverId ?? this.driverId,

      tripId: tripId,

      announceNumber: announceNumber ?? this.announceNumber,

      type: type ?? this.type,

      shortDescription: shortDescription ?? this.shortDescription,

      description: description ?? this.description,

      seats: seats ?? this.seats,

      reservedCount: reservedCount ?? this.reservedCount,

      imageUrl: imageUrl ?? this.imageUrl,

      publishedAt: publishedAt ?? this.publishedAt,

      authorId: authorId ?? this.authorId,

      authorName: authorName ?? this.authorName,

      targetAudience: targetAudience ?? this.targetAudience,

      priority: priority ?? this.priority,

      tags: tags ?? this.tags,

      views: views ?? this.views,

      likes: likes ?? this.likes,

      commentsCount: commentsCount ?? this.commentsCount,

      isPinned: isPinned ?? this.isPinned,

      isImportant: isImportant ?? this.isImportant,

      isActive: isActive ?? this.isActive,

      actionUrl: actionUrl ?? this.actionUrl,

      actionText: actionText ?? this.actionText,

      status: status ?? this.status,

      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// =============================================================
  /// GETTERS
  /// =============================================================

  bool get isPublished =>
      status ==
          PublicationStatus.published;

  bool get isDraft =>
      status ==
          PublicationStatus.draft;

  bool get isArchived =>
      status ==
          PublicationStatus.archived;

  bool get hasImage =>
      imageUrl.isNotEmpty;

  bool get hasAction =>
      actionUrl.isNotEmpty;

  bool get isPromotion =>
      type ==
          PublicationType.promotion;

  bool get isAlert =>
      type ==
          PublicationType.alert;

  bool get formattedViews =>
      views > 999;

  /// =============================================================
  /// ACTIONS
  /// =============================================================

  void incrementViews() {
    views++;
  }

  void incrementLikes() {
    likes++;
  }

  void incrementComments() {
    commentsCount++;
  }

  void publish() {

    status =
        PublicationStatus.published;

    publishedAt = DateTime.now();

    updatedAt = DateTime.now();
  }

  void archive() {

    status =
        PublicationStatus.archived;

    updatedAt = DateTime.now();
  }

  void deactivate() {

    isActive = false;

    updatedAt = DateTime.now();
  }

  void activate() {

    isActive = true;

    updatedAt = DateTime.now();
  }

  /// =============================================================
  /// DEBUG
  /// =============================================================

  @override
  String toString() {

    return '''
    Announcement(
      id: $id,
      title: $announceNumber,
      type: ${type.name},
      status: ${status.name}
    )
    ''';
  }
}
