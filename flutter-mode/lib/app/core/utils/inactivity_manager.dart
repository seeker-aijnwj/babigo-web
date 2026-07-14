// ============================================================================
// FILE : auth/core/inactivity_manager.dart
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';

class InactivityManager extends ChangeNotifier {

  InactivityManager._();

  static final InactivityManager instance = InactivityManager._();

  bool get isRunning => _timer != null;

  Timer? _timer;

  static const Duration timeout = Duration(minutes: 30);

  VoidCallback? onTimeout;

  void start() {

    stop();

    _timer = Timer(timeout, () {
        if (onTimeout != null) {
          onTimeout!();
        }
      },
    );

  }

  void reset() {
    start();
  }

  void stop() {

    _timer?.cancel();

    _timer = null;
  }


}