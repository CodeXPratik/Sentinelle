import 'package:flutter/material.dart';

import '../widgets/glass_conatiner.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlassContainer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Describe the issue',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}