import 'package:flutter/material.dart';

import '../widgets/glass_conatiner.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          child: const Center(
            child: Text('Map View Placeholder'),
          ),
        ),
      ),
    );
  }
}