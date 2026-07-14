// ============================================================================
// FILE : auth/guards/role_guard.dart
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../app/core/utils/session_manager.dart';
import '../../database/models/admin/utilisateur.dart';

import '../screens/unauthorized_screen.dart';

/// ============================================================================
/// ROLE GUARD
/// ============================================================================
///
/// Il pose cette question à l'utilisateur : Qui es-tu ?
/// Vérifie que l'utilisateur possède un rôle autorisé.
///
/// Exemple :
///
/// RoleGuard(
///   allowedRoles: [UserRole.driver],
///   child: DriverDashboard(),
/// )
///
/// Exemples d'utilisation
///
/// RoleGuard(
///
///   allowedRoles: const [
///     UserRole.driver,
///   ],
///
///   child: DriverDashboardScreen(),
/// );
///
/// RoleGuard(
///
///   allowedRoles: const [
///     UserRole.fleetManager,
///   ],
///
///   child: FleetDashboardScreen(),
/// );
///
/// RoleGuard(
///
///   allowedRoles: const [
///     UserRole.passenger,
///   ],
///
///   child: PassengerHomeScreen(),
/// );
///
/// RoleGuard(
///
///   allowedRoles: const [
///
///     UserRole.driver,
///
///     UserRole.fleetManager,
///   ],
///
///   child: VehicleManagementScreen(),
/// );
///
///
/// ============================================================================

class RoleGuard extends StatelessWidget {

  final Widget child;

  final List<UserRole> allowedRoles;

  const RoleGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
  });

  @override
  Widget build(BuildContext context) {

    final session = SessionManager.instance;

    final user = session.currentUser;

    // ========================================================================
    // PAS D'UTILISATEUR
    // ========================================================================

    if (user == null) {

      return const UnauthorizedScreen(
        reason: "Utilisateur introuvable",
      );
    }

    // ========================================================================
    // ADMIN = ACCÈS TOTAL
    // ========================================================================

    if (user.role == UserRole.admin) {

      return child;
    }

    // ========================================================================
    // ROLE AUTORISÉ
    // ========================================================================

    if (allowedRoles.contains(
      user.role,
    )) {

      return child;
    }

    // ========================================================================
    // REFUS
    // ========================================================================

    return UnauthorizedScreen(
      reason:
      "Vous n'avez pas l'autorisation d'accéder à cette section.",
    );
  }
}