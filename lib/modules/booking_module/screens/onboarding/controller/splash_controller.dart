import 'package:flutter/material.dart';
import 'package:babigo/modules/booking_module/screens/onboarding/views/welcome_screen.dart';
//import 'package:babigo_admin/screens/auth/admin_login_screen.dart';

Future<Null> time(BuildContext context) {
  return Future.delayed(const Duration(seconds: 5), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  });
}
