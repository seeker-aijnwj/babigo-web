import 'package:flutter/material.dart';

import '../../../../app/core/utils/colors.dart';

import 'sign_in_screen.dart';
import 'sign_up_screen.dart';


class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              flex: 6,
              child: _buildHero(),
            ),

            Expanded(
              flex: 5,
              child: _buildBottomSection(
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Image.asset(
            "assets/images/logo.png",
            height: 120,
          ),

          const SizedBox(height: 24),

          const Text(
            "BabiGO",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Voyagez, partagez et développez votre activité.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {

    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),

      padding: const EdgeInsets.all(24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          _buildFeature(
            Icons.route,
            "Trouvez rapidement un trajet",
          ),

          _buildFeature(
            Icons.drive_eta,
            "Proposez vos trajets",
          ),

          _buildFeature(
            Icons.business,
            "Gérez votre flotte",
          ),

          _buildFeature(
            Icons.security,
            "Voyagez en sécurité",
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 55,

            child: FilledButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const SignUpScreen(),
                  ),
                );
              },
              child: const Text(
                "Créer un compte",
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 55,

            child: OutlinedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const SignInScreen(),
                  ),
                );
              },
              child: const Text(
                "J'ai déjà un compte",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title,) {

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        children: [

          Icon(icon, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

}