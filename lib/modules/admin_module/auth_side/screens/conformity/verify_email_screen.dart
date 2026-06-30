import 'dart:async';

import 'package:babigo/app/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../app/screens/babigo_scaffold.dart';
import '../../../../../app/widgets/babigo_card.dart';
import '../../../database/services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  Timer? _timer;

  bool _loading = false;

  bool _sending = false;

  int _cooldown = 0;

  @override
  void initState() {
    super.initState();

    _sendVerificationEmail();

    _startAutoCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoCheck() {

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) async {

        await FirebaseAuth.instance
            .currentUser
            ?.reload();

        final user =
            FirebaseAuth.instance.currentUser;

        if (user == null) {
          return;
        }

        if (user.emailVerified) {

          _timer?.cancel();

          if (!mounted) return;

          Navigator.pop(context);
        }
      },
    );
  }

  Future<void>
  _sendVerificationEmail() async {

    try {

      setState(() {
        _sending = true;
      });

      await FirebaseAuth.instance
          .currentUser
          ?.sendEmailVerification();

      _startCooldown();

    } catch (_) {

    } finally {

      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  void _startCooldown() {

    _cooldown = 60;

    Timer.periodic(
      const Duration(seconds: 1),
          (timer) {

        if (_cooldown <= 0) {
          timer.cancel();
          return;
        }

        if (mounted) {
          setState(() {
            _cooldown--;
          });
        }
      },
    );
  }

  Future<void> _checkVerification() async {

    setState(() {
      _loading = true;
    });

    await AuthService().reloadUser();

    final user = AuthService().currentUser;

    if (user?.emailVerified ?? false) {

      if (!mounted) return;

      Navigator.pop(context);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _logout() async {

    await AuthService.signOut();

    if (!mounted) return;

    Navigator.of(context)
        .popUntil((route) => route.isFirst);
  }


  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return BabiGOScaffold(

        title: "Vérification",

        child: ListView(

            padding:
            const EdgeInsets.all(24),

            children: [

              BabiGOCard(

                child: Column(

                children: [

                  Container(

                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainColor.withValues(alpha: .1),
                    ),

                    child: const Icon(
                      Icons.mark_email_unread,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Vérifiez votre email",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    user?.email ?? "",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Nous avons envoyé un lien "
                        "de vérification à votre adresse email.",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                      _loading
                          ? null
                          : _checkVerification,
                      child: const Text(
                        "J'ai vérifié mon email",
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed:
                    _cooldown > 0
                        ? null
                        : _sendVerificationEmail,
                    child: Text(
                      _cooldown > 0
                          ? "Renvoyer ($_cooldown)"
                          : "Renvoyer l'email",
                    ),
                  ),

                  TextButton(
                    onPressed: _logout,
                    child: const Text(
                      "Se déconnecter",
                    ),
                  ),

                ],
                ),
              ),
            ],
        ),
    );
  }
}
