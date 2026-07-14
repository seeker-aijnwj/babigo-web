// ============================================================================
// FILE : auth/widgets/email_verification_checker.dart
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationChecker extends StatefulWidget {

  final Widget child;

  const EmailVerificationChecker({
    super.key,
    required this.child,
  });

  @override
  State<EmailVerificationChecker> createState() =>
      _EmailVerificationCheckerState();
}

class _EmailVerificationCheckerState
    extends State<EmailVerificationChecker> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) async {

        final user =
            FirebaseAuth.instance.currentUser;

        if (user == null) return;

        await user.reload();

        setState(() {});
      },
    );
  }

  @override
  void dispose() {

    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return widget.child;
  }
}