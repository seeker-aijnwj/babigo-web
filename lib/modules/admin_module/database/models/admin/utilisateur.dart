import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// =======================================================
/// ENUM : USER ROLE
/// =======================================================
///
/// Définit tous les rôles possibles dans la plateforme.
///
/// Chaque utilisateur appartient à un rôle.
///
/// - admin        -> Administrateur système
/// - support      -> Agent support
/// - passenger    -> Passager
/// - driver       -> Chauffeur
/// - fleetManager -> Gestionnaire de flotte
/// - investor     -> Investisseur
///
enum UserRole {
  admin,
  support,
  passenger,
  driver,
  fleetManager,
  investor,
}

/// =======================================================
/// ENUM : USER STATUS
/// =======================================================
///
/// Définit l’état actuel du compte utilisateur.
///
/// - active   -> utilisateur actif
/// - blocked  -> utilisateur bloqué
/// - pending  -> en attente de validation
/// - deleted  -> supprimé logiquement
///
enum UserStatus {
  active,
  approved,
  blocked,
  pending,
  deleted,
}

/// =======================================================
/// CLASS : UTILISATEUR
/// =======================================================
///
/// Classe principale représentant un utilisateur dans toute l’application BabiGO.
///
/// Cette classe est utilisée pour :
///
/// - Firebase Firestore
/// - UI Desktop
/// - UI Mobile
/// - CRUD
/// - Authentification
/// - Paiements
/// - Réservations
/// - Support
/// - Analytics
///
/// =======================================================
class Utilisateur {
  // =====================================================
  // IDENTIFIANTS
  // =====================================================

  /// ID Firestore
  String id;

  /// Numéro de téléphone
  String phone;

  /// Email utilisateur
  String email;

  /// App Password
  String password;

  // =====================================================
  // AUTRES IDENTIFIANTS
  // =====================================================

  /// UID Firebase Auth
  String? authId;
  
  /// App Custom Id
  String? customId;

  // =====================================================
  // INFORMATIONS PERSONNELLES
  // =====================================================

  /// Prénom
  String firstName;

  /// Nom de famille
  String lastName;

  /// Photo de profil / Avatar
  String photoUrl;

  /// Sexe
  String gender;

  /// Date de naissance
  DateTime? birthDate;

  String bio = "Hello! I'm using U-GO.";

  String location = "Unknown";

  /// Language : en, fr, es, etc.
  String language = "en";

  /// Currency : USD, EUR, XOF, XAF, etc.
  String currency = "USD";

  /// PreferredPaymentMethod : cash, credit_card, orange_money, momo, flooz, etc.
  String preferredPaymentMethod = "credit_card";

  final int loyaltyPoints = 0;

  final bool legalAccepted = true;

  final String referralCode = "REF12345";

  final int totalBookings = 0;

  final int totalReviews = 0;

  /// Current Tier : "Bronze", "Silver", "Gold", "Platinum" etc.
  final String currentTier = "Gold";

  final bool isDriverVerified = false;

  /// Driver status : "online", "offline", "on-trip", "suspended", etc.
  String driverStatus = "offline";

  bool hasDriverLicense = false;

  bool hasDriverProfile = false;

  int profileCompletion;

  DateTime lastActive = DateTime.now();


  // =====================================================
  // LOCALISATION
  // =====================================================

  /// Ville
  String city;

  /// Commune
  String district;

  /// Adresse complète
  String address;

  /// Latitude actuelle
  double? latitude;

  /// Longitude actuelle
  double? longitude;

  // =====================================================
  // ROLE & ETAT
  // =====================================================

  /// Rôle utilisateur
  UserRole role;

  /// Etat du compte / accountStatus
  UserStatus status; // "active", "pending", "blocked"

  /// Compte vérifié ?
  bool isVerified;

  /// KYC validé ?
  bool kycValidated;

  /// Téléphone vérifié ?
  bool phoneVerified;

  /// Email vérifié ?
  bool emailVerified;

  // =====================================================
  // STATISTIQUES
  // =====================================================

  /// Nombre total de trajets
  int totalTrips = 0;

  /// Nombre de trajets complétés
  int completedTrips = 0;

  /// Nombre de trajets annulés
  int canceledTrips = 0;

  /// Note moyenne
  double rating;

  /// Note moyenne
  double ratingCount;

  /// Note moyenne
  double ratingTotal;

  /// Nombre total d’avis
  int reviewCount;

  // =====================================================
  // FINANCES
  // =====================================================

  /// Solde portefeuille
  double walletBalance;

  /// Revenus générés
  double totalEarnings;

  /// Dépenses totales
  double totalSpent;

  // =====================================================
  // DOCUMENTS
  // =====================================================

  /// CNI
  String nationalIdUrl;

  /// Permis de conduire
  String driverLicenseUrl;

  /// Carte grise
  String vehicleDocumentUrl;

  // =====================================================
  // METADATA
  // =====================================================

  /// Date création
  DateTime? createdAt = DateTime.now();

  /// Dernière mise à jour
  DateTime updatedAt = DateTime.now();

  /// Dernière connexion
  DateTime? lastLoginAt = DateTime.now();

  // =====================================================
  // CONSTRUCTEUR
  // =====================================================

  Utilisateur({
    required this.id,
    required this.phone,
    required this.email,
    required this.password,
    required this.updatedAt,
    this.role = UserRole.driver,
    this.isVerified = false,
    this.profileCompletion = 0,
    this.status = UserStatus.pending,
    this.createdAt,
    this.authId,
    this.customId,
    this.firstName = 'Mon Prénom',
    this.lastName = 'Nom de famille',
    this.photoUrl = 'assets/images/avatars/boy.jpg',
    this.gender = 'Masculin',
    this.birthDate,
    this.city = 'Abidjan',
    this.district = 'Grand Abidjan',
    this.address = '',
    this.latitude,
    this.longitude,
    this.kycValidated = false,
    this.phoneVerified = false,
    this.emailVerified = false,
    this.totalTrips = 0,
    this.completedTrips = 0,
    this.canceledTrips = 0,
    this.rating = 0.0,
    this.ratingCount = 0.0,
    this.ratingTotal = 0.0,
    this.reviewCount = 0,
    this.walletBalance = 0.0,
    this.totalEarnings = 0.0,
    this.totalSpent = 0.0,
    this.nationalIdUrl = '',
    this.driverLicenseUrl = '',
    this.vehicleDocumentUrl = '',
    this.lastLoginAt,
  });

  // =====================================================
  // GETTERS
  // =====================================================

  /// Initiales utilisateur
  String get initials {
    if (fullName.isEmpty) return "?";

    final names = fullName.split(" ");

    if (names.length == 1) {
      return names.first[0].toUpperCase();
    }

    return "${names[0][0]}${names[1][0]}".toUpperCase();
  }


  /// Avoir le nom complet de l'utilisateur
  String get fullName => "$lastName $firstName";

  /// Compte bloqué ?
  bool get isSuspended => status == UserStatus.blocked;

  /// Compte approuvé ?
  bool get isApproved => status == UserStatus.approved;

  /// Compte actif ?
  bool get isActived => status == UserStatus.active;

  /// Est-il un chauffeur ?
  bool get isDriver
    => role == UserRole.driver || role == UserRole.support || role == UserRole.admin;

  /// Est-il un administrateur
  bool get isAdmin => role == UserRole.admin;

  /// Est-il un support ?
  bool get isSupport
    => role == UserRole.support || role == UserRole.admin;

  /// Est-il un investisseur ?
  bool get isInvestor
    => role == UserRole.investor || role == UserRole.admin;

  /// Est-il un gestionnaire de flotte ?
  bool get isFleetManager
    => role == UserRole.fleetManager || role == UserRole.support || role == UserRole.admin;

  /// Passager ?
  bool get isPassenger
    => role == UserRole.passenger || role == UserRole.support || role == UserRole.admin;

  /// Profil complété ?
  bool get isProfileComplete {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty;
  }

  /// Get my transactions
  Stream<QuerySnapshot> getMyTransactions(){

    String userId = id;

    return AdminDataService.streamUserTransactions(userId);
  }

  /// Get my wallet
  Future<DocumentSnapshot> getMyWallet(){

    String userId = id;

    return AdminDataService.getWallet(userId);
  }

  // =====================================================
  // SETTERS
  // =====================================================

  set setPhone(String value) {
    phone = value;
  }

  set setEmail(String value) {
    email = value;
  }

  set setPhoto(String value) {
    photoUrl = value;
  }

  set setStatus(UserStatus value) {
    status = value;
  }

  // =====================================================
  // COPY WITH
  // =====================================================

  Utilisateur copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? photoUrl,
    UserRole? role,
    UserStatus? status,
    bool? isVerified,
    int? profileCompletion,
  }) {
    return Utilisateur(
      id: id,
      authId: authId,
      customId: customId,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      gender: gender,
      birthDate: birthDate,
      city: city,
      district: district,
      address: address,
      latitude: latitude,
      longitude: longitude,
      role: role ?? this.role,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      kycValidated: kycValidated,
      phoneVerified: phoneVerified,
      emailVerified: emailVerified,
      totalTrips: totalTrips,
      completedTrips: completedTrips,
      canceledTrips: canceledTrips,
      rating: rating,
      ratingCount: ratingCount,
      ratingTotal: ratingTotal,
      reviewCount: reviewCount,
      walletBalance: walletBalance,
      totalEarnings: totalEarnings,
      totalSpent: totalSpent,
      nationalIdUrl: nationalIdUrl,
      driverLicenseUrl: driverLicenseUrl,
      vehicleDocumentUrl: vehicleDocumentUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      lastLoginAt: lastLoginAt,
    );
  }

  // =====================================================
  // TO JSON
  // =====================================================

  Map<String, dynamic> toJson() {
    return {
      'authId': authId,
      'customId': customId,
      'password': password,
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'gender': gender,
      'birthDate': birthDate,
      'city': city,
      'district': district,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'role': role.name,
      'status': status.name,
      'isVerified': isVerified,
      'kycValidated': kycValidated,
      'phoneVerified': phoneVerified,
      'emailVerified': emailVerified,
      'totalTrips': totalTrips,
      'completedTrips': completedTrips,
      'canceledTrips': canceledTrips,
      'rating': rating,
      'ratingCount': ratingCount,
      'ratingTotal': ratingTotal,
      'reviewCount': reviewCount,
      'walletBalance': walletBalance,
      'totalEarnings': totalEarnings,
      'totalSpent': totalSpent,
      'nationalIdUrl': nationalIdUrl,
      'driverLicenseUrl': driverLicenseUrl,
      'vehicleDocumentUrl': vehicleDocumentUrl,
      'createdAt': Timestamp.fromDate(createdAt!),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': lastLoginAt,
    };
  }

  // =====================================================
  // FROM FIRESTORE
  // =====================================================

  factory Utilisateur.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Utilisateur(
      id: doc.id,
      authId: data['authId'] ?? '',
      customId: data['customId'] ?? '',
      password: data['password'] ?? 'P@ssw0rd',
      firstName: data['prenom'] ?? '',
      lastName: data['nom'] ?? '',
      phone: data['numero'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['avatar'] ?? 'assets/images/avatars/boy.jpg',
      gender: data['gender'] ?? 'Masculin',
      birthDate: (data['birthDate'] as Timestamp?)?.toDate(),
      city: data['city'] ?? 'Abidjan',
      district: data['district'] ?? 'District Autonome d\'Abidjan',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      role: UserRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserRole.passenger,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.name == data['accountStatus'],
        orElse: () => UserStatus.active,
      ),
      isVerified: data['isVerified'] ?? false,
      kycValidated: data['kycValidated'] ?? false,
      phoneVerified: data['phoneVerified'] ?? false,
      emailVerified: data['emailVerified'] ?? false,
      totalTrips: data['totalTrips'] ?? 0,
      completedTrips: data['completedTrips'] ?? 0,
      canceledTrips: data['canceledTrips'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      ratingCount: (data['ratingCount'] ?? 0).toDouble(),
      ratingTotal: (data['ratingTotal'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      walletBalance: (data['walletBalance'] ?? 0).toDouble(),
      totalEarnings: (data['totalEarnings'] ?? 0).toDouble(),
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      nationalIdUrl: data['nationalIdUrl'] ?? '',
      driverLicenseUrl: data['driverLicenseUrl'] ?? '',
      vehicleDocumentUrl: data['vehicleDocumentUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),

      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),

      lastLoginAt:
          (data['lastLoginAt'] as Timestamp?)?.toDate(),
    );
  }
}
