import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:sentinelle/views/pages/auth/login_screen.dart';
import 'firebase_options.dart'; // This file is generated after running 'flutterfire configure'
import 'views/widget_tree.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Enable Hybrid Composition for Google Maps on Android
  // This often fixes touch interaction issues on physical devices.
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(const SentinelleApp());
}

class SentinelleApp extends StatelessWidget {
  const SentinelleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sentinelle',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E0E0E), // surface-dim
        primaryColor: const Color(0xFFD692FF), // primary
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFD692FF),
          secondary: const Color(0xFF474746),
          tertiary: const Color(0xFFFE0000),
          surface: const Color(0xFF0E0E0E),
          onSurface: Colors.white,
          onSurfaceVariant: const Color(0xFFABABAB),
          surfaceContainer: const Color(0xFF191919),
          surfaceContainerLow: const Color(0xFF131313),
          surfaceContainerHighest: const Color(0xFF262626),
          outlineVariant: const Color(0xFF484848),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 56, // 3.5rem equivalent
            fontWeight: FontWeight.bold,
            letterSpacing: -1.12, // -0.02em
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontFamily: 'Inter', color: Colors.white),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFFABABAB)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFD692FF)),
              ),
            );
          }
          if (snapshot.hasData) {
            return const WidgetTree();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
