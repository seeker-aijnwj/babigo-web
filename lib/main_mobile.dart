import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Import nécessaire pour Firebase
import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/modules/booking_module/screens/onboarding/views/splash_screen.dart';
import 'package:babigo/modules/booking_module/screens/passenger/passenger_home_screen.dart';
import 'package:babigo/modules/booking_module/screens/driver/driver_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // optionnel
  );
  runApp(const BabiGoApp());
}

class BabiGoApp extends StatelessWidget {
  const BabiGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BabiGO Express',
      theme: ThemeData(
        primaryColor: AppColors.mainColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const PassengerHomeScreen(),
        '/profile': (context) => const DriverProfileScreen(),
        // '/trips/{tripId}/': (context) => const DriverProfileScreen(),
      },
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('en'), Locale('fr')],
    );
  }
}
