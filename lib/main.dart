import 'package:flutter/material.dart';
import 'views/widget_tree.dart';

void main() {
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
