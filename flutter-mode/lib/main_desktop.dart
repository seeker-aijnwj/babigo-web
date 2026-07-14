import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:babigo/modules/admin_module/layouts/admin_layout.dart';
import 'firebase_options.dart';
// import 'package:babigo_pro/modules/admin_module/screens/selector_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BabiGoApp());
}

class BabiGoApp extends StatelessWidget {
  const BabiGoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabiGO Pro',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: SelectorScreen(),
      home: const AdminLayout(), // <--- Lancez le sélecteur
    );
  }
}