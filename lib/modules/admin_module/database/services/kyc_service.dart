// ============================================================================
// FILE : services/kyc/kyc_service.dart
// ============================================================================
//
// BabiGO KYC Service
//
// Gère :
//
// - Vérification d'identité
// - Vérification conducteur
// - Vérification flotte
// - Vérification documents
// - Validation Admin
// - Refus Admin
// - Historique
// - Firebase Storage
// - Firestore
//
// ============================================================================

import 'dart:io';

import 'package:babigo/modules/admin_module/database/services/admin_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../app/core/utils/constants.dart';

/// ============================================================================
/// ENUM
/// ============================================================================

enum KycStatus {
  notStarted,
  pending,
  underReview,
  approved,
  rejected,
  expired,
}

enum KycStep {
  identity,
  selfie,
  driverLicense,
  vehicleDocuments,
  fleetDocuments,
}

enum VerificationType {
  passenger,
  driver,
  fleetManager,
}

/// ============================================================================
/// MODEL
/// ============================================================================

class KycSubmission {

  final String id;

  final String userId;

  final VerificationType type;

  final KycStatus status;

  final DateTime submittedAt;

  final DateTime? reviewedAt;

  final String? reviewedBy;

  final String? rejectionReason;

  final Map<String, dynamic> documents;

  const KycSubmission({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
    required this.documents,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type.name,
      'status': status.name,
      'submittedAt': submittedAt,
      'reviewedAt': reviewedAt,
      'reviewedBy': reviewedBy,
      'rejectionReason': rejectionReason,
      'documents': documents,
    };
  }

  factory KycSubmission.fromFirestore(
      DocumentSnapshot doc,
      ) {
    final data =
    doc.data() as Map<String, dynamic>;

    return KycSubmission(
      id: doc.id,
      userId: data['userId'],
      type: VerificationType.values.firstWhere(
            (e) => e.name == data['type'],
      ),
      status: KycStatus.values.firstWhere(
            (e) => e.name == data['status'],
      ),
      submittedAt:
      (data['submittedAt'] as Timestamp)
          .toDate(),
      reviewedAt:
      (data['reviewedAt'] as Timestamp?)
          ?.toDate(),
      reviewedBy: data['reviewedBy'],
      rejectionReason:
      data['rejectionReason'],
      documents:
      Map<String, dynamic>.from(
        data['documents'] ?? {},
      ),
    );
  }
}

/// ============================================================================
/// SERVICE
/// ============================================================================

class KycService {

  KycService();

  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  /// ==========================================================================
  /// COLLECTIONS
  /// ==========================================================================

  CollectionReference<Map<String, dynamic>>
  get _kycCollection => Utils.db.collection('kyc');

  /// ==========================================================================
  /// UPLOAD DOCUMENT
  /// ==========================================================================

  Future<String> uploadDocument({
    required String userId,
    required File file,
    required String folder,
  }) async {

    final fileName =
    DateTime.now()
        .millisecondsSinceEpoch
        .toString();

    final ref = _storage
        .ref()
        .child(
      'kyc/$userId/$folder/$fileName',
    );

    await ref.putFile(file);

    return ref.getDownloadURL();
  }

  /// ==========================================================================
  /// SUBMIT IDENTITY
  /// ==========================================================================
  Future<void> submitIdentityVerification({
    required String userId,
    required File identityDocument,
    required File selfie,
  }) async {

    final identityUrl =
    await uploadDocument(
      userId: userId,
      file: identityDocument,
      folder: 'identity',
    );

    final selfieUrl =
    await uploadDocument(
      userId: userId,
      file: selfie,
      folder: 'selfie',
    );

    await _kycCollection.doc(userId).set({

      'userId': userId,

      'type':
      VerificationType.passenger.name,

      'status':
      KycStatus.pending.name,

      'submittedAt':
      FieldValue.serverTimestamp(),

      'documents': {

        'identityDocument':
        identityUrl,

        'selfie':
        selfieUrl,
      },
    });
  }

  /// ==========================================================================
  /// SUBMIT DRIVER
  /// ==========================================================================
  Future<void> submitDriverVerification({
    required String userId,
    required File identityDocument,
    required File selfie,
    required File driverLicense,
  }) async {

    final identityUrl =
    await uploadDocument(
      userId: userId,
      file: identityDocument,
      folder: 'identity',
    );

    final selfieUrl =
    await uploadDocument(
      userId: userId,
      file: selfie,
      folder: 'selfie',
    );

    final licenseUrl =
    await uploadDocument(
      userId: userId,
      file: driverLicense,
      folder: 'driver_license',
    );

    await _kycCollection.doc(userId).set({

      'userId': userId,

      'type':
      VerificationType.driver.name,

      'status':
      KycStatus.pending.name,

      'submittedAt':
      FieldValue.serverTimestamp(),

      'documents': {

        'identity':
        identityUrl,

        'selfie':
        selfieUrl,

        'driverLicense':
        licenseUrl,
      },
    });
  }

  /// ==========================================================================
  /// SUBMIT FLEET
  /// ==========================================================================
  Future<void> submitFleetVerification({
    required String userId,
    required List<String> documents,
  }) async {

    await _kycCollection.doc(userId).set({

      'userId': userId,

      'type':
      VerificationType.fleetManager.name,

      'status':
      KycStatus.pending.name,

      'submittedAt':
      FieldValue.serverTimestamp(),

      'documents': documents,
    });
  }

  /// ==========================================================================
  /// APPROVE
  /// ==========================================================================
  Future<void> approve({
    required String userId,
    required String adminId,
  }) async {

    await _kycCollection.doc(userId).update({

      'status':
      KycStatus.approved.name,

      'reviewedAt':
      FieldValue.serverTimestamp(),

      'reviewedBy':
      adminId,
    });

    await AdminDataService.usersRef
        .doc(userId)
        .update({

      'isVerified': true,

      'kycStatus':
      KycStatus.approved.name,
    });
  }

  /// ==========================================================================
  /// REJECT
  /// ==========================================================================
  Future<void> reject({
    required String userId,
    required String adminId,
    required String reason,
  }) async {

    await _kycCollection.doc(userId).update({

      'status': KycStatus.rejected.name,

      'reviewedAt': FieldValue.serverTimestamp(),

      'reviewedBy': adminId,

      'rejectionReason': reason,
    });

    await AdminDataService.usersRef
        .doc(userId)
        .update({

      'isVerified': false,

      'kycStatus':
      KycStatus.rejected.name,
    });
  }

  /// ==========================================================================
  /// GET STATUS
  /// ==========================================================================
  Future<KycStatus> getStatus(
      String userId,
      ) async {

    final doc = await _kycCollection
        .doc(userId)
        .get();

    if (!doc.exists) {
      return KycStatus.notStarted;
    }

    final data = doc.data()!;

    return KycStatus.values.firstWhere(
          (e) =>
      e.name ==
          data['status'],
      orElse: () =>
      KycStatus.notStarted,
    );
  }

  /// ==========================================================================
  /// STREAM STATUS
  /// ==========================================================================
  Stream<KycSubmission?> streamKyc(
      String userId,
      ) {

    return _kycCollection
        .doc(userId)
        .snapshots()
        .map((snapshot) {

      if (!snapshot.exists) {
        return null;
      }

      return KycSubmission
          .fromFirestore(snapshot);
    });
  }

  /// ==========================================================================
  /// DELETE KYC
  /// ==========================================================================

  Future<void> deleteKyc(
      String userId,
      ) async {

    await _kycCollection
        .doc(userId)
        .delete();
  }
}