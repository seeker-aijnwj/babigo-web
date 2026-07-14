import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../app/core/utils/constants.dart';
import '../models/admin/utilisateur.dart';
import 'admin_data_service.dart';

class AuthService {

  User? get currentUser => Utils.auth.currentUser;

  // IS SIGNED IN
  bool get isLoggedIn  =>  Utils.auth.currentUser != null;

  bool get isAuthenticated => Utils.auth.currentUser != null;

  static Stream<User?> authStateChanges()  =>  Utils.auth.authStateChanges();

  Future<void> register({
    required String email,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {

    try {

      // ============================================================
      // EMAIL DÉJÀ UTILISÉ ?
      // ============================================================

      final emailQuery = await AdminDataService.usersRef
          .where('email', isEqualTo: email.trim().toLowerCase(),
      ).limit(1).get();

      if (emailQuery.docs.isNotEmpty) {

        throw AuthException(
          "Cette adresse email possède déjà un compte BabiGO.",
        );
      }

      // ============================================================
      // TÉLÉPHONE DÉJÀ UTILISÉ ?
      // ============================================================

      final phoneQuery = await AdminDataService.usersRef
          .where('phoneNumber', isEqualTo: phoneNumber.trim(),
      ).limit(1).get();

      if (phoneQuery.docs.isNotEmpty) {

        throw AuthException(
          "Ce numéro est déjà associé à un compte.",
        );
      }

      // ============================================================
      // FIREBASE AUTH
      // ============================================================

      final credential = await Utils.auth
          .createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {

        throw AuthException(
          "Impossible de créer le compte.",
        );
      }

      // ============================================================
      // EMAIL VERIFICATION
      // ============================================================

      await firebaseUser.sendEmailVerification();

      // ============================================================
      // USER DOCUMENT
      // ============================================================

      await AdminDataService.usersRef.doc(firebaseUser.uid)
          .set({
        'uid': firebaseUser.uid,
        'email': email.trim().toLowerCase(),
        'phoneNumber': phoneNumber.trim(),
        'role': role,
        'profileCompletion': 10,
        'kycStatus': 'notStarted',
        'status': UserStatus.active.name,
        'isVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    on FirebaseAuthException catch (e) {

      throw AuthException(
        _firebaseMessage(e),
      );
    }

  }

  String _firebaseMessage(FirebaseAuthException e,) {

    switch (e.code) {

      case 'email-already-in-use':
        return "Cette adresse email est déjà utilisée.";

      case 'invalid-email':
        return "Adresse email invalide.";

      case 'weak-password':
        return "Mot de passe trop faible.";

      case 'network-request-failed':
        return "Connexion internet indisponible.";

      default:
        return e.message ??
            "Une erreur est survenue.";
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {

    try {

      final credential = await Utils.auth
          .signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {

        throw AuthException(
          "Connexion impossible.",
        );
      }

      // ============================================================
      // DOCUMENT FIRESTORE
      // ============================================================

      final doc = await AdminDataService.usersRef
          .doc(user.uid)
          .get();

      if (!doc.exists) {

        await signOut();

        throw AuthException(
          "Compte utilisateur introuvable.",
        );
      }

      final connectedUser = Utilisateur.fromFirestore(doc);

      // ============================================================
      // COMPTE DÉSACTIVÉ
      // ============================================================

      if (connectedUser.status != UserStatus.blocked) {

        await signOut();

        throw AuthException(
          "Votre compte a été désactivé.",
        );
      }

      // ============================================================
      // UPDATE LAST LOGIN
      // ============================================================

      await AdminDataService.usersRef
          .doc(user.uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

    }

    on FirebaseAuthException catch (e) {

      throw AuthException(
        _firebaseMessageLogin(e),
      );
    }

  }

  String _firebaseMessageLogin(FirebaseAuthException e,) {

    switch (e.code) {

      case 'user-not-found':
        return "Aucun compte trouvé.";

      case 'wrong-password':
        return "Mot de passe incorrect.";

      case 'invalid-credential':
        return "Identifiants invalides.";

      case 'user-disabled':
        return "Compte désactivé.";

      case 'network-request-failed':
        return "Pas de connexion internet.";

      default:
        return e.message ??
            "Erreur de connexion.";
    }
  }

  Future<UserCredential?> signInWithGoogle() async {

    try {

      await Utils.googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await Utils.googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      return await Utils.auth.signInWithCredential(
        credential,
      );

    } catch (e) {
      rethrow;
    }
  }


  Future<UserCredential> signInWithApple() async {

    final appleCredential = await SignInWithApple
        .getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],);

    final oauthCredential = OAuthProvider("apple.com")
        .credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return Utils.auth.signInWithCredential(
      oauthCredential,
    );

  }


 Stream<DocumentSnapshot<Map<String, dynamic>>> watchCurrentUser() {

    final uid = currentUser?.uid;

    if (uid == null) {
      throw Exception(
        "Utilisateur non connecté",
      );
    }

    return Utils.db.collection('users')
        .doc(uid)
        .snapshots();
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDocument() {

    final uid = currentUser?.uid;

    if (uid == null) {
      throw Exception(
        "Utilisateur non connecté",
      );
    }

    return Utils.db.collection('users')
        .doc(uid)
        .get();
  }

  Future<bool> isProfileCompleted() async {

    final doc = await getCurrentUserDocument();

    final data = doc.data();

    if (data == null) {
      return false;
    }

    return data['profileCompleted'] == true;
  }

  Future<void> resetPassword(String email) async {

    await Utils.auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> sendVerificationEmail() async {

    final user = currentUser;

    if (user == null) {
      throw Exception(
        "Utilisateur introuvable",
      );
    }

    await user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {

    final user = currentUser;

    if (user == null) {
      return false;
    }

    await user.reload();

    return Utils.auth.currentUser?.emailVerified ?? false;
  }

  Future<UserCredential> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {

    final credential = await Utils.auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user;

    if (user == null) {
      throw Exception(
        "Impossible de créer le compte",
      );
    }

    await user.sendEmailVerification();

    await Utils.db.collection('users').doc(user.uid)
        .set({
      'uid': user.uid,
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'role': role.name,
      'status': UserStatus.active.name,
      'emailVerified': false,
      'profilePhoto': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<Utilisateur> getCurrentUserProfile()  async {

    final user = currentUser;

    if (user == null) throw Exception("Utilisateur non connecté");

    final doc = await Utils.db.collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) throw Exception("Profil introuvable",);

    return Utilisateur.fromFirestore(doc);
  }

  Future<void> completeProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String phone,
    required String city,
    required String municipality,
    required String role,
    String? gender,
    DateTime? birthDate,
    String? photoUrl,
  }) async {

    await AdminDataService.usersRef.doc(uid)
        .set({

      'uid': uid,

      'email': currentUser?.email,

      'firstName': firstName,

      'lastName': lastName,

      'fullName': '$firstName $lastName',

      'phoneNumber': phone,

      'gender': gender,

      'birthDate': birthDate,

      'city': city,

      'municipality': municipality,

      'photoUrl': photoUrl,

      'role': role,

      'profileCompleted': true,

      'lastLoginAt': FieldValue.serverTimestamp(),

      'updatedAt': FieldValue.serverTimestamp(),

      'createdAt':  FieldValue.serverTimestamp(),
    },
        SetOptions(
          merge: true,
        ));
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {

    final user = currentUser;

    if (user == null) {
      return;
    }

    await AdminDataService.usersRef.doc(user.uid)
        .update({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'phone': phone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // if (!user.emailVerified) {
  //  return VerifyEmailScreen();
  // }
  Future<void> deleteAccount() async {

    final user = currentUser;

    if (user == null) return;

    await Utils.db.collection('users')
        .doc(user.uid)
        .delete();

    await user.delete();
  }

  String mapAuthException(FirebaseAuthException e) {

    switch (e.code) {

      case 'user-not-found':
        return "Compte introuvable.";

      case 'wrong-password':
        return "Mot de passe incorrect.";

      case 'email-already-in-use':
        return "Cet email existe déjà.";

      case 'weak-password':
        return "Mot de passe trop faible.";

      case 'invalid-email':
        return "Adresse email invalide.";

      case 'network-request-failed':
        return "Connexion internet indisponible.";

      default: return e.message ?? "Erreur inconnue.";
    }
  }

  // ============================================================================
  // DELETE CURRENT ACCOUNT
  // ============================================================================

  Future<void> deleteCurrentAccount({
    String? password,
  }) async {

    final user = currentUser;

    if (user == null) {
      throw Exception(
        "Utilisateur non connecté",
      );
    }

    await Utils().reauthenticate(
      user,
      password,
    );

    await Utils().cleanupFirestoreUserData(
      user.uid,
    );

    await user.delete();
  }


  static Future<void> signOut() async {
    try {

      await Utils.auth.signOut();

      await GoogleSignIn.instance.signOut();

      // Apple Sign-In
      // Gestion ultérieure si nécessaire

    } catch (_) {

      await Utils.auth.signOut();

    }
  }

  static Future<void> sendPasswordResetEmail(
      String email,
      ) async {
    await Utils.auth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  Future<void> reauthenticate(
      String password,
      ) async {

    final user = currentUser;

    if (user == null) return;

    final credential =
    EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(
      credential,
    );
  }

}

class AuthException implements Exception {

  final String message;

  AuthException(this.message,);

  @override
  String toString() => message;
}