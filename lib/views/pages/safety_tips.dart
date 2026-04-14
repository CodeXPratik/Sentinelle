import 'package:flutter/material.dart';

import '../widgets/glass_conatiner.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Tips')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          TipCard(title: 'Avoid isolated areas'),
          TipCard(title: 'Keep emergency contacts ready'),
          TipCard(title: 'Share your live location'),
          TipCard(title: 'Stay alert in crowded places'),
        ],
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final String title;

  const TipCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        child: ListTile(
          leading: const Icon(Icons.info, color: Colors.blue),
          title: Text(title),
        ),
      ),
    );
  }
}