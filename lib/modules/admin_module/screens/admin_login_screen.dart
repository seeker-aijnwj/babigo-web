import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/core/utils/colors.dart';
import '../../../app/core/utils/constants.dart';

import '../auth_side/screens/sign_up_screen.dart';
import 'users/admin_driver_main_screen.dart';
import 'users/admin_fleet_manager_main_screen.dart';
import 'users/admin_passenger_main_screen.dart';
import 'users/admin_superadmin_main_screen.dart';
import 'users/admin_support_main_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _busy = false;
  bool _obscurePassword = true;
  final bool _newUser = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);

    try {

      final credential = await Utils.auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = credential.user?.uid;

      if (uid == null) {
        _showSnack("Connexion impossible. Utilisateur introuvable.");
        return;
      }

      final role = await _getUserRole(uid);

      if (!mounted) return;

      if (role == null || role.isEmpty) {
        _showSnack("Aucun rôle n'est associé à ce compte.");
        return;
      }

      _redirectByRole(role);
    } on FirebaseAuthException catch (e) {
      _showSnack(_authErrorMessage(e));
    } catch (e) {
      _showSnack("Erreur : $e");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _getUserRole(String uid) async {
    final collections = ['users', 'utilisateurs', 'admins'];

    for (final collection in collections) {
      final doc = await Utils.db.collection(collection).doc(uid).get();

      if (!doc.exists) continue;

      final data = doc.data();
      if (data == null) continue;

      final rawRole = data['role'] ??
          data['userRole'] ??
          data['type'] ??
          data['accountType'];

      if (rawRole != null) {
        return rawRole.toString().trim().toLowerCase();
      }
    }

    return null;
  }

  void _redirectByRole(String role) {
    final normalizedRole = role
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e');

    Widget screen;

    switch (normalizedRole) {
      case 'super_admin':
      case 'superadmin':
      case 'admin_super':
      case 'admin':
        screen = const AdminSuperAdminMainScreen();
        break;

      case 'support':
      case 'agent_support':
      case 'admin_support':
        screen = const AdminSupportMainScreen();
        break;

      case 'fleet_manager':
      case 'gestionnaire_flotte':
      case 'gestionnaire_parc':
      case 'parc':
      case 'flotte':
        screen = const AdminFleetManagerMainScreen();
        break;

      case 'driver':
      case 'conducteur':
      case 'admin_driver':
        screen = const AdminDriverMainScreen();
        break;

      case 'passenger':
      case 'passager':
      case 'client':
        screen = const AdminPassengerMainScreen();
        break;

      default:
        _showSnack("Rôle non reconnu : $role");
        return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
          (_) => false,
    );
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showSnack("Entrez votre email pour réinitialiser le mot de passe.");
      return;
    }

    try {
      await Utils.auth.sendPasswordResetEmail(email: email);
      _showSnack("Email de réinitialisation envoyé.");
    } catch (e) {
      _showSnack("Impossible d'envoyer l'email : $e");
    }
  }

  String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Adresse email invalide.";
      case 'user-disabled':
        return "Ce compte a été désactivé.";
      case 'user-not-found':
        return "Aucun compte trouvé avec cet email.";
      case 'wrong-password':
      case 'invalid-credential':
        return "Email ou mot de passe incorrect.";
      case 'too-many-requests':
        return "Trop de tentatives. Réessayez plus tard.";
      default:
        return "Erreur de connexion : ${e.message}";
    }
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isDesktop ? 28 : 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1050),
                  child: isDesktop
                      ? Row(
                    children: [
                      Expanded(child: _buildBrandPanel()),
                      const SizedBox(width: 24),
                      SizedBox(width: 430, child: _buildLoginCard()),
                    ],
                  )
                      : Column(
                    children: [
                      // _buildBrandPanel(),
                      const SizedBox(height: 18),
                      _buildLoginCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.mainColor, Color(0xFF5B8DFF)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/icons/appstore.png',
              width: 120,
              height: 120,
            ),
          ),

          SizedBox(height: 10),
          Text(
            "Connectez-vous et accédez automatiquement à votre espace selon votre rôle.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.4,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 28),
          RoleHint(icon: Icons.person, label: "Passager"),
          RoleHint(icon: Icons.drive_eta, label: "Conducteur"),
          RoleHint(icon: Icons.business, label: "Gestionnaire de flotte"),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(
              height: 20,
            ),

            Utils.buildSignHeader(isLogin: true),

            const SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: "Email",
                hint: "exemple@babigo.app",
                icon: Icons.mail_outline,
              ),
              validator: (value) {
                final email = value?.trim() ?? "";
                if (email.isEmpty) return "Email obligatoire.";
                if (!email.contains('@')) return "Email invalide.";
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _busy ? null : _login(),
              decoration: _inputDecoration(
                label: "Mot de passe",
                hint: "Votre mot de passe",
                icon: Icons.lock_outline,
                suffix: IconButton(
                  tooltip: _obscurePassword
                      ? "Afficher le mot de passe"
                      : "Masquer le mot de passe",
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if ((value ?? "").trim().isEmpty) {
                  return "Mot de passe obligatoire.";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _busy ? null : _resetPassword,
                child: const Text("Mot de passe oublié ?"),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _busy ? null : _login,
              icon: _busy
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.login),
              label: Text(_busy ? "Connexion..." : "Se connecter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SignUpScreen(),
                  ),
                );
              },
              icon: _newUser
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.add_reaction_outlined),
              label: Text(_newUser ? "Redirection..." : "S'inscrire"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.mainColor),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.mainColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.4),
      ),
    );
  }
}
