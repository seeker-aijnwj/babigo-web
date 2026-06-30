// ============================================================================
// FILE : auth/core/session_manager.dart
// ============================================================================

import 'dart:async';

import 'package:babigo/modules/admin_module/database/models/admin/utilisateur.dart';
import 'package:babigo/modules/admin_module/database/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionManager extends ChangeNotifier {

  SessionManager._();

  static final SessionManager instance = SessionManager._();

  // ==========================================================================
  // EMAIL VERIFIED
  // ==========================================================================

  bool get emailVerified {

    return FirebaseAuth
        .instance
        .currentUser
        ?.emailVerified ??
        false;
  }

  // ==========================================================================
  // ACCOUNT ACTIVE
  // ==========================================================================

  bool get accountActive {

    return _currentUser?.isActived ?? false;
  }

  // ==========================================================================
  // ACCOUNT VERIFIED
  // ==========================================================================

  bool get accountVerified {

    return _currentUser?.isVerified ?? false;
  }

  StreamSubscription<User?>? _authSubscription;

  Utilisateur? _currentUser;

  bool _initialized = false;

  bool _loading = true;

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  bool get initialized => _initialized;

  bool get isLoading => _loading;

  bool get isLoggedIn => _currentUser != null;

  Utilisateur? get currentUser =>  _currentUser;

  String? get uid => _currentUser?.id;

  String? get email => _currentUser?.email;

  String? get role => _currentUser?.role.name;

  bool get isPassenger => _currentUser?.role.name == "passenger";

  bool get isDriver =>  _currentUser?.role.name == "driver";

  bool get isFleetManager => _currentUser?.role.name == "fleetManager";

  bool get isAdmin => _currentUser?.role.name == "admin";

  bool get isInvestor => _currentUser?.role.name == "investor";

  // ==========================================================================
  // START
  // ==========================================================================

  Future<void> initialize() async {

    if (_initialized) {
      return;
    }

    _initialized = true;

    _authSubscription =
        FirebaseAuth.instance
            .authStateChanges()
            .listen(
          _onAuthChanged,
        );
  }

  // ==========================================================================
  // AUTH CHANGED
  // ==========================================================================

  Future<void> _onAuthChanged(
      User? firebaseUser,
      ) async {

    try {

      _loading = true;

      notifyListeners();

      if (firebaseUser == null) {

        _currentUser = null;

        _loading = false;

        notifyListeners();

        return;
      }

      final user = await AuthService().getCurrentUserProfile();

      _currentUser = user;

      _loading = false;

      notifyListeners();

    } catch (e) {

      debugPrint(
        "SessionManager Error: $e",
      );

      _currentUser = null;

      _loading = false;

      notifyListeners();
    }
  }

  // ==========================================================================
  // REFRESH USER
  // ==========================================================================

  Future<void> refreshUser() async {

    try {

      if (!isLoggedIn) {
        return;
      }

      _loading = true;

      notifyListeners();

      final user = await AuthService().getCurrentUserProfile();

      _currentUser = user;

      _loading = false;

      notifyListeners();

    } catch (_) {

      _loading = false;

      notifyListeners();
    }
  }

  // ==========================================================================
  // SIGN OUT
  // ==========================================================================

  Future<void> signOut() async {

    await AuthService.signOut();

    _currentUser = null;

    notifyListeners();
  }

  // ==========================================================================
  // UPDATE LOCAL USER
  // ==========================================================================
  void updateUser(Utilisateur user) {

    _currentUser = user;

    notifyListeners();
  }

  @override
  void dispose() {

    _authSubscription?.cancel();

    super.dispose();
  }
}