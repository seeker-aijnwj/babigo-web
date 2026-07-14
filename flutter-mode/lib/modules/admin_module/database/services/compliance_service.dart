// ============================================================================
// FILE : services/compliance/compliance_service.dart
// ============================================================================
//
// BabiGO Compliance Service
//
// Vérifie :
//
// • Utilisateur
// • Conducteur
// • Gestionnaire de flotte
// • Véhicule
// • Documents
// • Assurance
// • Visite technique
// • KYC
//
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../app/database/models/vehicle.dart';
import '../../database/models/admin/utilisateur.dart';
import 'kyc_service.dart';

/// ============================================================================
/// ENUMS
/// ============================================================================

enum ComplianceStatus {
  compliant,
  warning,
  blocked,
}

enum ComplianceViolationType {
  missingIdentity,

  missingDriverLicense,

  vehicleInsuranceExpired,

  technicalInspectionExpired,

  accountSuspended,

  kycRejected,

  kycMissing,

  vehicleInactive,

  fleetNotVerified,

  missingVehicleDocuments,

  tooManyIncidents,

  lowRating,
}

/// ============================================================================
/// VIOLATION
/// ============================================================================

class ComplianceViolation {

  final ComplianceViolationType type;

  final String title;

  final String description;

  final bool blocking;

  const ComplianceViolation({
    required this.type,
    required this.title,
    required this.description,
    required this.blocking,
  });
}

/// ============================================================================
/// REPORT
/// ============================================================================

class ComplianceReport {

  final ComplianceStatus status;

  final int score;

  final List<ComplianceViolation> violations;

  const ComplianceReport({
    required this.status,
    required this.score,
    required this.violations,
  });

  bool get isCompliant =>
      status == ComplianceStatus.compliant;

  bool get isBlocked =>
      status == ComplianceStatus.blocked;

  bool get hasViolations =>
      violations.isNotEmpty;
}

/// ============================================================================
/// SERVICE
/// ============================================================================

class ComplianceService {

  ComplianceService();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final KycService _kycService =
  KycService();

  // ===========================================================================
  // USER COMPLIANCE
  // ===========================================================================

  Future<ComplianceReport> checkUserCompliance(
      Utilisateur user,
      ) async {

    final violations =
    <ComplianceViolation>[];

    int score = 100;

    /// KYC

    final kycStatus =
    await _kycService.getStatus(
      user.id,
    );

    if (kycStatus ==
        KycStatus.notStarted) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .kycMissing,
          title:
          "Vérification non effectuée",
          description:
          "Votre identité n'a pas encore été vérifiée.",
          blocking: true,
        ),
      );

      score -= 40;
    }

    if (kycStatus == KycStatus.rejected) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .kycRejected,
          title:
          "Vérification refusée",
          description:
          "Votre dossier KYC a été rejeté.",
          blocking: true,
        ),
      );

      score -= 50;
    }

    if (user.isSuspended) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .accountSuspended,
          title:
          "Compte suspendu",
          description:
          "Votre compte est suspendu.",
          blocking: true,
        ),
      );

      score -= 100;
    }

    return _buildReport(
      score,
      violations,
    );
  }

  // ===========================================================================
  // DRIVER COMPLIANCE
  // ===========================================================================

  Future<ComplianceReport> checkDriverCompliance({
    required Utilisateur driver,
    required Vehicle vehicle,
  }) async {

    final violations =
    <ComplianceViolation>[];

    int score = 100;

    final userReport =
    await checkUserCompliance(
      driver,
    );

    violations.addAll(
      userReport.violations,
    );

    score -=
    (100 - userReport.score);

    if (driver.rating < 3) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .lowRating,
          title:
          "Note insuffisante",
          description:
          "Votre note moyenne est trop faible.",
          blocking: false,
        ),
      );

      score -= 10;
    }

    final vehicleReport =
    await checkVehicleCompliance(
      vehicle,
    );

    violations.addAll(
      vehicleReport.violations,
    );

    score -=
    (100 - vehicleReport.score);

    return _buildReport(
      score.clamp(0, 100),
      violations,
    );
  }

  // ===========================================================================
  // VEHICLE COMPLIANCE
  // ===========================================================================

  Future<ComplianceReport> checkVehicleCompliance(
      Vehicle vehicle,
      ) async {

    final violations =
    <ComplianceViolation>[];

    int score = 100;

    if (!vehicle.active) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .vehicleInactive,
          title:
          "Véhicule inactif",
          description:
          "Ce véhicule est désactivé.",
          blocking: true,
        ),
      );

      score -= 40;
    }

    if (vehicle.insuranceExpired) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .vehicleInsuranceExpired,
          title:
          "Assurance expirée",
          description:
          "Le véhicule n'est plus assuré.",
          blocking: true,
        ),
      );

      score -= 40;
    }

    if (vehicle
        .technicalInspectionExpired) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .technicalInspectionExpired,
          title:
          "Visite technique expirée",
          description:
          "La visite technique est expirée.",
          blocking: true,
        ),
      );

      score -= 30;
    }

    if (!vehicle.hasDocuments) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .missingVehicleDocuments,
          title:
          "Documents manquants",
          description:
          "Le véhicule ne possède aucun document.",
          blocking: true,
        ),
      );

      score -= 30;
    }

    if (vehicle.incidents.length >
        10) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .tooManyIncidents,
          title:
          "Incidents nombreux",
          description:
          "Le véhicule présente trop d'incidents.",
          blocking: false,
        ),
      );

      score -= 10;
    }

    return _buildReport(
      score.clamp(0, 100),
      violations,
    );
  }

  // ===========================================================================
  // FLEET COMPLIANCE
  // ===========================================================================

  Future<ComplianceReport>
  checkFleetCompliance({
    required String fleetId,
  }) async {

    final violations =
    <ComplianceViolation>[];

    int score = 100;

    final fleetDoc =
    await _firestore
        .collection('fleets')
        .doc(fleetId)
        .get();

    if (!fleetDoc.exists) {

      violations.add(
        const ComplianceViolation(
          type:
          ComplianceViolationType
              .fleetNotVerified,
          title:
          "Flotte introuvable",
          description:
          "La flotte n'existe pas.",
          blocking: true,
        ),
      );

      score = 0;
    }

    return _buildReport(
      score,
      violations,
    );
  }

  // ===========================================================================
  // GLOBAL ELIGIBILITY
  // ===========================================================================

  Future<bool> canAcceptTrip({
    required Utilisateur driver,
    required Vehicle vehicle,
  }) async {

    final report =
    await checkDriverCompliance(
      driver: driver,
      vehicle: vehicle,
    );

    return !report.isBlocked;
  }

  // ===========================================================================
  // REPORT BUILDER
  // ===========================================================================

  ComplianceReport _buildReport(
      int score,
      List<ComplianceViolation>
      violations,
      ) {

    final blocking =
    violations.any(
          (e) => e.blocking,
    );

    if (blocking) {

      return ComplianceReport(
        status:
        ComplianceStatus.blocked,
        score: score,
        violations: violations,
      );
    }

    if (violations.isNotEmpty) {

      return ComplianceReport(
        status:
        ComplianceStatus.warning,
        score: score,
        violations: violations,
      );
    }

    return ComplianceReport(
      status:
      ComplianceStatus.compliant,
      score: score,
      violations: const [],
    );
  }

  // ===========================================================================
  // STREAM USER COMPLIANCE
  // ===========================================================================

  Stream<DocumentSnapshot<Map<String, dynamic>>>
  watchUserCompliance(
      String uid,
      ) {

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots();
  }
}