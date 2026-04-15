import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this
import 'firebase_options.dart'; // This file is generated after running 'flutterfire configure'
import 'views/widget_tree.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const WidgetTree(),
    );
  }
}