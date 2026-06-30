// ============================================================================
// FILE : modules/auth/screens/sign_in_screen.dart
// ============================================================================
import 'package:flutter/material.dart';

import '../../../../app/core/utils/colors.dart';
import '../../../../app/core/utils/constants.dart';
import '../../database/services/auth_service.dart';
import '../../database/models/admin/utilisateur.dart';
import '../../database/services/admin_data_service.dart';
import '../../layouts/admin_layout.dart';
import '../../screens/users/admin_driver_main_screen.dart';
import '../../screens/users/admin_passenger_main_screen.dart';
import '../../screens/users/admin_fleet_manager_main_screen.dart';
import '../../screens/users/admin_support_main_screen.dart';

import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool _obscurePassword = true;

  bool _rememberMe = true;

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // LOGIN
  // ==========================================================================

  Future<void> _login() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {

      setState(() {
        _loading = true;
      });

      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString(),),
        ),
      );

    } finally {

      if (mounted) {
          setState(() {
            _loading = false;
          });
      }

    }

  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500,),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24,),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      _buildHeader(),

                      const SizedBox(height: 32,),

                      _buildEmailField(),

                      const SizedBox(height: 16,),

                      _buildPasswordField(),

                      const SizedBox(height: 8,),

                      _buildForgotPassword(),

                      const SizedBox(height: 24,),

                      _buildRememberMe(),

                      const SizedBox(height: 24,),

                      _buildLoginButton(),

                      const SizedBox(height: 24,),

                      _buildDivider(),

                      const SizedBox(height: 24,),

                      _buildGoogleButton(),

                      const SizedBox(height: 12,),

                      _buildAppleButton(),

                      const SizedBox(
                      height: 32,
                    ),

                    _buildRegisterLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildHeader() {

    return Column(
      children: [

        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(28,),
          ),
          child: const Icon(Icons.directions_car,
            color: Colors.white,
            size: 48,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Bienvenue sur BabiGO",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Connectez-vous pour continuer",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 24),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: const [

            TrustBadge(
              icon: Icons.verified,
              label: "Conducteurs vérifiés",
            ),

            TrustBadge(
              icon: Icons.security,
              label: "Paiement sécurisé",
            ),

            TrustBadge(
              icon: Icons.location_on,
              label: "GPS temps réel",
            ),

            TrustBadge(
              icon: Icons.verified_user,
              label: "Sécurisé",
            ),

            TrustBadge(
              icon: Icons.shield,
              label: "Confidentiel",
            ),

            TrustBadge(
              icon: Icons.lock,
              label: "Chiffré",
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildEmailField() {

    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: "Adresse email",
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {

        if (value == null || value.trim().isEmpty) {
          return "Email requis";
        }

        if (!value.contains("@")) {
          return "Email invalide";
        }

        return null;
      },
    );

  }


  Widget _buildPasswordField() {

    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: "Mot de passe",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(_obscurePassword
            ? Icons.visibility
            : Icons.visibility_off,
          ),
        ),
      ),
      validator: (value) {

        if (value == null || value.isEmpty) {
          return "Mot de passe requis";
        }

        if (value.length < 6) {
          return "Minimum 6 caractères";
        }

        return null;
      },
    );

  }


  Widget _buildForgotPassword() {

      return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (_) => const ForgotPasswordScreen(),
              ),
            );
          },
          child: const Text("Mot de passe oublié ?",),
        ),
      );
  }

  Widget _buildRememberMe() {

    return CheckboxListTile(
      value: _rememberMe,
      onChanged: (value) {setState(() {
          _rememberMe = value ?? true;
        });
      },

      title: const Text("Se souvenir de moi",),
      contentPadding: EdgeInsets.zero,
    );

  }

  Widget _buildLoginButton() {

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _loading ? null : _login,
        child: _loading
          ? const SizedBox(
              height: 22, width: 22,
              child: CircularProgressIndicator(),)
          : const Text("Se connecter",),
      ),
    );
  }

  Widget _buildDivider() {

    return Row(
      children: [

        const Expanded(
          child: Divider(),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,),
          child: Text("ou",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),

        const Expanded(child: Divider(),),
      ],

    );

  }

  Widget _buildGoogleButton() {

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: _loading ? null : _handleGoogleSignIn,
        icon: Image.asset(
          "assets/images/brands/google.png",
          width: 22,
        ),
        label: const Text(
          "Continuer avec Google",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );

  }

  Widget _buildAppleButton() {

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: _loading ? null : _handleAppleSignIn,
        icon: const Icon(
          Icons.apple,
          size: 24,
        ),
        label: const Text("Continuer avec Apple",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text("Pas encore de compte ?",),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SignUpScreen(),
                ),
              );
            },
            child: const Text("Créer un compte",),
          ),

        ],
      ),
    );

  }

  Future<void> _createUserIfNeeded(Utilisateur firebaseUser,) async {

    final doc = Utils.db.collection("users")
        .doc(firebaseUser.id);

    final snapshot = await doc.get();

    if (snapshot.exists) return;

    final user = Utilisateur(
      id: firebaseUser.id,
      email: firebaseUser.email,
      firstName: firebaseUser.firstName,
      lastName: firebaseUser.lastName,
      role: UserRole.passenger,
      phone: firebaseUser.phone,
      password: firebaseUser.password,
      updatedAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await doc.set(user.toJson(),);

  }

  Future<void> _redirectUser() async {

    final uid = Utils.auth.currentUser!.uid;

    final doc = await AdminDataService.usersRef
        .doc(uid).get();

    final user = Utilisateur.fromFirestore(doc);

    if (!mounted) return;

    switch (user.role) {

      case UserRole.passenger:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminPassengerMainScreen(),
          ),
              (_) => false,
        );
        break;

      case UserRole.driver:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDriverMainScreen(),
          ),
              (_) => false,
        );
        break;

      case UserRole.fleetManager:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminFleetManagerMainScreen(),
          ),
              (_) => false,
        );
        break;

      case UserRole.admin:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminLayout(),
          ),
              (_) => false,
        );
        break;

      case UserRole.support:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminSupportMainScreen(),
          ),
              (_) => false,
        );
        break;

      case UserRole.investor:
      // TODO: Handle this case.
        throw UnimplementedError();

    }
  }

  Future<void> _handleGoogleSignIn() async {

    try {

      setState(() {
        _loading = true;
      });

      final credential = await _authService.signInWithGoogle();

      await _createUserIfNeeded(credential?.user as Utilisateur,);

      await _redirectUser();

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }

  }

  Future<void> _handleAppleSignIn() async {

    try {

      setState(() {
        _loading = true;
      });

      final credential = await _authService.signInWithApple();

      await _createUserIfNeeded(credential.user as Utilisateur,);

      await _redirectUser();

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }

  }



}

class TrustBadge extends StatelessWidget {

  final IconData icon;
  final String label;

  const TrustBadge({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300,),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(icon,
            size: 18,
            color: AppColors.mainColor,
          ),
          const SizedBox(width: 8),

          Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
      ),
    );
  }
}